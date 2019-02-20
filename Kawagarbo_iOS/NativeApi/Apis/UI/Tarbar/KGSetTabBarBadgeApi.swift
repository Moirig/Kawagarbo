//
//  KGSetTabBarBadgeApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/20.
//

import UIKit

class KGSetTabBarBadgeApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "setTabBarBadge" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        guard let tabBarController = webViewController?.tabBarController else { return complete(.failure(code: kParamCodeDefaultFail, message: "fail not TabBar page")) }
        
        guard let navigationController = webViewController?.navigationController, navigationController.viewControllers.count == 1 else { return complete(.failure(code: kParamCodeDefaultFail, message: "fail not TabBar page")) }
        
        guard var index = parameters?["index"] as? Int else { return complete(.failure(code: kParamCodeDefaultFail, message: "Invalid index;")) }
        
        guard let count = tabBarController.viewControllers?.count else { return complete(.failure(code: kParamCodeDefaultFail, message: "no tabbar;")) }
        if index < 0 { index = 0 }
        if index > count - 1 { index = count - 1 }
        
        guard let tabBarItem = tabBarController.tabBar.items?[index] else { return complete(.failure(code: kParamCodeDefaultFail, message: "no tabBarItem;")) }
        
        guard let text = parameters?["text"] as? String else { return complete(.failure(code: kParamCodeDefaultFail, message: "text undefined!")) }        
        
        tabBarItem.badgeValue = text.count > 4 ? "..." : text
        
        tabBarController.tabBar.kg_badgeScale = 0.7
        
        complete(.success(data: nil))
    }
    
}
