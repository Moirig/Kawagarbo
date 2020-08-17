//
//  WebViewController+Extension.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

extension WebViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didChange url: URL) {
        guard PluginManager.navigations.count > 0 else { return }

        for plugin in PluginManager.navigations {
            plugin.webView(webView, didChange: url)
        }
    }
    
    // should request
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard PluginManager.navigations.count > 0 else { return decisionHandler(.allow) }

        var isCallback: Bool = false
        for plugin in PluginManager.navigations {
            plugin.webView?(webView, decidePolicyFor: navigationAction, decisionHandler: { (policy) in
                guard !isCallback else { return }
                isCallback = true
                decisionHandler(policy)
            })
        }
        guard !isCallback else { return }
        isCallback = true
        decisionHandler(.allow)
    }

    // challenge
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard PluginManager.navigations.count > 0 else { return completionHandler(.performDefaultHandling, nil) }
        
        var isCallback: Bool = false
        for plugin in PluginManager.navigations {
            plugin.webView?(webView, didReceive: challenge, completionHandler: { (disposition, credential) in
                guard !isCallback else { return }
                isCallback = true
                completionHandler(disposition, credential)
            })
        }
        
        guard !isCallback else { return }
        isCallback = true
        completionHandler(.performDefaultHandling, nil)
    }

    // did start
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard PluginManager.navigations.count > 0 else { return }

        for plugin in PluginManager.navigations {
            plugin.webView?(webView, didStartProvisionalNavigation: navigation)
        }
    }

    // response
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard PluginManager.navigations.count > 0 else { return decisionHandler(.allow) }

        var isCallback: Bool = false
        for plugin in PluginManager.navigations {
            plugin.webView?(webView, decidePolicyFor: navigationResponse, decisionHandler: { (policy) in
                guard !isCallback else { return }
                isCallback = true
                decisionHandler(policy)
            })
        }
        guard !isCallback else { return }
        isCallback = true
        decisionHandler(.allow)
    }

    // finish
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard PluginManager.navigations.count > 0 else { return }

        for plugin in PluginManager.navigations {
            plugin.webView?(webView, didFinish: navigation)
        }
    }

    // error
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        guard PluginManager.navigations.count > 0 else { return }

        for plugin in PluginManager.navigations {
            plugin.webView?(webView, didFailProvisionalNavigation: navigation, withError: error)
        }
    }

    // error
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard PluginManager.navigations.count > 0 else { return }

        for plugin in PluginManager.navigations {
            plugin.webView?(webView, didFail: navigation, withError: error)
        }
    }

    // terminate
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        guard PluginManager.navigations.count > 0 else { return }

        for plugin in PluginManager.navigations {
            plugin.webViewWebContentProcessDidTerminate?(webView)
        }
    }
    
}

extension WebViewController: WKUIDelegate {
    
    public func webView(_ webView: WKWebView, didChange title: String) {
        guard PluginManager.uis.count > 0 else { return }

        for plugin in PluginManager.uis {
            plugin.webView(webView, didChange: title)
        }
    }
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard PluginManager.uis.count > 0 else { return nil }

        for plugin in PluginManager.uis {
            let _ = plugin.webView?(webView, createWebViewWith: configuration, for: navigationAction, windowFeatures: windowFeatures)
        }
        
        return nil
    }
    
    public func webViewDidClose(_ webView: WKWebView) {
        guard PluginManager.uis.count > 0 else { return }

        for plugin in PluginManager.uis {
            plugin.webViewDidClose?(webView)
        }
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        guard PluginManager.uis.count > 0 else { return completionHandler() }

        for plugin in PluginManager.uis {
            plugin.webView?(webView, runJavaScriptAlertPanelWithMessage: message, initiatedByFrame: frame, completionHandler: {
                return completionHandler()
            })
        }
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        guard PluginManager.uis.count > 0 else { return completionHandler(true) }

        for plugin in PluginManager.uis {
            plugin.webView?(webView, runJavaScriptConfirmPanelWithMessage: message, initiatedByFrame: frame, completionHandler: { (isComfirm) in
                return completionHandler(isComfirm)
            })
        }
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        guard PluginManager.uis.count > 0 else { return completionHandler(defaultText) }

        for plugin in PluginManager.uis {
            plugin.webView?(webView, runJavaScriptTextInputPanelWithPrompt: prompt, defaultText: defaultText, initiatedByFrame: frame, completionHandler: { (text) in
                return completionHandler(text)
            })
        }
    }
    
}

extension WebViewController: WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard PluginManager.scriptMessages.count > 0 else { return }
        
        for plugin in PluginManager.scriptMessages {
            plugin.userContentController(userContentController, didReceive: message)
        }
    }
    
}
