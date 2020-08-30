//
//  Interceptor.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import WebKit

open class Interceptor: URLProtocol {
        
    private static var classRefCountDict: [String: Int] = [:]
    
    private static var name: String {
        return String(describing: self)
    }
    
    public static func start(with webView: WKWebView) {
        assert(name != "Interceptor", "Please extend Interceptor!")
        
        guard let classRefCount: Int = classRefCountDict[name] else {
            if classRefCountDict.count == 0 {
                webView.kw.startInterceptor()
            }
            registerClass(self)
            classRefCountDict[name] = 1
            return
        }
        
        classRefCountDict[name] = classRefCount + 1
    }
    
    public static func stop(with webView: WKWebView) {
        guard var classRefCount: Int = classRefCountDict[name] else { return }
        classRefCount -= 1
        
        guard classRefCount <= 0 else { return classRefCountDict[name] = classRefCount }
        unregisterClass(self)
        classRefCountDict.removeValue(forKey: name)
        
        guard classRefCountDict.count == 0 else { return }
        webView.kw.stopInterceptor()
    }
    
    public func callback(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        if let res: URLResponse = response {
            client?.urlProtocol(self, didReceive: res, cacheStoragePolicy: .notAllowed)
        }
        if let err: Error = error {
            client?.urlProtocol(self, didFailWithError: err)
        }
        if let adata: Data = data {
            client?.urlProtocol(self, didLoad: adata)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    public func mark(_ request: URLRequest) {
        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else { return }
        URLProtocol.setProperty(true, forKey: type(of: self).name, in: mutableRequest)
    }
    
    public func unmark(_ request: URLRequest) {
        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else { return }
        URLProtocol.removeProperty(forKey: type(of: self).name, in: mutableRequest)
    }

    open override class func canInit(with request: URLRequest) -> Bool {
        kwlog("Please override canInit(with request:)")
        return request.kw.isFromWebKit
    }
    
    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    open override func startLoading() {
        kwlog("Please override startLoading()")
    }
    
    open override func stopLoading() {}
    
}
