//
//  KGShowToastApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/12.
//

import UIKit
import MBProgressHUD

class KGShowToastApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "showToast" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {

        let title = parameters?["title"] as? String
        let icon = (parameters?["icon"] as? String) ?? "success"
        let image = parameters?["image"] as? String
        let duration = (parameters?["duration"] as? Int) ?? 1500
        let mask = (parameters?["mask"] as? Bool) ?? false
        let delay = TimeInterval(duration / 1000)
        
        
        if icon == "none", image == nil {
            MBProgressHUD.toast(title: title, delay: delay, hasMask: mask)
            return complete(success())
        }
        
        if let aImage = image {
            if let image = UIImage(contentsOfFile: aImage.kg.noScheme) {
                MBProgressHUD.show(image: image, title: title, delay: delay, hasMask: mask)
            }
            else {
                MBProgressHUD.showSuccess(title: title, delay: delay, hasMask: mask)
            }
            return complete(success())
        }
            
        if icon == "loading" {
            MBProgressHUD.loading(title: title, delay: delay, hasMask: mask)
        }
        else if icon == "success" {
            MBProgressHUD.showSuccess(title: title, delay: delay, hasMask: mask)
        }
        else if icon == "fail" {
            MBProgressHUD.showFail(title: title, delay: delay, hasMask: mask)
        }
        else {
            MBProgressHUD.showSuccess(title: title, delay: delay, hasMask: mask)
        }
        
        return complete(success())
    }
    

}
