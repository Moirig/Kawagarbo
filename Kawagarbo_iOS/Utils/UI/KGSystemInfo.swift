//
//  KGSystemInfo.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/1/29.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import Photos
import AVFoundation
import CoreLocation
import UserNotifications

struct KGSystemInfo {
    
    static var albumAuthorized: Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    static var batteryLevel: Int8 {
        return UIDevice.current.batteryLevel > 0 ? Int8(UIDevice.current.batteryLevel * 100) : 0
    }
    
    static var bluetoothEnabled: Bool {
        return KGBluetoothManager.bluetoothEnabled
    }
    
    static var brand: String {
        return UIDevice.current.model
    }
    
    static var cameraAuthorized: Bool {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized
    }
    
    static var locationAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    static var locationEnabled: Bool {
        return locationAuthorized
    }

    static var deviceOrientation: String {
        switch UIApplication.shared.statusBarOrientation {
            
        case .unknown:
            return "unknown"
        case .portrait,
             .portraitUpsideDown:
            return "portrait"
        case .landscapeLeft,
             .landscapeRight:
            return "landscape"
        }
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var language: String {
        guard let collatorIdentifier = Locale.current.collatorIdentifier, let regionCode = Locale.current.regionCode else { return "" }
        return collatorIdentifier.replacingOccurrences(of: collatorIdentifier, with: ("-" + regionCode))
    }
    
    static var microphoneAuthorized: Bool {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.audio) == .authorized
    }
    
    static var model: String {
        return "\(UIDevice.kg.phoneModel.rawValue)<\(UIDevice.kg.hardwareString)>"
    }
    
    static var name: String {
        return UIDevice.current.name
    }
    
    static var notificationAlertAuthorized: Bool {
        var notificationAlertAuthorized: Bool = false
        let semaphore = DispatchSemaphore(value: 0)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                notificationAlertAuthorized = settings.alertSetting == .enabled
                semaphore.signal()
            }
        } else {
            guard let settings = UIApplication.shared.currentUserNotificationSettings else {
                return notificationAlertAuthorized
            }
            notificationAlertAuthorized = settings.types.contains(.alert)
            semaphore.signal()
        }
        
        return notificationAlertAuthorized
    }
    
    static var notificationAuthorized: Bool {
        var notificationAuthorized: Bool = false
        let semaphore = DispatchSemaphore(value: 0)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                notificationAuthorized = settings.authorizationStatus == .authorized
                semaphore.signal()
            }
        } else {
            guard let settings = UIApplication.shared.currentUserNotificationSettings else {
                return notificationAuthorized
            }
            notificationAuthorized = settings.types != .none
            semaphore.signal()
        }
        
        let _ = semaphore.wait(timeout: .distantFuture)
        return notificationAuthorized
    }
    
    static var notificationBadgeAuthorized: Bool {
        var notificationBadgeAuthorized: Bool = false
        let semaphore = DispatchSemaphore(value: 0)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                notificationBadgeAuthorized = settings.badgeSetting == .enabled
                semaphore.signal()
            }
        } else {
            guard let settings = UIApplication.shared.currentUserNotificationSettings else {
                return notificationBadgeAuthorized
            }
            notificationBadgeAuthorized = settings.types.contains(.badge)
            semaphore.signal()
        }
        
        return notificationBadgeAuthorized
    }
    
    static var notificationSoundAuthorized: Bool {
        var notificationSoundAuthorized: Bool = false
        let semaphore = DispatchSemaphore(value: 0)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                notificationSoundAuthorized = settings.soundSetting == .enabled
                semaphore.signal()
            }
        } else {
            guard let settings = UIApplication.shared.currentUserNotificationSettings else {
                return notificationBadgeAuthorized
            }
            notificationSoundAuthorized = settings.types.contains(.sound)
            semaphore.signal()
        }
        
        return notificationSoundAuthorized
    }
    
    static var ratio: Int8 {
        return Int8(UIScreen.main.scale)
    }
    
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    static var system: String {
        return "iOS \(UIDevice.current.systemVersion)"
    }
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var wifiEnabled: Bool {
        return currentSSIDs.count > 0
    }
    
    
}

extension KGSystemInfo {
    
    static var currentSSIDs: [String] {
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            return []
        }
        return interfaceNames.compactMap { name in
            guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {
                return nil
            }
            guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
                return nil
            }
            return ssid
        }
    }
    
}
