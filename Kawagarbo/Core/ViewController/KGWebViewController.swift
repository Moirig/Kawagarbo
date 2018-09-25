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
    
    public weak var delegate: KGWKWebViewControllerDelegate?
    
    public static var delegate: KGWKWebViewControllerDelegate?
    
    public var callback: KGWebCallback?
    
    public var userInfo: [String: Any]?
    
    private lazy var jsBridge: KGWKJSBridge = {
        let jsBridge = KGWKJSBridge(webView: self.webView)
        return jsBridge
    }()
    
    deinit {
        
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
        callWeb(function: "kg.enterPage")
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        callWeb(function: "kg.exitPage")
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


// MARK: - KGWKWebViewDelegate
extension KGWebViewController: KGWKWebViewDelegate {
    
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
            self.callWeb(function: "kg.exitApp")
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.main) { (notification) in
            self.callWeb(function: "kg.enterApp")
        }
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Call Web
extension KGWebViewController {
    
    public typealias KGCallWebComplete = (_ data: [String: Any]?, _ error: NSError?) -> Void

    func callWeb(function: String, parameters: [String: Any]? = nil, complete: KGCallWebComplete? = nil) {
        guard function.count > 0 else { return }
        
        debugPrint(
            """
            ---------------- Native->Web ----------------
            function:\(function)
            \(parameters?.string ?? "")
            ---------------------------------------------
            """
        )
        
        jsBridge.call(handlerName: function, data: parameters) { (response) in
            guard let complete = complete else { return }
            if let _ = response as? [Any] {
                complete(nil, NSError(code: NSURLErrorUnknown, message: "Unknown Error"))
                return
            }
            
            var dictionary: [String: Any]?
            
            if let string = response as? String {
                let data = string.data(using: .utf8)
                dictionary = data?.dictionary
            }
            else if let data = response as? Data {
                dictionary = data.dictionary
            }
            else if let dict = response as? [String: Any] {
                dictionary = dict
            }
            
            debugPrint(
                """
                ---------------- Native->Web ----------------
                function:\(function)
                \(dictionary?.string ?? "")
                ---------------------------------------------
                """
            )
            
            guard let dict = dictionary, let code = dict["code"] as? Int else {
                complete(nil, NSError(code: NSURLErrorUnknown, message: "Unknown Error"))
                return
            }
            
            //TODO-配置
            if code == 200 {
                if let dataDic = dict["data"] as? [String: Any] {
                    complete(dataDic, nil)
                }
                else {
                    complete(nil, nil)
                }
            }
            else {
                let error: NSError
                if let message = dict["message"] as? String {
                    error = NSError(code: code, message: message)
                }
                else {
                    error = NSError(code: code)
                }
                complete(nil, error)
            }
        }
    }
    
}

