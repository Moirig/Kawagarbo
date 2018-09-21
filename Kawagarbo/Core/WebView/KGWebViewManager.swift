//
//  KGWebViewManager.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/21.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit

class KGWebViewManager: NSObject {
    
    static let manager: KGWebViewManager = KGWebViewManager()
    
    lazy var webViewStack: [KGWKWebView] = {
        let stack = [KGWKWebView]()
        return stack
    }()
    
    var emptyWebView: KGWKWebView?
    
    var createWebView: KGWKWebView {
        if KGWebViewManager.manager.emptyWebView == nil {
            createEmptyWebView()
        }
        
        let webview = KGWebViewManager.manager.emptyWebView!
        KGWebViewManager.manager.webViewStack.append(webview)
        createEmptyWebView()
        return webview
    }
    
    var currentWebView: KGWKWebView? {
        return KGWebViewManager.manager.webViewStack.last
    }

    func preloadWebView() {
        let webView = KGWKWebView(frame: CGRect.zero, configuration: KGWKWebView.defaultConfiguration)
        webView.loadHTMLString("", baseURL: nil)
        KGWebViewManager.manager.emptyWebView = webView
    }
    
    func createEmptyWebView() {
        KGWebViewManager.manager.emptyWebView = KGWKWebView(frame: CGRect.zero, configuration: KGWKWebView.defaultConfiguration)
    }
    
    func removeEmptyWebView() {
        KGWebViewManager.manager.webViewStack.removeLast()
    }

}
