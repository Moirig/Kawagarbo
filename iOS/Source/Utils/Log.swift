//
//  Log.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import Foundation

public func kwlog(title: String? = nil, _ item: Any) {
    
#if DEBUG
    var log = item
    if let atltle = title {
        log = "\(atltle)\n\(log)"
    }
    
    
    print("""
        ----------------------- Kawagarbo -----------------------
        \(log)
        ---------------------------------------------------------
        
        """)
#endif
    
}
