//
//  AppDelegate.swift
//  KawagarboExample
//
//  Created by wyhazq on 2018/8/16.
//  Copyright © 2018年 Moirig. All rights reserved.
//

import UIKit
import Kawagarbo_iOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        Kawagarbo.setup()
        
        let urlString = "http://192.168.202.140:4000/Kawagarbo_web/index.html"
        
        let atPath = Bundle.main.bundlePath + "/Kawagarbo_web"
        let toPath = KawagarboCachePath + "/" + urlString.md5()
        FileManager.kg.createDirectory(toPath)
        FileManager.kg.copyItem(atPath: atPath, toPath: toPath)
        
        let vc1 = FirstVC()
        let navi1 = UINavigationController(rootViewController: vc1)
        
        let vc2 = KGWebViewController(urlString: urlString)
        vc2.title = "tab2"
        vc2.webRoute?.webAppUrlString = ""
        let navi2 = UINavigationController(rootViewController: vc2)
        
        let tabbarVC = UITabBarController()
        tabbarVC.viewControllers = [navi1, navi2]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabbarVC
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

