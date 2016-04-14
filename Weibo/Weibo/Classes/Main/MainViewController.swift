//
//  MainViewController.swift
//  Weibo
//
//  Created by nsky on 16/4/14.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.orangeColor()
        // Do any additional setup after loading the view.
        addChildViewController("HomeViewController", title: "首页", imageNamed: "tabbar_home")
        addChildViewController("MessageViewController", title: "消息", imageNamed: "tabbar_message_center")

        addChildViewController("DiscoverViewController", title: "广场", imageNamed: "tabbar_discover")
        addChildViewController("ProfileViewController", title: "我", imageNamed: "tabbar_profile")

    }

    private func addChildViewController(childControllerName: String, title:String, imageNamed:String) {

        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        let cls:AnyClass? = NSClassFromString(ns + "." + childControllerName)
        
        let vcCls = cls as! UIViewController.Type
        let vc = vcCls.init()
        
        
        
        
        
        
        vc.tabBarItem.image = UIImage(named: imageNamed)
        vc.tabBarItem.selectedImage = UIImage(named: imageNamed + "_highlighted")
        vc.title = title
        
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        
        addChildViewController(nav)
        
    }

}
