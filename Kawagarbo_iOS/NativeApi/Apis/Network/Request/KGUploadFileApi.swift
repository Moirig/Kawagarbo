//
//  KGUploadFileApi.swift
//  Alamofire
//
//  Created by 温一鸿 on 2019/3/5.
//

import UIKit
import SolarNetwork

class KGUploadFileApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "uploadFile" }
    
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
            
            if method == "onProgressUpdate", let handlerName = parameters?["handlerName"] as? String {
                progressDict[requestID] = handlerName
                return;
            }
            
            if method == "offProgressUpdate" {
                if progressDict.keys.contains(requestID) {
                    progressDict.removeValue(forKey: requestID)
                }
                
                return complete(success());
            }
            
        }
        
        guard let url = parameters?["url"] as? String, url.count > 0 else { return complete(failure(message: "Invalid url!")) }
        
        guard let filePath = parameters?["filePath"] as? String, filePath.count > 0 else { return complete(failure(message: "Invalid filePath!")) }

        guard let fileURL = URL(string: filePath) else { return complete(failure(message: "Invalid filePath!")) }
        
        guard let name = parameters?["name"] as? String, name.count > 0 else { return complete(failure(message: "Invalid name!")) }
        
        let header = parameters?["header"] as? [String: String]

        let formData = parameters?["formData"] as? [String: Any]
        
        let request = SLUploadRequest(URLString: url, headers: header)
        
        request.multipartFormDataClosure { (multipartFormData) in
            multipartFormData.append(fileURL, withName: name)
            
            if let aformData = formData {
                for (key, obj) in aformData {
                    if let data = self.getData(with: obj) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            }
        }
        
        KGNetwork.upload(request, progressClosure: { [weak self] (progress) in
            guard let strongSelf = self else { return }
            
            if let handlerName = strongSelf.progressDict[request.requestID] {
                let parameters: [String: Any] = [
                    "progress": progress.currentProgress,
                    "totalBytesWritten": progress.originalProgress?.completedUnitCount ?? 0,
                    "totalBytesExpectedToWrite": progress.originalProgress?.totalUnitCount ?? 0
                ]
                strongSelf.webViewController?.nativeApiManager?.callJS(function: handlerName, parameters: parameters)
            }
            
        }) { [weak self] (response) in
            guard let strongSelf = self else { return }

            let statusCode = response.httpURLResponse?.statusCode ?? 404
            let data = response.data ?? ""
            let dataDict: [String : Any] = ["statusCode": statusCode,
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
            
            if strongSelf.progressDict.keys.contains(request.requestID) {
                strongSelf.progressDict.removeValue(forKey: request.requestID)
            }
        }
    }
    
    func getData(with obj: Any) -> Data? {
        var jsonData: Data?
        do {
            if let _ = obj as? [String: Any], let _ = obj as? [Any] {
                jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
            }
            else {
                let str = "\(obj)"
                jsonData = str.kg.data
            }
        } catch {
            
        }
        return jsonData
    }
    
    var requestDict: [String: SLRequest] = [:]
    
    var progressDict: [String: String] = [:]
}
