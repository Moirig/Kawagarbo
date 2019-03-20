//
//  KGHideNavigationBarLoadingApi.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/2/12.
//

import UIKit

class KGHideNavigationBarLoadingApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "hideNavigationBarLoading" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        webViewController?.titleView.isShowLoading = false
        complete(success())
    }

}
