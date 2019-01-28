//
//  URLProtocol+Kawagarbo.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/1/28.
//

import Foundation
import WebKit

//browsingContextController
let KGContextController: AnyObject = type(of: WKWebView().value(forKey: "YnJvd3NpbmdDb250ZXh0Q29udHJvbGxlcg==".kg.base64DecodedString) as AnyObject)
//registerSchemeForCustomProtocol
let KGRegistScheme: Selector = NSSelectorFromString("dW5yZWdpc3RlclNjaGVtZUZvckN1c3RvbVByb3RvY29sOg==".kg.base64DecodedString)
//unregisterSchemeForCustomProtocol
let KGUnregistScheme: Selector = NSSelectorFromString("cmVnaXN0ZXJTY2hlbWVGb3JDdXN0b21Qcm90b2NvbDo=".kg.base64DecodedString)


extension KGNamespace where Base == URLProtocol {
    
    func regist(scheme: String) {
        let cls: AnyObject = KGContextController
        let sel: Selector = KGRegistScheme
        if cls.responds(to: sel) {
            let _ = cls.perform(sel)
        }
    }
    
    func unregist(scheme: String) {
        let cls: AnyObject = KGContextController
        let sel: Selector = KGUnregistScheme
        if cls.responds(to: sel) {
            let _ = cls.perform(sel)
        }
    }
        
}


