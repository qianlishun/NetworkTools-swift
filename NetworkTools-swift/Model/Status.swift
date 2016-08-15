//
//  Status.swift
//  weiBo
//
//  Created by Mr.Q on 16/7/26.
//  Copyright © 2016年 MrQ. All rights reserved.
//

import UIKit

class Status: NSObject {

    ///  微博创建时间
    var created_at : String?

    /// 微博 ID
    var id : Int = 0

    /// 微博来源
    var source : String?

    /// 用户模型
    var user:User?

    /// 微博内容
    var text : String?

    /// 缩略图配图数组 key: thumbnail_pic
    var pic_urls: [[String: String]]?
    /*	pic_urls		[1]

        0		{1}  thumbnail_pic : url

    thumbnail_pic	:	url
    thumbnail_pic	:	url

    bmiddle_pic	:	url

    original_pic	:	url
    geo	:	null
    */

    /// 被转发的原微博
    var retweeted_status:Status?


    //KVC
    init(dict:[String : AnyObject]) {
        super.init()

        setValuesForKeysWithDictionary(dict)
    }


    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "user"{
            if let dict = value as? [String : AnyObject]{
                user = User(dict:dict)
            }
            return
        }

        if key == "retweeted_status"{
            if let dict = value as? [String:AnyObject]{
                retweeted_status = Status(dict:dict)
            }
            return
        }

        super.setValue(value, forKey: key)
    }

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }


    override var description:String{
        let keys = ["id","created_at","text","source","user","pic_urls","retweeted_status"]

        return dictionaryWithValuesForKeys(keys).description
    }
}
