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
    
    public typealias CallWebCompleteClosure = (_ data: [String: Any]?, _ error: NSError?) -> Void
    
    public func callWeb(function: String, parameters: [String: Any]? = nil, complete: CallWebCompleteClosure? = nil) {
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
            if let _ = response as? [Any] {
                complete(nil, NSError(code: NSURLErrorUnknown, message: "Unknown Error"))
                return
            }
            
            var dictionary: [String: Any]?
            
            if let string = response as? String {
                let data = string.data(using: .utf8)
                dictionary = data?.dictionary
            }
            else if let data = response as? Data {
                dictionary = data.dictionary
            }
            else if let dict = response as? [String: Any] {
                dictionary = dict
            }
            
            debugPrint(
                """
                ---------------- Native->Web ----------------
                function:\(function)
                \(dictionary?.string ?? "")
                ---------------------------------------------
                """
            )
            
            guard let dict = dictionary, let code = dict["code"] as? Int else {
                complete(nil, NSError(code: NSURLErrorUnknown, message: "Unknown Error"))
                return
            }
            
            //TODO-配置
            if code == 200 {
                if let dataDic = dict["data"] as? [String: Any] {
                    complete(dataDic, nil)
                }
                else {
                    complete(nil, nil)
                }
            }
            else {
                let error: NSError
                if let message = dict["message"] as? String {
                    error = NSError(code: code, message: message)
                }
                else {
                    error = NSError(code: code)
                }
                complete(nil, error)
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
    
    private func call(handlerName: String, data: Any? = nil, callback: KGJSBridge.Callback? = nil) {
        jsBridge.send(handlerName: handlerName, data: data, callback: callback)
    }
    
}

extension KGNativeApiManager: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard webView == self.webView, let webViewDelegate = webViewDelegate, let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if jsBridge.isJSBridge(url: url) {
            if jsBridge.isBridgeLoaded(url: url) {
                jsBridge.injectJavascriptFile()
            }
            else if (jsBridge.isQueueMessage(url: url)) {
                self.wkFlushMessageQueue()
            }
            else {
                jsBridge.logUnkownMessage(url: url)
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
        webView?.evaluateJavaScript(jsBridge.webViewJavascriptFetchQueyCommand(), completionHandler: { [weak self] (result, error) in
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
