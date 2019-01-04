//
//  KGJSBridgeConst.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/12/18.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit

public typealias KGNativeApiResponseClosure = (_ response: KGNativeApiResponse) -> Void

internal typealias Message = [String: Any]
internal typealias Handler = (_ parameters: [String: Any]?, _ callback: Callback?) -> Void
internal typealias Callback = (_ responseData: [String: Any]?) -> Void

internal let KGScriptMessageHandleName = "invokeHandler"
internal let kParamHandlerName: String = "handlerName"
internal let kParamCallbackId: String = "callbackId"
internal let kParamResponseData: String = "responseData"
internal let kParamResponseId: String = "responseId"
internal let kParamCode: String = "code"
internal let kParamMessage: String = "message"
internal let kParamData: String = "data"

internal let kParamSuccessCode: Int = 200
internal let kParamCancelCode: Int = -999

internal let KGJSBridgeObj: String = "KGJSBridge"
internal let KGJSBridgeHandleMessageFunction: String = "_handleMessageFromNative"

