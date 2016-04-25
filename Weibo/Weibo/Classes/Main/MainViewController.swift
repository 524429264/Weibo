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


        addChildViewControllers()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupComposeBtn()
    }
    
    
    func composeBtnclick() {
        print(#function)
    }
    
    //MARK: - 内部控制方法
    private func setupComposeBtn() {
        tabBar.addSubview(composeBtn)
        let width = UIScreen.mainScreen().bounds.width / CGFloat((viewControllers?.count)!)
        let rect = CGRect(x:0,y: 0 ,width: width,height: 49)
        
        composeBtn.frame = CGRectOffset(rect, 2 * width, 0)
        
    }
    
    private func addChildViewControllers() {
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
                addChildViewController("NullViewController", title: "", imageNamed: "")
                
                addChildViewController("DiscoverViewController", title: "广场", imageNamed: "tabbar_discover")
                addChildViewController("ProfileViewController", title: "我", imageNamed: "tabbar_profile")
            }
            
        }

    }
        



        private func addChildViewController(childControllerName: String, title:String, imageNamed:String) {

        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        let cls:AnyClass? = NSClassFromString(ns + "." + childControllerName)
        
        let vcCls = cls as! UIViewController.Type
        let vc = vcCls.init()

        
        vc.tabBarItem.image = UIImage(named: imageNamed)
        vc.tabBarItem.selectedImage = UIImage(named: imageNamed + "_highlighted")
        vc.title = title
            
        tabBar.tintColor = UIColor.orangeColor()

        
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        
        addChildViewController(nav)
        
    }
    
    //MARK - 懒加载
    private lazy var composeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: #selector(MainViewController.composeBtnclick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn

    }()

}


