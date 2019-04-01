//
//  KGChooseVideoApi.swift
//  Alamofire
//
//  Created by wyhazq on 2019/3/28.
//

import UIKit
import TZImagePickerController

class KGChooseVideoApi: KGNativeApi, KGNativeApiDelegate, TZImagePickerControllerDelegate {
    
    var path: String { return "chooseVideo" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        let sourceType = parameters?["sourceType"] as? [String] ?? ["album", "camera"]
        isCompress = parameters?["compressed"] as? Bool ?? true
        let maxDuration = parameters?["maxDuration"] as? Int ?? 60
        let camera = parameters?["camera"] as? String ?? "back"
        
        self.complete = complete
        
        if sourceType.contains("album"), sourceType.contains("camera") {
            showActionSheet(maxDuration: maxDuration, camera: camera)
            return
        }
        
        if sourceType.contains("album") {
            selectPhoto()
            return
        }
        
        if sourceType.contains("camera") {
            recordVideo(maxDuration: maxDuration, camera: camera)
            return
        }
        
    }
    
    var complete: ((KGNativeApiResponse) -> Void)?
    
    var isCompress: Bool = true
    
    var tempCachePath: String {
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
    
    func showActionSheet(maxDuration: Int, camera: String) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Record Video".kg.localized, style: .default) { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.recordVideo(maxDuration: maxDuration, camera: camera)
        }
        let selectPhotoAction = UIAlertAction(title: "Select Video".kg.localized, style: .default) { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.selectPhoto()
        }
        let cancelAction = UIAlertAction(title: "Cancel".kg.localized, style: .cancel, handler: nil)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(selectPhotoAction)
        actionSheet.addAction(cancelAction)
        webViewController?.present(actionSheet, animated: true, completion: nil)
    }
    
    func selectPhoto() {
        guard KGInfoPlist.photoLibraryUsageDescription else {
            KGLog(title: "InfoPlist error", "Pleast add NSPhotoLibraryUsageDescription in infoPlist;")
            if let acomplete = complete {
                acomplete(failure(message: "Pleast add NSPhotoLibraryUsageDescription in infoPlist;"))
            }
            return
        }
        
        let imagePicker = TZImagePickerController(maxImagesCount: 1, delegate: self)
        imagePicker!.allowPickingImage = false
        webViewController?.present(imagePicker!, animated: true, completion: nil)
    }
    
    func recordVideo(maxDuration: Int, camera: String) {
        guard KGInfoPlist.cameraUsageDescription else {
            KGLog(title: "InfoPlist error", "Pleast add NSCameraUsageDescription in infoPlist;")
            if let acomplete = complete {
                acomplete(failure(message: "Pleast add NSCameraUsageDescription in infoPlist;"))
            }
            return
        }
        
        guard KGInfoPlist.microphoneUsageDescription else {
            KGLog(title: "InfoPlist error", "Pleast add NSMicrophoneUsageDescription in infoPlist;")
            if let acomplete = complete {
                acomplete(failure(message: "Pleast add NSMicrophoneUsageDescription in infoPlist;"))
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
        
        let imagePicker = KGImagePickerController(.RecordVideo, isSaveToAlbum: true)
        imagePicker.videoQuality = .typeIFrame960x540
        imagePicker.pickerVideoComplete {[weak self] (asset, error) in
            guard let strongSelf = self else { return }
            if let err = error {
                if let acomplete = strongSelf.complete {
                    acomplete(failure(message: err.localizedDescription))
                }
            }
            else if let aasset = asset {
                strongSelf.compressAndCallback(asset: aasset)
            }
        }
        if let vc = webViewController {
            imagePicker.showOnVC(vc)
        }
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: PHAsset!) {
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { (avAsset, audioMix, info) in
            if let aasset = avAsset as? AVURLAsset {
                self.compressAndCallback(asset: aasset)
            }
        }
    }
    
    func compressAndCallback(asset: AVURLAsset) {
        let atPath = asset.url.relativePath
        let toPath = tempCachePath + "/" + asset.url.lastPathComponent
        
        guard FileManager.kg.copyItem(atPath: atPath, toPath: toPath) else {
            if let acomplete = complete {
                acomplete(failure(message: "Move file to temp path fail."))
            }
            return
        }

        let duration = asset.kg.duration
        let size = asset.kg.fileSize
        let width = asset.kg.size.width
        let height = asset.kg.size.height
        
        if let acomplete = complete {
            acomplete(
                success(data: ["tempFilePath": toPath,
                               "duration": duration,
                               "size": size,
                               "width": width,
                               "height": height])
            )
        }
    }
    
}
