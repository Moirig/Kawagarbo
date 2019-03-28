//
//  UIImage.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/2/19.
//

import Foundation

extension KGNamespace where Base == UIImage {

    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        base.draw(in: CGRect(origin: CGPoint.zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /**
     wechat image compress
     
     - parameter type: session image boundary is 800, timeline is 1280
     
     - returns: thumb image
     */
    func compress(quality: CGFloat = 0.8) -> Data {
        let size = imageSize()
        let boundary: CGFloat = 1280
        guard size.width > boundary || size.height > boundary else {
            return base.jpegData(compressionQuality: quality)!
        }
        let reImage = resizedImage(size: size)
        return reImage.jpegData(compressionQuality: quality)!
    }
    
    /**
     get wechat compress image size
     
     - returns: size
     */
    private func imageSize() -> CGSize {
        var width = base.size.width
        var height = base.size.height
        
        let boundary: CGFloat = 1280
        
        // width, height <= 1280, Size remains the same
        guard width > boundary || height > boundary else {
            return CGSize(width: width, height: height)
        }
        
        // aspect ratio
        let s = max(width, height) / min(width, height)
        if s <= 2 {
            // Set the larger value to the boundary, the smaller the value of the compression
            let x = max(width, height) / boundary
            if width > height {
                width = boundary
                height = height / x
            } else {
                height = boundary
                width = width / x
            }
        } else {
            // width, height > 1280
            if min(width, height) >= boundary {
                // Set the smaller value to the boundary, and the larger value is compressed
                let x = min(width, height) / boundary
                if width < height {
                    width = boundary
                    height = height / x
                } else {
                    height = boundary
                    width = width / x
                }
            }
        }
        return CGSize(width: width, height: height)
    }
    
    /**
     Zoom the picture to the specified size
     
     - parameter newSize: image size
     
     - returns: new image
     */
    private func resizedImage(size: CGSize) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var newImage: UIImage!
        UIGraphicsBeginImageContext(newRect.size)
        newImage = UIImage(cgImage: base.cgImage!, scale: 1, orientation: base.imageOrientation)
        newImage.draw(in: newRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
