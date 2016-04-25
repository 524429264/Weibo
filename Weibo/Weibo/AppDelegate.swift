//
//  AppDelegate.swift
//  Weibo
//
//  Created by nsky on 16/4/14.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit
import AFNetworking

/// 视图控制器切换通知字符串
let XMGRootViewControllerSwitchNotification = "XMGRootViewControllerSwitchNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        
        let urlCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity:20 * 1024 * 1024, diskPath:nil)
        NSURLCache.setSharedURLCache(urlCache)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(switchRootViewController), name: XMGRootViewControllerSwitchNotification, object: nil)
        
        
        print(UserAccount.loadAccount())
        setupAppearance()
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = defaultController()
        window?.makeKeyAndVisible()
        return true
    }
    
    
    
    private func isNewUpdate() -> Bool
    {
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        let sadboxVersion = NSUserDefaults.standardUserDefaults().valueForKey("CFBundleShortVersionString") as? String ?? ""
        if currentVersion.compare(sadboxVersion) == NSComparisonResult.OrderedDescending {
            NSUserDefaults.standardUserDefaults().setValue(currentVersion, forKey: "CFBundleShortVersionString")
            NSUserDefaults.standardUserDefaults().synchronize()
            return true
        }
        return false
        
    }
    
    
    
    func switchRootViewController(notification: NSNotification){
        let isMainVC = notification.object as! Bool
        window?.rootViewController = isMainVC ? MainViewController() : WelcomeViewController()
    }
    
    private func defaultController() -> UIViewController{
        if UserAccount.loadAccount() != nil{

            return isNewUpdate() ? NewfeatureViewController() : WelcomeViewController()
    }
        return MainViewController()
    }
    
    
    func setupAppearance()  {
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

