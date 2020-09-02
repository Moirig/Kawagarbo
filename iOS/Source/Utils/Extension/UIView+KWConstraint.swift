////
////  UIView+KWConstraint.swift
////  Kawagarbo
////
////  Created by 一鸿温 on 8/31/20.
////  Copyright © 2020 Moirig. All rights reserved.
////
//
//import UIKit
//
//extension UIView {
//
//    
//    /// top, right, bottom, left
//    var kw_margin4: (CGFloat, CGFloat, CGFloat, CGFloat) {
//        set {
//            if translatesAutoresizingMaskIntoConstraints {
//                translatesAutoresizingMaskIntoConstraints = false
//            }
//            let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: newValue.0)
//            let right = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1, constant: -newValue.1)
//            let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: -newValue.2)
//            let left = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1, constant: newValue.3)
//            superview?.addConstraints([top, right, bottom, left])
//        }
//        get {
//            if constraints.count >= 4 {
//                let top = constraints[0].constant
//                let right = constraints[1].constant
//                let bottom = constraints[2].constant
//                let left = constraints[3].constant
//                return (top, right, bottom, left)
//            }
//            return (0, 0, 0, 0)
//        }
//    }
//    
//    /// top, right, bottom, left
//    var kw_margin3: (CGFloat, CGFloat, CGFloat) {
//        set {
//            if translatesAutoresizingMaskIntoConstraints {
//                translatesAutoresizingMaskIntoConstraints = false
//            }
//            let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: newValue.0)
//            let right = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1, constant: -newValue.1)
//            let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: -newValue.2)
//            superview?.addConstraints([top, right, bottom])
//        }
//        get {
//            if constraints.count >= 3 {
//                let top = constraints[0].constant
//                let right = constraints[1].constant
//                let bottom = constraints[2].constant
//                return (top, right, bottom)
//            }
//            return (0, 0, 0)
//        }
//    }
//    
//    
//    /// V, H
//    var kw_margin2: (CGFloat, CGFloat) {
//        set {
//            if translatesAutoresizingMaskIntoConstraints {
//                translatesAutoresizingMaskIntoConstraints = false
//            }
//            let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: newValue.0)
//            let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: -newValue.0)
//            let right = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1, constant: -newValue.1)
//            let left = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1, constant: newValue.1)
//            superview?.addConstraints([top, bottom, right, left])
//        }
//        get {
//            if constraints.count >= 4 {
//                let v = constraints[0].constant
//                let h = constraints[2].constant
//                return (v, h)
//            }
//            return (0, 0)
//        }
//    }
//    
//    var kw_margin: CGFloat {
//        set {
//            if translatesAutoresizingMaskIntoConstraints {
//                translatesAutoresizingMaskIntoConstraints = false
//            }
//            let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: newValue)
//            let right = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1, constant: newValue)
//            let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: newValue)
//            let left = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1, constant: newValue)
//            superview?.addConstraints([top, right, bottom, left])
//        }
//        get {
//            if constraints.count >= 4 {
//                let margin = constraints[0].constant
//                return margin
//            }
//            return 0
//        }
//    }
//    
//    var kw_marginTop: CGFloat {
//        set {
//            if translatesAutoresizingMaskIntoConstraints {
//                translatesAutoresizingMaskIntoConstraints = false
//            }
//            let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: newValue)
//            superview?.addConstraint(top)
//        }
//        get {
//            return 0
//        }
//    }
//    
//    var kw_marginTopTo: (UIView, CGFloat) {
//        set {
//            if translatesAutoresizingMaskIntoConstraints {
//                translatesAutoresizingMaskIntoConstraints = false
//            }
//            let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: newValue.0, attribute: .bottom, multiplier: 1, constant: newValue.1)
//            superview?.addConstraint(top)
//        }
//        get {
//            return (self, 0)
//        }
//    }
//    
//    var kw_marginRight: CGFloat {
//        set {
//            if translatesAutoresizingMaskIntoConstraints {
//                translatesAutoresizingMaskIntoConstraints = false
//            }
//            let right = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1, constant: newValue)
//            superview?.addConstraint(right)
//        }
//        get {
//            return 0
//        }
//    }
//    
//    var kw_marginRightTo: (UIView, CGFloat) {
//        set {
//            if translatesAutoresizingMaskIntoConstraints {
//                translatesAutoresizingMaskIntoConstraints = false
//            }
//            let right = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: newValue.0, attribute: .left, multiplier: 1, constant: newValue.1)
//            superview?.addConstraint(right)
//        }
//        get {
//            return (self, 0)
//        }
//    }
//    
//    var kw_marginBottom: CGFloat {
//        set {
//            if translatesAutoresizingMaskIntoConstraints {
//                translatesAutoresizingMaskIntoConstraints = false
//            }
//            let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: newValue)
//            superview?.addConstraint(bottom)
//        }
//        get {
//            return 0
//        }
//    }
//    
//    var kw_marginBottomTo: (UIView, CGFloat) {
//        set {
//            if translatesAutoresizingMaskIntoConstraints {
//                translatesAutoresizingMaskIntoConstraints = false
//            }
//            let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: newValue.0, attribute: .top, multiplier: 1, constant: newValue.1)
//            superview?.addConstraint(bottom)
//        }
//        get {
//            return (self, 0)
//        }
//    }
//    
//    var kw_marginLeft: CGFloat {
//        set {
//            let left = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1, constant: newValue)
//            superview?.addConstraint(left)
//        }
//        get {
//            return 0
//        }
//    }
//    
//    var kw_centerX: CGFloat {
//        set {
//            if translatesAutoresizingMaskIntoConstraints {
//                translatesAutoresizingMaskIntoConstraints = false
//            }
//            let centerX = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 0, constant: newValue)
//            superview?.addConstraint(centerX)
//        }
//        get {
//            return center.x
//        }
//    }
//    
//    var kw_centerY: CGFloat {
//        set {
//            if translatesAutoresizingMaskIntoConstraints {
//                translatesAutoresizingMaskIntoConstraints = false
//            }
//            let centerY = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 0, constant: newValue)
//            superview?.addConstraint(centerY)
//        }
//        get {
//            return center.x
//        }
//    }
//    
//    var kw_width: CGFloat {
//        set {
//            if translatesAutoresizingMaskIntoConstraints {
//                translatesAutoresizingMaskIntoConstraints = false
//            }
//            let width = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: newValue)
//            superview?.addConstraint(width)
//        }
//        get {
//            return frame.width
//        }
//    }
//    
//    var kw_height: CGFloat {
//        set {
//            if translatesAutoresizingMaskIntoConstraints {
//                translatesAutoresizingMaskIntoConstraints = false
//            }
//            let height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: newValue)
//            superview?.addConstraint(height)
//        }
//        get {
//            return frame.height
//        }
//    }
//
//}
