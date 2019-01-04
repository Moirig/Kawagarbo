//
//  KGNativeApiManager.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/8/16.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit
import WebKit

public class KGNativeApiManager: NSObject {

    weak var webViewController: KGWebViewController?
    
    private var webView: KGWKWebView? { return webViewController?.webView }
    
    private static var nativeApis: [String: KGNativeApiDelegate] = [:]
    
    private var startupMessageQueue = [Message]()
    
    private var responseCallbacks = [String: Callback]()
    
    private var messageHandlers = [String: Handler]()
    
    private var callbackId = 0
    
    override init() {
        super.init()
        
        let scriptMessageDelegate = KGScriptMessageHandler(delegate: self)
        webView?.configuration.userContentController.add(scriptMessageDelegate, name: KGScriptMessageHandleName)
    }
    
}

extension KGNativeApiManager {
    
    static func addNativeApi(_ api: KGNativeApiDelegate) {
        nativeApis[api.path] = api
    }
    
    func injectApis(apiPaths: [String]) {
        var workApis: [String: KGNativeApiDelegate] = [:]
        for apiPath in apiPaths {
            workApis[apiPath] = KGNativeApiManager.nativeApis[apiPath];
        }
        
        for (apiPath, api) in workApis {
            regist(apiPath) {[weak self] (parameters, callback) in
                guard let strongSelf = self else { return }
                
                debugPrint("""
                    ---------------- Web->Native ----------------
                    path:\(apiPath)
                    parameters:\(parameters?.string ?? "")
                    ---------------------------------------------
                    """)
                
                api.perform(with: parameters, in: strongSelf.webViewController) { (apiResponse) in
                    if let callback = callback {
                        DispatchQueue.main.async {
                            callback(apiResponse.jsonObject)
                        }
                    }
                }
            }
        }
    }
    
    func removeAllApis() {
        messageHandlers.removeAll()
    }
    
}

extension KGNativeApiManager {
        
    func callJS(function: String, parameters: [String: Any]? = nil, complete: KGNativeApiResponseClosure? = nil) {
        guard function.count > 0 else { return }
        
        debugPrint(
            """
            ---------------- Native->Web ----------------
            function:\(function)
            \(parameters?.string ?? "")
            ---------------------------------------------
            """
        )
        
        call(handler: function, data: parameters) { (response) in
            guard let complete = complete else { return }
            
            debugPrint(
                """
                ---------------- Native->Web ----------------
                function:\(function)
                \(response?.string ?? "")
                ---------------------------------------------
                """
            )
            
            guard let response = response, let code = response[kParamCode] as? Int else {
                return complete(.failure(code: KGNativeApiError.cannotParseResponse.rawValue, message: KGNativeApiError.cannotParseResponse.localizedDescription))
            }
            
            let message = response[kParamMessage] as? String
            
            if code == kParamSuccessCode {
                let data = response[kParamData] as? [String: Any]
                complete(.success(data: data, message: message))
            }
            else if code == kParamCancelCode {
                complete(.cancel(message: message))
            }
            else {
                guard let msg = message else {
                    return complete(.failure(code: KGNativeApiError.cannotParseResponse.rawValue, message: KGNativeApiError.cannotParseResponse.localizedDescription))
                }
                complete(.failure(code: code, message: msg))
            }
        }
    }
    
}

extension KGNativeApiManager {
    
    private func regist(_ handlerName: String, handle: @escaping Handler) {
        messageHandlers[handlerName] = handle
    }
    
    private func call(handler: String, data: [String: Any]? = nil, callback: Callback? = nil) {
        var message = Message()
        message[kParamHandlerName] = handler
        
        if let aData = data {
            message[kParamData] = aData
        }
        
        if let aCallback = callback {
            callbackId += 1
            let callbackIdString = "native_cb_\(callbackId)"
            responseCallbacks[callbackIdString] = aCallback
            message[kParamCallbackId] = callbackIdString
        }
        
        dispatch(message: message)
    }
    
    private func invokeHandler(message: Message) {
        if let responseId = message[kParamResponseId] as? String {
            guard let callback = responseCallbacks[responseId] else { return }
            callback(message[kParamResponseData] as? [String: Any])
            responseCallbacks.removeValue(forKey: responseId)
        }
        else {
            var callback: Callback?
            if let callbackID = message[kParamCallbackId] {
                callback = { (_ responseData: [String: Any]?) -> Void in
                    let msg = [kParamResponseId: callbackID, kParamResponseData: responseData ?? [:]] as Message
                    self.dispatch(message: msg)
                }
            } else {
                callback = { (_ responseData: [String: Any]?) -> Void in
                    // no logic
                }
            }
            
            guard let handlerName = message[kParamHandlerName] as? String else { return }
            guard let handler = messageHandlers[handlerName] else {
                debugPrint(
                    """
                    ---------------- Web->Native ----------------
                    \(KGNativeApiError.unknowNativeApi.localizedDescription)
                    \(message.string)
                    ---------------------------------------------
                    """
                )

                guard let aCallback = callback else { return }
                aCallback([kParamCode: KGNativeApiError.unknowNativeApi.rawValue, kParamMessage: "\(KGNativeApiError.unknowNativeApi.localizedDescription):\(handlerName)!" ])
                return
            }
            handler(message[kParamData] as? Message, callback)
        }
    }
    
}

extension KGNativeApiManager: WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if let messageDict = message.body as? Message {
            invokeHandler(message: messageDict)
        }
        else {
            debugPrint(
                """
                ---------------- Web->Native ----------------
                \(KGNativeApiError.invalidParameters.localizedDescription)
                ---------------------------------------------
                """
            )
        }
    }
    
}

// MARK: - Private
extension KGNativeApiManager {
    
    private func dispatch(message: Message) {
        guard var messageJSON = serialize(message: message, pretty: false) else { return }
        
        messageJSON = messageJSON.replacingOccurrences(of: "\\", with: "\\\\")
        messageJSON = messageJSON.replacingOccurrences(of: "\"", with: "\\\"")
        messageJSON = messageJSON.replacingOccurrences(of: "\'", with: "\\\'")
        messageJSON = messageJSON.replacingOccurrences(of: "\n", with: "\\n")
        messageJSON = messageJSON.replacingOccurrences(of: "\r", with: "\\r")
        messageJSON = messageJSON.replacingOccurrences(of: "\u{000C}", with: "\\f")
        messageJSON = messageJSON.replacingOccurrences(of: "\u{2028}", with: "\\u2028")
        messageJSON = messageJSON.replacingOccurrences(of: "\u{2029}", with: "\\u2029")
        
        let javascript = "\(KGJSBridgeObj).\(KGJSBridgeHandleMessageFunction)('\(messageJSON)');"
        DispatchQueue.main.async {
            self.webView?.evaluateJavaScript(javascript, completionHandler: nil)
        }
    }
    
    private func serialize(message: Message, pretty: Bool) -> String? {
        var result: String?
        do {
            let data = try JSONSerialization.data(withJSONObject: message, options: pretty ? .prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0))
            result = String(data: data, encoding: .utf8)
        } catch {
            debugPrint(
                """
                ---------- JSONSerializationError -----------
                \(KGNativeApiError.invalidParameters.localizedDescription)
                ---------------------------------------------
                """
            )
        }
        return result
    }
    
}
