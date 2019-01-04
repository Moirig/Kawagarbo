//
//  KGNativeApiDelegate.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/26.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import Foundation

public protocol KGNativeApiDelegate: NSObjectProtocol {
    
    var path: String { get }
    
    func perform(with parameters: [String: Any]?, in webViewController: KGWebViewController?, complete: KGNativeApiResponseClosure)
    
    func regist()
    
}

extension KGNativeApiDelegate {
    
    func regist() {
        KGNativeApiManager.addNativeApi(self)
    }
    
}
