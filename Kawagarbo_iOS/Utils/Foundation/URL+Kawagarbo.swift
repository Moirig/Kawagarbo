//
//  URL+Kawagarbo.swift
//  Alamofire
//
//  Created by wyhazq on 2019/3/15.
//

import Foundation

extension URL: KGNamespaceProtocol {}

extension KGNamespace where Base == URL {
    
    var baseURLString: String {
        guard let scheme = base.scheme, let host = base.host else { return "" }
        var str = "\(scheme)://\(host)"
        if let port = base.port {
            str = "\(str):\(port)"
        }
        if base.path.count > 0 {
            str = "\(str)/\(base.path)"
        }
        return str
    }
    
}
