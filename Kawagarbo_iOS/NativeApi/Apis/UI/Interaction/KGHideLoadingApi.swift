//
//  KGHideLoadingApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/12.
//

import UIKit

class KGHideLoadingApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "hideLoading" }
    
    func perform(with parameters: [String : Any]?, complete: (KGNativeApiResponse) -> Void) {
        //TODO-
    }
    

}
