//
//  KGJSBridge.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/8/16.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit

protocol KGJSBridgeDelegate: AnyObject {
    func evaluateJavascript(javascript: String)
}

class KGJSBridge: NSObject {
    
    typealias Handler = (_ parameters: [String: Any]?, _ callback: Callback?) -> Void
    typealias Callback = (_ responseData: [String: Any]?) -> Void
    typealias Message = [String: Any]
    
    weak var delegate: KGJSBridgeDelegate?
    
    var startupMessageQueue = [Message]()
    var responseCallbacks = [String: Callback]()
    var messageHandlers = [String: Handler]()
    var uniqueId = 0
    
    func send(handlerName: String, data: [String: Any]?, callback: Callback?) {
        var message = Message()
        message[kParamHandlerName] = handlerName
        
        if let aData = data {
            message[kParamData] = aData
        }
        
        if let aCallback = callback {
            uniqueId += 1
            let callbackId = "native_cb_\(uniqueId)"
            responseCallbacks[kParamCallbackId] = aCallback
            message[kParamCallbackId] = callbackId
        }
        
        queue(message: message)
    }
    
    func invokeHandler(message: Message) {
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
                    self.queue(message: msg)
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
                    No Handler!
                    \(message.string)
                    ---------------------------------------------
                    """
                )
                //TODO-提供配置文件
                guard let aCallback = callback else { return }
                aCallback(["code": NSURLErrorUnsupportedURL, "message": "Unsupported Native Api."])
                return
            }
            handler(message["data"] as? [String : Any], callback)
        }
    }
}

// MARK: - Private
extension KGJSBridge {
    
    private func queue(message: Message) {
        if startupMessageQueue.isEmpty {
            dispatch(message: message)
        } else {
            startupMessageQueue.append(message)
        }
    }
    
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
        
        let javascriptCommand = "KGJSBridge._handleMessageFromNative('\(messageJSON)');"
        DispatchQueue.main.async {
            self.delegate?.evaluateJavascript(javascript: javascriptCommand)
        }
    }
    
    private func serialize(message: Message, pretty: Bool) -> String? {
        var result: String?
        do {
            let data = try JSONSerialization.data(withJSONObject: message, options: pretty ? .prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0))
            result = String(data: data, encoding: .utf8)
        } catch {
            debugPrint(error)
        }
        return result
    }
    
}
