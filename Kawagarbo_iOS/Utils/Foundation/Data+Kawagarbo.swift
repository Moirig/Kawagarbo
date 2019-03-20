//
//  Data+Extension.swift
//  KawagarboExample
//
//  Created by wyhazq on 2018/9/20.
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
    
    var imageExtension: String {
        let bytes = base.bytes
        guard let byte0 = bytes.first else { return "" }
        
        switch byte0 {
        case 255: return "jpeg"
            
        case 137: return "png"
            
        case 71: return "gif"
            
        case 60: return "svg"
            
        case 73, 77: return "tiff"
            
        case 82:
            if base.count < 12 { return "" }
            guard let str = String(data: base.subdata(in: 0..<12), encoding: .ascii) else { return "" }
            if str.hasPrefix("RIFF"), str.hasSuffix("WEBP") { return "webp" }
            return ""
        
        default:
            return ""
        }        
    }
}
