//
//  KGNavigateBackApi.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/2/11.
//

import UIKit

class KGNavigateBackApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "navigateBack" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {

        guard let delta = parameters?["delta"] as? Int, delta > 0 else { return complete(failure(message: "Invalid delta!")) }
        
        guard let count = webViewController?.navigationController?.viewControllers.count else { return complete(failure(message: "Can not navigateBack!")) }
        
        if delta > count - 1 {
            webViewController?.navigationController?.popToRootViewController(animated: true)
        }
        else {
            if let vc = webViewController?.navigationController?.viewControllers[count - 1 - delta] {
                webViewController?.navigationController?.popToViewController(vc, animated: true)
            }
        }
        
        complete(success())
    }
    

}
