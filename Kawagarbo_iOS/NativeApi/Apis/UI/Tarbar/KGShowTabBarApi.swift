//
//  KGShowTabBarApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/15.
//

import UIKit

class KGShowTabBarApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "showTabBar" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let tabBarController = webViewController?.tabBarController else { return complete(.failure(code: kParamCodeDefaultFail, message: "fail not TabBar page")) }
        
        guard let navigationController = webViewController?.navigationController, navigationController.viewControllers.count == 1 else { return complete(.failure(code: kParamCodeDefaultFail, message: "fail not TabBar page")) }
        
        //TODO-
        tabBarController.tabBar.isHidden = false
        complete(.success(data: nil))
    }

}
