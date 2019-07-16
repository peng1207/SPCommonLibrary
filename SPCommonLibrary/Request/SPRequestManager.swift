//
//  SPRequestManager.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/7/15.
//  Copyright © 2019 Peng. All rights reserved.
// 网络请求

import Foundation
import Alamofire

/// 链接错误
let SPREQUESTFAILURL = "failure_url"
/// 参数错误
let SPREQUESTFAILPARM = "failure_parm"
/// 请求的回调
typealias SPRequestComplete = (_ data : Any?, _ error : Error?,_ errorMsg : String?)->Void

class SPRequestManager {

    /// 请求对象
    public static let netManager : SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 60
        return Alamofire.SessionManager(configuration: configuration)
    }()
    /// 发起请求
    ///
    /// - Parameters:
    ///   - model: 请求参数
    ///   - complete: 回调
    class func sp_request(model : SPRequestModel,complete : SPRequestComplete?){
        guard let urlString = model.url else {
            sp_dealComplete(data: nil, error: nil, errorMsg: SPREQUESTFAILURL, complete: complete)
            return
        }
        guard let url = URL(string: urlString) else {
            sp_dealComplete(data: nil, error: nil, errorMsg: SPREQUESTFAILURL, complete: complete)
            return
        }
        var httpMethod : HTTPMethod = .post
        switch model.methond {
            case .get:
                httpMethod = .get
            case .post:
                httpMethod = .post
            case .put:
                httpMethod = .put
            case .head:
                httpMethod = .head
        }
        let dataRequest = netManager.request(url, method: httpMethod, parameters: model.parm, encoding: JSONEncoding.default, headers: nil)
        model.isRequest = true
        switch model.reponseFormat {
            case .json:
                dataRequest.responseJSON { (dataResponse : DataResponse<Any>) in
                    sp_dealReequest(dataResponse: dataResponse, model: model, complete: complete)
                }
            case .data:
                dataRequest.responseData { (dataResponse : DataResponse<Data>) in
                    model.isRequest = false
                        sp_dealComplete(data: dataResponse.result.value, error: dataResponse.error,errorMsg: nil, complete: complete)
                }
            case .string:
                dataRequest.responseString { (dataResponse : DataResponse) in
                    model.isRequest = false
                    sp_dealComplete(data: dataResponse.result.value, error: dataResponse.error,errorMsg: nil, complete: complete)
                }
        }
    }
    /// 处理请求后的回调
    ///
    /// - Parameters:
    ///   - dataResponse: 请求返回的数据
    ///   - model: 请求参数model
    ///   - complete: 回调
    private class func sp_dealReequest(dataResponse : DataResponse<Any>,model : SPRequestModel,complete : SPRequestComplete?){
        model.isRequest = false
        sp_dealComplete(data: dataResponse.result.value, error: dataResponse.error,errorMsg: nil, complete: complete)
    }
    /// 处理回调
    ///
    /// - Parameters:
    ///   - data: 数据
    ///   - error: 错误码
    ///   - complete: 回调
    private class func sp_dealComplete(data : Any?,error : Error?,errorMsg : String?,complete:SPRequestComplete?){
        guard let block = complete else {
            return
        }
        block(data,error,errorMsg)
    }
    ///  上传文件
    ///
    /// - Parameters:
    ///   - model: 参数
    ///   - complete: 回调
    class func sp_upload(model : SPUploadImageModel,complete : SPRequestComplete?){
        guard let urlString = model.url else {
            sp_dealComplete(data: nil, error: nil, errorMsg: SPREQUESTFAILURL, complete: complete)
            return
        }
        guard let url = URL(string: urlString) else {
             sp_dealComplete(data: nil, error: nil, errorMsg: SPREQUESTFAILURL, complete: complete)
            return
        }
        if sp_count(array: model.dataList) <= 0 {
             sp_dealComplete(data: nil, error: nil, errorMsg: SPREQUESTFAILPARM, complete: complete)
            return
        }
        model.isRequest = true
        netManager.upload(multipartFormData: { (formData) in
            if let parm : [String : Any] = model.parm {
                for (key,value) in parm {
                    let parmData = sp_getString(string: value).data(using: String.Encoding.utf8)
                    if let data = parmData{
                        formData.append(data, withName: sp_getString(string: key))
                    }
                }
            }
            for imageStruct in model.dataList! {
                if let data = imageStruct.data {
                    formData.append(data, withName: imageStruct.name, fileName: sp_getString(string: imageStruct.fileName), mimeType: sp_getString(string: imageStruct.mimeType))
                }
            }
        }, to: url) { (encodingResult) in
            switch encodingResult{
                case .failure(let encodingError):
                    model.isRequest = false
                    sp_dealComplete(data: nil, error: encodingError,errorMsg: nil, complete: complete)
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    upload.responseJSON(completionHandler: { (response) in
                        model.isRequest = false
                        sp_dealComplete(data: response.result.value, error: response.error,errorMsg: nil, complete: complete)
                    })
            }
        }
    }
    
}
