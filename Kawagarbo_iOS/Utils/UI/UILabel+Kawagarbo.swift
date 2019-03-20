//
//  UILabel+Kawagarbo.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/2/14.
//

import Foundation

extension KGNamespace where Base == UILabel {

    func fitWidth() {
        guard let text = base.text else { return }
        
        let frame = NSString(string: text).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: base.bounds.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: base.font], context: nil)
        
        var newFrame = base.frame
        newFrame.size.width = frame.width
        base.frame = newFrame
    }
}

