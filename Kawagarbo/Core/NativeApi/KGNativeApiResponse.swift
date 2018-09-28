//
//  KGNativeApiResponse.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/26.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import Foundation

public typealias KGNativeApiResponseClosure = (_ response: KGNativeApiResponse) -> Void

public enum KGNativeApiResponse {
    case success(data: [String: Any]?)
    case failure(code: Int, message: String?)
}

extension KGNativeApiResponse {
    
    var response: [String: Any] {
        
        var dict: [String : Any] = [
            "code": 0,
            "message": ""
        ]
        
        switch self {
            
        case .success(let data):
            
            if let data = data {
                dict["data"] = data
            }
            
        case .failure(let code, let message):
            
            dict["code"] = code
            
            if let message = message {
                dict["message"] = message
            }
            
            
        }
        return dict
    }
}
