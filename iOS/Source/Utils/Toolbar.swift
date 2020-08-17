//
//  Toolbar.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 8/1/20.
//  Copyright © 2020 Moirig. All rights reserved.
//
/*
 0.cangoback时显示，一旦显示就一直显示
 1.back forward按钮会根据状态改变enable和颜色
 2.向下滑动隐藏，向上滑动显示，有动画
 */
import UIKit

let ToolbarHeight: CGFloat = 44.0

protocol ToolbarDelegate: NSObject {
    
    func backItemAction(item: UIBarButtonItem)
    
    func forwardItemAction(item: UIBarButtonItem)
    
}

class Toolbar: UIToolbar {
    
    weak var adelegate: ToolbarDelegate?
    
    var viewFrame: CGRect!
    var hiddenFrame: CGRect!
    
    var backButton: UIButton!
    var forwardButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewFrame = frame
        self.hiddenFrame = CGRect(origin: CGPoint(x: frame.origin.x, y: frame.origin.y + ToolbarHeight), size: frame.size)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        let spaceL: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spaceM: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spaceR: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        backButton = barButton(imageNamed: "back", action: #selector(backAction(item:)))
        let backItem = UIBarButtonItem(customView: backButton)
        forwardButton = barButton(imageNamed: "forward", action: #selector(forwardAction(item:)))
        let forwardItem = UIBarButtonItem(customView: forwardButton)
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        
        items = [spaceL, backItem, spaceM, forwardItem, spaceR]
    }
    
    @objc func backAction(item: UIBarButtonItem) {
        adelegate?.backItemAction(item: item)
    }
    
    @objc func forwardAction(item: UIBarButtonItem) {
        adelegate?.forwardItemAction(item: item)
    }
    
    var lastOffsetY: CGFloat = 0
    
    var offsetY: CGFloat {
        set {
            if isFirstLoadPage { return }

            let y = newValue - lastOffsetY
            if abs(y) <= 44 {
                if frame.minY <= hiddenFrame.minY && frame.minY > viewFrame.minY && y < 0 {
                    isHidden = false
                    var newFrame: CGRect = hiddenFrame
                    newFrame.origin.y = newFrame.origin.y + y
                    frame = newFrame
                }
                else if frame.minY >= viewFrame.minY && frame.minY < hiddenFrame.minY && y > 0 {
                    var newFrame: CGRect = viewFrame
                    newFrame.origin.y = newFrame.origin.y + y
                    frame = newFrame
                }
            }
        }
        get { return 0 }
    }
    
    var direction: Int8 = 0
    
    var isHiddenWithAnimate: Bool {
        set {
            if isFirstLoadPage { return }
            
            isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = newValue ? self.hiddenFrame : self.viewFrame
            }) { (_) in
                self.isHidden = newValue
            }
        }
        get { return isHidden }
    }
    
    func barButton(imageNamed: String, action: Selector) -> UIButton {
        let button: UIButton = UIButton(type: .system)
        button.frame = CGRect(origin: .zero, size: CGSize(width: ToolbarHeight, height: ToolbarHeight))
        button.setImage(UIImage.kw.image(named: imageNamed), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    var canGoBack: Bool {
        set {
            show()
            backButton.isEnabled = newValue
        }
        get { return backButton.isEnabled }
    }
    
    var canGoForward: Bool {
        set {
            forwardButton.isEnabled = newValue
        }
        get { return forwardButton.isEnabled }
    }
    
    var isFirstLoadPage: Bool {
        return !canGoBack && !canGoForward
    }
    
    func show() {
        isHidden = false
        frame = viewFrame
    }

}
