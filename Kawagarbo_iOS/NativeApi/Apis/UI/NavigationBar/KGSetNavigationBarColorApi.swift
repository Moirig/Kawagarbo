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

        //TODO-
    }

}
