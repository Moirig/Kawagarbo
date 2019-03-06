//
//  KGSetNavigationBarColorApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/12.
//

import UIKit

class KGSetNavigationBarColorApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "setNavigationBarColor" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let webVC = webViewController else { return }
        
        guard let frontColor = parameters?["frontColor"] as? String else { return complete(failure(message: "fail parameter error: parameter.frontColor should be String instead of Undefined;")) }
        if KGInfoPlist.baseStatusBarAppearance {
            KGLog(title: "infoPlist error", "Pleast set UIViewControllerBasedStatusBarAppearance to true in infoPlist;")
            return complete(failure(message: "Pleast set UIViewControllerBasedStatusBarAppearance to true in infoPlist;"))
        }
        
        if frontColor == "#000000" || frontColor == "#ffffff" {
            guard let color = UIColor(hexString: frontColor) else { return }
            webVC.currentUI.navigationBar.frontColor = color
            webVC.titleView.tintColor = color
        }
        else {
            return complete(failure(message: "fail invalid frontColor \"\(frontColor)\""))
        }
        
        guard let backgroundColor = parameters?["backgroundColor"] as? String else { return complete(failure(message: "fail parameter error: parameter.backgroundColor should be String instead of Undefined;")) }
        webVC.currentUI.navigationBar.backgroundColor = UIColor(hexString: backgroundColor) ?? UIColor.white
        
        webVC.changeToCurrentUI()
        complete(success())
    }

}
