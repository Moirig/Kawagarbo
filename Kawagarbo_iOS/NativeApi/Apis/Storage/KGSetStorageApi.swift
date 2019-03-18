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
        
        guard let key = parameters?["key"] as? String else { return complete(failure(message: "key undefined!")) }
        guard let data = parameters?["data"] else { return complete(failure(message: "data undefined!")) }

        var url: URL?
        var storageName: String = "kgstorage"
        
        if let rootPath = webViewController?.webRoute?.webApp?.rootPath {
            url = URL(fileURLWithPath: rootPath)
        }
        else {
            if let appId = webViewController?.webRoute?.appId {
                storageName = appId + "/" + storageName
            }
        }
        
        let config = DiskConfig(name: storageName, expiry: .never, maxSize: 10 * 1024 * 1024, directory: url, protectionType: .complete)
        
        do {
            let storage = try DiskStorage(config: config, transformer: TransformerFactory.forData())
            var jsonData: Data
            if let _ = data as? [String: Any], let _ = data as? [Any] {
                jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            }
            else {
                let str = "\(data)"
                jsonData = str.kg.data
            }
            try storage.setObject(jsonData, forKey: key)
            
            var keys = getKeys(from: storage)
            if keys.contains(key) == false { keys.append(key) }
            let keysData = try JSONSerialization.data(withJSONObject: keys, options: .prettyPrinted)
            try storage.setObject(keysData, forKey: "kgKeys")
            return complete(success())
        } catch {
            let nsError = error
            return complete(failure(message: nsError.localizedDescription))
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
