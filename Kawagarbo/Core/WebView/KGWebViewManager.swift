//
//  KGWebViewManager.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/21.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit

public class KGWebViewManager: NSObject {
    
    static let manager: KGWebViewManager = KGWebViewManager()
    
    lazy var webViewStack: [KGWKWebView] = {
        let stack = [KGWKWebView]()
        return stack
    }()
    
    var emptyWebView: KGWKWebView?
    
    static var createWebView: KGWKWebView {
        if KGWebViewManager.manager.emptyWebView == nil {
            createEmptyWebView()
        }
        
        let webview = KGWebViewManager.manager.emptyWebView!
        KGWebViewManager.manager.webViewStack.append(webview)
        createEmptyWebView()
        return webview
    }
    
    static var currentWebView: KGWKWebView? {
        return KGWebViewManager.manager.webViewStack.last
    }

    public class func preloadWebView() {
        let webView = KGWKWebView(frame: CGRect.zero, configuration: KGWKWebView.defaultConfiguration)
        webView.loadHTMLString("", baseURL: nil)
        KGWebViewManager.manager.emptyWebView = webView
    }
    
    class func createEmptyWebView() {
        KGWebViewManager.manager.emptyWebView = KGWKWebView(frame: CGRect.zero, configuration: KGWKWebView.defaultConfiguration)
    }
    
    class func removeCurrentWebView() {
        KGWebViewManager.manager.webViewStack.removeLast()
    }

}
