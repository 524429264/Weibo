//
//  NetworkTools.swift
//  Weibo
//
//  Created by nsky on 16/4/19.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: AFHTTPSessionManager {

   static let tools: NetworkTools = {
     //注意baseURL一定以/结尾
        let url = NSURL(string: "https://api.weibo.com/")
        let t = NetworkTools(baseURL: url)
    //设置AFN能接收的数据类型
        t.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as! Set<String>
        return t
    }()
    

    // 获取单例的方法
    class func shareNetworkTools() -> NetworkTools {
        return tools
    }
}
