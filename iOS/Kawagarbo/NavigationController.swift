//
//  NavigationController.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/3/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gesture = interactivePopGestureRecognizer else { return false }
        return gesture.isEnabled && viewControllers.count > 1
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) {
            return false
        }
        return gestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.self)
    }

}
