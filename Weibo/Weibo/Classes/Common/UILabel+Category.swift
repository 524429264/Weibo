//
//  UILabel+Category.swift
//  DSWeibo
//
//  Created by nsky on 16/4/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit
extension UILabel{
    class func createLabel(color: UIColor, fontSize: CGFloat) -> UILabel{
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    }
}