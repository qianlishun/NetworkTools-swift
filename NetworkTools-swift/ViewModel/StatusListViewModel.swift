//
//  StatusListViewModel.swift
//  weiBo
//
//  Created by Mr.Q on 16/7/26.
//  Copyright © 2016年 MrQ. All rights reserved.
//

import Foundation
//import SDWebImage

/// 微博数据列表模型 － 封装网络方法
class StatusListViewModel {

    /// 微博数据数组 - 上拉/下拉刷新
    lazy var statusList = [StatusViewModel]()
    /// 下拉刷新计数
    var pulldownCount: Int?

    /// 加载微博数据库
    ///
    /// - parameter isPullup: 是否上拉刷新
    /// - parameter finished: 完成回调
    func loadStatus(isPullup isPullup: Bool, finished: (isSuccessed: Bool)->()) {

        // 下拉刷新 - 数组中第一条微博的id
        let since_id = isPullup ? 0 : (statusList.first?.status.id ?? 0)
        // 上拉刷新 - 数组中最后一条微博的id
        let max_id = isPullup ? (statusList.last?.status.id ?? 0) : 0

        NetworkTools.sharedTools.loadStatus(since_id: since_id, max_id: max_id) { (result, error) -> () in
            if error != nil {
                print("出错了")

                finished(isSuccessed: false)
                return
            }

            // 判断 result 的数据结构是否争取
            guard let array = result?["statuses"] as? [[String: AnyObject]] else {
                print("数据格式错误")

                finished(isSuccessed: false)
                return
            }

            // 遍历字典的数组，字典转模型
            // 1. 可变的数组
            var dataList = [StatusViewModel]()

            // 2. 遍历数组
            for dict in array {
                dataList.append(StatusViewModel(status: Status(dict: dict)))
            }

            print("刷新到 \(dataList.count) 条数据")
            // 下拉刷新计数
            self.pulldownCount = since_id > 0 ? dataList.count : nil

            // 3. 拼接数据
            // 判断是否是上拉刷新
            if max_id > 0 {
                self.statusList += dataList
            } else {
                self.statusList = dataList + self.statusList
            }

            // 4. 缓存单张图片
//            self.cacheSingleImage(dataList, finished: finished)

            finished(isSuccessed: true)

        }
    }

  /*  /// 缓存单张图片
    private func cacheSingleImage(dataList: [StatusViewModel], finished: (isSuccessed: Bool)->()) {

        // 1. 创建调度组
        let group = dispatch_group_create()
        // 缓存数据长度
        var dataLength = 0

        // 2. 遍历视图模型数组
        for vm in dataList {

            // 判断图片数量是否是单张图片
            if vm.thumbnailUrls?.count != 1 {
                continue
            }

            // 获取 url
            let url = vm.thumbnailUrls![0]
            print("开始缓存图像 \(url)")

            // SDWebImage - 下载图像(缓存是自动完成的)
            // 入组 - 监听后续的 block
            dispatch_group_enter(group)

            // SDWebImage 的核心下载函数，如果本地缓存已经存在，同样会通过完成回调返回
            SDWebImageManager.sharedManager().downloadImageWithURL(
                url,
                options: [SDWebImageOptions.RefreshCached, SDWebImageOptions.RetryFailed],
                progress: nil,
                completed: { (image, _, _, _, _) -> Void in

                    // 单张图片下载完成 － 计算长度
                    if let img = image,
                        let data = UIImagePNGRepresentation(img) {

                        // 累加二进制数据的长度
                        dataLength += data.length
                    }

                

                    // 出组
                    dispatch_group_leave(group)
            })
        }

        // 3. 监听调度组完成
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            print("缓存完成 \(dataLength / 1024) K")

            // 完成回调 - 控制器才开始刷新表格
            finished(isSuccessed: true)
        }
    }
 */

}