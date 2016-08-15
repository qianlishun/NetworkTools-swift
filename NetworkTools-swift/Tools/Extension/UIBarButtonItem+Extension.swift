//
//  UIBarButtonItem+Extension.swift
//  weiBo
//
//  Created by Mr.Q on 16/8/3.
//  Copyright © 2016年 MrQ. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    /// 便利构造函数
    ///
    /// - parameter imageName:  图像名
    /// - parameter target:     监听对象
    /// - parameter actionName: 监听图像名
    ///
    /// - returns: UIBarButtonItem
    convenience init(imageName: String, target: AnyObject?, actionName: String?) {
        let button = UIButton(imageName: imageName, backImageName: nil)

        // 判断 actionName
        if let actionName = actionName {
            button.addTarget(target, action: Selector(actionName), forControlEvents: .TouchUpInside)
        }

        self.init(customView: button)
    }
}
