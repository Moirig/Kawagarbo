//
//  KGImagePickerController.swift
//  Alamofire
//
//  Created by wyhazq on 2019/3/27.
//

/** add to info.plist
 <key>NSCameraUsageDescription</key>
 <string>Use Camera</string>
 <key>NSMicrophoneUsageDescription</key>
 <string>Use Microphone</string>
 <key>NSPhotoLibraryUsageDescription</key>
 <string>Use PhotoLibrary</string>
 <key>NSPhotoLibraryAddUsageDescription</key>
 <string>Save photo to PhotoLibrary</string>
 */

import UIKit
import MobileCoreServices
import AVFoundation
import Photos

public enum KGImagePickerType: UInt {
    case TakePhoto
    case RecordVideo
    case AlbumList
    case AlbumTimeline
    
    public var sourceType: UIImagePickerController.SourceType {
        
        switch self {
        case .TakePhoto:
            return .camera
            
        case .RecordVideo:
            return .camera
            
        case .AlbumList:
            return .photoLibrary
            
        case .AlbumTimeline:
            return .savedPhotosAlbum
        }
        
    }
}


// MARK: - Life Cycle
public class KGImagePickerController: UIImagePickerController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate {
    
    public typealias KGPhotoPickerCompleteClosure = (Data?, NSError?) -> Void
    
    public typealias KGVideoPickerCompleteClosure = (Data?, UInt, NSError?) -> Void
    
    public convenience init(_ pickerType: KGImagePickerType = .TakePhoto, isSaveToAlbum: Bool = true) {
        self.init()
        if UIImagePickerController.isSourceTypeAvailable(pickerType.sourceType) {
            self.pickerType = pickerType
            self.isSaveToAlbum = isSaveToAlbum
            sourceType = pickerType.sourceType
            delegate = self
            
            switch pickerType {
            case .TakePhoto:
                cameraCaptureMode = .photo
            case .RecordVideo:
                cameraCaptureMode = .video
                mediaTypes = [kUTTypeMovie as String]
            case .AlbumList, .AlbumTimeline:
                break
            }
        }
    }
    
    public func pickerPhotoComplete(_ closure: @escaping KGPhotoPickerCompleteClosure) {
        photoPickerCompleteClosure = closure
    }
    
    public func pickerVideoComplete(_ closure: @escaping KGVideoPickerCompleteClosure) {
        videoPickerCompleteClosure = closure
    }
    
    public func showOnVC(_ vc: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(pickerType.sourceType) {
            
            switch pickerType {
                
            case .TakePhoto:
                canUseCamera {
                    if vc.presentedViewController == nil {
                        vc.present(self, animated: true, completion: nil)
                    }
                }
                
            case .RecordVideo:
                canUseCamera {
                    self.canUseMicrophone {
                        if vc.presentedViewController == nil {
                            vc.present(self, animated: true, completion: nil)
                        }
                    }
                }
                
            case .AlbumList, .AlbumTimeline:
                canUseAlbum {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        if vc.presentedViewController == nil {
                            vc.present(self, animated: true, completion: nil)
                        }
                    })
                }
            }
            
        }
        else {
            if let closure = photoPickerCompleteClosure {
                closure(nil, NSError(code: -1, message: "SourceType Invalid!".kg.localized))
            }
            else if let closure = videoPickerCompleteClosure {
                closure(nil, 0, NSError(code: -1, message: "SourceType Invalid!".kg.localized))
            }
            KGLog("SourceType Invalid!")
            UIAlertView(title: "Camera or Album Invalid!".kg.localized, message: nil, delegate: nil, cancelButtonTitle: "OK".kg.localized).show()
        }
    }
    
    private var pickerType: KGImagePickerType = .TakePhoto
    private var isSaveToAlbum: Bool = true
    private var photoPickerCompleteClosure: KGPhotoPickerCompleteClosure?
    private var videoPickerCompleteClosure: KGVideoPickerCompleteClosure?
    
}

