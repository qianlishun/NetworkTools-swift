//
//  UILabel+Extension.swift
//  weiBo
//
//  Created by Mr.Q on 16/7/22.
//  Copyright © 2016年 MrQ. All rights reserved.
//

import UIKit

extension UILabel{

    /// 便利构造函数
    ///
    /// - parameter title:          title
    /// - parameter fontSize:       fontSize，默认 14 号字
    /// - parameter color:          color，默认深灰色
    /// - parameter screenInset:    相对与屏幕左右的缩紧，默认为0，局中显示，如果设置，则左对齐
    ///
    /// - returns: UILabel
    /// 参数后面的值是参数的默认值，如果不传递，就使用默认值
    convenience init(title: String,
        fontSize: CGFloat = 14,
        color: UIColor = UIColor.darkGrayColor(),
        screenInset: CGFloat = 0) {

            self.init()

            text = title
            textColor = color
            font = UIFont.systemFontOfSize(fontSize)

            numberOfLines = 0

            if screenInset == 0 {
                textAlignment = .Center
            } else {
                //在自动布局中，如果要让 label 自动换行，必须要指定 preferredMaxLayoutWidth，单纯使用 左右约束，自动布局的时候会有计算错误

                // 设置换行宽度
                preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * screenInset
                textAlignment = .Left
            }
    }
}
