//
//  KGNativeApiResponse.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/26.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import Foundation

public enum KGNativeApiResponse {
    case success(data: [String: Any]?, message: String?)
    case cancel(message: String?)
    case unknowApi(apiPath: String)
    case failure(code: Int, message: String?)
}

extension KGNativeApiResponse {
    
    var jsonObject: [String: Any] {
        
        var dict: [String : Any] = [:]
        
        switch self {
            
        case .success(let data, let message):
            
            dict[kParamCode] = kParamSuccessCode
            dict[kParamMessage] = message ?? ""
            
            if let data = data {
                dict[kParamData] = data
            }
            
        case .cancel(let message):
            
            dict[kParamCode] = kParamCancelCode
            dict[kParamMessage] = message ?? ""
            
        case .unknowApi(let apiPath):
            
            dict[kParamCode] = KGNativeApiError.unknowNativeApi
            dict[kParamMessage] = "\(KGNativeApiError.unknowNativeApi.localizedDescription):\(apiPath)!"
            
        case .failure(let code, let message):
            
            dict[kParamCode] = code
            dict[kParamMessage] = message ?? ""
            
        }
        return dict
    }

}
