//
//  Router.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import UIKit

public class Router: NSObject {
    
}

public class Route: NSObject {
    
    var path: String
    var query: [String: Any]?
    var params: [String: Any]?
    
    init(path: String, query: [String: Any]? = nil, params: [String: Any]? = nil) {
        self.path = path
        self.query = query
        self.params = params
    }
    
}

extension Route {
    
    var urlStr: String {
        if let query = query {
            let queryStr = queryString(query)
            if path.hasSuffix("?") {
                return path + queryStr
            }
            else if path.contains("&") {
                return path + "&" + queryStr
            }
            else {
                return path + "?" + queryStr
            }
        }
        
        if let params = params {
            for (key, value) in params {
                let keyStr: String = key.hasPrefix(":") ? key : ":" + key
                let valueStr: String = paramsValueString(value: value)
                path = path.replacingOccurrences(of: keyStr, with: valueStr)
            }
        }
        
        return path
    }
    
    var url: URL {
        if let url = URL(string: urlStr) {
            return url
        }
        return URL(string: urlStr.kw.urlEncode) ?? URL(fileURLWithPath: "")
    }
    
    var request: URLRequest {
        return URLRequest(url: url)
    }
    
}

extension Route {
    
    
    private func queryString(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        switch value {
        case let dictionary as [String: Any]:
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        case let array as [Any]:
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        case let number as NSNumber:
            if number.kw.isBool {
                components.append((key.kw.urlEncode, number.boolValue ? "1" : "0"))
            } else {
                components.append((key.kw.urlEncode, "\(number)".kw.urlEncode))
            }
        case let bool as Bool:
            components.append((key.kw.urlEncode, bool ? "1" : "0"))
        default:
            components.append((key.kw.urlEncode, "\(value)".kw.urlEncode))
        }
        return components
    }
    
    private func paramsValueString(value: Any) -> String {
        switch value {
        case let number as NSNumber:
            if number.kw.isBool {
                return number.boolValue ? "1" : "0"
            } else {
                return "\(number)".kw.urlEncode
            }
        case let bool as Bool:
            return bool ? "1" : "0"
            
        case let string as String:
            return string.kw.urlEncode
            
        default:
            return ""
        }
    }
}
