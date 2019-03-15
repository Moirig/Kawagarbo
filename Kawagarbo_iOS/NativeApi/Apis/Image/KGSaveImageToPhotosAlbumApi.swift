//
//  KGSaveImageToPhotosAlbumApi.swift
//  Alamofire
//
//  Created by 温一鸿 on 2019/3/14.
//

import UIKit
import SolarNetwork
import MBProgressHUD

class KGSaveImageToPhotosAlbumApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "saveImageToPhotosAlbum" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard KGInfoPlist.photoLibraryAddUsageDescription else {
            KGLog(title: "infoPlist error", "Pleast set UIViewControllerBasedStatusBarAppearance to false in infoPlist;")
            return complete(failure(message: "Pleast add NSPhotoLibraryAddUsageDescription in infoPlist;"))
        }
        
        guard let filePath = parameters?["filePath"] as? String, filePath.count > 0 else { return complete(failure(message: "Invaild filePath!")) }
        
        self.complete = complete

        if filePath.kg.isFile {
            saveImage(filePath: filePath)
        }
        
        else if filePath.kg.isHTTP {
            let request = SLDownloadRequest(URLString: filePath)
            MBProgressHUD.loading()
            KGNetwork.download(request) { (response) in
                MBProgressHUD.hide()
                if let path = response.destinationURL?.absoluteString {
                    self.saveImage(filePath: path)
                }
                else if let error = response.error {
                    complete(failure(message: error.localizedDescription))
                }
            }
        }
        
    }
    
    var complete: ((KGNativeApiResponse) -> Void)!
    
    func saveImage(filePath: String) {
        guard let image = UIImage(contentsOfFile: filePath.kg.noScheme) else { return complete(failure(message: "No file!")) }
        
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if let err = error {
            return complete(failure(message: err.localizedDescription))
        }
        
        complete(success())
    }

}
