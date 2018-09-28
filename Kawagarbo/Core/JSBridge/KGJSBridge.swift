//
//  KGJSBridge.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/8/16.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit

private let kParamHandlerName: String = "handlerName"
private let kParamCallbackId: String = "callbackId"
private let kParamData: String = "data"
private let kParamResponseData: String = "responseData"
private let kParamResponseId: String = "responseId"

private let kDefaultJSBridgeObj: String = "KGJSBridge"
private let kDefaultJBCallbacksObj: String = "KGJBCallbacks"
private let kDefaultJBScheme: String = "kwgb"

private let kQueueHasMessage: String = "__wvjb_queue_message__"
private let kBridgeLoaded: String = "__request__bridge__inject__"

protocol KGJSBridgeDelegate: AnyObject {
    func evaluateJavascript(javascript: String)
}

class KGJSBridge: NSObject {
    
    typealias Handler = (_ parameters: [String: Any]?, _ callback: Callback?) -> Void
    typealias Callback = (_ responseData: [String: Any]?) -> Void
    
    typealias Message = [String: Any]
    
    //TODO-提供配置文件
    static var debugLogEnable: Bool = false
    static var JSBridgeObj: String?
    static var JBCallbacksObj: String?
    static var JBScheme: String = kDefaultJBScheme
    
    weak var delegate: KGJSBridgeDelegate?
    
    var startupMessageQueue = [Message]()
    var responseCallbacks = [String: Callback]()
    var messageHandlers = [String: Handler]()
    var uniqueId = 0
    
    private var KGJSBridgeJS: String = ""
    
    override init() {
        super.init()
        
        do {
            if let path: String = Bundle.main.path(forResource: kDefaultJSBridgeObj, ofType: "js") {
                KGJSBridgeJS = try String(contentsOfFile: path, encoding: .utf8)
                if let bridgeObj = KGJSBridge.JSBridgeObj {
                    KGJSBridgeJS = KGJSBridgeJS.replacingOccurrences(of: kDefaultJSBridgeObj, with: bridgeObj)
                }
                if let callbacksObj = KGJSBridge.JBCallbacksObj {
                    KGJSBridgeJS = KGJSBridgeJS.replacingOccurrences(of: kDefaultJBCallbacksObj, with: callbacksObj)
                }
            }
        }
        catch {
            debugPrint(error)
        }
    }
    
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
    
    func flush(messageQueueString: String) {
        guard let messages = deserialize(messageJSON: messageQueueString) else {
            debugPrint(messageQueueString)
            return
        }
        
        for message in messages {
            if let responseId = message[kParamResponseId] as? String {
                guard let callback = responseCallbacks[responseId] else { continue }
                callback(message[kParamResponseData] as? [String: Any])
                responseCallbacks.removeValue(forKey: responseId)
            } else {
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
    
    func injectJavascriptFile() {
        let js = KGJSBridgeJS
        delegate?.evaluateJavascript(javascript: js)
        for message in startupMessageQueue {
            dispatch(message: message)
        }
        startupMessageQueue.removeAll()
    }
    
}

// MARK: - Get
extension KGJSBridge {
    
    static func isJSBridge(url: URL) -> Bool {
        if !isSchemeMatch(url) {
            return false
        }
        return isBridgeLoaded(url:url) || isQueueMessage(url:url)
    }
    
    static func isSchemeMatch(_ url: URL) -> Bool {
        let scheme = url.scheme?.lowercased()
        return scheme == KGJSBridge.JBScheme || scheme == "https"
    }
    
    static func isQueueMessage(url: URL) -> Bool {
        let host = url.host?.lowercased()
        return isSchemeMatch(url) && host == kQueueHasMessage
    }
    
    static func isBridgeLoaded(url: URL) -> Bool {
        let host = url.host?.lowercased()
        return isSchemeMatch(url) && host == kBridgeLoaded
    }
    
    static func logUnkownMessage(url: URL) {
        debugPrint("\(KGJSBridge.JSBridgeObj ?? kDefaultJSBridgeObj): WARNING: Received unknown \(KGJSBridge.JSBridgeObj ?? kDefaultJSBridgeObj) command \(url.absoluteString)")
    }
    
    static func webViewJavascriptFetchQueyCommand() -> String {
        return "\(KGJSBridge.JSBridgeObj ?? kDefaultJSBridgeObj)._fetchQueue();"
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
    
    private func deserialize(messageJSON: String) -> [Message]? {
        var result = [Message]()
        guard let data = messageJSON.data(using: .utf8) else { return nil }
        do {
            result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [KGJSBridge.Message]
        } catch {
            debugPrint(error)
        }
        return result
    }
    
}
