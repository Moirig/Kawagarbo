//
//  KGReLaunchApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/11.
//

import UIKit

class KGReLaunchApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "reLaunch" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let urlString = parameters?["url"] as? String else { return complete(failure(message: "Invalid url!")) }
        
        guard let _ = URL(string: urlString) else { return complete(failure(message: "Invalid url!")) }
        
        if urlString.kg.isFile {
            let filePath = urlString.kg.noScheme
            if FileManager.kg.fileExists(atPath: filePath) == false {
                return complete(failure(message: "No file!"))
            }
        }
        complete(success())
        
        guard let webVC = webViewController else { return }
        
        webVC.webRoute = KGWebRoute(urlString: urlString)
        webVC.setup()
        webVC.navigationController?.viewControllers = [webVC]
    }
    

}
