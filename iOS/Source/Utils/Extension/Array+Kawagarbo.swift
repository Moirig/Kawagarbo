//
//  Array+Kawagarbo.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 9/1/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }

}
