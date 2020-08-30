//
//  Data+Kawagarbo.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import Foundation

extension Data: KWNamespaceProtocol {}

extension KWNamespace where Base == Data {
    
    var base64EncodedString: String {
        return base.base64EncodedString()
    }
    
    var base64DecodedString: String {
        return String(data: base64DecodedData, encoding: .utf8) ?? ""
    }
    
    var base64EncodedData: Data {
        return base.base64EncodedData()
    }
    
    var base64DecodedData: Data {
        return Data(base64Encoded: base, options: .ignoreUnknownCharacters) ?? Data()
    }
    
}
