//
//  KGRedirectToApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/11.
//

import UIKit

class KGRedirectToApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "redirectTo" }
    
    func perform(with parameters: [String : Any]?, complete: (KGNativeApiResponse) -> Void) {
        
    }
    

}
