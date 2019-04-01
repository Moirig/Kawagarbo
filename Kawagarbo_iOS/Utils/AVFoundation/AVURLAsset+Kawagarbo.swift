//
//  AVURLAsset+Kawagarbo.swift
//  Alamofire
//
//  Created by wyhazq on 2019/4/1.
//

import AVFoundation

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
        let tracks = base.tracks(withMediaType: .video)
        if tracks.count > 0 {
            let videoTrack = tracks[0]
            return videoTrack.naturalSize
        }
        
        return CGSize.zero
    }
    
}
