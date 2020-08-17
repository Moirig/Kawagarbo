//
//  NameSpace.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import Foundation

public struct KWNamespace<Base> {
    /// Base object to extend.
    public let base: Base
    
    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

/// A type that has reactive extensions.
public protocol KWNamespaceProtocol {
    /// Extended type
    associatedtype KWCompatibleType
    
    /// Reactive extensions.
    static var kw: KWNamespace<KWCompatibleType>.Type { get set }
    
    /// Reactive extensions.
    var kw: KWNamespace<KWCompatibleType> { get set }
}

extension KWNamespaceProtocol {
    /// Reactive extensions.
    public static var kw: KWNamespace<Self>.Type {
        get {
            return KWNamespace<Self>.self
        }
        set {
            // this enables using Reactive to "mutate" base type
        }
    }
    
    /// Reactive extensions.
    public var kw: KWNamespace<Self> {
        get {
            return KWNamespace(self)
        }
        set {
            // this enables using Reactive to "mutate" base object
        }
    }
}

import class Foundation.NSObject

extension NSObject: KWNamespaceProtocol { }
