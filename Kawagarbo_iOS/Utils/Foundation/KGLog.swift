//
//  KGLog.swift
//  KawagarboExample
//
//  Created by wyhazq on 2019/1/22.
//  Copyright © 2019年 Moirig. All rights reserved.
//

import Foundation

public func KGLog(title: String? = nil, _ item: Any) {
    
#if DEBUG
    var log = item
    if let atltle = title {
        log = "\(atltle)\n\(log)"
    }
    
    
    print("""
        -------------------- Kawagarbo --------------------
        \(log)
        ---------------------------------------------------
        
        """)
#endif
    
}



