//
//  UIImage+Kawagarbo.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/1/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import UIKit

extension KWNamespace where Base == UIImage {

    static func image(named: String) -> UIImage? {
        let imagePath = "images/\(named)"
        return UIImage(named: imagePath, in: Bundle.kw.bundle, compatibleWith: nil)
    }
    
}
