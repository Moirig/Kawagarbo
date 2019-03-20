//
//  KGShowModalApi.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/2/12.
//

import UIKit

class KGShowModalApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "showModal" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        let title = parameters?["title"] as? String
        let content = parameters?["content"] as? String
        let showCancel = (parameters?["showCancel"] as? Bool) ?? true
        let cancelText = (parameters?["cancelText"] as? String) ?? "取消"
        let cancelColor = (parameters?["cancelColor"] as? String) ?? "#000000"
        let confirmText = (parameters?["confirmText"] as? String) ?? "确定"
        let confirmColor = (parameters?["confirmColor"] as? String) ?? "#576B95"
        
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        
        if showCancel {
            let action = UIAlertAction(title: cancelText, style: .cancel) { (action) in
                complete(success(data: ["confirm": false, "cancel": true]))
            }
            action.setValue(UIColor(hexString: cancelColor), forKey: "_titleTextColor")
            alert.addAction(action)
        }
        
        let action = UIAlertAction(title: confirmText, style: .default) { (action) in
            complete(success(data: ["confirm": true, "cancel": false]))
        }
        action.setValue(UIColor(hexString: confirmColor), forKey: "_titleTextColor")
        alert.addAction(action)
        webViewController?.present(alert, animated: true, completion: nil)
    }
    

}
