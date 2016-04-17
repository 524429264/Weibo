//
//  BaseTableViewController.swift
//  Weibo
//
//  Created by nsky on 16/4/15.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, VisitorViewDelegate {
    
    var login: Bool = true
    var visitorView: VisitorView?
    
    
    override func loadView() {
        
        login ? super.loadView() : setupVisitorView()
    }

    
    //MARK: - 内部控制方法
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
    }
    
    func visitorViewRegister() {
        print(#function)
    }
    
}
