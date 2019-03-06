//
//  KGNativeApiResponse.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/9/26.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import Foundation

public typealias KGNativeApiResponse = [String: Any]

public func success(message: String = "", data: [String: Any]? = nil) -> KGNativeApiResponse {
    return response(code: kParamCodeSuccess, message: message, data: data)
}

public func cancel(message: String = "", data: [String: Any]? = nil) -> KGNativeApiResponse {
    return response(code: kParamCodeCancel, message: message, data: data)
}

public func unknowApi(message: String = "", data: [String: Any]? = nil) -> KGNativeApiResponse {
    return response(code: kParamCodeUnknownApi, message: message, data: data)
}

public func failure(code: Int = -1, message: String = "", data: [String: Any]? = nil) -> KGNativeApiResponse {
    return response(code: code, message: message, data: data)
}

func response(code: Int, message: String = "", data: [String: Any]? = nil) -> KGNativeApiResponse {
    var dict: [String : Any] = [:]
    dict[kParamCode] = code
    dict[kParamMessage] = message
    
    if let data = data {
        dict[kParamData] = data
    }
    return dict
}
