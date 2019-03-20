//
//  KGSetNavigationBarTitleApi.swift
//  KawagarboExample
//
//  Created by wyhazq on 2019/1/22.
//  Copyright © 2019年 Moirig. All rights reserved.
//

import UIKit

class KGSetNavigationBarTitleApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "setNavigationBarTitle" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {

        guard let title = parameters?["title"] as? String else { return complete(failure(message: "title undefined!")) }
        
        webViewController?.title = title
        
        complete(success())
    }
    
}

