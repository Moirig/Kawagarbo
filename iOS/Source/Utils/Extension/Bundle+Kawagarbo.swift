//
//  Bundle+Kawagarbo.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/1/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import Foundation


extension KWNamespace where Base == Bundle {

    static var bundle: Bundle {
        guard let path: String = Bundle(for: Kawagarbo.self).path(forResource: "Kawagarbo", ofType: "bundle") else { return Bundle.main }
        return Bundle(path: path)!
    }
    
}
