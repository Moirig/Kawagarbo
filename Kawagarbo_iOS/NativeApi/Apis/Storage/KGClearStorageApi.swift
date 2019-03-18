//
//  KGClearStorageApi.swift
//  Cache
//
//  Created by 温一鸿 on 2019/3/4.
//

import UIKit
import Cache

class KGClearStorageApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "clearStorage" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
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
            try storage.removeAll()
            return complete(success())
        } catch {
            let nsError = error
            return complete(failure(message: nsError.localizedDescription))
        }
        
    }

}
