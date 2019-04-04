//
//  KGAssetExportSession.swift
//  Alamofire
//
//  Created by 温一鸿 on 2019/4/1.
//

import UIKit
import AVFoundation

class KGAssetExportSession: NSObject {
    
    var outputCachePath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true).first ?? ""
    
    var outputFileType: AVFileType = .mp4
    
    var videoSettings: [String: Any] = [:]
    var audioSettings: [String: Any] = [:]
    
    private var inputAsset: AVURLAsset!
    private var assetReader: AVAssetReader!
    private var assetWriter: AVAssetWriter!
    
    private var videoOutput: AVAssetReaderVideoCompositionOutput!
    private var audioOutput: AVAssetReaderAudioMixOutput!
    
    private var videoInput: AVAssetWriterInput!
    private var audioInput: AVAssetWriterInput!
    
    private let videoInputQueue = DispatchQueue(label: "com.KGAssetExportSession.videoInputQueue")
    private let audioInputQueue = DispatchQueue(label: "com.KGAssetExportSession.audioInputQueue")

    private var completeClosure: ((AVAssetExportSession.Status, AVURLAsset?, NSError?) -> Void)?
    
    private var outputItemPath: String {
        return outputCachePath + "/" + inputAsset.url.lastPathComponent
    }

    convenience init(asset: AVURLAsset) {
        self.init()
        
        inputAsset = asset
        setup()
    }
    
    func setup() {
        let size = inputAsset.kg.size
        let width: CGFloat
        let height: CGFloat
        
        switch inputAsset.kg.orientation {
        
        case .portrait:
            width = size.width > 540 ? 540 : size.width
            height = size.height > 960 ? 960 : size.height

        case .landscape:
            width = size.width > 960 ? 960 : size.width
            height = size.height > 540 ? 540 : size.height
        }
        
        videoSettings = [
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: width * height * 3,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264Baseline31
            ]
        ]
        audioSettings = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100,
            AVEncoderBitRateKey: 128000
        ]

    }

}

extension KGAssetExportSession {
    
    func setAssetReader() -> NSError? {
        do {
            assetReader = try AVAssetReader(asset: inputAsset)
        } catch {
            return error as NSError
        }
        
        let videoTracks = inputAsset.tracks(withMediaType: .video)
        guard videoTracks.count > 0 else {
            return NSError(code: -1, message: "No videoTracks.")
        }
        videoOutput = AVAssetReaderVideoCompositionOutput(videoTracks: videoTracks, videoSettings: nil)
        videoOutput.alwaysCopiesSampleData = false
        videoOutput.videoComposition = defaultVideoComposition
        if assetReader.canAdd(videoOutput) {
            assetReader.add(videoOutput)
        }
        
        let audioTracks = inputAsset.tracks(withMediaType: .audio)
        audioOutput = AVAssetReaderAudioMixOutput(audioTracks: audioTracks, audioSettings: nil)
        audioOutput.alwaysCopiesSampleData = false
        if assetReader.canAdd(audioOutput!) {
            assetReader.add(audioOutput!)
        }
        
        return nil
    }
    
