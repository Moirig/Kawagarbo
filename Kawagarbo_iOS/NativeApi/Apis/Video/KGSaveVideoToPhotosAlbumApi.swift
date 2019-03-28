//
//  KGSaveVideoToPhotosAlbumApi.swift
//  Alamofire
//
//  Created by wyhazq on 2019/3/28.
//

import UIKit
import SolarNetwork
import MBProgressHUD

class KGSaveVideoToPhotosAlbumApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "saveVideoToPhotosAlbum" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard KGInfoPlist.photoLibraryAddUsageDescription else {
            KGLog(title: "InfoPlist error", "Pleast add NSPhotoLibraryAddUsageDescription in infoPlist;")
            return complete(failure(message: "Pleast add NSPhotoLibraryAddUsageDescription in infoPlist;"))
        }
        
        guard let filePath = parameters?["filePath"] as? String, filePath.count > 0 else { return complete(failure(message: "Invaild filePath!")) }
        
        self.complete = complete
        
        if filePath.kg.isFile {
            saveVideo(urlStr: filePath)
        }
            
        else if filePath.kg.isHTTP {
            let request = SLDownloadRequest(URLString: filePath)
            MBProgressHUD.loading()
            KGNetwork.download(request) { (response) in
                MBProgressHUD.hide()
                if let error = response.error {
                    return complete(failure(message: error.localizedDescription))
                }
                guard let destinationURL = response.destinationURL, let suggestedFilename = response.httpURLResponse?.suggestedFilename else {
                    return complete(failure(message: "No file!"))
                }
                let atPath = destinationURL.absoluteString.kg.noScheme
                let toPath = atPath.replacingOccurrences(of: destinationURL.lastPathComponent, with: suggestedFilename)
                FileManager.kg.moveItem(atPath: atPath, toPath: toPath)
                self.saveVideo(urlStr: toPath)
            }
        }
        
    }
    
    var complete: ((KGNativeApiResponse) -> Void)?
    
    func saveVideo(urlStr: String) {
        UISaveVideoAtPathToSavedPhotosAlbum(urlStr.kg.noScheme, self, #selector(saveVideo(videoPath:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func saveVideo(videoPath: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
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
