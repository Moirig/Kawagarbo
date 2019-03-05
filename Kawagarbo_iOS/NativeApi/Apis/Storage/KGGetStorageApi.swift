//
//  KGGetStorageApi.swift
//  Cache
//
//  Created by 温一鸿 on 2019/3/4.
//

import UIKit
import Cache

class KGGetStorageApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "getStorage" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let appId = webViewController?.webRoute?.appId else { return complete(.failure(code: kParamCodeDefaultFail, message: "No appId;")) }
        
        guard let key = parameters?["key"] as? String else { return complete(.failure(code: kParamCodeDefaultFail, message: "key undefined!")) }
        
        let url = URL(fileURLWithPath: KawagarboCachePath + "/\(appId)")
        let config = DiskConfig(name: "kgstorage", expiry: .never, maxSize: 10 * 1024 * 1024, directory: url, protectionType: .complete)
        
        do {
            let storage = try DiskStorage(config: config, transformer: TransformerFactory.forData())
            let obj = try storage.object(forKey: key)
            return complete(.success(data: ["data": obj.kg.json ?? ""]))
        } catch {
            return complete(.failure(code: kParamCodeDefaultFail, message: "fail data not found"))
        }
        
    }
    
}
