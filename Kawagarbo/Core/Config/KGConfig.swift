//
//  KGConfig.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/12/25.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit

public struct KGConfig {
    
    public var injectDynamically: Bool?
    
    public var userAgent: String?
    
    public var cachePolicy: URLRequest.CachePolicy?
    
    public var timeoutInterval: TimeInterval?
    
    public var progressTintColor: UIColor?
    
    
    var isInjectDynamically: Bool {
        if let isInjectDynamically = injectDynamically {
            return isInjectDynamically
        }
        return KGGlobalConfig.injectDynamically
    }
    
    var getProgressTintColor: UIColor {
        if let color = progressTintColor {
            return color
        }
        
        return KGGlobalConfig.progressTintColor
    }
    
    var getUserAgent: String {
        if let ua = userAgent {
            return ua
        }
        
        return KGGlobalConfig.userAgent ?? ""
    }
    
    var getCachePolicy: URLRequest.CachePolicy {
        if let policy = cachePolicy {
            return policy
        }
        
        return KGGlobalConfig.cachePolicy
    }
    
    var getTimeoutInterval: TimeInterval {
        if let interval = timeoutInterval {
            return interval
        }
        
        return KGGlobalConfig.timeoutInterval
    }
    
    
}
