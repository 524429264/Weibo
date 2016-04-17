//
//  MessageViewController.swift
//  Weibo
//
//  Created by nsky on 16/4/14.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit

class MessageViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        visitorView?.setupVisitorInfo(false, imageName: "visitordiscover_image_message", message: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
    }

}

