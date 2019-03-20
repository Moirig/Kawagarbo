//
//  KGNavigateToApi.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/2/11.
//

import UIKit

class KGNavigateToApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "navigateTo" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {

        guard let urlString = parameters?["url"] as? String else { return complete(failure(message: "Invalid url!")) }
        
        guard let _ = URL(string: urlString) else { return complete(failure(message: "Invalid url!")) }
        
        if urlString.kg.isFile {
            let filePath = urlString.kg.noScheme
            if FileManager.kg.fileExists(atPath: filePath) == false {
                return complete(failure(message: "No file!"))
            }
        }
        
        let webVC = KGWebViewController(urlString: urlString)
        webVC.hidesBottomBarWhenPushed = true
        webViewController?.navigationController?.pushViewController(webVC, animated: true)
        
        complete(success())
    }
    

}
