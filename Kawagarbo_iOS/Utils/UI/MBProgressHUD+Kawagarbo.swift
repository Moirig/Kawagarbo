//
//  MBProgressHUD+Kawagarbo.swift
//  Kawagarbo_iOS
//
//  Created by wyhazq on 2019/2/13.
//

import Foundation
import MBProgressHUD

public extension MBProgressHUD {
    
    @discardableResult
    public static func loading(title: String? = nil, on view: UIView? = UIApplication.shared.keyWindow, delay: TimeInterval? = 60, hasMask: Bool = true) -> MBProgressHUD {

        if #available(iOS 9.0, *) {
            UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = UIColor.white
        }
        
        let hud = showAdded(to: view!, animated: true)
        hud.setupUI()
        hud.label.text = title
        hud.isUserInteractionEnabled = hasMask
        
        if #available(iOS 9.0, *) {}
        else {
            hud.activityIndicatorColor = UIColor.white
        }
        
        hud.hide(animated: true, afterDelay: delay!)
        
        return hud
    }
    
    public static func toast(title: String? = nil, delay: TimeInterval? = 2, hasMask: Bool = true) {
        let hud = showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        hud.mode = .text
        hud.setupUI()
        hud.detailsLabel.text = title
        hud.isUserInteractionEnabled = hasMask

        hud.hide(animated: true, afterDelay: delay!)
    }
    
    public static func show(image: UIImage, title: String? = nil, delay: TimeInterval? = 2, hasMask: Bool = true) {
        let hud = showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        hud.customView = UIImageView(image: image)
        hud.mode = .customView
        hud.setupUI()
        hud.label.text = title
        hud.isUserInteractionEnabled = hasMask

        hud.hide(animated: true, afterDelay: delay!)
    }
    
    public static func showSuccess(title: String? = nil, delay: TimeInterval? = 2, hasMask: Bool = true) {
        let image = Bundle.kg.image(named: "icon_hud_success")
        MBProgressHUD.show(image: image, title: title, delay: delay, hasMask: hasMask)
    }
    
    public static func showFail(title: String? = nil, delay: TimeInterval? = 2, hasMask: Bool = true) {
        let image = Bundle.kg.image(named: "icon_hud_fail")
        MBProgressHUD.show(image: image, title: title, delay: delay, hasMask: hasMask)
    }
    
    public static func hide(on view: UIView? = UIApplication.shared.keyWindow) {
        let hud = MBProgressHUD(for: view!)
        hud?.hide()
    }
    
    public func hide() {
        hide(animated: true)
    }
    
    func setupUI() {
        bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.white
        detailsLabel.font = UIFont.systemFont(ofSize: 14.0)
        detailsLabel.textColor = UIColor.white
    }
    
}
