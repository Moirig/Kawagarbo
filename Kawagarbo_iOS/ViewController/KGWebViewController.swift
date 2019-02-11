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
    
    public lazy var config: KGConfig = {
        let config = KGConfig()
        
        return config
    }()
    
    public lazy var webView: KGWKWebView = {
        let webView = KGWKWebView.webView
        webView.frame = view.frame
        webView.webViewDelegate = self
        webView.scrollView.delegate = self
        
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        return webView
    }()
    
    public var nativeApiManager: KGNativeApiManager {
        return webView.nativeApiManager!
    }
    
    public var webRoute: KGWebRoute?
    
    public weak var delegate: KGWebViewControllerDelegate?
    
    public static var delegate: KGWebViewControllerDelegate?
    
    public var callback: KGWebCallback?
    
    public var userInfo: [String: Any]?
    
    deinit {
        KGLog(title: "Deinit", self)
        deinitWebView()
    }
    
    func deinitWebView() {
        webView.webViewDelegate = nil
        webView.scrollView.delegate = nil
        webView.removeFromSuperview()
        KGWebViewManager.removeCurrentWebView()
    }
    
    public convenience init(urlString: String, parameters: [String: String]? = nil, headerFields: [String: String]? = nil) {
        self.init()
        webRoute = KGWebRoute(urlString: urlString, parameters: parameters, headerFields: headerFields)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        KGLog(title: "ViewDidLoad", self)
        view.backgroundColor = UIColor.white
        
        addNotification()
        
        injectNativeApi()
        
        webRoute?.config = config
        webView.config = config
        view.addSubview(webView)
        reloadWebView()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if webView.url == nil || webView.url?.absoluteString == "about:blank" {
            reset()
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        removeNotification()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let navigationBar = navigationController?.navigationBar, navigationBar.frame.maxY > 20 else {
            return
        }
        
        var frame = webView.frame
        frame.origin.y = navigationBar.frame.maxY
        frame.size.height = UIScreen.kg.height - navigationBar.frame.maxY
        webView.frame = frame
    }

}

// MARK: - Setup
extension KGWebViewController {
    
    func injectNativeApi() {
        
        nativeApiManager.webViewController = self

        if config.isInjectDynamically == false {
            nativeApiManager.injectApis()
        }
    }
    
    func reloadWebView() {
        if !view.subviews.contains(webView) {
            view .addSubview(webView)
        }
        
        guard let urlRequest = webRoute?.urlRequest else { return }
        guard let url = urlRequest.url else { return }
        
        //TODO-加载离线包首页的逻辑
        if #available(iOS 9.0, *), url.isFileURL {
            let accessUrl = URL(fileURLWithPath: KawagarboCachePath)
            webView.loadFileURL(url, allowingReadAccessTo: accessUrl)
        }
        else {
            webView.load(urlRequest)
        }
        KGLog(title: "Reload:", url.absoluteString)
        
    }
    
    func reset() {
        deinitWebView()
        injectNativeApi()
        reloadWebView()
    }
    
}


// MARK: - KGWebViewDelegate
extension KGWebViewController: KGWebViewDelegate {
    
    func webView(_ webView: KGWKWebView, shouldStartLoadWith request: URLRequest, navigationType: WKNavigationType) -> Bool {
        guard let url = request.url, let scheme = url.scheme else { return false }
        
        KGLog(title: "ShouldStart:", url.absoluteString)
        
        if scheme.kg.isHTTP || scheme.kg.isFile {
            if navigationType != .reload {
                if isUnload(webView, shouldStartLoadWith: request, navigationType: navigationType) {
                    onUnload()
                }
                else {
                    onHide()
                }
            }
        }
        
        if let adelegate = delegate {
            return adelegate.webViewController(self, shouldStartLoadWith: request, navigationType: navigationType)
        }
        if let adelegate = KGWebViewController.delegate {
            return adelegate.webViewController(self, shouldStartLoadWith: request, navigationType: navigationType)
        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: KGWKWebView) {
        
        KGWebViewController.delegate?.webViewControllerDidStartLoad(self)
        delegate?.webViewControllerDidStartLoad(self)
    }
    
    func webViewDidFinishLoad(_ webView: KGWKWebView) {
        
        if !config.isInjectDynamically {
            onReady()
        }
        
        onShow()
        
        KGWebViewController.delegate?.webViewControllerDidFinishLoad(self)
        delegate?.webViewControllerDidFinishLoad(self)
    }
    
    func webView(_ webView: KGWKWebView, didFailLoadWithError error: Error) {
        KGLog(title: "didFailLoad:", error)
        
        let nsError = error as NSError
        if nsError.code == 102 || nsError.code == 204 { return }
        if let urlError = error as? URLError, urlError.code == .cancelled { return }

        if let url = webView.url, url.isFileURL,
           let forwardItemScheme = webView.backForwardList.forwardItem?.url.scheme, forwardItemScheme.kg.isHTTP,
           let filePath = webView.url?.absoluteString.kg.noScheme, FileManager.kg.fileExists(atPath: filePath) {
            return reloadWebView()
        }
        
        KGWebViewController.delegate?.webViewControllerDidFailLoad(self)
        delegate?.webViewControllerDidFailLoad(self)
    }
    
    func webViewDidTerminate(_ webView: KGWKWebView) {
        reset()
    }
    
    func webViewTitleChange(_ webView: KGWKWebView) {
        title = webView.title
    }
    
}


// MARK: - Action
extension KGWebViewController {
    
    func updateWebRoute(url: URL) {
        guard url.absoluteString != "about:blank" else { return }
        guard let urlString = webRoute?.urlString, urlString == url.absoluteString else { return }
        
        webRoute = KGWebRoute(urlString: url.absoluteString)
    }
    
}

// MARK: - Notification
extension KGWebViewController {

    func addNotification() {
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            guard let strongSelf = self else { return }
            strongSelf.onHide()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            guard let strongSelf = self else { return }
            strongSelf.onShow()
        }
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - UIScrollViewDelegate
extension KGWebViewController: UIScrollViewDelegate {
    
    private func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.decelerationRate = .normal
    }
    
}

// MARK: - Web Life Cycle
extension KGWebViewController {
    
    func onShow() {
        nativeApiManager.callJS(function: "onShow")
    }
    
    func onHide() {
        nativeApiManager.callJS(function: "onHide")
    }
    
    func onUnload() {
        nativeApiManager.callJS(function: "onUnload")
    }
    
    func onReady() {
        nativeApiManager.callJS(function: "onReady")
    }
    
    private func isUnload(_ webView: KGWKWebView, shouldStartLoadWith request: URLRequest, navigationType: WKNavigationType) -> Bool {
        //goback
        if navigationType == .backForward && webView.backForwardList.backItem?.url.absoluteString == request.url?.absoluteString {
            return true
        }
        
        return false
    }
}
