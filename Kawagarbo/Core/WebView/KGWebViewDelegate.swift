//
//  KGWebViewDelegate.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/12.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit
import WebKit

protocol KGWebViewDelegate: NSObjectProtocol {
    
    func webView(_ webView: KGWKWebView, shouldStartLoadWith request: URLRequest, navigationType: WKNavigationType) -> Bool
    
    func webViewDidStartLoad(_ webView: KGWKWebView)
    
    func webViewDidFinishLoad(_ webView: KGWKWebView)
    
    func webView(_ webView: KGWKWebView, didFailLoadWithError error: Error)
    
    func webViewDidTerminate(_ webView: KGWKWebView)
    
    func webViewTitleChange(_ webView: KGWKWebView)
    
}

extension KGWebViewDelegate {
    
    func webView(_ webView: KGWKWebView, shouldStartLoadWith request: URLRequest, navigationType: WKNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(_ webView: KGWKWebView) {}
    
    func webViewDidFinishLoad(_ webView: KGWKWebView) {}
    
    func webView(_ webView: KGWKWebView, didFailLoadWithError error: Error) {}
    
    func webViewDidTerminate(_ webView: KGWKWebView) {}
    
    func webViewTitleChange(_ webView: KGWKWebView) {}
    
}
