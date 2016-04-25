//
//  BaseTableViewController.swift
//  Weibo
//
//  Created by nsky on 16/4/15.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, VisitorViewDelegate {
    // 定义一个变量保存用户当前是否登录
    var login: Bool = UserAccount.userLogin()
    // 定义属性保存未登录状态
    var visitorView: VisitorView?
    
    override func loadView() {
        
        login ? super.loadView() : setupVisitorView()
    }

    
    //MARK: - 内部控制方法
    /**
     创建未登录界面
     */
    private func setupVisitorView()
    {
        visitorView = VisitorView()
        visitorView?.delegate = self
        
        view = visitorView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册",style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseTableViewController.visitorViewRegister))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录",style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseTableViewController.visitorViewLogin))
    }
    
    //MARK: - VisitorViewDelegate
    
    func visitorViewLogin() {
        print(#function)
        
        let oauthVC = OAuthViewController()
        let nav = UINavigationController(rootViewController: oauthVC)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func visitorViewRegister() {
        print(#function)
    }
    
}
