//
//  KGHideTabBarApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/15.
//

import UIKit

class KGHideTabBarApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "hideTabBar" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let tabBarController = webViewController?.tabBarController else { return complete(.failure(code: kParamCodeDefaultFail, message: "fail not TabBar page")) }

        guard let navigationController = webViewController?.navigationController, navigationController.viewControllers.count == 1 else { return complete(.failure(code: kParamCodeDefaultFail, message: "fail not TabBar page")) }

        tabBarController.tabBar.isHidden = true
        complete(.success(data: nil))
    }

}
