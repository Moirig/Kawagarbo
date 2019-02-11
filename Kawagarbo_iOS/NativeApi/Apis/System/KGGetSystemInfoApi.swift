//
//  KGGetSystemInfoApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/1/29.
//

//TODO-SDKVersion:"2.5.2"
//albumAuthorized:true
//batteryLevel:93
//bluetoothEnabled:false
//brand:"iPhone"
//cameraAuthorized:true
//deviceOrientation:"portrait"
//errMsg:"getSystemInfo:ok"
//TODO-fontSizeSetting:17
//language:"zh_CN"
//locationAuthorized:true
//locationEnabled:true
//microphoneAuthorized:true
//model:"iPhone 7 Plus<iPhone9,2>"
//notificationAlertAuthorized:true
//notificationAuthorized:true
//notificationBadgeAuthorized:true
//notificationSoundAuthorized:true
//pixelRatio:3
//platform:"ios"
//screenHeight:736
//screenWidth:414
//statusBarHeight:20
//system:"iOS 11.3"
//version:"7.0.2"
//wifiEnabled:true
//windowHeight:624
//windowWidth:414

import UIKit

class KGGetSystemInfoApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "getSystemInfo" }
    
    func perform(with parameters: [String : Any]?, complete: (KGNativeApiResponse) -> Void) {
        
        var dict: [String: Any] = [:]
        
        dict["albumAuthorized"] = KGSystemInfo.albumAuthorized
        
        dict["batteryLevel"] = KGSystemInfo.batteryLevel
        dict["bluetoothEnabled"] = KGSystemInfo.bluetoothEnabled
        dict["brand"] = KGSystemInfo.brand
        
        dict["cameraAuthorized"] = KGSystemInfo.cameraAuthorized
        
        dict["deviceOrientation"] = KGSystemInfo.deviceOrientation
        
        dict["fontSizeSetting"] = 0
        
        dict["language"] = KGSystemInfo.language
        dict["locationAuthorized"] = KGSystemInfo.locationAuthorized
        dict["locationEnabled"] = KGSystemInfo.locationEnabled
        
        dict["microphoneAuthorized"] = KGSystemInfo.microphoneAuthorized
        dict["model"] = KGSystemInfo.model
        
        dict["notificationAlertAuthorized"] = KGSystemInfo.notificationAlertAuthorized
        dict["notificationAuthorized"] = KGSystemInfo.notificationAuthorized
        dict["notificationBadgeAuthorized"] = KGSystemInfo.notificationBadgeAuthorized
        dict["notificationSoundAuthorized"] = KGSystemInfo.notificationSoundAuthorized

        dict["pixelRatio"] = KGSystemInfo.ratio
        dict["platform"] = "ios"
        
        dict["screenWidth"] = KGSystemInfo.width
        dict["screenHeight"] = KGSystemInfo.height
        dict["SDKVersion"] = "0.1.0"
        dict["system"] = KGSystemInfo.system
        dict["statusBarHeight"] = KGSystemInfo.statusBarHeight
        
        dict["version"] = KGInfoPlist.appVersion
        
        dict["wifiEnabled"] = KGSystemInfo.wifiEnabled
        dict["windowWidth"] = webViewController?.webView.frame.width ?? 0
        dict["windowHeight"] = webViewController?.webView.frame.height ?? 0
        
        
        complete(.success(data: dict))
        
    }
    
}
