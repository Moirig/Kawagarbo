//
//  NSError+Kawagarbo.swift
//  Alamofire
//
//  Created by wyhazq on 2019/3/27.
//

import Foundation

public extension NSError {
    
    public convenience init(code: Int, message: String = "") {
        self.init(domain: KGInfoPlist.bundleID, code: code, userInfo: [NSLocalizedDescriptionKey : message])
    }
    
}
