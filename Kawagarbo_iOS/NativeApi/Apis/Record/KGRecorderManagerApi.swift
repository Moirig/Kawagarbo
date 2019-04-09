//
//  KGRecorderManagerApi.swift
//  Alamofire
//
//  Created by wyhazq on 2019/4/5.
//

import UIKit
import AVFoundation

class KGRecorderManagerApi: KGNativeApi, KGNativeApiDelegate {
    
    var path: String { return "RecorderManager" }
    
    func perform(with parameters: [String : Any]?, complete: @escaping (KGNativeApiResponse) -> Void) {
        
        guard let method = parameters?["method"] as? String, method.count > 0 else { return complete(failure(message: "Invalid method")) }
        
        switch method {
            
        case "start":
            audioRecorder.getPermission { [weak self] (error) in
                guard let strongSelf = self else { return }
                if let err = error {
                    return complete(failure(message: err.localizedDescription))
                }
                strongSelf.startRecord(parameters)
                complete(success())
            }
            
        case "stop":
            audioRecorder.stop { (tempFilePath) in
                complete(success(data: ["tempFilePath": tempFilePath]))
            }

        case "pause":
            audioRecorder.pause()
            complete(success())

        case "resume":
            audioRecorder.resume()
            complete(success())

        case "onError":
            audioRecorder.onError { (error) in
                complete(failure(message: error.localizedDescription))
            }
        
        default:
            break
        }
        
    }
    
    let audioRecorder = KGAudioRecorder()
    
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
    
    func startRecord(_ parameters: [String : Any]?) {
        
        let duration = parameters?["duration"] as? TimeInterval ?? 600000
        let sampleRate = parameters?["sampleRate"] as? UInt ?? 8000
        let numberOfChannels = parameters?["numberOfChannels"] as? UInt ?? 2
        let encodeBitRate = parameters?["encodeBitRate"] as? UInt ?? 48000
        let format = parameters?["format"] as? String ?? "aac"
//        let frameSize = parameters?["frameSize"] as? UInt
//        let audioSource = parameters?["audioSource"] as? String ?? "auto"
        
        let settings: [String: Any] = [AVSampleRateKey: sampleRate,
                                       AVNumberOfChannelsKey: numberOfChannels,
                                       AVEncoderBitRateKey: encodeBitRate,
                                       AVFormatIDKey: format == "mp3" ? kAudioFormatMPEGLayer3 : kAudioFormatMPEG4AAC,
                                       ]
        
        audioRecorder.path = tempCachePath
        audioRecorder.pathExtension = format
        audioRecorder.settings = settings
        audioRecorder.duration = duration / 1000
        
        audioRecorder.start()
    }

}
