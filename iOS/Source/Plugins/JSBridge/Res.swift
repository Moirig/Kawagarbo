//
//  Res.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/30/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import Foundation

public let ResSuccess: Int = 200
public let ResFail: Int = -1
public let ResCancel: Int = -999
public let ResUnknown: Int = 404

public let kResCode: String = "code"
public let kResMessage: String = "message"
public let kResData: String = "data"

public struct Res {
    
    var code: Int
    var message: String
    var data: [String: Any]
    
}
