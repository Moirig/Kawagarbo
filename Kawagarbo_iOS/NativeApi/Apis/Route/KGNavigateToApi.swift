//
//  KGNavigateToApi.swift
//  Kawagarbo_iOS
//
//  Created by 温一鸿 on 2019/2/11.
//

import UIKit

class KGNavigateToApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "navigateTo" }
    
    func perform(with parameters: [String : Any]?, complete: (KGNativeApiResponse) -> Void) {
        
        guard let urlString = parameters?["url"] as? String else { return complete(.failure(code: kParamCodeDefaultFail, message: "Invalid url!")) }
        
        guard let url = URL(string: urlString) else { return complete(.failure(code: kParamCodeDefaultFail, message: "Invalid url!")) }
        
        if url.scheme == nil || url.host == nil {
            guard let baseURLString = KGWebRoute.baseURLString else { return complete(.failure(code: kParamCodeDefaultFail, message: "Invalid url!")) }
            if baseURLString.kg.isFile {
                let filePath = baseURLString.kg.noScheme + urlString
                if FileManager.kg.fileExists(atPath: filePath) == false {
                    return complete(.failure(code: kParamCodeDefaultFail, message: "Can not find filePath!"))
                }
            }
        }
        
        let webVC = KGWebViewController(urlString: urlString)
        webViewController?.navigationController?.pushViewController(webVC, animated: true)
        
        complete(.success(data: nil))
    }
    

}
