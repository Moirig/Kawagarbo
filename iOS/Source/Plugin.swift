//
//  Plugin.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

public protocol NavigationPlugin: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didChange url: URL)
    
}
extension NavigationPlugin {
    func webView(_ webView: WKWebView, didChange url: URL) {}

    func regist() {
        PluginManager.navigations.insert(self, at: 0)
    }
}

public protocol UIPlugin: WKUIDelegate {
    
    func webView(_ webView: WKWebView, didChange title: String)
    
}
extension UIPlugin {
    
    func webView(_ webView: WKWebView, didChange title: String) {}
    
    func regist() {
        PluginManager.uis.insert(self, at: 0)
    }
}

public protocol ScriptMessagePlugin: WKScriptMessageHandler {}
extension ScriptMessagePlugin {
    func regist() {
        PluginManager.scriptMessages.insert(self, at: 0)
    }
}

class PluginManager: NSObject {

    static var navigations: [NavigationPlugin] = []
    
    static var uis: [UIPlugin] = []

    static var scriptMessages: [ScriptMessagePlugin] = []

}
