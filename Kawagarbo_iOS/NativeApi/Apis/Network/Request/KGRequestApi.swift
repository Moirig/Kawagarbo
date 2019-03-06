//
//  KGRequestApi.swift
//  Alamofire
//
//  Created by 温一鸿 on 2019/3/5.
//

import UIKit
import SolarNetwork

class KGRequestApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "request" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let url = parameters?["url"] as? String else { return complete(failure(message: "Invalid url!")) }
        
        let data = parameters?["data"]
        
        var params: Parameters? = nil
        if let dataString = data as? String {
            params = ["anyKey": dataString]
        }
        else if let dataDict = data as? Parameters {
            params = dataDict
        }
        
        let header = parameters?["header"] as? [String: String]
        
        var encoding: ParameterEncoding = JSONEncoding.default
        if let contentType = header?["content-type"], contentType != "application/json" {
            encoding = URLEncoding.default
        }
        
        let methodString = parameters?["method"] as? String ?? "GET"
        let method: HTTPMethod = HTTPMethod(rawValue: methodString) ?? .get
        //TODO-fix
        let _ = parameters?["dataType"] as? String ?? "json"
        let _ = parameters?["responseType"] as? String ?? "text"
        
        let request = SLRequest(method: method, URLString: url, parameters: params, parameterEncoding: encoding, headers: header)
        
        KGNetwork.request(request) { (response) in
            let statusCode = response.httpURLResponse?.statusCode ?? 404
            if statusCode == 200 {
                
            }
            else {
//                let message = response.error?.localizedDescription ?? ""
//                complete(.failure(code: <#T##Int#>, message: <#T##String?#>))
            }
//            let dataDict
        }

        
        
    }
    
//    func perform1(with parameters: [String : Any]?, complete: @escaping (Int, String?, [String : Any]?) -> Void) {
//        
//    }
    
    
}
