//
//  WKWebView+Interceptor.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/30/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

private let HookXHRPOSTJS = """
; (function () {
    if (window.kwhookxhrpost) {
        return;
    }

    var xhrPro = XMLHttpRequest.prototype;
    var originOpen = xhrPro.open;
    var originSend = xhrPro.send;

    xhrPro.open = function () {
        if (arguments[0].toUpperCase() === 'POST') {
            this.openArguments = arguments;
        }
        else {
            return originOpen.apply(this, arguments);
        }
    };

    xhrPro.send = function () {
        if (this.openArguments && this.openArguments[0].toUpperCase() === 'POST') {
            var params = arguments[0];
            if (typeof (params) !== 'string') {
                params = JSON.stringify(params);
            }
            this.openArguments[1] = this.openArguments[1] + '?HOOKPOST=' + params;
            originOpen.apply(this, this.openArguments);
        }
        return originSend.apply(this, arguments);
    };

    window.kwhookxhrpost = {
        open: originOpen,
        send: originSend
    };
})();
"""

private let UnHookXHRPOSTJS = """
; (function () {
    if (window.kwhookxhrpost) {
        var xhrPro = XMLHttpRequest.prototype;
        xhrPro.open = window.kwhookxhrpost.open;
        xhrPro.send = window.kwhookxhrpost.send;
        window.kwhookxhrpost = undefined;
    }
})();
"""

extension KWNamespace where Base == WKWebView {

    func startInterceptor() {
        URLProtocol.kw.regist(scheme: "http")
        URLProtocol.kw.regist(scheme: "https")
        
        URLProtocol.registerClass(POSTInterceptor.self)
        
        base.evaluateJavaScript(HookXHRPOSTJS, completionHandler: nil)
    }
    
    func stopInterceptor() {
        base.evaluateJavaScript(UnHookXHRPOSTJS, completionHandler: nil)
        
        URLProtocol.unregisterClass(POSTInterceptor.self)

        URLProtocol.kw.unregist(scheme: "http")
        URLProtocol.kw.unregist(scheme: "https")
    }
    
}
