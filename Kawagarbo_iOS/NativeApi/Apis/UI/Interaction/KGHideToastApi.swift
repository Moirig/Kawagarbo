//
//  KGHideToastApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/12.
//

import UIKit

class KGHideToastApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "hideToast" }
    
    func perform(with parameters: [String : Any]?, complete: (KGNativeApiResponse) -> Void) {
        //TODO-
    }
    

}