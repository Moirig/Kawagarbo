//
//  KGSwitchTabApi.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/2/11.
//

import UIKit

class KGSwitchTabApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "switchTab" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {

        guard var index = parameters?["index"] as? Int else { return complete(failure(message: "Invalid delta!")) }
        
        guard let tabBarController = webViewController?.navigationController?.tabBarController, let count = tabBarController.viewControllers?.count else { return complete(failure(message: "no tabbar;")) }
        if index < 0 { index = 0 }
        if index > count - 1 { index = count - 1 }
        
        tabBarController.selectedIndex = index
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let count = self.webViewController?.navigationController?.viewControllers.count, count > 1 {
                self.webViewController?.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        complete(success())
    }
    
}
