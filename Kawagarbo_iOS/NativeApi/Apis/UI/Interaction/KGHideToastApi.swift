//
//  KGHideToastApi.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/2/12.
//

import UIKit
import MBProgressHUD

class KGHideToastApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "hideToast" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        MBProgressHUD.hide()
        complete(success())
    }
    

}
