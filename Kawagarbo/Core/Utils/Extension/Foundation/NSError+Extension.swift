//
//  NSError+Extension.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/20.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import Foundation

extension NSError {
    
    convenience init(code: Int, message: String? = nil) {
        self.init(domain: "com.Moirig.Kawagarbo", code: code, userInfo: [NSLocalizedDescriptionKey : message ?? ""])
    }
    
}
