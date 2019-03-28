//
//  KGWebApp.swift
//  Alamofire
//
//  Created by wyhazq on 2019/3/15.
//

import Foundation
import CryptoSwift

public struct KGWebApp {
    
    init?(appId: String) {
        guard appId.count > 0 else { return nil }
        
        let rootPath = KawagarboCachePath + "/" + appId
        guard FileManager.kg.fileExists(atPath: rootPath) else {
            FileManager.kg.createDirectory(rootPath)
            return nil
        }
        let appJsonPath = rootPath + "/" + "app.json"
        guard FileManager.kg.fileExists(atPath: appJsonPath) else { return nil }
        
        let appJsonUrl = URL(fileURLWithPath: appJsonPath)
        do {
            let data = try Data(contentsOf: appJsonUrl)
            if let appJson = data.kg.dictionary,
                let aversion = appJson["version"] as? String,
                let apages = appJson["pages"] as? [String],
                let aurl = appJson["url"] as? String {
                self.appId = appId
                self.rootPath = rootPath
                
                version = aversion
                pages = apages
                url = aurl
            }
        }
        catch { return nil }
    }
    
    var version: String = ""
    
    var pages: [String] = []
    
    var url: String = ""

    
    var appId: String = ""

    var rootPath: String = ""
    
    var launchPagePath: String {
        var path = pages.first ?? "/index.html"
        if path.hasPrefix("/") == false {
            path = "/" + path
        }
        return rootPath + path
    }
}
