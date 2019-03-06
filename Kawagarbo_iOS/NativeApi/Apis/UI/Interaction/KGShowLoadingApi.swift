//
//  KGShowLoadingApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/12.
//

import UIKit
import MBProgressHUD

class KGShowLoadingApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "showLoading" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {

        let title = parameters?["title"] as? String
        let mask = (parameters?["mask"] as? Bool) ?? false
        
        MBProgressHUD.loading(title: title, hasMask: mask)
        
        complete(success())
    }

}
