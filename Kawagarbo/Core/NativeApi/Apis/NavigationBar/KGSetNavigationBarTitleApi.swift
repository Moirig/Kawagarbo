//
//  KGSetNavigationBarTitleApi.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2019/1/22.
//  Copyright © 2019年 Moirig. All rights reserved.
//

import UIKit

class KGSetNavigationBarTitleApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "setNavigationBarTitle" }
    
    func perform(with parameters: [String : Any]?, complete: (KGNativeApiResponse) -> Void) {
        
        guard let title = parameters?["title"] as? String else {
            return complete(.failure(code: kParamCodeDefaultFail, message: "title undefined!"))
        }
        
        webViewController?.title = title
        
        complete(.success(data: nil))
    }
    
}

