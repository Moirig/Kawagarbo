//
//  KGWebViewControllerDelegate.swift
//  KawagarboExample
//
//  Created by wyhazq on 2018/9/14.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit
import WebKit

public protocol KGWebViewControllerDelegate: NSObjectProtocol {
    
    func webViewController(_ webViewController: KGWebViewController, shouldStartLoadWith request: URLRequest, navigationType: WKNavigationType) -> Bool
    
    func webViewControllerDidStartLoad(_ webViewController: KGWebViewController)

    func webViewControllerDidFinishLoad(_ webViewController: KGWebViewController)

    func webViewControllerDidFailLoad(_ webViewController: KGWebViewController)

}

extension KGWebViewControllerDelegate {
        
    func webViewController(_ webViewController: KGWebViewController, shouldStartLoadWith request: URLRequest, navigationType: WKNavigationType) -> Bool { return true }
    
    func webViewControllerDidStartLoad(_ webViewController: KGWebViewController) {}
    
    func webViewControllerDidFinishLoad(_ webViewController: KGWebViewController) {}
    
    func webViewControllerDidFailLoad(_ webViewController: KGWebViewController) {}
    
}
