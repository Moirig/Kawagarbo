//
//  TestInterceptor.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/30/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

class TestInterceptor: Interceptor {

    override class func canInit(with request: URLRequest) -> Bool {
        kwlog(request.url?.absoluteString ?? "")
        return false
    }
    
    override func startLoading() {}
    
}

class TestInterceptorApi: NativeApi {
    var path: String { return "testInterceptor" }
    
    func webview(_ webView: WKWebView, invokeWith params: [String : Any]?, callback: @escaping (Res) -> Void) {
        guard let enable: Bool = params?["enable"] as? Bool else {
            return callback(.fail())
        }
        enable ? TestInterceptor.start(with: webView) : TestInterceptor.stop(with: webView)
        callback(.success())
    }
    
}
