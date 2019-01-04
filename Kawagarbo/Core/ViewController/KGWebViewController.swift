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
    
    public typealias KGWebCallback = (_ path: String, _ data: [String: Any]?, _ error: NSError?) -> Void
    
    public lazy var webView: KGWKWebView = {
        let webView = KGWKWebView.webView
        webView.frame = view.frame
        webView.webViewDelegate = self
        return webView
    }()
    
    //TODO-没完成
    public var webRoute: Any?
    
    public weak var delegate: KGWebViewControllerDelegate?
    
    public static var delegate: KGWebViewControllerDelegate?
    
    public var callback: KGWebCallback?
    
    public var userInfo: [String: Any]?
    
    private lazy var nativeApiManager: KGNativeApiManager = {
        let manager = KGNativeApiManager()
        manager.webViewController = self
        return manager
    }()
    
    deinit {
        nativeApiManager.removeAllApis()
        deinitWebView()
    }
    
    func deinitWebView() {
        webView.webViewDelegate = nil
        webView.scrollView.delegate = nil
        webView.removeFromSuperview()
        KGWebViewManager.removeCurrentWebView()
    }
    
    public convenience init(urlString: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) {
        self.init()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)

    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if webView.url == nil || webView.url?.absoluteString == "about:blank" {
            deinitWebView()
            reloadWebView()
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = !webView.canGoBack
        //TODO-Path
        nativeApiManager.callJS(function: "")
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //TODO-Path
        nativeApiManager.callJS(function: "")
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        removeNotification()
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


// MARK: - KGWebViewDelegate
extension KGWebViewController: KGWebViewDelegate {
    
    func webView(_ webView: KGWKWebView, shouldStartLoadWith request: URLRequest, navigationType: WKNavigationType) -> Bool {
        guard let url = request.url, let scheme = url.scheme, let host = url.host else { return false }
        debugPrint(
            """
            ---------------- ShouldStart ----------------
            \(url.absoluteString)
            ---------------------------------------------
            """
        )
        
        if !url.isFileURL {
            if scheme.isHTTP && host == "itunes.apple.com" {
                UIApplication.shared.openURL(url)
                return false
            }
            else if scheme == "tel" {
                let phoneCallStr = url.absoluteString.replacingOccurrences(of: scheme, with: "telprompt")
                guard let telUrl = URL(string: phoneCallStr) else {
                    return false
                }
                UIApplication.shared.openURL(telUrl)
            }
            else {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
                return false
            }
        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: KGWKWebView) {
        
        KGWebViewController.delegate?.webViewControllerDidStartLoad(self)
        delegate?.webViewControllerDidStartLoad(self)
    }
    
    func webViewDidFinishLoad(_ webView: KGWKWebView) {
        
        KGWebViewController.delegate?.webViewControllerDidFinishLoad(self)
        delegate?.webViewControllerDidFinishLoad(self)
    }
    
    func webView(_ webView: KGWKWebView, didFailLoadWithError error: Error) {
        let nsError = error as NSError
        if nsError.code == 102 || nsError.code == 204 { return }
        if let urlError = error as? URLError, urlError.code == .cancelled { return }

        if let url = webView.url, url.isFileURL,
           let forwardItemScheme = webView.backForwardList.forwardItem?.url.scheme, forwardItemScheme.isHTTP,
           let filePath = webView.url?.absoluteString.replacingOccurrences(of: "file://", with: ""), FileManager.default.fileExists(atPath: filePath) {
            return reloadWebView()
        }
        
        KGWebViewController.delegate?.webViewControllerDidFailLoad(self)
        delegate?.webViewControllerDidFailLoad(self)
    }
    
    func webViewDidTerminate(_ webView: KGWKWebView) {
        deinitWebView()
        reloadWebView()
    }
    
    func webViewTitleChange(_ webView: KGWKWebView) {
        title = webView.title
    }
    
}


// MARK: - Action
extension KGWebViewController {
    
    func updateWebRoute() {
        
    }
    
    func updateUI() {
        webView.evaluateJavaScript("document.title") { [weak self] (obj, error) in
            guard let strongSelf = self, let title = obj as? String else { return }
            strongSelf.title = title
        }
    }
    
}

// MARK: - Notification
extension KGWebViewController {
    //TODO-配置
    func addNotification() {
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: OperationQueue.main) { (notification) in
            self.nativeApiManager.callJS(function: "")
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.main) { (notification) in
            self.nativeApiManager.callJS(function: "")
        }
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Call Web
extension KGWebViewController {
    
    
    
}

