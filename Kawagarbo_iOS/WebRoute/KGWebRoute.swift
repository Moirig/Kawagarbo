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
        if let awebApp = webApp {
            storeURLString = "file://" + awebApp.launchPagePath
        }
        var request = formatURLRequest()
        request?.timeoutInterval = config.timeoutInterval
        request?.cachePolicy = config.cachePolicy
        return formatURLRequest()
    }
    
    public var appId: String {
        guard let aurl = url else { return "" }
        
        return aurl.kg.baseURLString.md5()
    }
    
    public var webAppUrlString: String?
    
    public var webApp: KGWebApp? {
        guard let _ = webAppUrlString else { return nil }
        return KGWebApp(appId: appId)
    }
    
    public var config: KGConfig!
    
    var storeURLString: String?
    var storeParameters: [String: String]?
    var storeHeaderFields: [String: String]?
    
    public convenience init(urlString: String, parameters: [String: String]? = nil, headerFields: [String: String]? = nil) {
        self.init()
        
        storeURLString = urlString
        storeParameters = parameters
        storeHeaderFields = headerFields
    }
    
    func formatURLRequest() -> URLRequest? {
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
            
            return request
        }
        
        return nil
    }
    
}

