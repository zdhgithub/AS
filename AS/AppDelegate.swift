//
//  AppDelegate.swift
//  AS
//
//  Created by dh on 2023/9/19.
//

import UIKit
import MMKV

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        MMKV.initialize(rootDir: nil)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = DHBaseNavigationController(rootViewController: ViewController())
        window?.makeKeyAndVisible()
        
        return true
    }




}

