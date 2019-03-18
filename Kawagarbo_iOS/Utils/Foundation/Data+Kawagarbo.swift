//
//  Data+Extension.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/20.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import Foundation

extension Data: KGNamespaceProtocol {}

extension KGNamespace where Base == Data {
    
    public var dictionary: [String: Any]? {
        
        do {
            let dict = try JSONSerialization.jsonObject(with: base, options: .allowFragments) as? [String: Any]
            return dict
        }
        catch {
            debugPrint(error)
            return nil
        }
        
    }
    
    var json: Any? {
        do {
            let json = try JSONSerialization.jsonObject(with: base, options: .allowFragments)
            return json
        }
        catch {
            if let jsonString = String(data: base, encoding: .utf8) {
                return jsonString
            }
            debugPrint(error)
            return nil
        }
    }
    
    var base64EncodedString: String {
        return base.base64EncodedString()
    }
    
    var base64DecodedString: String {
        return String(data: base64Decoded, encoding: .utf8) ?? ""
    }
    
    var base64Encoded: Data {
        return base.base64EncodedData()
    }
    
    var base64Decoded: Data {
        return Data(base64Encoded: base, options: .ignoreUnknownCharacters) ?? Data()
    }
    
}
