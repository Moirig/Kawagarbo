//
//  SystemPopupItem.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 9/2/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import UIKit

class SystemPopupItem: MorePopupItem {
    
    static var type: MorePopupItemType { return .default }
    
    static var image: UIImage? { return UIImage.kw.image(named: "more1") }
    
    static var text: String { return NSLocalizedString("More") }
    
    static func selected(info: MorePopupItemInfo, callback: @escaping (MorePopupItemRes) -> Void) {
        guard let url = URL(string: info.link), UIApplication.shared.canOpenURL(url) else { return callback(.fail)
        }
        var items: [Any] = []
        if let img = info.image {
            items.append(img)
        }
        items.append(info.title)
        items.append(url)
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
            if let _ = activityError { return callback(.fail) }
            callback(completed ? .success : .cancel)
        }
        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
}
