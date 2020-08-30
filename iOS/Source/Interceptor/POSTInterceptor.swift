//
//  POSTInterceptor.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import Foundation

class POSTInterceptor: Interceptor {
    
    static let session: URLSession = URLSession(configuration: .default)
    
    override class func canInit(with request: URLRequest) -> Bool {
        guard request.kw.isFromWebKit else { return false }
        
        if let method = request.httpMethod, method == "POST" {
            return true
        }
        return false
    }
    
    override func startLoading() {
        mark(request)
        guard var urlStr: String = request.url?.absoluteString, urlStr.contains("HOOKPOST") else { return }
        let components = urlStr.components(separatedBy: "?HOOKPOST=")
        guard components.count == 2 else { return }
        urlStr = components[0]
        let paramsStr = components[1].kw.urlDecode
        guard let url = URL(string: urlStr) else { return }
        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else { return }
        mutableRequest.url = url
        mutableRequest.httpBody = paramsStr.kw.data
        let newReq = mutableRequest as URLRequest
        let task = POSTInterceptor.session.dataTask(with: newReq) { (data, response, error) in
            self.callback(data: data, response: response, error: error)
        }
        task.resume()
    }
    
    override func stopLoading() {
        unmark(request)
    }
    
}
