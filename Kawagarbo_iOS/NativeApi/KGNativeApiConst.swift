//
//  KGJSBridgeConst.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/12/18.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit

public let kParamCode: String = "code"
public let kParamMessage: String = "message"
public let kParamData: String = "data"


let ResCodeSuccess: Int = 200
let ResCodeCancel: Int = -999
let ResCodeUnknownApi: Int = 404
public let ResCodeDefaultFail: Int = -1

internal typealias Message = [String: Any]
internal typealias Handler = (_ parameters: [String: Any]?, _ callback: Callback?) -> Void
internal typealias Callback = (_ jsonObject: [String: Any]?) -> Void


internal let KGScriptMessageHandleName = "invokeHandler"
internal let kParamHandlerName: String = "handlerName"
internal let kParamCallbackId: String = "callbackId"
internal let kParamResponseData: String = "responseData"
internal let kParamResponseId: String = "responseId"


internal let KGJSBridgeObj: String = "KGJSBridge"
internal let KGSubscribeHandler: String = "_subscribeHandler"

