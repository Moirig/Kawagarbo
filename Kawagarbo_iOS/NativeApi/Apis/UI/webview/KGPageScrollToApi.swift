//
//  KGPageScrollToApi.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/2/20.
//

import UIKit

class KGPageScrollToApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "pageScrollTo" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let webView = webViewController?.webView else { return complete(failure(message: "No webView;")) }
        
        guard var scrollTop = parameters?["scrollTop"] as? CGFloat else { return complete(failure(message: "scrollTop undefined;")) }
        
        if webView.scrollView.contentSize.height < webView.scrollView.frame.height {
            return complete(failure(message: "can not scroll;"))
        }
        
        //TODO-
//        let duration = (parameters?["duration"] as? TimeInterval) ?? TimeInterval(300.0 / 1000)
        
        scrollTop = scrollTop < 0 ? 0 : scrollTop;
        scrollTop = scrollTop > webView.scrollView.contentSize.height ? webView.scrollView.contentSize.height - webView.scrollView.frame.height : scrollTop
        
        webView.scrollView.setContentOffset(CGPoint(x: 0, y: scrollTop), animated: true)
        
        complete(success())
    }

}
