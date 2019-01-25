//
//  Dictionary+Extension.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/20.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import Foundation

extension Dictionary: KGNamespaceProtocol {}

extension KGNamespace where Base == Dictionary<String, Any> {
    
    var string: String {
        
        do {
            let data = try JSONSerialization.data(withJSONObject: base, options: .prettyPrinted)
            let string = String(data: data, encoding: .utf8)
            return string ?? ""
        }
        catch {
            return ""
        }
        
    }
    
}
