//
//  Kawagarbo.swift
//  KawagarboExample
//
//  Created by wyhazq on 2018/8/16.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit

public class Kawagarbo: NSObject {

    public static func setup() {
        KGWebViewManager.preloadWebView()
        KGNativeApi.regist()
    }
    
}
