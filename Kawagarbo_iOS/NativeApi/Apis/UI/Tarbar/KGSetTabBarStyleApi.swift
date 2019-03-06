//
//  KGSetTabBarStyleApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/15.
//

import UIKit

class KGSetTabBarStyleApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "setTabBarStyle" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let tabBarController = webViewController?.tabBarController else { return complete(failure(message: "fail not TabBar page")) }
        
        guard let navigationController = webViewController?.navigationController, navigationController.viewControllers.count == 1 else { return complete(failure(message: "fail not TabBar page")) }
        
        if let normalColor = parameters?["color"] as? String {
            if let color = UIColor(hexString: normalColor) {
                if let items = tabBarController.tabBar.items {
                    for item in items {
                        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .normal)
                    }
                }
            }
        }
        
        if let selectedColor = parameters?["selectedColor"] as? String {
            if let color = UIColor(hexString: selectedColor) {
                if let items = tabBarController.tabBar.items {
                    for item in items {
                        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .selected)
                    }
                }
            }
        }
        
        if let backgroundColor = parameters?["backgroundColor"] as? String {
            if let color = UIColor(hexString: backgroundColor) {
                tabBarController.tabBar.barTintColor = color
            }
        }
        
        if let borderStyle = parameters?["borderStyle"] as? String, (borderStyle == "black" || borderStyle == "white") {
            tabBarController.tabBar.clipsToBounds = borderStyle == "white"
        }

        complete(success())
    }

}
