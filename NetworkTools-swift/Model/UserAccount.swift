//
//  UserAccount.swift
//  weiBo
//
//  Created by Mr.Q on 16/7/24.
//  Copyright © 2016年 MrQ. All rights reserved.
//

import UIKit

class UserAccount: NSObject,NSCoding {

    /// 用于调用access_token，接口获取授权后的access token
    var access_token: String?
    /// token 的过期日期
    var expiresDate: NSDate?

    /// 用户昵称
    var screen_name:String?
    /// 用户头像
    var avatar_large:String?


    ///  access_token的生命周期，单位:秒
    var expires_in: NSTimeInterval = 0 {
        didSet{
            expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }

    var uid: String?

    init(dict:[String : AnyObject]) {
        super.init()

        setValuesForKeysWithDictionary(dict)

    }

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }

    override var description:String{

        let keys = ["access_token","expires_in","expiresDate","uid","screen_name","avatar_large"]

        return dictionaryWithValuesForKeys(keys).description
    }


    // MARK: - 归档
    /// 归档 - 在把当前对象保存到磁盘前，将对象编码成二进制数据 － 跟网络的序列化概念很像！
    /// - parameter aCoder: 编码器
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token,forKey:"access_token")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }

    // MARK: - 解档 从磁盘加载二进制文件，转换成对象时调用 － 跟网络的反序列化很像
    /// - parameter aDecoder: 解码器
    /// - returns: 当前对象
    /// `required` - 没有继承性，所有的对象只能解档出当前的类对象
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }

}
// 在 extension 中只允许写 便利构造函数，而不能写指定构造函数
// 不能定义存储型属性，定义存储型属性，会破坏类本身的结构！