//
//  KGWKJSBridge.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/8/16.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit
import WebKit

class KGWKJSBridge: NSObject {

    private weak var webView: WKWebView?
    private weak var webViewDelegate: WKNavigationDelegate?
    private var base = KGJSBridgeBase()
    
    deinit {
        
    }
    
    init(webView: WKWebView) {
        super.init()
        
        self.webView = webView
        webViewDelegate = webView as? WKNavigationDelegate
        base.delegate = self
        reset()
    }
    
    func reset() {
        base.reset()
    }
    
    func register(handlerName: String, handle: @escaping KGJSBridgeBase.Handler) {
        base.messageHandlers[handlerName] = handle
    }
    
    func remove(handlerName: String) {
        base.messageHandlers.removeValue(forKey: handlerName)
    }
    
    func call(handlerName: String, data: Any? = nil, callback: KGJSBridgeBase.Callback? = nil) {
        base.send(handlerName: handlerName, data: data, callback: callback)
    }
    
}

extension KGWKJSBridge: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard webView == self.webView, let webViewDelegate = webViewDelegate, let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if base.isJSBridge(url: url) {
            if base.isBridgeLoaded(url: url) {
                base.injectJavascriptFile()
            }
            else if (base.isQueueMessage(url: url)) {
                self.wkFlushMessageQueue()
            }
            else {
                base.logUnkownMessage(url: url)
            }
            decisionHandler(.cancel)
            return;
        }
        
        if webViewDelegate.webView?(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler) == nil {
            decisionHandler(.allow)
        }
    }
    
}

extension KGWKJSBridge: KGJSBridgeBaseDelegate {
    
    private func wkFlushMessageQueue() {
        webView?.evaluateJavaScript(base.webViewJavascriptFetchQueyCommand(), completionHandler: { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                debugPrint("KGWKJSBridge: WARNING: Error when trying to fetch data from WKWebView: \(error)")
            }
            if let result = result as? String {
                strongSelf.base.flush(messageQueueString: result)
            }
        })
    }
    
    func evaluateJavascript(javascript: String) {
        webView?.evaluateJavaScript(javascript, completionHandler: nil)
    }
    
}
