//
//  KGJSBridgeConst.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/12/18.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit


public let kParamSuccessCode: Int = 200
public let kParamCancelCode: Int = -999
public typealias KGNativeApiResponseClosure = (_ response: KGNativeApiResponse) -> Void

internal let KGScriptMessageHandleName = "invokeHandler"
internal let kParamHandlerName: String = "handlerName"
internal let kParamCallbackId: String = "callbackId"
internal let kParamData: String = "data"
internal let kParamResponseData: String = "responseData"
internal let kParamResponseId: String = "responseId"
internal let kParamCode: String = "data"
internal let kParamMessage: String = "data"

