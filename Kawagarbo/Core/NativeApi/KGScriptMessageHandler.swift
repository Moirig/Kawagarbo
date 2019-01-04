//
//  KGScriptMessageHandler.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2018/12/17.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit
import WebKit

class KGScriptMessageHandler: NSObject, WKScriptMessageHandler {
    
    public weak var scriptDelegate: WKScriptMessageHandler?
    
    convenience init(delegate: WKScriptMessageHandler) {
        self.init()
        
        scriptDelegate = delegate
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
    
}
