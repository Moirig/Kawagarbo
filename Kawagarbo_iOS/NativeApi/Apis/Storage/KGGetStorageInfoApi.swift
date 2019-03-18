//
//  KGGetStorageInfoApi.swift
//  Cache
//
//  Created by 温一鸿 on 2019/3/4.
//

import UIKit
import Cache

class KGGetStorageInfoApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "getStorageInfo" }
    
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
            let keys = getKeys(from: storage)
            let currentSize = try totalSize(of: storage)
            let limitSize: UInt64 = 10 * 1024
            let dataDict: [String: Any] = ["keys": keys,
                                           "currentSize": currentSize,
                                           "limitSize": limitSize]
            return complete(success(data: dataDict))
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
    
    func totalSize(of storage: DiskStorage<Data>) throws -> UInt64 {
        var size: UInt64 = 0
        let contents = try FileManager.default.contentsOfDirectory(atPath: storage.path)
        for pathComponent in contents {
            let filePath = NSString(string: storage.path).appendingPathComponent(pathComponent)
            let attributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = attributes[.size] as? UInt64 {
                size += fileSize
            }
        }
        if size > 1024 {
            size = size / 1024
        }
        else if size > 0 {
            size = 1
        }
        
        return size
    }
    
}
