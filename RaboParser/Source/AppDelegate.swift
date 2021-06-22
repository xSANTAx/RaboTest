//
//  AppDelegate.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/18/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userFlow: UserFlowCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let version = OperatingSystemVersion(majorVersion: 13, minorVersion: 0, patchVersion: 0)
        if !ProcessInfo.processInfo.isOperatingSystemAtLeast(version) {
            self.window = self.window ?? UIWindow()
            setupWindow(self.window!)
        }
        
        return true
    }
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK: - Common Function for AppDelegate and SceneDelegate
    func setupWindow(_ window: UIWindow) {
        window.frame = UIScreen.main.bounds
        
        let userFlow = UserFlowCoordinator(navigationController: UINavigationController(), screenFactory: UserScreenFactory())
        userFlow.start(using: window)
        self.userFlow = userFlow
        
        window.makeKeyAndVisible()
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

