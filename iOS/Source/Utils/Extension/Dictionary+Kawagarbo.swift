//
//  Dictionary+Extension.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import Foundation

extension Dictionary: KWNamespaceProtocol {}

extension KWNamespace where Base == Dictionary<String, Any> {
    
    var string: String? {
        
        do {
            let data = try JSONSerialization.data(withJSONObject: base, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        }
        catch {
            debugPrint("Dictionary to String error: \(error)")
            return nil
        }
        
    }
    
}
