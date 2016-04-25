//
//  OAuthViewController.swift
//  Weibo
//
//  Created by nsky on 16/4/18.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit
import SVProgressHUD
class OAuthViewController: UIViewController {

    let  WB_App_Key = "2741923322"
    let  WB_App_Secret = "3239efdd353b0d25d741651f548339b1"
    let  WB_redirect_uri = "http://www.baidu.com"

    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // 0.初始化导航条
        navigationItem.title = "将军的微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(OAuthViewController.close))
        //1. 获取未授权的RequestToken
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_uri)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        webView.delegate = self
        

    }
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private lazy var webView = UIWebView()
}

extension OAuthViewController: UIWebViewDelegate
{
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
       print(request.URL!.absoluteString)
        //1.判断是否是授权回调页面,如果不是就继续加载
        let urlStr = request.URL!.absoluteString
        if !urlStr.hasPrefix(WB_redirect_uri)
        {
            return true
        }
        
        //2.判断是否授权成功
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr) {
            print("授权成功")
            // 获取已经授权的RequestToken
            let code = request.URL?.query?.substringFromIndex(codeStr.endIndex)
            print(code)
            
            // 利用已经授权的RequestToken换取AccessToken
            loadAccessToken(code!)
        }else{
            
            print("授权失败")
            //取消授权
            close()
        }
        return false
    }
    
    
    func webViewDidStartLoad(webView: UIWebView) {
       //提示用户正在加载
        SVProgressHUD.showInfoWithStatus("正在加载...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //关闭提示
        SVProgressHUD.dismiss()
    }
    
    
    
    
    
    private func loadAccessToken(code: String)
    {
        // 1.定义路径
        let path = "oauth2/access_token"
        // 2.封装参数
        let params = ["client_id":WB_App_Key, "client_secret":WB_App_Secret, "grant_type": "authorization_code", "code":code, "redirect_uri": WB_redirect_uri]
    
    // 3.发送POST请求
        NetworkTools.shareNetworkTools().POST(path, parameters: params, success: { (_, JSON) in
            print(JSON)
            // 1.字典转模型
            let account = UserAccount(dict: JSON as! [String: AnyObject])
            print(account)
            
            // 2.获取用户信息
            account.loadUserInfo({ (account, error) in
                if account != nil
                {
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(XMGRootViewControllerSwitchNotification, object: false)
                    self.close()
                    
                    print(account)
                    
                    return
                    
                }
                SVProgressHUD.showInfoWithStatus("网络不给力...")
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
           
            })

            

        }) { (_, error) in
                print(error)
        }
    }
}


