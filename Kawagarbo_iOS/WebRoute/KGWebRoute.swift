//
//  KGWebRoute.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2019/1/16.
//  Copyright © 2019年 Moirig. All rights reserved.
//

import UIKit

public class KGWebRoute: NSObject {
    
    public var url: URL? { return urlRequest?.url }
    
    public var urlString: String? { return urlRequest?.url?.absoluteString }
    
    public var urlRequest: URLRequest?
    
    public var appId: String? {
        get {
            if let appId = storeAppId {
                return appId
            }
            
            if let host = url?.host {
                return host.kg.base64EncodedString
            }
            
            if let url = urlString, let components = URLComponents(string: url) {
                if let queryItems = components.queryItems {
                    for item in queryItems {
                        if item.name == config.appIdKey {
                            return item.value
                        }
                    }
                }
            }
                
            return nil
        }
        set {
            storeAppId = newValue
        }
    }
    
    public var storeAppId: String?
    
    public var config: KGConfig! {
        get { return KGConfig() }
        set {
            urlRequest?.cachePolicy = newValue.cachePolicy
            urlRequest?.timeoutInterval = newValue.timeoutInterval
        }
    }
    
    public convenience init(urlString: String, parameters: [String: String]? = nil, headerFields: [String: String]? = nil) {
        self.init()
        
        urlRequest = format(urlString: urlString, parameters: parameters, headerFields: headerFields)
        
    }
    
    func format(urlString: String, parameters: [String: String]? = nil, headerFields: [String: String]? = nil) -> URLRequest? {
        var formatUrl: String = urlString
        if let params = parameters {
            for (key, obj) in params {
                formatUrl = formatUrl.replacingOccurrences(of: key, with: obj)
            }
        }
        
        if URL(string: formatUrl) == nil {
            formatUrl = formatUrl.kg.urlEncode
        }
        
        if let url = URL(string: formatUrl) {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = headerFields
            
            return request
        }
        
        return nil
    }
    
}

