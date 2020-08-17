//
//  RouterPlugin.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

class RouterPlugin: NSObject, NavigationPlugin {
    
    func webView(_ webView: WKWebView, didChange url: URL) {
        kwlog(title: "URL", url.absoluteString)
        
        webView.kw.viewController.route = Route(path: url.absoluteString)
    }
    
}
