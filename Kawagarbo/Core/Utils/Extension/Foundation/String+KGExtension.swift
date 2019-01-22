//
//  String+Extension.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/24.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import Foundation

extension String {
    
    var isHTTP: Bool {
        if self == "https" || self == "http" {
            return true
        }
        if hasPrefix("https") || hasSuffix("http") {
            return true
        }
        return false
    }
    
    var isFile: Bool {
        return self == "file" || hasPrefix("file")
    }
    
    var urlEncode: String {
        let encodeUrlSet: CharacterSet = CharacterSet.urlQueryAllowed
        if let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters: encodeUrlSet) {
            return encodeUrlString
        }
        
        return self
    }
}
