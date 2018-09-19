//
//  KGWebViewController.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/14.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit
import WebKit

public class KGWebViewController: UIViewController {
    
    public typealias KGWebCallback = (_ path: String, _ data: [String: Any], _ error: Error) -> Void
    
    public weak var webView: KGWKWebView?
    
    //TODO-没完成
    public var webRoute: Any?
    
    public weak var delegate: KGWKWebViewControllerDelegate?
    
    public static var delegate: KGWKWebViewControllerDelegate?
    
    public var callback: KGWebCallback?
    
    public var userInfo: [String: Any]?
    
    private lazy var jsBridge: KGWKJSBridge = {
        let jsBridge = KGWKJSBridge(webView: self.webView!)
        return jsBridge
    }()
    
    public convenience init(urlString: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) {
        self.init()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

}

// MARK: - Setup
extension KGWebViewController {
    
    func reloadWebView() {
        
    }
    
    func registNativeApi() {
        
    }
    
    func setupNavigatonController() {
        
    }
    
}


// MARK: - KGWKWebViewDelegate
extension KGWebViewController: KGWKWebViewDelegate {
    
    func webView(_ webView: KGWKWebView, shouldStartLoadWith request: URLRequest, navigationType: WKNavigationType) -> Bool {
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: KGWKWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: KGWKWebView) {
        
    }
    
    func webView(_ webView: KGWKWebView, didFailLoadWithError error: Error) {
        
    }
    
    func webViewDidTerminate(_ webView: KGWKWebView) {
        
    }
    
}


// MARK: - Action
extension KGWebViewController {
    
    func showFailView(with error: Error) {
        
    }
    
    func updateWebRoute() {
        
    }
    
    func updateWebUI() {
        
    }
    
    func leftItemAction(_ sender: UIButton) {
        
    }
    
    func rightItemAction(_ sender: UIButton) {
        
    }
    
}

extension KGWebViewController {
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(exitApp(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc func exitApp(_ notification: Notification) {
        
    }
    
}

