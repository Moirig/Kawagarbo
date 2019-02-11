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
    
    static var nativeApis: [String: KGNativeApiDelegate] = [:]
    
    private var startupMessageQueue = [Message]()
    
    private var responseCallbacks = [String: Callback]()
    
    private var messageHandlers = [String: Handler]()
    
    private var callbackId = 0
    
    override init() {
        super.init()
        
    }
    
    var userContentController: WKUserContentController {
        let userContentController = WKUserContentController()
        let scriptMessageDelegate = KGScriptMessageHandler(delegate: self)
        userContentController.add(scriptMessageDelegate, name: KGScriptMessageHandleName)
        return userContentController
    }
    
}

extension KGNativeApiManager {
    
    static func addNativeApi(_ api: KGNativeApiDelegate) {
        nativeApis[api.path] = api
    }
    
    func injectApis() {
        for (apiPath, api) in KGNativeApiManager.nativeApis {
            regist(apiPath) {[weak self] (parameters, callback) in
                guard let strongSelf = self else { return }
                
                KGLog(title: "callNative:", """
                    path:\(apiPath)
                    parameters:\(parameters?.kg.string ?? "")
                    """)
                
                api.webViewController = strongSelf.webViewController
                api.perform(with: parameters) { (apiResponse) in
                    if let callback = callback {
                        KGLog(title: "nativeResponse:", """
                            path:\(apiPath)
                            response:\(apiResponse.jsonObject)
                            """)
                        
                        DispatchQueue.main.async {
                            callback(apiResponse.jsonObject)
                        }
                    }
                }
            }
        }
        
        KGLog("Inject Apis Success!")
    }
    
    func removeAllApis() {
        messageHandlers.removeAll()
    }
    
}

extension KGNativeApiManager {
        
    public func callJS(function: String, parameters: [String: Any]? = nil, complete: KGNativeApiResponseClosure? = nil) {
        guard function.count > 0 else { return }
        KGLog(title: "callJS:", """
            \(function)
            \(parameters?.kg.string ?? "")
            """)
        call(handler: function, data: parameters) { (jsonObject) in
            guard let complete = complete else { return }
            
            
            
            guard let jsonObj = jsonObject, let code = jsonObj[kParamCode] as? Int else {
                KGLog(title: "Invalid Response Type:", jsonObject?.kg.string ?? "")
                return
            }
            
            KGLog(title: "JSResponse:", """
                function:\(function)
                \(jsonObj.kg.string)
                """)
            
            let message = jsonObj[kParamMessage] as? String ?? ""
            
            switch code {
                
            case kParamCodeSuccess:
                let data = jsonObj[kParamData] as? [String: Any]
                complete(.success(data: data))
            
            case kParamCodeCancel:
                complete(.cancel(message: message))

            case kParamCodeUnknownApi:
                complete(.unknownApi(api: function))
                
            default:
                complete(.failure(code: code, message: message))
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
                KGLog(title: "UnknownApi:", handlerName)

                guard let aCallback = callback else { return }
                aCallback(KGNativeApiResponse.unknownApi(api: handlerName).jsonObject)
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
            KGLog(title: "Invalid Paramters:", message.body)
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
        
        let javascript = "\(KGJSBridgeObj).\(KGSubscribeHandler)('\(messageJSON)');"
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
            KGLog(title: "Invalid Paramters:", message)
        }
        return result
    }
    
}
