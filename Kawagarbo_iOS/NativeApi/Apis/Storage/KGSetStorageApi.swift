//
//  KGSetStorageApi.swift
//  Cache
//
//  Created by 温一鸿 on 2019/3/4.
//

import UIKit
import Cache

class KGSetStorageApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "setStorage" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let appId = webViewController?.webRoute?.appId else { return complete(.failure(code: kParamCodeDefaultFail, message: "No appId;")) }
        
        guard let key = parameters?["key"] as? String else { return complete(.failure(code: kParamCodeDefaultFail, message: "key undefined!")) }
        guard let data = parameters?["data"] else { return complete(.failure(code: kParamCodeDefaultFail, message: "data undefined!")) }

        
        let url = URL(fileURLWithPath: KawagarboCachePath + "/\(appId)")
        let config = DiskConfig(name: "kgstorage", expiry: .never, maxSize: 10 * 1024 * 1024, directory: url, protectionType: .complete)
        
        do {
            let storage = try DiskStorage(config: config, transformer: TransformerFactory.forData())
            var jsonData: Data
            if let jsonString = data as? String {
                jsonData = jsonString.kg.data
            }
            else {
                jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            }
            try storage.setObject(jsonData, forKey: key)
            
            var keys = getKeys(from: storage)
            if keys.contains(key) == false { keys.append(key) }
            let keysData = try JSONSerialization.data(withJSONObject: keys, options: .prettyPrinted)
            try storage.setObject(keysData, forKey: "kgKeys")
            return complete(.success(data: nil))
        } catch {
            let nsError = error
            return complete(.failure(code: kParamCodeDefaultFail, message: nsError.localizedDescription))
        }
        
    }
    
    func getKeys(from storage: DiskStorage<Data>) -> [String] {
        do {
            let keysData = try storage.object(forKey: "kgKeys")
            if let keys = try JSONSerialization.jsonObject(with: keysData, options: .allowFragments) as? [String] {
                return keys
            }
        } catch {
            
        }
        
        return []
    }
    
}
