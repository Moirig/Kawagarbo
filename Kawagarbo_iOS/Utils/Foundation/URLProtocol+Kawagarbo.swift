//
//  URLProtocol+Kawagarbo.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/1/28.
//

import Foundation
import WebKit

extension KGNamespace where Base == URLProtocol {
    
    //browsingContextController
    static private let KGContextController: AnyObject = type(of: WKWebView().value(forKey: "YnJvd3NpbmdDb250ZXh0Q29udHJvbGxlcg==".kg.base64DecodedString) as AnyObject)

    //registerSchemeForCustomProtocol
    static private let KGRegistScheme: Selector = NSSelectorFromString("dW5yZWdpc3RlclNjaGVtZUZvckN1c3RvbVByb3RvY29sOg==".kg.base64DecodedString)
    
    //unregisterSchemeForCustomProtocol
    static private let KGUnregistScheme: Selector = NSSelectorFromString("cmVnaXN0ZXJTY2hlbWVGb3JDdXN0b21Qcm90b2NvbDo=".kg.base64DecodedString)
    
    func regist(scheme: String) {
        let cls: AnyObject = Base.kg.KGContextController
        let sel: Selector = Base.kg.KGRegistScheme
        if cls.responds(to: sel) {
            let _ = cls.perform(sel)
        }
    }
    
    func unregist(scheme: String) {
        let cls: AnyObject = Base.kg.KGContextController
        let sel: Selector = Base.kg.KGUnregistScheme
        if cls.responds(to: sel) {
            let _ = cls.perform(sel)
        }
    }
        
}


