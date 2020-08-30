//
//  InvokeHandlerPlugin.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

private let kInvokeJSFunc: String = "kawagarbo._invokeCallback"

extension Res {
    static func success(message: String = "ok", data: [String: Any] = [:]) -> Res {
        return Res(code: ResSuccess, message: message, data: data)
    }
    
    static func fail(message: String = "fail", data: [String: Any] = [:]) -> Res {
        return Res(code: ResFail, message: message, data: data)
    }
    
    static func cancel(message: String = "cancel", data: [String: Any] = [:]) -> Res {
        return Res(code: ResCancel, message: message, data: data)
    }
    
    static func unknown() -> Res {
        return Res(code: ResUnknown, message: "unknown path", data: [:])
    }
    
    var jsonObj: [String: Any] {
        return [
            kResCode: code,
            kResMessage: message,
            kResData: data
        ]
    }
}

public protocol NativeApi {
    
    var path: String { get }
    
    func webview(_ webView: WKWebView, invokeWith params:[String: Any]?, callback: @escaping (_ res: Res) -> Void)
    
}

extension NativeApi {
    func regist() {
        InvokeHandlerPlugin.apis[path] = self
    }
}


class InvokeHandlerPlugin: NSObject {
    
    static var apis = [String: NativeApi]()
    
}

extension InvokeHandlerPlugin: ScriptMessagePlugin {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == InvokeHandleName {
            invokeNative(message)
        }
    }
    
    func invokeNative(_ message: WKScriptMessage) {
        guard let webView = message.webView else { return }
        
        guard let messageDict = message.body as? [String: Any],
            let msgId = messageDict[kMsgId] as? String,
            let path = messageDict[kPath] as? String
            else { return kwlog(title:"Invalid Invoke", message.body) }
        guard let api = InvokeHandlerPlugin.apis[path] else  {
            webView.kw.evaluateJavaScript(jsFunc: kInvokeJSFunc, obj: Res.unknown().jsonObj)
            return kwlog(title:Res.unknown().message, message.body)
        }
        
        var params: [String: Any]?
        if let aparams = messageDict[kParams] as? [String: Any] {
            params = aparams
        }
        
        kwlog(title: "Invoke Native", """
            \(kPath):\(path)
            \(kParams):\(params?.kw.string ?? "")
            """)
        
        api.webview(webView, invokeWith: params) { (res) in
            //invokeNativeCallback
            let resObj = res.jsonObj
            let obj: [String : Any] = [kMsgId: msgId, kRes: resObj]
            webView.kw.evaluateJavaScript(jsFunc: kInvokeJSFunc, obj: obj)
            kwlog(title: "Native Res", """
                \(kPath):\(path)
                \(kRes):\(resObj.kw.string ?? "")
                """)
        }
    }
    
}
