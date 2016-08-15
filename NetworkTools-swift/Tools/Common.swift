//
//  Common.swift
//  weiBo
//
//  Created by Mr.Q on 16/7/22.
//  Copyright © 2016年 MrQ. All rights reserved.
//

import UIKit


// MARK: - 全局通知定义
/// 切换根视图控制器的通知 一定要够长，有前缀
let WBSwitchRootViewControllerNotification = "WBSwitchRootViewControllerNotification"

// 全局外观渲染颜色
let WBApperanceColor = UIColor.orangeColor()


// MARK: - 全局函数，可以直接使用
/// 延迟在主线程执行函数
///
/// - parameter delta:    延迟时间
/// - parameter callFunc: 要执行的闭包
func delay(delta:NSTimeInterval,callFunc:()->()){

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delta * NSTimeInterval(NSEC_PER_SEC))), dispatch_get_main_queue()) {

        callFunc()
    }
}