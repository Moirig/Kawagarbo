//
//  String+Extension.swift
//  KawagarboExample
//
//  Created by wyhazq on 2018/9/24.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import Foundation

extension String: KGNamespaceProtocol {}

extension KGNamespace where Base == String {
    
    var noScheme: String {
        guard let url = URL(string: base) else { return base }
        
        guard let scheme = url.scheme else { return base }
        
        return base.replacingOccurrences(of: (scheme + "://"), with: "")
    }
    
    var isHTTP: Bool {
        if base == "https" || base == "http" {
            return true
        }
        if base.hasPrefix("https") || base.hasSuffix("http") {
            return true
        }
        return false
    }
    
    var isFile: Bool {
        return base == "file" || base.hasPrefix("file")
    }
    
    var urlEncode: String {
        let encodeUrlSet: CharacterSet = CharacterSet.urlQueryAllowed
        if let encodeUrlString = base.addingPercentEncoding(withAllowedCharacters: encodeUrlSet) {
            return encodeUrlString
        }
        
        return base
    }
    
    var data: Data {
        return base.data(using: .utf8) ?? Data()
    }
    
    var base64EncodedString: String {
        return data.kg.base64EncodedString
    }
    
    var base64DecodedString: String {
        return data.kg.base64DecodedString
    }
    
}
