//
//  KGNativeApiError.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/12/22.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import Foundation

public enum KGNativeApiError: Int {
    
    case invalidParameters = -4000
    
    case cannotParseResponse = -1017
    
    case unknowNativeApi = -1
    
    
    var localizedDescription: String {
        switch self {
        
        case .cannotParseResponse:
            return "Bad response!"
            
        case .invalidParameters:
            return "Invalid Paramters! Parameters must be a object."
            
        case .unknowNativeApi:
            return "Unknown Api"
            
        
            
        }
    }
    
    
}
