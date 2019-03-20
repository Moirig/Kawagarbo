//
//  KGNativeApiResponse.swift
//  KawagarboExample
//
//  Created by wyhazq on 2018/9/26.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import Foundation

public typealias KGNativeApiResponse = [String: Any]

public func success(message: String? = "", data: [String: Any]? = nil) -> KGNativeApiResponse {
    return response(code: ResCodeSuccess, message: message, data: data)
}

public func cancel(message: String? = "", data: [String: Any]? = nil) -> KGNativeApiResponse {
    return response(code: ResCodeCancel, message: message, data: data)
}

public func unknowApi(message: String? = "", data: [String: Any]? = nil) -> KGNativeApiResponse {
    return response(code: ResCodeUnknownApi, message: message, data: data)
}

public func failure(code: Int = ResCodeDefaultFail, message: String? = "", data: [String: Any]? = nil) -> KGNativeApiResponse {
    return response(code: code, message: message, data: data)
}

func response(code: Int, message: String? = "", data: [String: Any]? = nil) -> KGNativeApiResponse {
    var dict: [String : Any] = [:]
    dict[kParamCode] = code
    dict[kParamMessage] = message
    
    if let data = data {
        dict[kParamData] = data
    }
    return dict
}
