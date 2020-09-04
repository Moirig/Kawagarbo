//
//  SafariPopupItem.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 9/1/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import UIKit

class SafariPopupItem: MorePopupItem {
    
    static var type: MorePopupItemType { return .share }
    
    static var image: UIImage? { return UIImage.kw.image(named: "safari") }
    
    static var text: String { return NSLocalizedString("Safari") }
    
    static func selected(info: MorePopupItemInfo, callback: @escaping (MorePopupItemRes) -> Void) {
        guard let url = URL(string: info.link), UIApplication.shared.canOpenURL(url) else { return callback(.fail)
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        callback(.success)
    }
    

}
