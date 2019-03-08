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
        
        if let requestID = parameters?["requestID"] as? String, let method = parameters?["method"] as? String {
            
            if method == "abort" {
                let request = requestDict[requestID]
                request?.cancel()
                if requestDict.keys.contains(requestID) {
                    requestDict.removeValue(forKey: requestID)
                }
                return
            }
            
            if method == "onHeadersReceived" {
                let request = requestDict[requestID]
                let headerRequest = SLRequest(method: .head, URLString: request?.URLString, parameters: request?.parameters, parameterEncoding: (request?.parameterEncoding)!, headers: request?.headers)
                KGNetwork.request(headerRequest) { (response) in
                    let statusCode = response.httpURLResponse?.statusCode ?? 404
                    let header = response.httpURLResponse?.allHeaderFields as? [String: String] ?? [:]
                    let dataDict: [String : Any] = ["header": header]
                    if statusCode == 200 {
                        complete(success(data: dataDict))
                    }
                    else {
                        let message = response.error?.localizedDescription
                        complete(failure(message: message, data: dataDict))
                    }
                }
                return
            }
            
        }
        
        
        guard let url = parameters?["url"] as? String, url.count > 0 else { return complete(failure(message: "Invalid url!")) }
        
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
        
        KGNetwork.request(request) { [weak self] (response) in
            guard let strongSelf = self else { return }
            let statusCode = response.httpURLResponse?.statusCode ?? 404
            let data = response.data ?? [:]
            let header = response.httpURLResponse?.allHeaderFields ?? [:]
            let dataDict: [String : Any] = ["statusCode": statusCode,
                                            "header": header,
                                            "data": data]
            if statusCode == 200 {
                complete(success(data: dataDict))
            }
            else {
                let message = response.error?.localizedDescription
                complete(failure(message: message, data: dataDict))
            }
            
            if strongSelf.requestDict.keys.contains(request.requestID) {
                strongSelf.requestDict.removeValue(forKey: request.requestID)
            }
        }
        
        requestDict[request.requestID] = request
    }
    
    var requestDict: [String: SLRequest] = [:]
    
}
