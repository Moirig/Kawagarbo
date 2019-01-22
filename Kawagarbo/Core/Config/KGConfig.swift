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
    
    public var progressColor: UIColor?
    
    
    var isInjectDynamically: Bool {
        if let isInjectDynamically = injectDynamically {
            if isInjectDynamically {
                return true
            }
        }
        else if KGGlobalConfig.injectDynamically {
            return true
        }
        
        return false
    }
    
    var progressTintColor: UIColor {
        if let color = progressColor {
            return color
        }
        
        return KGGlobalConfig.progressColor
    }
    
}
