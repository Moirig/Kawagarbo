//
//  KGDownloadFileApi.swift
//  Alamofire
//
//  Created by wyhazq on 2019/3/5.
//

import UIKit
import SolarNetwork

class KGDownloadFileApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "downloadFile" }
    
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
        
        let header = parameters?["header"] as? [String: String]

        let request = SLDownloadRequest(URLString: url, headers: header)
        
        if let filePath = parameters?["filePath"] as? String {
            request.destinationURL = URL(string: filePath)
        }
        else {
            if let rootPath = webViewController?.webRoute?.webApp?.rootPath {
                let path = rootPath + "/kgtempfiles/" + request.requestID
                request.destinationURL = URL(fileURLWithPath: path)
            }
        }
        
        KGNetwork.download(request, progressClosure: { [weak self] (progress) in
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
            let tempFilePath = response.destinationURL?.absoluteString ?? ""
            var dataDict: [String : Any] = ["statusCode": statusCode]
            if statusCode == 200 {
                dataDict["tempFilePath"] = tempFilePath
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
    
    var requestDict: [String: SLRequest] = [:]
    
    var progressDict: [String: String] = [:]
    
}
