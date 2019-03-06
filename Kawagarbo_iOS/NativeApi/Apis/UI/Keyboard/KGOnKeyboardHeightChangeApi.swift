//
//  KGOnKeyboardHeightChangeApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/21.
//

import UIKit

class KGOnKeyboardHeightChangeApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "onKeyboardHeightChange" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let webVC = webViewController else { return complete(failure(message: "no webview;")) }
        NotificationCenter.default.addObserver(webVC, selector: #selector(onKeyboardHeightChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc func onKeyboardHeightChange(_ notification: Notification) {}

}
