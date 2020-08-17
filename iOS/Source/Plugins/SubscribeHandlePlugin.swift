//
//  SubscribeHandlePlugin.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/30/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

private let kSubscribeJSFunc: String = "kawagarbo._subscribeNative"

extension WebViewController {
    
    func invokeJS(path: String, params: [String: Any]?, callback: ((Res) -> Void)?) {
        guard path.count > 0 else { return kwlog("invokeJS no path!") }
        kwlog(title: "Invoke JS", """
            \(kPath):\(path)
            \(kParams):\(params?.kw.string ?? "")
            """)
        
        var message: [String: Any] = [kPath: path]
        
        if let aparams = params {
            message[kParams] = aparams
        }
        
        if let cb = callback {
            uniqueId += 1
            let msgId = "subscribe_\(uniqueId)"
            message[kMsgId] = msgId
            invokeJSs[msgId] = cb
        }
        
        webView.kw.evaluateJavaScript(jsFunc: kSubscribeJSFunc, obj: message)
    }
    
}

class SubscribeHandlePlugin: NSObject, ScriptMessagePlugin {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == SubscribeHandleName {
            invokeJSCallback(message)
        }
    }
    
    func invokeJSCallback(_ message: WKScriptMessage) {
        guard let webView = message.webView else { return }
        
        guard let dataObj = message.body as? [String: Any],
            let msgId = dataObj[kMsgId] as? String,
            let path = dataObj[kPath] as? String,
            let res = dataObj[kRes] as? [String: Any]
            else { return kwlog(title:"Invalid Subscribe Res", message.body) }
        
        guard let code = res[kResCode] as? Int,
            let message = res[kResMessage] as? String
            else {
            return kwlog(title:"Invalid Res", res)
        }
        let data: [String: Any] = res[kResData] as? [String : Any] ?? [:]
        let kwres = Res(code: code, message: message, data: data)
        
        guard let handler = webView.kw.viewController.invokeJSs[msgId] else { return }
        handler(kwres)
        kwlog(title: "JS Res", """
        \(kPath):\(path)
        \(kRes):\(res.kw.string ?? "")
        """)
    }
}