// MARK: - Delegate
extension KGImagePickerController {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        switch pickerType {
        case .RecordVideo:
            
            if let url = info[.mediaURL] as? URL {
                do {
                    let data = try Data(contentsOf: url)
                    let asset = AVURLAsset(url: url)
                    let time = asset.duration
                    let second: UInt = UInt(time.value / Int64(time.timescale))
                    if isSaveToAlbum {
                        UISaveVideoAtPathToSavedPhotosAlbum(url.absoluteString, self, #selector(video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
                    }
                    if let block = videoPickerCompleteClosure {
                        KGLog("""
                            Length:\(data.count)
                            Seconds"\(second)
                            """)
                        block(data, second, nil)
                    }
                }
                catch {
                    if let block = videoPickerCompleteClosure {
                        block(nil, 0, error as NSError)
                    }
                }
            }
            else {
                if let block = videoPickerCompleteClosure {
                    block(nil, 0, NSError(code: -1, message: "No UIImagePickerControllerMediaURL!".kg.localized))
                }
            }
            
        case .TakePhoto, .AlbumList, .AlbumTimeline:
            
            var selectedImage: UIImage?
            if allowsEditing {
                if let image = info[.editedImage] as? UIImage {
                    selectedImage = image
                }
            }
            else {
                if let image = info[.originalImage] as? UIImage {
                    selectedImage = image
                }
            }
            if let image = selectedImage {
                let data = image.pngData()
                if pickerType == .TakePhoto, isSaveToAlbum {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                }
                if let block = photoPickerCompleteClosure {
                    block(data, nil)
                }
            }
            else {
                if let block = photoPickerCompleteClosure {
                    block(nil, NSError(code: -1, message: "No Image!".kg.localized))
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc private func video(videoPath: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        if let error = error {
            KGLog("""
                videoPath:\(videoPath)
                error:\(error)
                """)
        }
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        if let error = error {
            KGLog("""
                image:\(image)
                error:\(error)
                """)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if let block = photoPickerCompleteClosure {
            block(nil, NSError(code: -1, message: "Cancel".kg.localized))
        }
        if let block = videoPickerCompleteClosure {
            block(nil, 0, NSError(code: -1, message: "Cancel".kg.localized))
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Authorization
extension KGImagePickerController {
    
    private func canUseCamera(_ block: @escaping () -> Void) {
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .denied, .notDetermined, .restricted:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    if granted {
                        block()
                    }
                    else {
                        self.showAuthorizationFailTips("Camera".kg.localized)
                    }
                }
            })
            
        case .authorized:
            block()
            
        }
        
    }
    
    private func canUseAlbum(_ block: @escaping () -> Void) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .denied, .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    if status == .authorized {
                        block()
                    }
                    else {
                        self.showAuthorizationFailTips("Album".kg.localized)
                    }
                }
            })
            
        case .authorized:
            block()
            
        }
        
    }
    
    private func canUseMicrophone(_ block: @escaping () -> Void) {
        
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch status {
        case .denied, .notDetermined, .restricted:
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    if granted {
                        block()
                    }
                    else {
                        self.showAuthorizationFailTips("Microphone".kg.localized)
                    }
                }
            })
            
        case .authorized:
            block()
        }
        
    }
    
    private func showAuthorizationFailTips(_ function: String) {
        let title = function + "Disabled".kg.localized
        let message = "Please go to Settings - Privacy - ".kg.localized  + function + " to allow ".kg.localized + appName + " use ".kg.localized + function
        UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Cancel".kg.localized, otherButtonTitles: "Go to setting".kg.localized).show()
    }
    
    private var appName: String {
        guard let name: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String else {
            return "App".kg.localized
        }
        return name.kg.localized
    }
    
    public func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == alertView.cancelButtonIndex { return }
        
        UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
    }
    
}
