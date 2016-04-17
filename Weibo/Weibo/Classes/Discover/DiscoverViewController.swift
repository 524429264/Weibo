//
//  DiscoverViewController.swift
//  Weibo
//
//  Created by nsky on 16/4/14.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit

class DiscoverViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        visitorView?.setupVisitorInfo(false, imageName: "visitordiscover_image_message", message: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")

    }
}
