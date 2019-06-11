//
//  KGWebViewController.swift
//  KawagarboExample
//
//  Created by wyhazq on 2018/9/14.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit
import WebKit

public class KGWebViewController: UIViewController {
    
    public lazy var config: KGConfig = {
        let config = KGConfig()
        
        return config
    }()
    
    public var nativeApiManager: KGNativeApiManager? {
        return webView?.nativeApiManager
    }
    
    public var webRoute: KGWebRoute?
    
    public weak var delegate: KGWebViewControllerDelegate?
    
    public static var delegate: KGWebViewControllerDelegate?
    
    public var userInfo: [String: Any]?

    var originUI = KGWebVCUI()
    var currentUI = KGWebVCUI()
    
    lazy var titleView: KGTitleView = {
        return KGTitleView(frame: CGRect(x: 0, y: 0, width: UIScreen.kg.width - 140, height: 44))
    }()
    
    public weak var webView: KGWKWebView?
    
    public func start(with vc: UIViewController) {
        guard let route = webRoute else { return }
        if let urlStr = route.webAppUrlString {
            //download webApp
            return
        }
        vc.navigationController?.pushViewController(self, animated: true)
    }
    
    deinit {
        KGLog(title: "Deinit", self)
        deinitWebView()
    }
    
    func deinitWebView() {
        guard let webView = webView else { return }
        webView.webViewDelegate = nil
        webView.scrollView.delegate = nil
        webView.removeFromSuperview()
        KGWebViewManager.destoryCurrentWebView()
    }
    
    public convenience init(urlString: String, parameters: [String: String]? = nil, headerFields: [String: String]? = nil) {
        self.init()
        webRoute = KGWebRoute(urlString: urlString, parameters: parameters, headerFields: headerFields)
        webRoute?.config = config
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        KGLog(title: "ViewDidLoad", self)
        
        storeOriginUI()
        navigationItem.titleView = titleView
        view.backgroundColor = UIColor.white

        setup()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeToCurrentUI()
        if webView?.url == nil || webView?.url?.absoluteString == "about:blank" {
            setup()
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetToOriginUI()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        removeNotification()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let webView = webView else { return }
        var navigationBarHeight: CGFloat = 0
        var tabbarHeight: CGFloat = 0
        
        if let navigationController = navigationController, navigationController.navigationBar.frame.maxY > 20 {
            navigationBarHeight = navigationController.navigationBar.frame.maxY
        }
        
        if let count = navigationController?.viewControllers.count, count == 1, let tabBar = tabBarController?.tabBar, tabBar.isHidden == false {
            tabbarHeight = tabBar.frame.height
        }
        
        var frame = webView.frame
        frame.origin.y = navigationBarHeight
        frame.size.height = UIScreen.kg.height - navigationBarHeight - tabbarHeight
        webView.frame = frame
    }

}

// MARK: - Setup
extension KGWebViewController {
    
    public func setup() {
        deinitWebView()
        setupWebView()
        injectNativeApi()
        reloadWebView()
    }
    
    func injectNativeApi() {
        
        nativeApiManager?.webViewController = self

        if config.injectDynamically == false {
            nativeApiManager?.injectApis()
        }
    }
    
    func setupWebView() {
        let webview = KGWKWebView.webView
        webview.config = config
        webview.frame = view.frame
        webview.webViewDelegate = self
        webview.scrollView.delegate = self
//        webview.allowDisplayingKeyboardWithoutUserAction = true

        if #available(iOS 11.0, *) {
            webview.scrollView.contentInsetAdjustmentBehavior = .never
        }
        else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        webView = webview
    }
    
    func reloadWebView() {
        guard let webView = webView else { return }
        
        if !view.subviews.contains(webView) {
            view .addSubview(webView)
        }
        
        guard let urlRequest = webRoute?.urlRequest, let url = webRoute?.url else { return }
        
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
    
    func storeOriginUI() {
        originUI.navigationBar.frontColor = config.barFrontColor
        originUI.navigationBar.backgroundColor = config.barBackgroundColor
        
        currentUI.navigationBar.frontColor = config.barFrontColor
        currentUI.navigationBar.backgroundColor = config.barBackgroundColor
    }
    
    func changeToCurrentUI() {
        if let bar = navigationController?.navigationBar {
            bar.tintColor = currentUI.navigationBar.frontColor
            bar.barTintColor = currentUI.navigationBar.backgroundColor
            titleView.tintColor = currentUI.navigationBar.frontColor
            UIApplication.shared.statusBarStyle = currentUI.navigationBar.frontColor == UIColor(hexString: "#ffffff") ? .lightContent : .default
        }
    }
    
    func resetToOriginUI() {
        if let bar = navigationController?.navigationBar {
            bar.tintColor = originUI.navigationBar.frontColor
            bar.barTintColor = originUI.navigationBar.backgroundColor
            titleView.tintColor = originUI.navigationBar.frontColor
            UIApplication.shared.statusBarStyle = originUI.navigationBar.frontColor == UIColor(hexString: "#ffffff") ? .lightContent : .default
        }
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
        
        if config.injectDynamically == false {
            onReady()
        }
        
//        onShow()
        
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
        setup()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(onHide), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onShow), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func onKeyboardHeightChange(_ notification: Notification) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat) ?? 0
        let frame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) ?? CGRect.zero
        let height = UIScreen.kg.height - frame.minY
        let data: [String: CGFloat] = ["duration": duration, "height": height]
        nativeApiManager?.callJS(function: "onKeyboardHeightChange_subscription", parameters: data)
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
    
    @objc func onShow() {
        nativeApiManager?.callJS(function: "onShow")
    }
    
    @objc func onHide() {
        nativeApiManager?.callJS(function: "onHide")
    }
    
    func onUnload() {
        nativeApiManager?.callJS(function: "onUnload")
    }
    
    func onReady() {
        nativeApiManager?.callJS(function: "onReady")
    }
    
    private func isUnload(_ webView: KGWKWebView, shouldStartLoadWith request: URLRequest, navigationType: WKNavigationType) -> Bool {
        //goback
        if navigationType == .backForward && webView.backForwardList.backItem?.url.absoluteString == request.url?.absoluteString {
            return true
        }
        
        return false
    }
}

extension KGWebViewController {
    
    public override var title: String? {
        get {
            return titleView.title
        }
        set {
            titleView.title = newValue ?? ""
        }
    }
    
}
