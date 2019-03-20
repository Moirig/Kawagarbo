//
//  UITabBar+Kawagarbo.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/2/20.
//

import Foundation


extension UITabBar {
    
    //_UIBadgeView
    static private let kg_badgeView = "X1VJQmFkZ2VWaWV3".kg.base64DecodedString

    var kg_badgeScale: CGFloat {
        get {
            return 0
        }
        set {
            for item in subviews {
                for badgeView in item.subviews {
                    let className=NSStringFromClass(badgeView.classForCoder)
                    if  className == UITabBar.kg_badgeView {
                        badgeView.transform = CGAffineTransform(scaleX: newValue, y: newValue)
                    }
                }
            }
        }
    }

}
