//
//  UserAccount.swift
//  Weibo
//
//  Created by nsky on 16/4/19.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit
import SVProgressHUD

// Swift2.0 打印对象需要重写CustomStringConvertible 协议中的description
class UserAccount: NSObject, NSCoding {
    
    /// 接口授权后的RequestToken
    var access_token: String?
    /// access_token的生命周期，单位是秒数
    var expires_in: NSNumber?
    {
        didSet{
            expires_Date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
        }
    }
    //保存用户过期时间
    var expires_Date: NSDate?
    /// 授权用户的UID
    var uid: String?
    //用户昵称
    var screen_name: String?
    //用户头像地址（大图）
    var avatar_large: String?
    
    init(dict: [String: AnyObject]) {
        

        super.init()
        setValuesForKeysWithDictionary(dict)
    }

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print(key)
    }
    
    override var description: String{
        // 1.定义属性数组
        let properties = ["access_token","expires_in","uid","expires_Date","screen_name","avatar_large"]
        // 2.根据属性数组,将属性转换为字典
        let dict = self.dictionaryWithValuesForKeys(properties)
        // 2.将字典转换为字符串
        return "\(dict)"
    }
    
    
    func loadUserInfo(finished: (account: UserAccount?,  error: NSError? ) ->()) {
        
        assert(access_token != nil, "没有授权")
        let path = "2/users/show.json"
        let params = ["access_token":access_token!,"uid":uid!]
        
        NetworkTools.shareNetworkTools().GET(path, parameters: params, success: { (_, JSON) in
            print(JSON)
            //判断字典是否有值
            if let dict = JSON as? [String:AnyObject]
            {
                self.screen_name = dict["screen_name"] as? String
                self.avatar_large = dict["avatar_large"] as? String
              
                self.saveAccount()
                
                finished(account: self, error: nil)
            }else
            {
                finished(account: nil, error: nil)
            }

            }) { (_, error) in
                
                finished(account: nil, error: error)

                print(error)
                
        }
        
    }
    
    
    
    
    /**
     返回用户是否登录
     */
    
    class func userLogin() ->Bool
    {
        return UserAccount.loadAccount() != nil
    }
    
    
    // MARK: - 保存和读取 Keyed
    /**
     保存授权模型
     */
    
    static let filePath = ("account.plist").cacheDir()

    func saveAccount()
    {
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    // 加载授权模型
    static var account: UserAccount?
    class func loadAccount() -> UserAccount? {
        
        // 1.判断是否已经加载过
        if account != nil {
            return account
        }
        
        // 2.2加载授权模型
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? UserAccount
       
        if account?.expires_Date?.compare(NSDate()) == NSComparisonResult.OrderedAscending
        {
            return nil
        }
        return account
    }
    
    
    
    // MARK: - NSCoding
    // 将对象写入到文件中
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")

    }
    //  从文件中读取对象
    required init?(coder aDecoder: NSCoder)
    {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String

    }
    
}
