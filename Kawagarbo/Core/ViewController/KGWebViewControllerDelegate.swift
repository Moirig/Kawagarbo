//
//  KGWebViewControllerDelegate.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/14.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit

public protocol KGWKWebViewControllerDelegate: NSObjectProtocol {

    func webViewController(_ webViewController: KGWebViewController, didClickBackItem backItem: Any)
    
    func webViewController(_ webViewController: KGWebViewController, didStartLoad webView: KGWKWebView)

    func webViewController(_ webViewController: KGWebViewController, didFinishLoad webView: KGWKWebView)

    func webViewController(_ webViewController: KGWebViewController, didFailLoad webView: KGWKWebView)

}

extension KGWKWebViewControllerDelegate {
    
    func webViewController(_ webViewController: KGWebViewController, didClickBackItem backItem: Any) {}
    
    func webViewController(_ webViewController: KGWebViewController, didStartLoad webView: KGWKWebView) {}
    
    func webViewController(_ webViewController: KGWebViewController, didFinishLoad webView: KGWKWebView) {}
    
    func webViewController(_ webViewController: KGWebViewController, didFailLoad webView: KGWKWebView) {}
    
}
