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
    case cancel(message: String?)
    case unknownApi(api: String)
    case failure(code: Int, message: String?)
}

extension KGNativeApiResponse {
    
    var jsonObject: [String: Any] {
        
        var dict: [String : Any] = [:]
        
        switch self {
            
        case .success(let data):
            
            dict[kParamCode] = kParamCodeSuccess
            dict[kParamMessage] = ""
            
            if let data = data {
                dict[kParamData] = data
            }
            
        case .cancel(let message):
            
            dict[kParamCode] = kParamCodeCancel
            dict[kParamMessage] = message ?? ""
            
        case .unknownApi(let api):
            
            dict[kParamCode] = kParamCodeUnknownApi
            dict[kParamMessage] = "Unknown Api:\(api)!"
            
        case .failure(let code, let message):
            
            dict[kParamCode] = code
            dict[kParamMessage] = message ?? ""
        
        }
        return dict
    }

}
