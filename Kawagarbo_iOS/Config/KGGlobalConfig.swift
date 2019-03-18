//
//  KGGlobalConfig.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2019/1/21.
//  Copyright © 2019年 Moirig. All rights reserved.
//

import UIKit

public struct KGGlobalConfig {
    
    public static var injectDynamically: Bool = false
    
    public static var userAgent: String?
    
    public static var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    
    public static var timeoutInterval: TimeInterval = 60
    
    public static var progressTintColor: UIColor = UIColor(red:0.59, green:0.78, blue:0.45, alpha:1.00)

    public static var barBackgroundColor: UIColor = UIColor(hexString: "#ffffff")!
    
    public static var barFrontColor: UIColor = UIColor(hexString: "#000000")!
        
    public static var offlineWebAppConfig: [String: Any] = [:]
    
    public static var offlineWebAppEnable: Bool = false
    
}
