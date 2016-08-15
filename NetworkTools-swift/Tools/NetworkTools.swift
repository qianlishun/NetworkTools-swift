//
//  NetworkTools.swift
//  weiBo
//
//  Created by Mr.Q on 16/7/22.
//  Copyright © 2016年 MrQ. All rights reserved.
//

import UIKit

enum RequestMethod:String{

    case GET = "GET"
    case POST = "POST"
}

class NetworkTools: AFHTTPSessionManager {

//    static let sharedTools = NetworkTools()
    private let  appKey = "3421521352"

    private let  appSecret = "7bb768ee1d1df71253f1308e14887aac"

    private let redirectUri = "http://www.itqls.com"

    static let sharedTools: NetworkTools = {

        let url = NSURL.fileURLWithPath("")

        //baseURL:是加载素材的网页服务器路径
        let tools = NetworkTools(baseURL:url)

        // 设置反序列化数据格式
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")

        return tools
    }()

    // 返回 token 字典
    private var tokenDict :[String:AnyObject]?{
        // 判断 token 是否有效
        if let token = UserAccountViewModel.sharedUserAccount.accessToken{
            return ["access_token":token]
        }
        return nil
    }
}


/// 网络请求完成回调，类似于 OC 的 typeDefine
typealias  RequestCallBack = (result: AnyObject?, error: NSError?)->()


// MARK: - 发布微博
extension NetworkTools {

    /// 发布微博
    ///
    /// - parameter status:   微博文本
    /// - parameter image:    微博配图
    /// - parameter finished: 完成回调
    /// - see: [http://open.weibo.com/wiki/2/statuses/update](http://open.weibo.com/wiki/2/statuses/update)
    /// - see: [http://open.weibo.com/wiki/2/statuses/upload](http://open.weibo.com/wiki/2/statuses/upload)
    func sendStatus(status: String, image: UIImage?, finished: RequestCallBack) {

        // 1. 创建参数字典
        var params = [String: AnyObject]()

        // 2. 设置参数
        params["status"] = status

        // 3. 判断是否上传图片
        if image == nil {
            let urlString = "https://api.weibo.com/2/statuses/update.json"

            tokenRequest(.POST, URLString: urlString, parameters: params, finished: finished)
        } else {
            let urlString = "https://upload.api.weibo.com/2/statuses/upload.json"

            let data = UIImagePNGRepresentation(image!)

            upload(urlString, data: data!, name: "pic", parameters: params, finished: finished)
        }
    }
}


// MARK: - 微博相关方法
extension NetworkTools{
    /// 加载微博数据
    ///
    /// - parameter since_id:	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    /// - parameter max_id:     若指定此参数，则返回ID`小于或等于max_id`的微博，默认为0
    /// - parameter finished:   完成回调
    /// - see: [http://open.weibo.com/wiki/2/statuses/home_timeline](http://open.weibo.com/wiki/2/statuses/home_timeline)
    func loadStatus(since_id since_id: Int, max_id: Int, finished: RequestCallBack) {

        // 1. 创建参数字典
        var params = [String: AnyObject]()

        // 判断是否下拉
        if since_id > 0 {
            params["since_id"] = since_id
        } else if max_id > 0 {  // 上拉参数
            params["max_id"] = max_id - 1
        }

        // 2. 准备网络参数
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"

        // 3. 发起网络请求
        tokenRequest(.GET, URLString: urlString, parameters: params, finished: finished)
    }

}

// MARK: - 请求用户信息
extension NetworkTools{

    func  loadUserInfo(uid: String, finished: RequestCallBack){

        // 检查 token
        guard var params = tokenDict else{
            finished(result: nil, error: NSError(domain: "com.itqls.error", code: -10001, userInfo: ["message":"token为空"]))
            return
        }

        // 网络访问, 请求 json
        let urlString = "https://api.weibo.com/2/users/show.json"

         params["uid"] = uid

        tokenRequest(.GET, URLString: urlString, parameters: params, finished: finished)
    }

}

// MARK: - 请求 Token
extension NetworkTools{

    /// OAuth 授权地址
    /// - see: [http://open.weibo.com/wiki/Oauth2/authorize](http://open.weibo.com/wiki/Oauth2/authorize)
    var oauthUrl : NSURL{
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirectUri)"

        return NSURL(string:urlString)!
    }

    /// 加载 Token
    /// - see: [http://open.weibo.com/wiki/OAuth2/access_token](http://open.weibo.com/wiki/OAuth2/access_token)
    func loadAccessToken(code:String, finished:RequestCallBack){
        let urlString = "https://api.weibo.com/oauth2/access_token"

        let parameters = ["client_id":appKey,
        "client_secret":appSecret,
        "grant_type":"authorization_code",
        "code":code,
        "redirect_uri":redirectUri]

        request(.POST, URLString: urlString, parameters: parameters, finished: finished)
    }

}

