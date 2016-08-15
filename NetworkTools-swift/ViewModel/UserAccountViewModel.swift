//
//  UserAccountViewModel.swift
//  weiBo
//
//  Created by Mr.Q on 16/7/25.
//  Copyright © 2016年 MrQ. All rights reserved.
//

import Foundation

/// 用户账号视图模型 - 没有父类
/**
模型通常继承自 NSObject -> 可以使用 KVC 设置属性，简化对象构造
如果没有父类，所有的内容，都需要从头创建，量级更轻

视图模型的作用：封装`业务逻辑`，通常没有复杂的属性
*/
class UserAccountViewModel {

    /// 用户账户视图模型单例
    static let sharedUserAccount = UserAccountViewModel()

    /// 用户模型
    var account: UserAccount?

    /// 返回有效的 token
    var accessToken: String? {

        // 如果 token 没有过期，返回 account.中的 token 属性
        if !isExpired {
            return account?.access_token
        }
        return nil
    }

    /// 用户登录标记
    var userLogin : Bool{ //(计算型属性)
        // 如果 token 有值, 则说明登陆成功
        // 如果没有过期,  说明登录有效
        return account?.access_token != nil && !isExpired
    }
    /// 头像
    var avatarUrl: NSURL{
        return NSURL(string: account?.avatar_large ?? "")!
    }

    // 归档保存路径
    private var accountPath: String{
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last!
        return (path as NSString).stringByAppendingPathComponent("account.plist")
    }

    // 判断账户是否过期
    private var isExpired:Bool{
        // 判断用户账户过期日期与当前系统日期`进行比较`
        // 自己改写日期，测试逻辑是否正确，创建日期的时候，如果给定 负数，返回比当前时间早的日期
        //        userAccount?.expiresDate = NSDate(timeIntervalSinceNow: -3600)

        // 如果 userAccount 为 nil，不会调用后面的属性，后面的比较也不会继续...
        if account?.expiresDate?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            return false
        }
        return true
    }


    // MARK: - 构造函数
   private init() {
        // 解档
         account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount

    // 如果帐号已经过期，清空帐号，要求用户重新登录
        if isExpired{
            print("已经过期")
            account = nil
        }
    }

}

// MARK: - 用户账户相关的网络方法
/*
    代码重构的步骤
1.新方法
2.粘贴代码
3.根据上下文调整参数和返回值
4.移动其他'子方法'
*/

extension UserAccountViewModel{

    func loadAccessToken(code:String, finished:(isSuccessed:Bool)->()){

        NetworkTools.sharedTools.loadAccessToken(code) { (result, error) -> () in

            if error != nil{
                print("出错了")
                finished(isSuccessed: false)
                return
            }

            // 输出结果 － 在 Swift 中任何 AnyObject 在使用前，必须转换类型 -> as ?/! 类型
            self.account = UserAccount(dict: result as! [String : AnyObject])

            self.loadUserInfo(self.account!, finished: finished)
        }

    }


    // 加载用户信息
    /// - parameter account:  用户账户对象
    private func loadUserInfo(account:UserAccount,finished:(isSuccessed:Bool)->()){

        NetworkTools.sharedTools.loadUserInfo(account.uid!) { (result, error) -> () in
            if error != nil{
                print("加载用户信息出错\(error)")
                finished (isSuccessed: false)
                return
            }

            guard let dict = result as? [String : AnyObject] else{
                print("数据格式错误")
                finished (isSuccessed: false)
                return
            }

            account.screen_name = dict["screen_name"] as? String
            account.avatar_large = dict["avatar_large"] as? String

            // 保存对象 － 会调用对象的 encodeWithCoder 方法
            NSKeyedArchiver.archiveRootObject(account, toFile: self.accountPath)
            print(self.accountPath)

            finished (isSuccessed: true)

        }
    }

}
