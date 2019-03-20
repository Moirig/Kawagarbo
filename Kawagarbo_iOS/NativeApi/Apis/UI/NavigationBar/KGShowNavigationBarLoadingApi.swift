//
//  KGShowNavigationBarLoadingApi.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/2/12.
//

import UIKit

class KGShowNavigationBarLoadingApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "showNavigationBarLoading" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        webViewController?.titleView.isShowLoading = true
        complete(success())
    }

}
