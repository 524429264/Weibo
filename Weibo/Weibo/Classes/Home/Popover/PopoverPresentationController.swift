//
//  PopoverPresentationController.swift
//  Weibo
//
//  Created by nsky on 16/4/15.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class PopoverPresentationController: UIPresentationController {
    
    //定义一个保存菜单大小
    var presentFrame = CGRectZero
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    
    override func containerViewWillLayoutSubviews() {
        
        if presentFrame == CGRectZero {
            presentedView()?.frame = CGRect(x: 100, y: 56, width: 200,height: 250)

        }else
        {
            presentedView()?.frame = presentFrame
        }
        
        containerView?.insertSubview(coverView, atIndex: 0)
    }
    
    
    
    func close() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - 懒加载
    private lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(PopoverPresentationController.close))
        view.addGestureRecognizer(tap)
        return view
    }()

}
