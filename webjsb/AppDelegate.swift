//
//  AppDelegate.swift
//  webjsb
//
//  Created by 杨东举 on 2025/4/3.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ProgressViewController() // 使用ViewController作为根视图控制器
        window?.makeKeyAndVisible()
        return true
    }
}
