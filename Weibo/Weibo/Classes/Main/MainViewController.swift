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

        
        
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        
        if let jsonPath = path{
            let jsonData = NSData(contentsOfFile: jsonPath)
      
            do{
                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                print(dictArr)
                
                for dict in dictArr as! [[String:String]] {
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageNamed: dict["imageName"]!)
                }

            }catch{
                print(error)
                addChildViewController("HomeViewController", title: "首页", imageNamed: "tabbar_home")
                addChildViewController("MessageViewController", title: "消息", imageNamed: "tabbar_message_center")
            
                addChildViewController("DiscoverViewController", title: "广场", imageNamed: "tabbar_discover")
                addChildViewController("ProfileViewController", title: "我", imageNamed: "tabbar_profile")
            }
       
        }
        
    }
    
        



        private func addChildViewController(childControllerName: String, title:String, imageNamed:String) {

        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        let cls:AnyClass? = NSClassFromString(ns + "." + childControllerName)
        
        let vcCls = cls as! UITableViewController.Type
        let vc = vcCls.init()
        
        
        
        
        
        
        vc.tabBarItem.image = UIImage(named: imageNamed)
        vc.tabBarItem.selectedImage = UIImage(named: imageNamed + "_highlighted")
        vc.title = title
        
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        
        addChildViewController(nav)
        
    }

}
