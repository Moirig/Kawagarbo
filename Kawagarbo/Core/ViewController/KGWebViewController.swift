//
//  KGWebViewController.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/14.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit

public class KGWebViewController: UIViewController {
    
    public typealias KGWebCallback = (_ path: String, _ data: [String: Any], _ error: Error) -> Void
    
    public weak var webView: KGWKWebView?
    
    //TODO-没完成
    public var webRoute: Any?
    
    public weak var delegate: KGWKWebViewControllerDelegate?
    
    public static var delegate: KGWKWebViewControllerDelegate?
    
    public var callback: KGWebCallback?
    
    public var userInfo: [String: Any]?
    
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

}
