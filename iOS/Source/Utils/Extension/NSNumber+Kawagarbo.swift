//
//  NSNumber+Kawagarbo.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 7/31/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import Foundation

extension KWNamespace where Base == NSNumber {
    var isBool: Bool {
        // Use Obj-C type encoding to check whether the underlying type is a `Bool`, as it's guaranteed as part of
        // swift-corelibs-foundation, per [this discussion on the Swift forums](https://forums.swift.org/t/alamofire-on-linux-possible-but-not-release-ready/34553/22).
        String(cString: base.objCType) == "c"
    }
}
