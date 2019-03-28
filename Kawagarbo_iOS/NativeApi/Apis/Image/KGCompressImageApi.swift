//
//  KGCompressImageApi.swift
//  Alamofire
//
//  Created by wyhazq on 2019/3/14.
//

import UIKit
import SolarNetwork
import MBProgressHUD

class KGCompressImageApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "compressImage" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let src = parameters?["src"] as? String, src.count > 0 else { return complete(failure(message: "Invaild src!")) }
        
        let quality = parameters?["quality"] as? Int ?? 80
        let compressQuality = CGFloat(quality) / 100.0
        
        guard let image = self.getImage(src: src) else { return complete(failure(message: "No file!")) }
        
        if src.kg.isFile {
            compress(image: image, src: src, quality: compressQuality, complete: complete)
        }
        else if src.kg.isHTTP {
            let request = SLDownloadRequest(URLString: src)
            if let rootPath = webViewController?.webRoute?.webApp?.rootPath {
                let path = rootPath + "/" + KawagarboTempCachePathName + "/" + request.requestID
                request.destinationURL = URL(fileURLWithPath: path)
            }
            else {
                request.destinationURL = URL(fileURLWithPath: KawagarboTempCachePath)
            }
            MBProgressHUD.loading()
            KGNetwork.download(request) { (response) in
                MBProgressHUD.hide()
                if let src = response.destinationURL?.absoluteString {
                    guard let image = self.getImage(src: src) else { return complete(failure(message: "No file!")) }
                    self.compress(image: image, src: src, quality: compressQuality, complete: complete)
                }
                else if let error = response.error {
                    complete(failure(message: error.localizedDescription))
                }
            }
        }
        
    }
    
    func getImage(src: String) -> UIImage? {
        guard let image = UIImage(contentsOfFile: src.kg.noScheme) else {
            return nil
        }
        #if DEBUG
        do {
            let data = try Data(contentsOf: URL(string: src)!)
            KGLog(title: "KGCompress", "Before:\(data.count)")
        } catch {}
        
        #endif
        return image
    }
    
    func compress(image:UIImage, src: String, quality: CGFloat, complete: @escaping (KGNativeApiResponse) -> Void) {
        let data = image.kg.compress(quality: quality)
        FileManager.kg.removeItem(atPath: src.kg.noScheme)
        do {
            if let url = URL(string: src) {
                try data.write(to: url)
            }
        } catch {
            let err = error as NSError
            return complete(failure(message: err.localizedDescription))
        }
        KGLog(title: "KGCompress", "After:\(data.count)")
        complete(success(data: ["tempFilePath": src]))
    }
    
}
