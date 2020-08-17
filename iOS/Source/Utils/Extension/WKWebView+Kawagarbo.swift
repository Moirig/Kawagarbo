//
//  WKWebView+Kawagarbo.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

extension KWNamespace where Base == WKWebView {
    
    var viewController: WebViewController {
        return base.navigationDelegate as? WebViewController ?? WebViewController()
    }
        
    func evaluateJavaScript(jsFunc: String, obj: [String: Any]) {
        if var objStr = obj.kw.string {
            objStr = objStr.replacingOccurrences(of: "\\", with: "\\\\")
            objStr = objStr.replacingOccurrences(of: "\"", with: "\\\"")
            objStr = objStr.replacingOccurrences(of: "\'", with: "\\\'")
            objStr = objStr.replacingOccurrences(of: "\n", with: "\\n")
            objStr = objStr.replacingOccurrences(of: "\r", with: "\\r")
            objStr = objStr.replacingOccurrences(of: "\u{000C}", with: "\\f")
            objStr = objStr.replacingOccurrences(of: "\u{2028}", with: "\\u2028")
            objStr = objStr.replacingOccurrences(of: "\u{2029}", with: "\\u2029")
            
            let js = "\(jsFunc)('\(objStr)')"
            DispatchQueue.main.async {
                self.base.evaluateJavaScript(js) { (obj, error) in
                    guard let err = error else { return }
                    kwlog(title: "JS Error", err)
                }
            }
        }
    }
                
}
