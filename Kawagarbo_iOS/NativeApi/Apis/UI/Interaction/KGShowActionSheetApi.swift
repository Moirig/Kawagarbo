//
//  KGShowActionSheetApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/12.
//

import UIKit

class KGShowActionSheetApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "showActionSheet" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        let title = parameters?["title"] as? String
        let content = parameters?["content"] as? String
        let cancelText = (parameters?["cancelText"] as? String) ?? "取消"
        let cancelColor = (parameters?["cancelColor"] as? String) ?? "#000000"

        guard let itemList = parameters?["itemList"] as? [String], itemList.count > 0 else { return complete(failure(message: "fail parameter error: parameter.itemList should have at least 1 item;")) }

        let itemColor = (parameters?["itemColor"] as? String) ?? "#000000"
        
        let actionSheet = UIAlertController(title: title, message: content, preferredStyle: .actionSheet)
        
        
        for (index, item) in itemList.enumerated() {
            let action = UIAlertAction(title: item, style: .default) { (action) in
                complete(success(data: ["tapIndex": index]))
            }
            action.setValue(UIColor(hexString: itemColor), forKey: "_titleTextColor")
            actionSheet.addAction(action)
        }
        
        let action = UIAlertAction(title: cancelText, style: .cancel) { (action) in
            complete(failure(message: "fail cancel"))
        }
        action.setValue(UIColor(hexString: cancelColor), forKey: "_titleTextColor")
        actionSheet.addAction(action)

        webViewController?.present(actionSheet, animated: true, completion: nil)
    }
    

}
