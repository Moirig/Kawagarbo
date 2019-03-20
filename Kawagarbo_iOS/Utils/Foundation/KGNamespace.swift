//
//  KGNamespace.swift
//  KawagarboExample
//
//  Created by wyhazq on 2019/1/25.
//  Copyright © 2019年 Moirig. All rights reserved.
//

/**
 Use `Reactive` proxy as customization point for constrained protocol extensions.
 General pattern would be:
 // 1. Extend Reactive protocol with constrain on Base
 // Read as: Reactive Extension where Base is a SomeType
 extension Reactive where Base: SomeType {
 // 2. Put any specific reactive extension for SomeType here
 }
 With this approach we can have more specialized methods and properties using
 `Base` and not just specialized on common base type.
 */

public struct KGNamespace<Base> {
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
public protocol KGNamespaceProtocol {
    /// Extended type
    associatedtype KGCompatibleType
    
    /// Reactive extensions.
    static var kg: KGNamespace<KGCompatibleType>.Type { get set }
    
    /// Reactive extensions.
    var kg: KGNamespace<KGCompatibleType> { get set }
}

extension KGNamespaceProtocol {
    /// Reactive extensions.
    public static var kg: KGNamespace<Self>.Type {
        get {
            return KGNamespace<Self>.self
        }
        set {
            // this enables using Reactive to "mutate" base type
        }
    }
    
    /// Reactive extensions.
    public var kg: KGNamespace<Self> {
        get {
            return KGNamespace(self)
        }
        set {
            // this enables using Reactive to "mutate" base object
        }
    }
}

import class Foundation.NSObject

extension NSObject: KGNamespaceProtocol { }
