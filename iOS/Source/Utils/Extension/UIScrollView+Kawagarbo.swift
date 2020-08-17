//
//  UIScrollView+Kawagarbo.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/2/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import UIKit

extension KWNamespace where Base == UIScrollView {
    
    var safeTop: CGFloat {
        if #available(iOS 11.0, *) {
            return base.adjustedContentInset.top
        }
        return base.contentInset.top
    }
    
}
