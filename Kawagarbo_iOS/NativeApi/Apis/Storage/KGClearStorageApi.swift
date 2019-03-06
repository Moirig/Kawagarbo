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
        
        guard let appId = webViewController?.webRoute?.appId else { return complete(failure(message: "No appId;")) }
        
        let url = URL(fileURLWithPath: KawagarboCachePath + "/\(appId)")
        let config = DiskConfig(name: "kgstorage", expiry: .never, maxSize: 10 * 1024 * 1024, directory: url, protectionType: .complete)
        
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
