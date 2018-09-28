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
    
    func perform(with parameters: [String: Any]?, complete: KGNativeApiResponseClosure)
    
    func regist()
    
    func dynamicRegist()
}

extension KGNativeApiDelegate {
    
    func regist() {
        KGNativeApiManager.addNativeApi(self)
    }
    
    func dynamicRegist() {
        KGNativeApiManager.addDynamicNativeApi(self)
    }
    
}
