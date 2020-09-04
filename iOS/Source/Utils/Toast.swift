//
//  Toast.swift
//  Kawagarbo
//
//  Created by 一鸿温 on 9/2/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import UIKit

func toast(_ message: String) {
    toast(title: "", message)
}

func toast(title: String, _ message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
        alert.dismiss(animated: true, completion: nil)
    }
}
