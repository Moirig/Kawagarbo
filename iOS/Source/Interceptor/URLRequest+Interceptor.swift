//
//  URLRequest+Kawagarbo.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import Foundation

extension URLRequest: KWNamespaceProtocol {}

extension KWNamespace where Base == URLRequest {

    var isFromWebKit: Bool {
        guard let header = base.allHTTPHeaderFields, let ua = header["User-Agent"] else { return false }
        return ua.hasPrefix("Mozilla")
    }
    
}
