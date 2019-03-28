//
//  KGWebRoute.swift
//  KawagarboExample
//
//  Created by wyhazq on 2019/1/16.
//  Copyright © 2019年 Moirig. All rights reserved.
//

import UIKit

public class KGWebRoute: NSObject {
    
    public var url: URL? { return urlRequest?.url }
    
    public var urlString: String? { return urlRequest?.url?.absoluteString }
    
    public var urlRequest: URLRequest? {
        if let request = storeURLRequest {
            return request
        }
        storeURLRequest = formatURLRequest()
        return storeURLRequest
    }
    
    public var appId: String {
        guard let aurl = storeURLString else { return "" }
        
        if let url = URL(string: aurl) {
            return url.kg.baseURLString.md5()
        }
        return ""
    }
    
    public var webAppUrlString: String?
    
    public var webApp: KGWebApp? {
        guard let _ = webAppUrlString else { return nil }
        if let webApp = storeWebApp {
            return webApp
        }
        storeWebApp = KGWebApp(appId: appId)
        return storeWebApp
    }
    
    public var config: KGConfig!
    
    var storeURLString: String?
    var storeParameters: [String: String]?
    var storeHeaderFields: [String: String]?
    var storeWebApp: KGWebApp?
    var storeURLRequest: URLRequest?
    
    public convenience init(urlString: String, parameters: [String: String]? = nil, headerFields: [String: String]? = nil) {
        self.init()
        
        storeURLString = urlString
        storeParameters = parameters
        storeHeaderFields = headerFields
    }
    
    func formatURLRequest() -> URLRequest? {
        if let awebApp = webApp {
            storeURLString = "file://" + awebApp.launchPagePath
        }
        guard let urlString = storeURLString else { return nil }
        var formatUrl: String = urlString
        if let params = storeParameters {
            for (key, obj) in params {
                formatUrl = formatUrl.replacingOccurrences(of: key, with: obj)
            }
        }
        
        if URL(string: formatUrl) == nil {
            formatUrl = formatUrl.kg.urlEncode
        }
        
        if let url = URL(string: formatUrl) {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = storeHeaderFields
            request.timeoutInterval = config.timeoutInterval
            request.cachePolicy = config.cachePolicy
            return request
        }
        
        return nil
    }
    
}

