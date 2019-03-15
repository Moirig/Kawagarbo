//
//  KGInfoPlist.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/1/29.
//

import UIKit

struct KGInfoPlist {
    
    static let shared: [String: Any] = Bundle.main.infoDictionary ?? [:]
    
    static var appName: String {
        return KGInfoPlist.shared["CFBundleDisplayName"] as? String ?? ""
    }
    
    static var appVersion: String {
        return KGInfoPlist.shared["CFBundleShortVersionString"] as? String ?? ""
    }
    
    static var baseStatusBarAppearance: Bool {
        return KGInfoPlist.shared["UIViewControllerBasedStatusBarAppearance"] as? Bool ?? false
    }
    
    static var photoLibraryAddUsageDescription: Bool {
        if let _ = KGInfoPlist.shared["NSPhotoLibraryAddUsageDescription"] as? String {
            return true
        }
        return false
    }
    
}
