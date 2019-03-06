//
//  KGGetSystemInfoApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/1/29.
//

//TODO-SDKVersion:"2.5.2"
//TODO-fontSizeSetting:17

import UIKit

class KGGetSystemInfoApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "getSystemInfo" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {

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
        dict["windowWidth"] = webViewController?.webView?.frame.width ?? 0
        dict["windowHeight"] = webViewController?.webView?.frame.height ?? 0
        
        
        complete(success(data: dict))
        
    }
    
}