    func setAssetWriter() -> NSError? {
        do {
            assetWriter = try AVAssetWriter(outputURL: URL(fileURLWithPath: outputItemPath), fileType: outputFileType)
            assetWriter.shouldOptimizeForNetworkUse = true
        } catch {
            return error as NSError
        }
        
        videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        if assetWriter.canAdd(videoInput) {
            assetWriter.add(videoInput)
        }

        audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
        if assetWriter.canAdd(audioInput) {
            assetWriter.add(audioInput)
        }
        
        return nil
    }
    
    
    func export(completeClosure: @escaping (AVAssetExportSession.Status, AVURLAsset?, NSError?) -> Void) {
        self.completeClosure = completeClosure
        
        if let error = setAssetReader() {
            return completeClosure(.failed, nil, error)
        }
        if let error = setAssetWriter() {
            return completeClosure(.failed, nil, error)
        }
        
        assetReader.startReading()
        assetWriter.startWriting()
        assetWriter.startSession(atSourceTime: .zero)
        
        let group = DispatchGroup()
        
        group.enter()
        videoInput.requestMediaDataWhenReady(on: videoInputQueue) { [weak self] in
            guard let strongSelf = self else { return }
            while strongSelf.videoInput.isReadyForMoreMediaData {
                let buffer = strongSelf.videoOutput.copyNextSampleBuffer()
                if buffer == nil {
                    strongSelf.videoInput.markAsFinished()
                    group.leave()
                    return
                }
                else {
                    strongSelf.videoInput.append(buffer!)
                }
            }
        }
        
        group.enter()
        audioInput.requestMediaDataWhenReady(on: audioInputQueue) { [weak self] in
            guard let strongSelf = self else { return }
            while strongSelf.audioInput.isReadyForMoreMediaData {
                let buffer = strongSelf.audioOutput.copyNextSampleBuffer()
                if buffer == nil {
                    strongSelf.audioInput.markAsFinished()
                    group.leave()
                    return
                }
                else {
                    strongSelf.audioInput.append(buffer!)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.finish()
        }
        
    }
    
    func finish() {
        if assetWriter.status == .cancelled || assetWriter.status == .cancelled { return }
        
        if assetWriter.status == .failed {
            let error: NSError = assetWriter.error == nil ? NSError(code: -1, message: "Asset writer error.") : ((assetWriter.error)! as NSError)
            complete(status: .failed, asset: nil, error: error)
        }
        else if assetReader.status == .failed {
            assetWriter.cancelWriting()
            let error: NSError = assetReader.error == nil ? NSError(code: -1, message: "Asset writer error.") : ((assetReader.error)! as NSError)
            complete(status: .failed, asset: nil, error: error)
        }
        else {
            assetWriter.finishWriting { [weak self] in
                guard let strongSelf = self else { return }
                let outputAssert = AVURLAsset(url: URL(fileURLWithPath: strongSelf.outputItemPath))
                DispatchQueue.main.async {
                    strongSelf.complete(status: .completed, asset: outputAssert, error: nil)
                }
            }
        }
    }
    
    func complete(status: AVAssetExportSession.Status, asset: AVURLAsset?, error: NSError?) {
        if assetWriter.status == .failed || assetWriter.status == .cancelled {
            FileManager.kg.removeItem(atPath: outputItemPath)
        }
        
        if let complete = completeClosure {
            complete(status, asset, error)
        }
    }
    
    private var defaultVideoComposition: AVMutableVideoComposition {
        let videoComposition = AVMutableVideoComposition()
        let videoTrack = inputAsset.tracks(withMediaType: .video).first!
        var trackFrameRate: Float = 0
        if let videoCompressionProperties = videoSettings[AVVideoCompressionPropertiesKey] as? [String: Any] {
            trackFrameRate = videoCompressionProperties[AVVideoAverageNonDroppableFrameRateKey] as? Float ?? 0
        }
        else {
            trackFrameRate = videoTrack.nominalFrameRate
        }
        if trackFrameRate == 0 { trackFrameRate = 30 }
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: Int32(trackFrameRate))
        
        var naturalSize = videoTrack.naturalSize
        var transform = videoTrack.preferredTransform
        if transform.ty == -560 { transform.ty = 0 }
        if transform.tx == -560 { transform.tx = 0 }
        let videoAngleInDegree = atan2(transform.b, transform.a) * 180 / .pi
        if videoAngleInDegree == 90 || videoAngleInDegree == -90 {
            let temp = naturalSize.width
            naturalSize.width = naturalSize.height
            naturalSize.height = temp
        }
        videoComposition.renderSize = naturalSize
        
        let targetWidth = videoSettings[AVVideoWidthKey] as? CGFloat ?? naturalSize.width
        let targetHeight = videoSettings[AVVideoHeightKey] as? CGFloat ?? naturalSize.height
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        let xratio = targetSize.width / naturalSize.width
        let yratio = targetSize.height / naturalSize.height
        let ratio = min(xratio, yratio)
        let postWidth = naturalSize.width * ratio
        let postHeight = naturalSize.height * ratio
        let transx = (targetSize.width - postWidth) / 2
        let transy = (targetSize.height - postHeight) / 2
        let matrix = CGAffineTransform(translationX: transx / xratio, y: transy / yratio).scaledBy(x: ratio / xratio, y: ratio / yratio)
        transform = transform.concatenating(matrix)
        
        let passThroughInstruction = AVMutableVideoCompositionInstruction()
        passThroughInstruction.timeRange = CMTimeRangeMake(start: .zero, duration: inputAsset.duration)
        let passThroughLayer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        passThroughLayer.setTransform(transform, at: .zero)
        passThroughInstruction.layerInstructions = [passThroughLayer]
        videoComposition.instructions = [passThroughInstruction]
        
        return videoComposition
    }
}
