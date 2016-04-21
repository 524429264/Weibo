//
//  HomeViewController.swift
//  Weibo
//
//  Created by nsky on 16/4/14.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit

class HomeViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !login {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
             setupNavigationItem()
        
        //注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.change), name: TYHPopooverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.change), name: TYHPopooverAnimatorWillDismiss, object: nil)

    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //修改标题按钮状态
    func change() {
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.selected = !titleBtn.selected

    }
    
    func leftBtnClick() {
        print(#function)
        
    }
    
    func rightBtnClick() {
        print(#function)
        
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    // MARK: - 内部控件方法
    private func setupNavigationItem()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: #selector(HomeViewController.leftBtnClick))
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: #selector(HomeViewController.rightBtnClick))
        
        let titleBtn = TitleButton()
        titleBtn.setTitle("即可江南 ", forState: UIControlState.Normal)
        
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
        
    }
    
    // MARK: - 标题按钮
    func titleBtnClick(btn: TitleButton) {
        
        //创建Storyboard
        let sb = UIStoryboard(name: "PopoverViewController",bundle: nil)
        let vc = sb.instantiateInitialViewController()
        
       // 设置转场代理,告诉系统谁来负责
        vc!.transitioningDelegate = popoverAnimator
        vc!.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc!, animated: true, completion: nil)
        
    }

    // MARK: - 懒加载
    private lazy var popoverAnimator:PopoverAnimator = {
        let pa = PopoverAnimator()
        pa.presentFrame = CGRect(x: 100, y: 56, width: 200,height: 300)
        return pa
    }()
}


