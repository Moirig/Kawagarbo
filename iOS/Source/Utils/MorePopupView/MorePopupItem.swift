//
//  MorePopupItem.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 9/1/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import UIKit

public enum MorePopupItemType: Int {
    case share = 1000
    case `default` = 1001
}

public protocol MorePopupItem {
    
    static var type: MorePopupItemType { get }
        
    static var image: UIImage? { get }
    
    static var text: String { get }
        
    static func selected(info: MorePopupItemInfo, callback: @escaping (MorePopupItemRes) -> Void)

}

extension MorePopupItem {
    
    static func add() {
        MorePopupView.addItem(item: self)
    }
    
    static func remove() {
        MorePopupView.removeItem(item: self)        
    }
    
}

public struct MorePopupItemInfo {
    var image: UIImage?
    var title: String = ""
    var message: String = ""
    var link: String = ""
}

public enum MorePopupItemRes: Int {
    case success = 200
    case fail = -1
    case cancel = -999
}
