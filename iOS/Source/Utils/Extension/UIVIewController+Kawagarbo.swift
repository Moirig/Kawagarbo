//
//  UIVIewController+Kawagarbo.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/1/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import UIKit

extension UIViewController {

    func closeVC() {
        guard let navi = navigationController else {
            guard let _ = presentingViewController else { return }
            return dismiss(animated: true, completion: nil)
        }
        
        let count = navi.viewControllers.count
        guard count > 1 else {
            guard let _ = navi.presentingViewController else { return }
            return navi.dismiss(animated: true, completion: nil)
        }
        
        guard navi.topViewController == self else { return }
        
        navi.popViewController(animated: true)
    }
    
    var safeTop: CGFloat {
        guard let navi = navigationController else { return 0 }
        return navi.navigationBar.isHidden ? 0 : navi.navigationBar.frame.maxY
    }
    
}
