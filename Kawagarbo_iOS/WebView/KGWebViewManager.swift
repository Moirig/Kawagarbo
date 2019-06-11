//
//  KGWebViewManager.swift
//  KawagarboExample
//
//  Created by wyhazq on 2018/9/21.
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
    
    static func createWebView() -> KGWKWebView {
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

    public static func preloadWebView() {
        let webView = getWebView
        webView.loadHTMLString("", baseURL: nil)
        KGWebViewManager.manager.emptyWebView = webView
    }
    
    static func createEmptyWebView() {
        KGWebViewManager.manager.emptyWebView = getWebView
    }
    
    static var getWebView: KGWKWebView {
        let configuration = KGWKWebView.defaultConfiguration
        let nativeApiManager = KGNativeApiManager()
        let userContentController = nativeApiManager.userContentController
        configuration.userContentController = userContentController
        let webView = KGWKWebView(frame: CGRect.zero, configuration: configuration)
        webView.nativeApiManager = nativeApiManager
        return webView
    }
    
    static func destoryCurrentWebView() {
        KGWebViewManager.manager.webViewStack.removeLast()
    }

}
