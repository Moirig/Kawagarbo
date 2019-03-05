//
//  KGConfig.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/12/25.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit

public struct KGConfig {
    
    public var injectDynamically: Bool = KGGlobalConfig.injectDynamically
    
    public var userAgent: String = KGGlobalConfig.userAgent ?? ""
    
    public var cachePolicy: URLRequest.CachePolicy = KGGlobalConfig.cachePolicy
    
    public var timeoutInterval: TimeInterval = KGGlobalConfig.timeoutInterval
    
    public var progressTintColor: UIColor = KGGlobalConfig.progressTintColor
    
    public var barBackgroundColor: UIColor = KGGlobalConfig.barBackgroundColor
    
    public var barFrontColor: UIColor = KGGlobalConfig.barFrontColor
    
    public var appIdKey: String = KGGlobalConfig.appIdKey
}
