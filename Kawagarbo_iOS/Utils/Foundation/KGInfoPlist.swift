//
//  KGInfoPlist.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/1/29.
//

import UIKit

let InfoPlist: [String: Any] = Bundle.main.infoDictionary ?? [:]

struct KGInfoPlist {
    
    static var appName: String {
        return InfoPlist["CFBundleDisplayName"] as? String ?? ""
    }
    
    static var appVersion: String {
        return InfoPlist["CFBundleShortVersionString"] as? String ?? ""
    }

}
