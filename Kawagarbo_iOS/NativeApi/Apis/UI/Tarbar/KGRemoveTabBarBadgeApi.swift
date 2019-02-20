//
//  KGRemoveTabBarBadgeApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/20.
//

import UIKit

class KGRemoveTabBarBadgeApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "removeTabBarBadge" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        guard let tabBarController = webViewController?.tabBarController else { return complete(.failure(code: kParamCodeDefaultFail, message: "fail not TabBar page")) }
        
        guard let navigationController = webViewController?.navigationController, navigationController.viewControllers.count == 1 else { return complete(.failure(code: kParamCodeDefaultFail, message: "fail not TabBar page")) }
        
        guard var index = parameters?["index"] as? Int else { return complete(.failure(code: kParamCodeDefaultFail, message: "Invalid index;")) }
        
        guard let count = tabBarController.viewControllers?.count else { return complete(.failure(code: kParamCodeDefaultFail, message: "no tabbar;")) }
        if index < 0 { index = 0 }
        if index > count - 1 { index = count - 1 }
        
        guard let tabBarItem = tabBarController.tabBar.items?[index] else { return complete(.failure(code: kParamCodeDefaultFail, message: "no tabBarItem;")) }
        
        tabBarItem.badgeValue = nil

        tabBarController.tabBar.kg_badgeScale = 1.0
        
        complete(.success(data: nil))
    }
    

}
