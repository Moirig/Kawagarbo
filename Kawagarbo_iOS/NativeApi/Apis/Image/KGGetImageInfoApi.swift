//
//  KGGetImageInfoApi.swift
//  Alamofire
//
//  Created by wyhazq on 2019/3/14.
//

import UIKit
import SolarNetwork
import MBProgressHUD

class KGGetImageInfoApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "getImageInfo" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let src = parameters?["src"] as? String, src.count > 0 else { return complete(failure(message: "Invaild src!")) }
        
        if src.kg.isFile {
            getImageInfo(urlStr: src, complete: complete)
        }
        else if src.kg.isHTTP {
            let request = SLDownloadRequest(URLString: src)
            if let rootPath = webViewController?.webRoute?.webApp?.rootPath {
                let path = rootPath + "/kgtempfiles/" + request.requestID
                request.destinationURL = URL(fileURLWithPath: path)
            }
            MBProgressHUD.loading()
            KGNetwork.download(request) { (response) in
                MBProgressHUD.hide()
                if let urlStr = response.destinationURL?.absoluteString {
                    self.getImageInfo(urlStr: urlStr, complete: complete)
                }
                else if let error = response.error {
                    complete(failure(message: error.localizedDescription))
                }
            }
        }
        
    }

    func getImageInfo(urlStr:String, complete: @escaping (KGNativeApiResponse) -> Void) {
        guard let image = UIImage(contentsOfFile: urlStr.kg.noScheme) else { return complete(failure(message: "No file!")) }
        
        let width = image.size.width
        let height = image.size.height
        var orientation: String
        switch image.imageOrientation {
            
        case .up:
            orientation = "up"
            
        case .down:
            orientation = "down"

        case .left:
            orientation = "left"

        case .right:
            orientation = "right"

        case .upMirrored:
            orientation = "up-mirrored"

        case .downMirrored:
            orientation = "down-mirrored"

        case .leftMirrored:
            orientation = "left-mirrored"

        case .rightMirrored:
            orientation = "right-mirrored"

        }
        var type: String = ""
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: urlStr))
            type = data.kg.imageExtension
        } catch {}
        
        let dataDict: [String : Any] = ["width": width,
                                        "height": height,
                                        "path": urlStr,
                                        "orientation": orientation,
                                        "type": type]
        complete(success(data: dataDict))
        
    }
    
}
