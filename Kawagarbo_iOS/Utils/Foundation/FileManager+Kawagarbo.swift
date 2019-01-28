//
//  FileManager+Kawagarbo.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2019/1/23.
//  Copyright © 2019年 Moirig. All rights reserved.
//

import Foundation

public let KawagarboCachePath: String = FileManager.kg.kawagarboCachePath

private let KawagarboCachePathName: String = "kawagarbo"

extension KGNamespace where Base == FileManager {
    
    static var kawagarboCachePath: String {
        if #available(iOS 9.0, *) {
            return documentPath + "/" + KawagarboCachePathName
        }
        return tmpPath + KawagarboCachePathName
    }
    
}

public extension KGNamespace where Base == FileManager {
    
    static var documentPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first ?? ""
    }
    
    static var cachePath: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true).first ?? ""
    }
    
    static var tmpPath: String {
        return NSTemporaryDirectory()
    }
    
}

public extension FileManager {
    
    static func fileExists(atPath: String) -> Bool {
        return FileManager.default.fileExists(atPath: atPath)
    }
    
    @discardableResult
    static func removeItem(atPath: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: atPath)
        }
        catch {
            KGLog(error)
            return false
        }
        
        return true
    }
    
    @discardableResult
    static func createDirectory(_ atPath: String) -> Bool {
        if fileExists(atPath: atPath) { return true }
        
        do {
            try FileManager.default.createDirectory(atPath: atPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            KGLog(error)
            return false
        }
        
        return true
    }
    
    @discardableResult
    static func moveItem(atPath: String, toPath: String) -> Bool {
        if  fileExists(atPath: toPath){
            removeItem(atPath: toPath)
        }
        
        do {
            try FileManager.default.moveItem(atPath: atPath, toPath: toPath)
        } catch {
            KGLog(error)
            return false
        }
        
        return true
    }
    
    @discardableResult
    static func copyItem(atPath: String, toPath: String) -> Bool {
        if  fileExists(atPath: toPath){
            removeItem(atPath: toPath)
        }
        
        do {
            try FileManager.default.copyItem(atPath: atPath, toPath: toPath)
        } catch {
            KGLog(error)
            return false
        }
        
        return true
    }
    
    
}
