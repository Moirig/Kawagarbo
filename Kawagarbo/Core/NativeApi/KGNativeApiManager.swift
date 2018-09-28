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
    
    private var jsBridge = KGJSBridge()
    
    private var webView: KGWKWebView? { return webViewController?.webView }
    
    private var webViewDelegate: WKNavigationDelegate? { return webView }
    
    private static var nativeApis: [String: KGNativeApiDelegate] = [:]

    private static var dynamicNativeApis: [String: KGNativeApiDelegate] = [:]
    
    override init() {
        super.init()
        
        jsBridge.delegate = self
    }
    
}

extension KGNativeApiManager {
    
    static func addNativeApi(_ api: KGNativeApiDelegate) {
        nativeApis[api.path] = api
    }
    
    static func addDynamicNativeApi(_ api: KGNativeApiDelegate) {
        dynamicNativeApis[api.path] = api
    }
    
    func injectApis() {
        inject(apis: KGNativeApiManager.nativeApis)
    }
    
    public func injectDynamicApis() {
        inject(apis: KGNativeApiManager.dynamicNativeApis)
    }
    
    func removeDynamicApis() {
        KGNativeApiManager.dynamicNativeApis.removeAll()
    }
    
    private func inject(apis: [String: KGNativeApiDelegate]) {
        for (path, api) in apis {
            register(handlerName: path) { (parameters, callback) in
                debugPrint("""
                    ---------------- Web->Native ----------------
                    path:\(path)
                    parameters:\(parameters?.string ?? "")
                    ---------------------------------------------
                    """)
                
                api.perform(with: parameters, complete: { (apiResponse) in
                    if let callback = callback {
                        DispatchQueue.main.async {
                            callback(apiResponse.response)
                        }
                    }
                })
            }
        }
    }
    
}

extension KGNativeApiManager {
        
    public func callWeb(function: String, parameters: [String: Any]? = nil, complete: KGNativeApiResponseClosure? = nil) {
        guard function.count > 0 else { return }
        
        debugPrint(
            """
            ---------------- Native->Web ----------------
            function:\(function)
            \(parameters?.string ?? "")
            ---------------------------------------------
            """
        )
        
        call(handlerName: function, data: parameters) { (response) in
            guard let complete = complete else { return }
            
            debugPrint(
                """
                ---------------- Native->Web ----------------
                function:\(function)
                \(response?.string ?? "")
                ---------------------------------------------
                """
            )
            
            guard let response = response, let code = response["code"] as? Int else {
                return complete(.failure(code: NSURLErrorUnknown, message: "Unknown Error"))
            }
            
            //TODO-配置
            if code == 200 {
                guard let responseData = response["data"] as? [String: Any] else {
                    return complete(.success(data: nil))
                }
                complete(.success(data: responseData))
            }
            else {
                guard let message = response["message"] as? String else {
                    return complete(.failure(code: NSURLErrorUnknown, message: nil))
                }
                complete(.failure(code: NSURLErrorUnknown, message: message))
            }
        }
    }
    
}

extension KGNativeApiManager {
    
    private func register(handlerName: String, handle: @escaping KGJSBridge.Handler) {
        jsBridge.messageHandlers[handlerName] = handle
    }
    
    private func remove(handlerName: String) {
        jsBridge.messageHandlers.removeValue(forKey: handlerName)
    }
    
    private func call(handlerName: String, data: [String: Any]? = nil, callback: KGJSBridge.Callback? = nil) {
        jsBridge.send(handlerName: handlerName, data: data, callback: callback)
    }
    
}

extension KGNativeApiManager: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard webView == self.webView, let webViewDelegate = webViewDelegate, let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if KGJSBridge.isJSBridge(url: url) {
            if KGJSBridge.isBridgeLoaded(url: url) {
                jsBridge.injectJavascriptFile()
            }
            else if (KGJSBridge.isQueueMessage(url: url)) {
                self.wkFlushMessageQueue()
            }
            else {
                KGJSBridge.logUnkownMessage(url: url)
            }
            decisionHandler(.cancel)
            return;
        }
        
        if webViewDelegate.webView?(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler) == nil {
            decisionHandler(.allow)
        }
    }
    
}

extension KGNativeApiManager: KGJSBridgeDelegate {
    
    private func wkFlushMessageQueue() {
        webView?.evaluateJavaScript(KGJSBridge.webViewJavascriptFetchQueyCommand(), completionHandler: { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                debugPrint("KGNativeApiManager: WARNING: Error when trying to fetch data from WKWebView: \(error)")
            }
            if let result = result as? String {
                strongSelf.jsBridge.flush(messageQueueString: result)
            }
        })
    }
    
    func evaluateJavascript(javascript: String) {
        webView?.evaluateJavaScript(javascript, completionHandler: nil)
    }
    
}
