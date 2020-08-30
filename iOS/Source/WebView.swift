//
//  WebView.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

//观察mainRunloop空闲时创建
public class WebView {
    
    static var stack: [WKWebView] = []
        
    static var top: WKWebView {
        if stack.count > 0 {
            let webView = stack.removeLast()
            preload()
            return webView
        }
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        preload()
        return webView
    }
    
    public static func preload() {
        if stack.count > 0 { return }
        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 2000008) { (observer, activity) in
            if stack.count > 0 { return }
            let webView = WKWebView(frame: .zero, configuration: configuration)
            webView.loadHTMLString("", baseURL: nil)
            stack.append(webView)
            CFRunLoopObserverInvalidate(observer)
        }
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, CFRunLoopMode.defaultMode)
    }
    
    private static let processPool: WKProcessPool = WKProcessPool()
    
    private static var configuration: WKWebViewConfiguration {
        let defaultConfiguration = WKWebViewConfiguration()
        defaultConfiguration.mediaTypesRequiringUserActionForPlayback = .all
        defaultConfiguration.allowsInlineMediaPlayback = true
        defaultConfiguration.processPool = processPool
        
        return defaultConfiguration
    }
    
}





