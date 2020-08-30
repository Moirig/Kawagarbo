//
//  String+Kawagarbo.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 7/31/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import Foundation

extension String: KWNamespaceProtocol {}

extension KWNamespace where Base == String {

    var urlEncode: String {
        return base.addingPercentEncoding(withAllowedCharacters: CharacterSet.kw.queryAllowed) ?? base
    }
    
    var urlDecode: String {
        return base.removingPercentEncoding ?? base
    }
    
    var data: Data {
        return base.data(using: .utf8) ?? Data()
    }
    
    var base64EncodedString: String {
        return data.kw.base64EncodedString
    }
    
    var base64DecodedString: String {
        return data.kw.base64DecodedString
    }
    
    var dictionary: [String: Any]? {
        do {
            if let dict: [String: Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
                return dict
            }
        } catch {
            debugPrint("String to Dictionary error: \(error)")
        }
        return nil
    }
    
}
