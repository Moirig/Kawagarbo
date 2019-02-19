//
//  UIImage.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/19.
//

import Foundation

extension KGNamespace where Base == UIImage {

    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        base.draw(in: CGRect(origin: CGPoint.zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
