//
//  KGHideLoadingApi.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/2/12.
//

import UIKit
import MBProgressHUD

class KGHideLoadingApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "hideLoading" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {

        MBProgressHUD.hide()
        complete(success())
    }
    
}
