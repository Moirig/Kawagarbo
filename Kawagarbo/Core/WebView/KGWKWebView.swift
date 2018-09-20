//
//  KGWKWebView.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/12.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit
import WebKit

private let kProgressObserverKey: String = "estimatedProgress"

public class KGWKWebView: WKWebView {

    weak var webViewDelegate: KGWKWebViewDelegate?
    
    var progressHidden: Bool {
        get {
            return progressView.isHidden
        }
        set {
            progressView.isHidden = newValue
        }
    }
    
    var progress: Float {
        get {
            return progressView.progress
        }
        set {
            progressView.setProgress(newValue, animated: true)
        }
    }
    
    var banAlert: Bool = false
    
    class var originalUserAgent: String {
        let webview = UIWebView(frame: CGRect.zero)
        var userAgent = webview.stringByEvaluatingJavaScript(from: "navigator.userAgent")
        
        if let projectUserAgent = projectUserAgent {
            userAgent = userAgent?.replacingOccurrences(of: projectUserAgent, with: "")
        }
        
        return userAgent ?? ""
    }
    
    var projectUserAgent: String?
    
    static var projectUserAgent: String?
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        //TODO-配置
        progressView.progressTintColor = UIColor.green
        progressView.alpha = 0
        self.addObserver(self, forKeyPath: kProgressObserverKey, options: [.old, .new], context: nil)
        return progressView;
    }()
    
    private static let sharedProcessPool: WKProcessPool = WKProcessPool()
    
    private class var defaultConfiguration: WKWebViewConfiguration {
        let defaultConfiguration = WKWebViewConfiguration()
        
        if #available(iOS 10.0, *) {
            defaultConfiguration.mediaTypesRequiringUserActionForPlayback = .all
            defaultConfiguration.dataDetectorTypes = [.link, .phoneNumber]
        }
        if #available(iOS 9.0, *) {
            defaultConfiguration.requiresUserActionForMediaPlayback = false
            defaultConfiguration.websiteDataStore = WKWebsiteDataStore.default()
        }
        
        defaultConfiguration.allowsInlineMediaPlayback = true
        defaultConfiguration.processPool = sharedProcessPool
        
        return defaultConfiguration
    }
    
    deinit {
        removeObserver(self, forKeyPath: kProgressObserverKey)
        stopLoading()
        navigationDelegate = nil
        uiDelegate = nil
    }
    
    convenience init() {
        self.init()
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        setupWebView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWebView() {
        addSubview(progressView)
        navigationDelegate = self
        uiDelegate = self
        scrollView.delegate = self
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kProgressObserverKey {
            progressView.alpha = 1
            progressView .setProgress(Float(estimatedProgress), animated: true)
            if estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }) { (finished) in
                    self.progressView .setProgress(0, animated: true)
                }
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}

// MARK: - WKNavigationDelegate
extension KGWKWebView: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let allowed = webViewDelegate?.webView(self, shouldStartLoadWith: navigationAction.request, navigationType: navigationAction.navigationType) else {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(allowed ? .allow : .cancel)
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewDelegate?.webViewDidStartLoad(self)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewDelegate?.webViewDidFinishLoad(self)
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webViewDelegate?.webView(self, didFailLoadWithError: error)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webViewDelegate?.webView(self, didFailLoadWithError: error)
    }
    
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webViewDelegate?.webViewDidTerminate(self)
    }
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust && challenge.previousFailureCount == 0 else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, credential)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let response = navigationResponse.response
        guard response.mimeType == "application/octet-stream" else {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.cancel)
        
        if let urlString = response.url?.absoluteString {
            //TODO-没写完
        }
        
       
    }
    
}

// MARK: - WKUIDelegate
extension KGWKWebView: WKUIDelegate {
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        if banAlert {
            completionHandler()
            return
        }
        
        //TODO-showAlert
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        if banAlert {
            completionHandler(false)
            return
        }
        
        //TODO-showAlert
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        if banAlert {
            completionHandler(nil)
            return
        }
        
        //TODO-showAlert
    }
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
}

// MARK: - UIScrollViewDelegate
extension KGWKWebView: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.decelerationRate = .normal
    }
    
}
