//
//  UIScreen+Kawagarbo.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/1/29.
//

import Foundation

extension KGNamespace where Base == UIScreen {
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
}
