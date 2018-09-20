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
    
    public typealias KGWebCallback = (_ path: String, _ data: [String: Any]?, _ error: Error?) -> Void
    
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

// MARK: - Notification
extension KGWebViewController {
    
    func addNotification() {
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: OperationQueue.main) { (notification) in
            
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.main) { (notification) in
            
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

