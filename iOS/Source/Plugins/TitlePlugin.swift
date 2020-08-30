//
//  TitlePlugin.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/2/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

class TitlePlugin: NSObject, UIPlugin {
    
    func webView(_ webView: WKWebView, didChange title: String) {
        webView.kw.viewController.title = title
    }
    
}
