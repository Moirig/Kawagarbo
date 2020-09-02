//
//  WebViewController.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

private let KVOKeyProgress: String = "estimatedProgress"
private let KVOKeyTitle: String = "title"
private let KVOKeyURL: String = "URL"
private let KVOKeyCanGoBack: String = "canGoBack"


public class WebViewController: UIViewController {
    
    lazy var morePopupView: MorePopupView = {
        let morePopupView = MorePopupView()
        
        return morePopupView
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 0)))
        progressView.progressTintColor = UIColor.green
        progressView.trackTintColor = UIColor.white
        return progressView
    }()

    lazy var webView: WKWebView = {
        let webView = WebView.top
        
        var originY: CGFloat = 0
        if let navigationController = navigationController, navigationController.navigationBar.frame.maxY > 20 {
            originY = navigationController.navigationBar.frame.maxY
        }
        webView.frame = CGRect(x: 0, y: originY, width: view.bounds.width, height: view.bounds.height - originY)
        
        webView.allowsBackForwardNavigationGestures = true
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        
        webView.addObserver(self, forKeyPath: KVOKeyProgress, options: [.old, .new], context: nil)
        webView.addObserver(self, forKeyPath: KVOKeyTitle, options: [.old, .new], context: nil)
        webView.addObserver(self, forKeyPath: KVOKeyURL, options: [.old, .new], context: nil)
        
        return webView
    }()
    
    lazy var toolbar: Toolbar = {
        let toolbar = Toolbar(frame: CGRect(x: 0, y: webView.bounds.height - ToolbarHeight, width: webView.frame.width, height: ToolbarHeight))
        toolbar.adelegate = self
        toolbar.isHidden = true
        return toolbar
    }()
    
    public var route: Route!
    @IBInspectable public var path: String = ""
    private var query: [String: Any]? = nil
    private var params: [String: Any]? = nil

    
    var invokeJSs = [String: (Res) -> Void]()
    var uniqueId = 0
    
    deinit {
        webView.removeObserver(self, forKeyPath: KVOKeyProgress)
        webView.removeObserver(self, forKeyPath: KVOKeyTitle)
        webView.removeObserver(self, forKeyPath: KVOKeyURL)
        webView.removeObserver(self, forKeyPath: KVOKeyCanGoBack)
    }
    
}

extension WebViewController {
    
    convenience public init(path: String, query: [String: Any]? = nil, params: [String: Any]? = nil) {
        self.init()
        self.path = path
        self.query = query
        self.params = params
    }
    
}

extension WebViewController {
        
    override public func viewDidLoad() {
        super.viewDidLoad()
        setUI()

        setBar()

        self.route = Route(path: path, query: query, params: params)
        
        view.addSubview(webView)
        webView.addSubview(progressView)
        webView.load(route.request)
    }
    
    func setUI() {
        view.backgroundColor = .white
    }
    
}

extension WebViewController {
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == KVOKeyProgress {
            guard let progress = change?[.newKey] as? Float else { return }
            progressView.setProgress(progress, animated: true)
            if progress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }) { (finished) in
                    self.progressView.progress = 0
                    self.progressView.alpha = 1
                }
            }
        }
        else if keyPath == KVOKeyTitle {
            guard let title = change?[.newKey] as? String else { return }
            webView(webView, didChange: title)
        }
        else if keyPath == KVOKeyURL {
            guard let url = change?[.newKey] as? URL else { return }
            webView(webView, didChange: url)
        }
        else if keyPath == KVOKeyCanGoBack {
            guard let canGoBack = change?[.newKey] as? Bool else { return }
            toolbar.canGoBack = canGoBack
            toolbar.canGoForward = webView.canGoForward
        }
    }
    
}

extension WebViewController: ToolbarDelegate, UIScrollViewDelegate {
    
    func setBar() {
        leftItemImage = UIImage.kw.image(named: "close")
        rightItemImage = UIImage.kw.image(named: "more")
        
        webView.addSubview(toolbar)
        
        webView.addObserver(self, forKeyPath: KVOKeyCanGoBack, options: [.old, .new], context: nil)
    }
    
    var leftItemImage: UIImage? {
        set {
            let item = UIBarButtonItem(image: newValue, style: .plain, target: self, action: #selector(leftItemAction(item:)))
            navigationItem.leftBarButtonItem = item
        }
        get {
            return nil
        }
    }
    
    var rightItemImage: UIImage? {
        set {
            let item = UIBarButtonItem(image: newValue, style: .plain, target: self, action: #selector(rightItemAction(item:)))
            navigationItem.rightBarButtonItem = item
        }
        get {
            return nil
        }
    }
    
    @objc func leftItemAction(item: UINavigationItem) {
        closeVC()
    }
    
    @objc func rightItemAction(item: UINavigationItem) {
        morePopupView.info = MorePopupItemInfo(image: UIImage(), title: webView.title ?? "", message: "", link: route.urlStr)
        morePopupView.show()
        morePopupView.selected = { (res, item) in
            kwlog("""
            \(res)
            \(item)
            """)
        }
    }
    
    func backItemAction(item: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    func forwardItemAction(item: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        toolbar.lastOffsetY = scrollView.contentOffset.y
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height + scrollView.kw.safeTop > scrollView.frame.height else { return }
        toolbar.offsetY = scrollView.contentOffset.y
        
        if abs(scrollView.contentOffset.y) == scrollView.kw.safeTop {
            toolbar.isHiddenWithAnimate = false
        }
        else if scrollView.contentOffset.y + scrollView.frame.height == scrollView.contentSize.height {
            toolbar.isHiddenWithAnimate = true
        }
                
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.contentOffset.y < toolbar.lastOffsetY {
            toolbar.isHiddenWithAnimate = false
        }
        else if scrollView.contentOffset.y > toolbar.lastOffsetY {
            toolbar.isHiddenWithAnimate = true
        }
    }
    
}
