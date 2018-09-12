//
//  KGJSBridgeBase.swift
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

protocol KGJSBridgeBaseDelegate: AnyObject {
    func evaluateJavascript(javascript: String)
}

class KGJSBridgeBase: NSObject {
    
    public typealias Handler = (_ parameters: [String: Any]?, _ callback: Callback?) -> Void
    public typealias Callback = (_ responseData: Any?) -> Void
    
    typealias Message = [String: Any]
    
    //TODO-提供配置文件
    public static var debugLogEnable: Bool = false
    public static var JSBridgeObj: String?
    public static var JBCallbacksObj: String?
    public static var JBScheme: String = kDefaultJBScheme
    
    weak var delegate: KGJSBridgeBaseDelegate?
    
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
                if let bridgeObj = KGJSBridgeBase.JSBridgeObj {
                    KGJSBridgeJS = KGJSBridgeJS.replacingOccurrences(of: kDefaultJSBridgeObj, with: bridgeObj)
                }
                if let callbacksObj = KGJSBridgeBase.JBCallbacksObj {
                    KGJSBridgeJS = KGJSBridgeJS.replacingOccurrences(of: kDefaultJBCallbacksObj, with: callbacksObj)
                }
            }
        }
        catch {
            debugPrint(error)
        }
    }

    func reset() {
        startupMessageQueue = [Message]()
        responseCallbacks = [String: Callback]()
        uniqueId = 0
    }
    
    func send(handlerName: String, data: Any?, callback: Callback?) {
        var message = [String: Any]()
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
            log(message)
            
            if let responseId = message[kParamResponseId] as? String {
                guard let callback = responseCallbacks[responseId] else { continue }
                callback(message[kParamResponseData])
                responseCallbacks.removeValue(forKey: responseId)
            } else {
                var callback: Callback?
                if let callbackID = message[kParamCallbackId] {
                    callback = { (_ responseData: Any?) -> Void in
                        let msg = [kParamResponseId: callbackID, kParamResponseData: responseData ?? NSNull()] as Message
                        self.queue(message: msg)
                    }
                } else {
                    callback = { (_ responseData: Any?) -> Void in
                        // no logic
                    }
                }
                
                guard let handlerName = message[kParamHandlerName] as? String else { return }
                guard let handler = messageHandlers[handlerName] else {
                    log("NoHandlerException, No handler for message from JS: \(message)")
                    //TODO-提供配置文件
                    callback!(["code": -999, "message": "Native Api is not exist."])
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

extension KGJSBridgeBase {
    
    // MARK: - Action
    func isJSBridge(url: URL) -> Bool {
        if !isSchemeMatch(url) {
            return false
        }
        return isBridgeLoaded(url:url) || isQueueMessage(url:url)
    }
    
    func isSchemeMatch(_ url: URL) -> Bool {
        let scheme = url.scheme?.lowercased()
        return scheme == KGJSBridgeBase.JBScheme || scheme == "https"
    }
    
    func isQueueMessage(url: URL) -> Bool {
        let host = url.host?.lowercased()
        return isSchemeMatch(url) && host == kQueueHasMessage
    }
    
    func isBridgeLoaded(url: URL) -> Bool {
        let host = url.host?.lowercased()
        return isSchemeMatch(url) && host == kBridgeLoaded
    }
    
    func logUnkownMessage(url: URL) {
        debugPrint("\(KGJSBridgeBase.JSBridgeObj ?? kDefaultJSBridgeObj): WARNING: Received unknown \(KGJSBridgeBase.JSBridgeObj ?? kDefaultJSBridgeObj) command \(url.absoluteString)")
    }
    
    func webViewJavascriptFetchQueyCommand() -> String {
        return "\(KGJSBridgeBase.JSBridgeObj ?? kDefaultJSBridgeObj)._fetchQueue();"
    }
    
    func disableJavscriptAlertBoxSafetyTimeout() {
        send(handlerName: "_disableJavascriptAlertBoxSafetyTimeout", data: nil, callback: nil)
    }

}

extension KGJSBridgeBase {
    
    // MARK: - Private
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
        if Thread.current.isMainThread {
            delegate?.evaluateJavascript(javascript: javascriptCommand)
        } else {
            DispatchQueue.main.async {
                self.delegate?.evaluateJavascript(javascript: javascriptCommand)
            }
        }
    }
    
    // MARK: - JSON
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
            result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [KGJSBridgeBase.Message]
        } catch {
            debugPrint(error)
        }
        return result
    }
    
}

extension KGJSBridgeBase {
    
    // MARK: - Log
    private func log<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
        if KGJSBridgeBase.debugLogEnable {
            let fileName = (file as NSString).lastPathComponent
            debugPrint("\(fileName):\(line) \(function) | \(message)")
        }
    }
    
}

