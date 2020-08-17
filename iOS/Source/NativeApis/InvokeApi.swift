//
//  InvokeApi.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/30/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

class InvokeApi: NativeApi {
    var path: String { return "invoke" }
    
    func webview(_ webView: WKWebView, invokeWith params: [String : Any]?, callback: @escaping (Res) -> Void) {
        callback(.success())
    }
    
}
