//
//  NSURLProtocol+Kawagarbo.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import Foundation
import WebKit

extension KWNamespace where Base == URLProtocol {

    //browsingContextController
    static private let KGContextController: AnyObject = type(of: WKWebView().value(forKey: "YnJvd3NpbmdDb250ZXh0Q29udHJvbGxlcg==".kw.base64DecodedString) as AnyObject)

    //registerSchemeForCustomProtocol
    static private let KGRegistScheme: Selector = NSSelectorFromString("cmVnaXN0ZXJTY2hlbWVGb3JDdXN0b21Qcm90b2NvbDo=".kw.base64DecodedString)

    //unregisterSchemeForCustomProtocol
    static private let KGUnregistScheme: Selector = NSSelectorFromString("dW5yZWdpc3RlclNjaGVtZUZvckN1c3RvbVByb3RvY29sOg==".kw.base64DecodedString)

    static func regist(scheme: String) {
        let cls: AnyObject = Base.kw.KGContextController
        let sel: Selector = Base.kw.KGRegistScheme
        if cls.responds(to: sel) {
            let _ = cls.perform(sel, with: scheme)
        }
    }

    static func unregist(scheme: String) {
        let cls: AnyObject = Base.kw.KGContextController
        let sel: Selector = Base.kw.KGUnregistScheme
        if cls.responds(to: sel) {
            let _ = cls.perform(sel, with: scheme)
        }
    }

}
