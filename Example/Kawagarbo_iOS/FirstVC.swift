//
//  FirstVC.swift
//  KawagarboExample
//
//  Created by 温一鸿 on 2019/1/24.
//  Copyright © 2019年 Moirig. All rights reserved.
//

import UIKit
import Kawagarbo_iOS

class FirstVC: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "tab1"

        view.backgroundColor = UIColor.white
        view.addSubview(tableView)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FirstVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = "http://192.168.215.193:4000/Kawagarbo_web/index.html"

//        let urlString = "http://localhost:4000/Kawagarbo_web/index.html"
        
//        let toPath = KawagarboCachePath + "/Kawagarbo_web"
//        let urlString = "file://" + toPath + "/index.html"
        
        let webVC = KGWebViewController(urlString: urlString)
        webVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "demo"
        
        return cell
    }
}
