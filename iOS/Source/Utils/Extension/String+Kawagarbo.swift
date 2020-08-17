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
    
}