// MARK: - 封装 AFN 网络方法
extension NetworkTools{
    /// 向 parameters 字典中追加 token 参数
    ///
    /// - parameter parameters: 参数字典
    ///
    /// - returns: 是否追加成功
    /// - 默认情况下，关于函数参数，在调用时，会做一次 copy，函数内部修改参数值，不会影响到外部的数值
    /// - inout 关键字，相当于在 OC 中传递对象的地址
    private func appendToken(inout parameters: [String: AnyObject]?) -> Bool {

        // 1> 判断 token 是否为nil
        guard let token = UserAccountViewModel.sharedUserAccount.accessToken else {
            return false
        }

        // 2> 判断参数字典是否有值
        if parameters == nil {
            parameters = [String: AnyObject]()
        }

        // 3> 设置 token
        parameters!["access_token"] = token

        return true
    }

    /// 使用 token 进行网络请求
    ///
    /// - parameter method:     GET / POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter finished:   完成回调
    private func tokenRequest(method: RequestMethod, URLString: String, var parameters: [String: AnyObject]?, finished: RequestCallBack) {

        // 1> 如果追加 token 失败，直接返回
        if !appendToken(&parameters) {
            finished(result: nil, error: NSError(domain: "com.itqls.error", code: -10001, userInfo: ["message": "token 为空"]))

            return
        }

        // 2. 发起网络请求
        request(method, URLString: URLString, parameters: parameters!, finished: finished)
    }
    


    // MARK: - 请求数据
    func request(method: RequestMethod, URLString: String, parameters:[String: AnyObject]?, finished: RequestCallBack) {

        // 定义请求成功的闭包
        let successCallBack = { (dataTask: NSURLSessionDataTask, result: AnyObject?)-> Void in
            finished(result:result, error:nil)
        }

        // 定义请求失败的闭包
        let failureCallBack = { (dataTask: NSURLSessionDataTask?, error: NSError)-> Void in
            print(error)
            finished(result: nil, error: error)
        }

        if method == .GET{
            GET(URLString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)

        }else{
            POST(URLString, parameters: parameters, progress:nil, success: successCallBack, failure: failureCallBack)
        }

    }


    /// 上传文件
    private func upload(URLString: String, data: NSData, name: String, var parameters: [String: AnyObject]?, finished: RequestCallBack) {

        // 1> 如果追加 token 失败，直接返回
        if !appendToken(&parameters) {
            finished(result: nil, error: NSError(domain: "cn.itcast.error", code: -1001, userInfo: ["message": "token 为空"]))

            return
        }

        /**
         1. data 要上传文件的二进制数据
         2. name 是服务器定义的字段名称 － 后台接口文档会提示
         3. fileName 是保存在服务器的文件名，但是：现在通常可以`乱写`，后台会做后续的处理
         - 根据上传的文件，生成 缩略图，中等图，高清图
         - 保存在不同路径，并且自动生成文件名

         - fileName 是 HTTP 协议定义的属性
         4. mimeType / contentType: 客户端告诉服务器，二进制数据的准确类型
         - 大类型/小类型
         * image/jpg image/gif image/png
         * text/plain text/html
         * application/json
         - 无需记忆
         - 如果不想告诉服务器准确的类型
         * application/octet-stream
         */
        POST(URLString, parameters: parameters, constructingBodyWithBlock: { (formData) -> Void in

            formData.appendPartWithFileData(data, name: name, fileName: "xxx", mimeType: "application/octet-stream")

            }, success: { (_, result) -> Void in
                finished(result: result, error: nil)
        }) { (_, error) -> Void in
            print(error)
            finished(result: nil, error: error)
        }
    }

//
//    // MARK: - 发送请求(上传文件)
//    func requestWithData(data:NSData, name:String, urlstring: String, parameters:[String:AnyObject]?,finished:RequestCallBack ){
//
//        // 定义请求成功的闭包
//        let successCallBack = { (dataTask: NSURLSessionDataTask, result: AnyObject?)-> Void in
//            finished(result:result, error:nil)
//        }
//
//        // 定义请求失败的闭包
//        let failureCallBack = { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
//            print(error)
//            finished(result: nil, error: error)
//        }
//
//        POST(urlstring, parameters: parameters, constructingBodyWithBlock: {
//            (formData) -> Void in
//             formData.appendPartWithFileData(data,name:name,fileName: "aa", mimeType: "application/octet-stream")
//            }, progress: nil, success: successCallBack, failure: failureCallBack)
//
//        }
}