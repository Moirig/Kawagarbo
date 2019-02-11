//
//  KGCanIUseApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/11.
//

//${API} 代表 API 名字
//TODO-${method} 代表调用方式，有效值为return, success, object, callback
//TODO-${param} 代表参数或者返回值
//TODO-${options} 代表参数的可选值

import UIKit

class KGCanIUseApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "canIUse" }
    
    func perform(with parameters: [String : Any]?, complete: (KGNativeApiResponse) -> Void) {
        
        guard let schemaString = parameters?["schema"] as? String, schemaString.count > 0 else { return complete(.failure(code: kParamCodeDefaultFail, message: "Invalid schema")) }
        
        let schemas = schemaString.components(separatedBy: ".")
        guard let schema = schemas.last else { return complete(.failure(code: kParamCodeDefaultFail, message: "Invalid schema")) }
        
        if KGNativeApiManager.nativeApis[schema] == nil {
            return complete(.failure(code: kParamCodeDefaultFail, message: "Unknown Api:\(schema)!"))
        }
        
        complete(.success(data: nil))
    }

}
