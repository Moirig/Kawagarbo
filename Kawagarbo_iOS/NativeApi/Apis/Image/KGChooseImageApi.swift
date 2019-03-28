//
//  KGChooseImageApi.swift
//  Alamofire
//
//  Created by wyhazq on 2019/3/14.
//

import UIKit
import ZYImagePickerAndBrower

class KGChooseImageApi: KGNativeApi, KGNativeApiDelegate, ZYPhotoAlbumProtocol {
    
    var path: String { return "chooseImage" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        let count = parameters?["count"] as? Int ?? 9
        let sizeType = parameters?["sizeType"] as? [String] ?? ["origin", "compressed"]
        let sourceType = parameters?["sourceType"] as? [String] ?? ["album", "camera"]
        
        if sizeType.count == 1, sizeType.contains("origin") {
            isCompress = false
        }
        self.complete = complete
        
        if sourceType.contains("album"), sourceType.contains("camera") {
            showActionSheet(count: count)
            return
        }
        
        if sourceType.contains("album") {
            selectPhoto(count: count)
            return
        }
        
        if sourceType.contains("camera") {
            takePhoto()
            return
        }
        
    }
    
    var complete: ((KGNativeApiResponse) -> Void)?

    var isCompress: Bool = true
    
    var imageTempCachePath: String {
//        var toPath = KawagarboCachePath + "/6c54e788077a596b004344f048f2dbb4"
//        toPath = toPath + "/" + KawagarboTempCachePathName
//        FileManager.kg.createDirectory(toPath)
//        return toPath
        let path: String
        if let rootPath = webViewController?.webRoute?.webApp?.rootPath {
            path = rootPath + "/" + KawagarboTempCachePathName
        }
        else {
            path = KawagarboTempCachePath
        }
        FileManager.kg.createDirectory(path)
        return path
    }
    
    func showActionSheet(count: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Take Photo".kg.localized, style: .default) { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.takePhoto()
        }
        let selectPhotoAction = UIAlertAction(title: "Select Photo".kg.localized, style: .default) { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.selectPhoto(count: count)
        }
        let cancelAction = UIAlertAction(title: "Cancel".kg.localized, style: .cancel, handler: nil)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(selectPhotoAction)
        actionSheet.addAction(cancelAction)
        webViewController?.present(actionSheet, animated: true, completion: nil)
    }
    
    func selectPhoto(count: Int) {
        guard KGInfoPlist.photoLibraryUsageDescription else {
            KGLog(title: "InfoPlist error", "Pleast add NSPhotoLibraryUsageDescription in infoPlist;")
            if let acomplete = complete {
                acomplete(failure(message: "Pleast add NSPhotoLibraryUsageDescription in infoPlist;"))
            }
            return
        }
        
        let photoAlbumVC = ZYPhotoNavigationViewController(photoAlbumDelegate: self, photoAlbumType: .selectPhoto)    //初始化需要设置代理对象
        photoAlbumVC.maxSelectCount = count   //最大可选择张数
        webViewController?.present(photoAlbumVC, animated: true, completion: nil)
    }
    
    func takePhoto() {
        guard KGInfoPlist.cameraUsageDescription else {
            KGLog(title: "InfoPlist error", "Pleast add NSCameraUsageDescription in infoPlist;")
            if let acomplete = complete {
                acomplete(failure(message: "Pleast add NSCameraUsageDescription in infoPlist;"))
            }
            return
        }
        guard KGInfoPlist.photoLibraryAddUsageDescription else {
            KGLog(title: "InfoPlist error", "Pleast add NSPhotoLibraryAddUsageDescription in infoPlist;")
            if let acomplete = complete {
                acomplete(failure(message: "Pleast add NSPhotoLibraryAddUsageDescription in infoPlist;"))
            }
            return
        }
        
        let imagePicker = KGImagePickerController(.TakePhoto, isSaveToAlbum: true)
        imagePicker.pickerPhotoComplete {[weak self] (data, error) in
            guard let strongSelf = self else { return }
            if let err = error {
                if let acomplete = strongSelf.complete {
                    acomplete(failure(message: err.localizedDescription))
                }
            }
            else if let adata = data, let image = UIImage(data: adata) {
                let (tempFilePath, tempFile, error) = strongSelf.compressAndSave(image: image, index: 0)
                if let acomplete = strongSelf.complete {
                    if let err = error {
                        acomplete(failure(message: err.localizedDescription))
                    }
                    else if let atempFilePath = tempFilePath, let atempFile = tempFile {
                        acomplete(success(data: ["tempFilePaths": [atempFilePath], "tempFiles": [atempFile]]))
                    }
                }
            }
        }
        if let vc = webViewController {
            imagePicker.showOnVC(vc)
        }
    }
    
    func photoAlbum(selectPhotos: [ZYPhotoModel]) {
        var tempFilePaths: [String] = []
        var tempFiles: [[String: Any]] = []
        for (idx, model) in selectPhotos.enumerated() {
            let (tempFilePath, tempFile, error) = compressAndSave(image: model.originImage!, index: idx)
                if let err = error {
                    if let acomplete = complete {
                        acomplete(failure(message: err.localizedDescription))
                        complete = nil
                    }
                    return
                }
                else if let atempFilePath = tempFilePath, let atempFile = tempFile {
                    tempFilePaths.append(atempFilePath)
                    tempFiles.append(atempFile)
                }
        }
        if let acomplete = complete {
            acomplete(success(data: ["tempFilePaths": tempFilePaths, "tempFiles": tempFiles]))
        }
    }
    
    func compressAndSave(image: UIImage, index: Int) -> (String?, [String: Any]?, NSError?) {
        let data: Data
        
        if isCompress {
            data = image.kg.compress()
        }
        else {
            data = image.jpegData(compressionQuality: 0.8)!
        }
        
        let imagePath = "file://" + imageTempCachePath + "/" + "\(Date().timeIntervalSince1970)_\(index)"
        do {
            if let url = URL(string: imagePath) {
                try data.write(to: url)
            }
        } catch {
            let err = error as NSError
            return (nil, nil, err)
        }
        
//        if let acomplete = complete {
//            acomplete(success(data: ["tempFilePaths": tempFilePaths, "tempFiles": tempFiles]))
//        }
        return (imagePath, ["path": imagePath, "size": data.count], nil)
    }
    
}
