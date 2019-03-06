//
//  KGSetTabBarItemApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/15.
//

import UIKit

class KGSetTabBarItemApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "setTabBarItem" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        guard let tabBarController = webViewController?.tabBarController else { return complete(failure(message: "fail not TabBar page")) }
        
        guard let navigationController = webViewController?.navigationController, navigationController.viewControllers.count == 1 else { return complete(failure(message: "fail not TabBar page")) }
        
        guard var index = parameters?["index"] as? Int else { return complete(failure(message: "Invalid index;")) }
        
        guard let count = tabBarController.viewControllers?.count else { return complete(failure(message: "no tabbar;")) }
        if index < 0 { index = 0 }
        if index > count - 1 { index = count - 1 }
        
        guard let tabBarItem = tabBarController.tabBar.items?[index] else { return complete(failure(message: "no tabBarItem;")) }
        
        if let aIconPath = parameters?["iconPath"] as? String {
            if let icon = UIImage(contentsOfFile: aIconPath.kg.noScheme)?.kg.resize(to: CGSize(width: 27, height: 27)) {
                tabBarItem.image = icon
            }
            else {
                return complete(failure(message: "Invalid iconPath;"))
            }
        }
        
        if let aIconPath = parameters?["selectedIconPath"] as? String {
            if let icon = UIImage(contentsOfFile: aIconPath.kg.noScheme)?.kg.resize(to: CGSize(width: 27, height: 27)) {
                tabBarItem.selectedImage = icon
            }
            else {
                return complete(failure(message: "Invalid selectedIconPath;"))
            }
        }
        
        if let text = parameters?["text"] as? String {
            tabBarItem.title = text
        }
        
        complete(success())
    }

}
