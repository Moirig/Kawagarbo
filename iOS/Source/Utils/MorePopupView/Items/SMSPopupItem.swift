//
//  SMSPopupItem.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 9/1/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import UIKit
import MessageUI

class SMSPopupItem: MorePopupItem {

    static var type: MorePopupItemType { return .share }
    
    static var image: UIImage? { return UIImage.kw.image(named: "sms") }

    static var text: String { return "短信" }
    
    static func selected(info: MorePopupItemInfo, callback: @escaping (MorePopupItemRes) -> Void) {
        guard KWMessageComposeViewController.canSendText() else { return callback(.fail) }
        let vc: KWMessageComposeViewController = KWMessageComposeViewController()
        let text = """
        [\(info.title)]
        \(info.message)
        \(info.link)
        """
        vc.body = text
        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true, completion: nil)
        vc.finish = { (result) in
            switch result {
            case .cancelled:
                callback(.cancel)
            case .sent:
                callback(.success)
            case .failed:
                callback(.fail)
            default:
                callback(.fail)
            }
        }
    }
    
}

private class KWMessageComposeViewController: MFMessageComposeViewController, MFMessageComposeViewControllerDelegate {
    
    var finish: ((MessageComposeResult) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageComposeDelegate = self
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        guard let afinish = finish else { return }
        afinish(result)
    }
}
