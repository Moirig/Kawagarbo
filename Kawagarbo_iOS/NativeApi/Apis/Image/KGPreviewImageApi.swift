//
//  KGPreviewImageApi.swift
//  Alamofire
//
//  Created by wyhazq on 2019/3/14.
//

import UIKit
import JXPhotoBrowser

class KGPreviewImageApi: KGNativeApi, KGNativeApiDelegate, PhotoBrowserDelegate {
    
    var path: String { return "previewImage" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let urls = parameters?["urls"] as? [String], urls.count > 0 else { return complete(failure(message: "Invalid urls!")) }
        self.urls = urls
        
        let currentUrl = parameters?["current"] as? String ?? urls.first!
        let current = urls.firstIndex(of: currentUrl) ?? 0
        
        let browser = PhotoBrowser(animationType: .fade, delegate: self, originPageIndex: current)
        browser.plugins.append(NumberPageControlPlugin())
        
        browser.show()

        complete(success())
    }
    
    
    var urls: [String] = []
    
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return urls.count
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        return nil
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlForIndex index: Int) -> URL? {
        return URL(string: urls[index])
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, didLongPressForIndex index: Int, image: UIImage) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveImageAction = UIAlertAction(title: "Save Image".kg.localized, style: .default) { [weak self] (_) in
            guard let strongSelf = self else { return }
            guard KGInfoPlist.photoLibraryAddUsageDescription else {
                KGLog(title: "InfoPlist error", "Pleast add NSPhotoLibraryAddUsageDescription in infoPlist;")
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(strongSelf.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel".kg.localized, style: .cancel, handler: nil)
        actionSheet.addAction(saveImageAction)
        actionSheet.addAction(cancelAction)
        photoBrowser.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if let err = error {
            KGLog(err)
        }
    }
}
