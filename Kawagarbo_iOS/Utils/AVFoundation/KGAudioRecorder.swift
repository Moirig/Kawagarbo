//
//  KGAudioRecorder.swift
//  Alamofire
//
//  Created by wyhazq on 2019/4/5.
//

import UIKit
import AVFoundation

class KGAudioRecorder: NSObject, UIAlertViewDelegate {
    
    typealias KGAudioRecorderClosure = () -> Void
    typealias KGAudioRecorderCompleteClosure = (String) -> Void
    typealias KGAudioRecorderFailClosure = (NSError) -> Void
    
    private var audioRecorder: AVAudioRecorder?
    private let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    private var complete: KGAudioRecorderCompleteClosure?
    private var fail: KGAudioRecorderFailClosure?

    var path: String = ""
    var pathExtension: String = ""
    var settings: [String: Any] = [:]
    var duration: TimeInterval = 600
    
    private lazy var url: URL = {
        let apath = path.count > 0 ? path : KawagarboTempCachePath
        FileManager.kg.createDirectory(apath)
        return URL(fileURLWithPath: apath + "/audio-\(Date().timeIntervalSince1970).\(pathExtension)")
    }()
    
    func start(callback: KGAudioRecorderClosure? = nil) {
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
        } catch {
            
        }
        guard let recorder = audioRecorder else { return }
        if recorder.isRecording {
            stopRecord()
            recorder.deleteRecording()
        }
        do {
            try audioSession.setActive(true)
            if #available(iOS 10.0, *) {
                try audioSession.setCategory(.playAndRecord, mode: .default)
            } else {}
            
            recorder.delegate = self
            recorder.prepareToRecord()
            recorder.record(forDuration: duration)
        } catch {
            
        }
        if let acallback = callback { acallback() }
    }
    
    func stop(callback: KGAudioRecorderCompleteClosure? = nil) {
        complete = callback
        stopRecord()
    }
    
    func pause(callback: KGAudioRecorderClosure? = nil) {
        guard let recorder = audioRecorder, recorder.isRecording else { return }
        recorder.pause()
        if let acallback = callback { acallback() }
    }
    
    func resume(callback: KGAudioRecorderClosure? = nil) {
        guard let recorder = audioRecorder, recorder.isRecording == false else { return }
        recorder.record()
        if let acallback = callback { acallback() }
    }
    
    func onError(callback: @escaping KGAudioRecorderFailClosure) {
        fail = callback
    }
    
    private func stopRecord() {
        guard let recorder = audioRecorder, recorder.isRecording else { return }
        recorder.stop()
        
        do {
            try audioSession.setActive(false)
        } catch {
            
        }
    }
    
}

extension KGAudioRecorder: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag, let callback = complete {
            callback(recorder.url.absoluteString)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let err = error, let callback = fail {
            callback(err as NSError)
        }
    }
    
}

extension KGAudioRecorder {
    
    func getPermission(_ callback: @escaping (NSError?) -> Void) {
        audioSession.requestRecordPermission { (grant) in
            if grant {
                callback(nil)
                return
            }
            self.showAuthorizationFailTips("Microphone".kg.localized)
            callback(NSError(code: -1, message: "Microphone Permission Denied."))
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
