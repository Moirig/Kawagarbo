//
//  KGNativeApiResponse.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/26.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import Foundation

public enum KGNativeApiResponse {
    case success(data: [String: Any]?)
    case failure(code: Int, message: String?)
    case cancel
}

extension KGNativeApiResponse {
    
    var response: [String: Any] {
        
        var dict: [String : Any] = [
            kParamCode: kParamSuccessCode,
            kParamMessage: ""
        ]
        
        switch self {
            
        case .success(let data):
            
            if let data = data {
                dict[kParamData] = data
            }
            
        case .failure(let code, let message):
            
            dict[kParamCode] = code
            
            if let message = message {
                dict[kParamMessage] = message
            }
            
            
        case .cancel:
            dict[kParamCode] = kParamCancelCode
        }
        
        return dict
    }
}
