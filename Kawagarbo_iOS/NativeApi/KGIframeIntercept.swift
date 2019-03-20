//
//  KGIframeIntercept.swift
//  KawagarboExample
//
//  Created by wyhazq on 2019/1/23.
//  Copyright © 2019年 Moirig. All rights reserved.
//

import UIKit

class KGIframeIntercept: NSObject {
    
    static func canIntercept(_ url: URL) -> Bool {
        guard let scheme = url.scheme else { return true }
        
        if scheme.kg.isHTTP {
            guard let host = url.host else { return true }
            if host == "itunes.apple.com" { return true }
        }
            
        else if scheme.kg.isFile { }
            
        else if scheme == "tel" { return true }
            
        else { return true }
        
        return false
    }

    static func intercept(_ url: URL) {
        var vUrl = url
        let scheme = url.scheme!
        
        if scheme == "tel" {
            let phoneCallStr = url.absoluteString.replacingOccurrences(of: scheme, with: "telprompt")
            
            guard let telUrl = URL(string: phoneCallStr) else { return }
            vUrl = telUrl
        }
            
        if UIApplication.shared.canOpenURL(vUrl) {
            UIApplication.shared.openURL(vUrl)
        }
    }
    
}
