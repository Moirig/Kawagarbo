//
//  FirstViewController.swift
//  Kawagarbo
//
//  Created by wyhazq on 7/29/20.
//  Copyright © 2020 Moirig. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


    @IBAction func testAction(_ sender: UIButton) {
        
        let webVC = WebViewController(path: "http://localhost:8080/#/demo")
//        let webVC = WebViewController(path: "https://www.baidu.com")
        webVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(webVC, animated: true)
    }
}

