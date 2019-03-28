//
//  KGSaveImageToPhotosAlbumApi.swift
//  Alamofire
//
//  Created by wyhazq on 2019/3/14.
//

import UIKit
import SolarNetwork
import MBProgressHUD

class KGSaveImageToPhotosAlbumApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "saveImageToPhotosAlbum" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard KGInfoPlist.photoLibraryAddUsageDescription else {
            KGLog(title: "InfoPlist error", "Pleast add NSPhotoLibraryAddUsageDescription in infoPlist;")
            return complete(failure(message: "Pleast add NSPhotoLibraryAddUsageDescription in infoPlist;"))
        }
        
        guard let filePath = parameters?["filePath"] as? String, filePath.count > 0 else { return complete(failure(message: "Invaild filePath!")) }
        
        self.complete = complete

        if filePath.kg.isFile {
            saveImage(urlStr: filePath)
        }
        
        else if filePath.kg.isHTTP {
            let request = SLDownloadRequest(URLString: filePath)
            MBProgressHUD.loading()
            KGNetwork.download(request) { (response) in
                MBProgressHUD.hide()
                if let urlStr = response.destinationURL?.absoluteString {
                    self.saveImage(urlStr: urlStr)
                }
                else if let error = response.error {
                    complete(failure(message: error.localizedDescription))
                }
            }
        }
        
    }
    
    var complete: ((KGNativeApiResponse) -> Void)?
    
    func saveImage(urlStr: String) {
        guard let image = UIImage(contentsOfFile: urlStr.kg.noScheme) else {
            if let acomplete = complete {
                acomplete(failure(message: "No file!"))
            }
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if let err = error {
            if let acomplete = complete {
                acomplete(failure(message: err.localizedDescription))
            }
            return
        }
        
        if let acomplete = complete {
            acomplete(success())
        }
    }

}
