//
//  AVURLAsset+Kawagarbo.swift
//  Alamofire
//
//  Created by wyhazq on 2019/4/1.
//

import AVFoundation

enum KGVideoOrientation {
    case portrait
    case landscape
}

extension KGNamespace where Base == AVURLAsset {

    var duration: UInt {
        let time = base.duration
        let second: UInt = UInt(time.value / Int64(time.timescale))
        return second
    }
    
    var fileSize: UInt {
        let path = base.url.absoluteString.kg.noScheme
        return FileManager.kg.fileSize(of: path)
    }
    
    var size: CGSize {
        if let videoTrack = base.tracks(withMediaType: .video).first {
            let size = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
            return CGSize(width: fabs(size.width), height: fabs(size.height))
        }
        
        return .zero
    }
    
    var orientation: KGVideoOrientation {
        if let videoTrack = base.tracks(withMediaType: .video).first {
            let transform = videoTrack.preferredTransform
            let videoAngleInDegree = atan2(transform.b, transform.a) * 180 / .pi
            return videoAngleInDegree == 0 ? .landscape : .portrait
        }
        
        return .portrait
    }
}
