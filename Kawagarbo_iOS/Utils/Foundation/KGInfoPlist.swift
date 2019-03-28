//
//  KGInfoPlist.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/1/29.
//

import UIKit

struct KGInfoPlist {
    
    static let shared: [String: Any] = Bundle.main.infoDictionary ?? [:]
    
    static var bundleID: String {
        return KGInfoPlist.shared["CFBundleIdentifier"] as? String ?? ""
    }
    
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
    
    static var photoLibraryUsageDescription: Bool {
        if let _ = KGInfoPlist.shared["NSPhotoLibraryUsageDescription"] as? String {
            return true
        }
        return false
    }
    
    static var cameraUsageDescription: Bool {
        if let _ = KGInfoPlist.shared["NSCameraUsageDescription"] as? String {
            return true
        }
        return false
    }
    
    
    
}
