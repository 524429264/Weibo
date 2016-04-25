//
//  VisitorView.swift
//  Weibo
//
//  Created by nsky on 16/4/15.
//  Copyright © 2016年 nsky. All rights reserved.
//

import UIKit


protocol VisitorViewDelegate: NSObjectProtocol {
    
    func visitorViewLogin()
    
    func visitorViewRegister()
}

class VisitorView: UIView {
    
    weak var delegate: VisitorViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
      
        setupUI()
    }
    
    
       required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupVisitorInfo(isHome:Bool, imageName:String, message:String)  {
        
        iconView.hidden = !isHome
        messageLabel.text = message
        homeIcon.image = UIImage(named: imageName)
        
        if isHome {
            startAnimation()
        }
    }
    
    
    func registerBtnClick()  {
        delegate?.visitorViewRegister()
    }
    
    func loginBtnClick()  {
        
        delegate?.visitorViewLogin()
    }
    
    
    // MARK: - 内部控制方法
    /**
     开始动画
     */
    private func startAnimation(){
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        
        anim.removedOnCompletion = false
        
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    
    private func setupUI(){
        
        addSubview(iconView)
        addSubview(maskBGView)
        
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(loginButton)
        addSubview(registerButton)
        
        
        iconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        homeIcon.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        messageLabel.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: iconView, size: nil)
        
        let widthCons = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem:nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224 )
        
        addConstraint(widthCons)
        
        registerButton.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: messageLabel, size: CGSize(width:100, height:30),offset: CGPoint(x: 0, y: 20))
        loginButton.xmg_AlignVertical(type: XMG_AlignType.BottomRight, referView: messageLabel, size: CGSize(width: 100, height: 30),offset: CGPoint(x: 0, y: 20))
        
        maskBGView.xmg_Fill(self)
    }
    

    
    // MARK: - 懒加载控件
    ///转盘
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named:"visitordiscover_feed_image_smallicon"))
        return iv
        
    }()
    
    private lazy var homeIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(named:"visitordiscover_feed_image_house"))
        return iv
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.darkGrayColor()
        label.text = "关注一些人，回这里看看有什么惊喜"
        label.font = UIFont.systemFontOfSize(14)
        label.sizeToFit()
        return label
        
    }()
    
    
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)

        btn.addTarget(self, action: #selector(VisitorView.loginBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var registerButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)

        btn.addTarget(self, action: #selector(VisitorView.registerBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var maskBGView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return iv
    }()
}
