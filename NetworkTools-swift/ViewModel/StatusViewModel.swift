//
//  StatusViewModel.swift
//  weiBo
//
//  Created by Mr.Q on 16/7/26.
//  Copyright © 2016年 MrQ. All rights reserved.
//

import UIKit

class StatusViewModel: CustomStringConvertible {

    // 微博模型
    var status : Status

    var cellID: String  //{
//        return status.retweeted_status != nil ? StatusCellRetweetedID : StatusCellNormalID
   // }

  /*  /// 缓存的行高
    lazy var rowHeight: CGFloat = {
        // 1. cell
        // 定义 cell
        var cell: StatusCell

        // 根据是否是转发微博，决定 cell 的创建
        if self.status.retweeted_status != nil {
            cell = StatusRetweetedCell(style: .Default, reuseIdentifier: StatusCellRetweetedID)
        } else {
            cell = StatusNormalCell(style: .Default, reuseIdentifier: StatusCellNormalID)
        }

        // 2. 记录高度
        return cell.rowHeight(self)
    }()
*/
    // 用户头像
    var userProfileUrl : NSURL{
        return NSURL(string: status.user?.profile_image_url ?? "")!
    }
    // 默认头像
    var userDefaultIconView: UIImage{
        return UIImage(named: "avatar_default_big")!
    }

    // 用户会员图标
    var userMemberImage: UIImage? {

        // 根据 mbrank 生成图像
        if status.user?.mbrank > 0 && status.user?.mbrank < 7 {
            return UIImage(named:  "common_icon_membership_level\(status.user!.mbrank)")
        }
        return nil
    }

    // 认证图标
    var userVipImage:UIImage? {
        switch(status.user?.verified_type ?? -1){

        case 0 : return UIImage(named: "avatar_vip")
        case 2, 3, 5: return UIImage(named: "avatar_enterprise_vip")
        case 220: return UIImage(named: "avatar_grassroot")
        default: return nil

        }
    }

    //  配图 URL 数组
    var thumbnailUrls: [NSURL]?

    var retweetedText: String? {

        // 1. 判断是否是转发微博，如果不是直接返回 nil
        guard let s = status.retweeted_status else {
            return nil
        }

        // 2. s 就是转发微博
        return "@" + (s.user?.screen_name ?? "") + ":" + (s.text ?? "")
    }


  /*  init(status:Status) {
        self.status = status

        // 创建配图 URL 数组
        let urls = status.retweeted_status?.pic_urls ?? status.pic_urls
        //pic_urls 的 key 是 thumbnail_pic 
        if urls?.count >= 0{

            thumbnailUrls = [NSURL]()

            for dict in urls!{

                let url = NSURL(string: dict["thumbnail_pic"]!)

                thumbnailUrls?.append(url!)
            }
        }
    }
*/
    var description: String {
        return status.description + "\n配图数组\((thumbnailUrls ?? []) as NSArray) "
    }

}
