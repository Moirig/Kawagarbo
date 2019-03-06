//
//  KGHideTabBarRedDotApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/20.
//

import UIKit

class KGHideTabBarRedDotApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "hideTabBarRedDot" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        guard let tabBarController = webViewController?.tabBarController else { return complete(failure(message: "fail not TabBar page")) }
        
        guard let navigationController = webViewController?.navigationController, navigationController.viewControllers.count == 1 else { return complete(failure(message: "fail not TabBar page")) }
        
        guard var index = parameters?["index"] as? Int else { return complete(failure(message: "Invalid index;")) }
        
        guard let count = tabBarController.viewControllers?.count else { return complete(failure(message: "no tabbar;")) }
        if index < 0 { index = 0 }
        if index > count - 1 { index = count - 1 }
        
        guard let tabBarItem = tabBarController.tabBar.items?[index] else { return complete(failure(message: "no tabBarItem;")) }
        
        tabBarItem.badgeValue = nil
        
        tabBarController.tabBar.kg_badgeScale = 1.0
        
        complete(success())
    }
    
}
