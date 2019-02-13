//
//  Bundle+Kawagarbo.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/13.
//

import Foundation

extension KGNamespace where Base == Bundle {
    
    static var bundle: Bundle {
        guard let path = Bundle(for: Kawagarbo.self).path(forResource: "Kawagarbo_iOS", ofType: "bundle") else {
            return Bundle.main
        }
        return Bundle(path: path) ?? Bundle.main
    }
    
    static func image(named: String) -> UIImage {
        let imagePath = "images/\(named)"
        return UIImage(named: imagePath, in: bundle, compatibleWith: nil) ?? UIImage()
    }
    
}
