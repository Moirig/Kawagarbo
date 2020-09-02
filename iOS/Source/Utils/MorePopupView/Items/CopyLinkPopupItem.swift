//
//  CopyLinkPopupItem.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 9/1/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import UIKit

class CopyLinkPopupItem: MorePopupItem {
        
    static var type: MorePopupItemType { return .default }
    
    static var image: UIImage? { return UIImage.kw.image(named: "copylink") }
    
    static var text: String { return "拷贝链接" }
    
    static func selected(info: MorePopupItemInfo, callback: @escaping (MorePopupItemRes) -> Void) {
        let text = """
        [\(info.title)]
        \(info.message)
        \(info.link)
        """
        let pasteBoard: UIPasteboard = UIPasteboard.general
        pasteBoard.string = text
        //show tips
        
        callback(.success)
    }
}
