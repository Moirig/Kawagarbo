//
//  KGRemoveStorageApi.swift
//  Cache
//
//  Created by wyhazq on 2019/3/4.
//

import UIKit
import Cache

class KGRemoveStorageApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "removeStorage" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let key = parameters?["key"] as? String else { return complete(failure(message: "key undefined!")) }
        
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
            try storage.removeObject(forKey: key)
        } catch {}
        complete(success())
    }
    
}
