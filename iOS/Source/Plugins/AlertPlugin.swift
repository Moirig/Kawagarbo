//
//  AlertPlugin.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/30/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

class AlertPlugin: NSObject, UIPlugin {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        webView.kw.viewController.present(alert, animated: true, completion: nil)
    }
    
}
