//
//  DHNetworkTool.swift
//  mx3app
//
//  Created by dh on 2022/11/10.
//

import UIKit
import MMKV
import Alamofire
import SwiftyJSON


public let body = "data"
public let code = "code"
public let errMsg = "msg"

public let errors = "errors"




struct HTTPResponse<T:Codable>: Codable {
    let code: Int
    let data: [T]
}



//定义一个自己的凭证（也就是后续需要用到的认证信息）
struct DHAuthCredential: AuthenticationCredential {
    let accessToken: String
    let expiration: Date
    
    // 这里我们在有效期即将过期的3分钟返回需要刷新
    var requiresRefresh: Bool { Date(timeIntervalSinceNow: 60 * 3) > expiration || accessToken.count == 0 }
}
//实现一个自己的授权中心
class DHAuthAuthenticator: Authenticator {
    /// 添加header
    func apply(_ credential: DHAuthCredential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }
    /// 实现刷新流程
    func refresh(_ credential: DHAuthCredential,
                 for session: Session,
                 completion: @escaping (Result<DHAuthCredential, Error>) -> Void) {
        let (token,exp) = DHJWTTool.genToken()
        let ac = DHAuthCredential(accessToken: token, expiration: exp)
        MMKV.default()?.set(token, forKey: "token")
        MMKV.default()?.set(exp, forKey: "exp")
        completion(Result.success(ac))
    }
    
    func didRequest(_ urlRequest: URLRequest,
                    with response: HTTPURLResponse,
                    failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 401
    }
    
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: DHAuthCredential) -> Bool {
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }
}




class DHNetworkTool: NSObject {
    
    static let shared = DHNetworkTool()
    
    var session:Session
    
    // Make sure the class has only one instance
    // Should not init or copy outside
    private override init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 60
        configuration.httpAdditionalHeaders = [
            "Content-Type": "application/json"
        ]
        
        // 生成授权凭证。用户没有登陆时，可以不生成。 App Store Connect API 允许最多20分钟
        let token = MMKV.default()?.string(forKey: "token") ?? ""
        let exp = MMKV.default()?.date(forKey: "exp") ?? Date()
        let credential = DHAuthCredential(accessToken: token, expiration: exp)
        
        // 生成授权中心
        let authenticator = DHAuthAuthenticator()
        // 使用授权中心和凭证（若没有可以不传）配置拦截器
        let interceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
        
        session = Session(configuration: configuration, interceptor: interceptor)
    }
    
    override func copy() -> Any {
        return self // SingletonClass.shared
    }
    
    override func mutableCopy() -> Any {
        return self // SingletonClass.shared
    }
    
    @objc static func del(_ url: String, params: [String:Any]=[:], headers: [String:String]=[:], callback: @escaping (String?, String) -> Void)   {
        
        let urlStr = "https://api.appstoreconnect.apple.com" + url
        // encoding： 对字典类型的参数编码  encoder： 对 Encodable 类型编码
        DHNetworkTool.shared.session.request(urlStr, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers)).responseString { resp in
            let strResp = NSString(data: resp.data ?? Data(), encoding: 4)
            let strParams = NSString(data: resp.request?.httpBody ?? Data(), encoding: 4)!
            let dataHeader = try? JSONSerialization.data(withJSONObject: resp.request?.allHTTPHeaderFields ?? [:])
            var strHeader = NSString(data: dataHeader ?? Data(), encoding: 4)!
            strHeader = strHeader.replacingOccurrences(of: "\\", with: "") as NSString
            print("\nurl: \(resp.request!.url!.absoluteURL)")
            print("\nheader: \(strHeader)")
            print("\nparams: \(strParams)")
            print("\ndata: \(strResp ?? "")\n")
            
            
            if resp.error != nil {
                callback(nil, resp.error?.localizedDescription ?? "")
                return
            }
            if((resp.value) != nil){
                callback(resp.value, "")
            }
        }
    }
    @objc static func patch(_ url: String, params: [String:Any]=[:], headers: [String:String]=[:], callback: @escaping (String?, String) -> Void)   {
        
        let urlStr = "https://api.appstoreconnect.apple.com" + url
        // encoding： 对字典类型的参数编码  encoder： 对 Encodable 类型编码
        DHNetworkTool.shared.session.request(urlStr, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers)).responseString { resp in
            let strResp = NSString(data: resp.data ?? Data(), encoding: 4)
            let strParams = NSString(data: resp.request?.httpBody ?? Data(), encoding: 4)!
            let dataHeader = try? JSONSerialization.data(withJSONObject: resp.request?.allHTTPHeaderFields ?? [:])
            var strHeader = NSString(data: dataHeader ?? Data(), encoding: 4)!
            strHeader = strHeader.replacingOccurrences(of: "\\", with: "") as NSString
            print("\nurl: \(resp.request!.url!.absoluteURL)")
            print("\nheader: \(strHeader)")
            print("\nparams: \(strParams)")
            print("\ndata: \(strResp ?? "")\n")
            
            
            if resp.error != nil {
                callback(nil, resp.error?.localizedDescription ?? "")
                return
            }
            if((resp.value) != nil){
                callback(resp.value, "")
            }
        }
    }
    @objc static func get(_ url: String, params: [String:Any]=[:], headers: [String:String]=[:], callback: @escaping (String?, String) -> Void)   {
        
        //       let urlStr = SMDomainRequestUrl(url)
        let urlStr = "https://api.appstoreconnect.apple.com" + url
        // encoding： 对字典类型的参数编码  encoder： 对 Encodable 类型编码
        DHNetworkTool.shared.session.request(urlStr, method: .get, parameters: params, encoding: URLEncoding.default, headers: HTTPHeaders(headers)).responseString { resp in //AFDataResponse<String>
            
            
            let strResp = NSString(data: resp.data ?? Data(), encoding: 4)
            let strParams = NSString(data: resp.request?.httpBody ?? Data(), encoding: 4)!
            let dataHeader = try? JSONSerialization.data(withJSONObject: resp.request?.allHTTPHeaderFields ?? [:])
            var strHeader = NSString(data: dataHeader ?? Data(), encoding: 4)!
            strHeader = strHeader.replacingOccurrences(of: "\\", with: "") as NSString
            print("\nurl: \(resp.request!.url!.absoluteURL)")
            print("\nheader: \(strHeader)")
            print("\nparams: \(strParams)")
            print("\ndata: \(strResp ?? "")\n")
            
            
            if resp.error != nil {
                callback(nil, resp.error?.localizedDescription ?? "")
                return
            }
            if((resp.value) != nil){
                callback(resp.value, "")
            }
        }
    }
    @objc static func post(_ url: String, params: [String:Any]=[:], headers: [String:String]=[:], callback: @escaping (String?, String) -> Void)   {
        
        //       let urlStr = SMDomainRequestUrl(url)
        let urlStr = "https://api.appstoreconnect.apple.com" + url
        // encoding： 对字典类型的参数编码  encoder： 对 Encodable 类型编码
        DHNetworkTool.shared.session.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers)).responseString { resp in //AFDataResponse<String>
            
            
            let strResp = NSString(data: resp.data ?? Data(), encoding: 4)
            let strParams = NSString(data: resp.request?.httpBody ?? Data(), encoding: 4)!
            let dataHeader = try? JSONSerialization.data(withJSONObject: resp.request?.allHTTPHeaderFields ?? [:])
            var strHeader = NSString(data: dataHeader ?? Data(), encoding: 4)!
            strHeader = strHeader.replacingOccurrences(of: "\\", with: "") as NSString
            print("\nurl: \(resp.request!.url!.absoluteURL)")
            print("\nheader: \(strHeader)")
            print("\nparams: \(strParams)")
            print("\ndata: \(strResp ?? "")\n")
            
            
            if resp.error != nil {
                callback(nil, resp.error?.localizedDescription ?? "")
                return
            }
            if((resp.value) != nil){
                //                let json = JSON(resp.value ?? "")
                //                let code = json[code].intValue
                //                if 301 == code {
                //                    MMKV.default()?.removeValue(forKey: "token")
                //                    MMKV.default()?.removeValue(forKey: localUser)
                //                    DHuserManager.shared.user = DHUserInfo()
                //
                //                    dhMainQueueAction {
                //                        let window = UIApplication.shared.keyWindow
                //                        window?.rootViewController = DHBaseNavigationController(rootViewController: DHInputMobileController())
                //                    }
                //                }else{
                callback(resp.value, "")
                //                }
            }
        }
    }
    
    //    static func post<T:Decodable>(_ url: String, params: [String:Any]=[:], headers: [String:Any]=[:], callback: @escaping (T?, String) -> Void)   {
    //        let headers: HTTPHeaders = [
    //            "Content-Type": "application/json"
    //        ]
    ////        headers.add(name: "", value: "")
    //        // encoding： 对字典类型的参数编码  encoder： 对 Encodable 类型编码
    //        DHNetworkTool.shared.session.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseDecodable(of: T.self) { resp in
    //
    //            let strResp = NSString(data: resp.data ?? Data(), encoding: 4)
    //            let strParams = NSString(data: resp.request!.httpBody ?? Data(), encoding: 4)!
    //            let dataHeader = try? JSONSerialization.data(withJSONObject: resp.request!.allHTTPHeaderFields!)
    //            var strHeader = NSString(data: dataHeader ?? Data(), encoding: 4)!
    //            strHeader = strHeader.replacingOccurrences(of: "\\", with: "") as NSString
    //            print("\nurl: \(resp.request!.url!.absoluteURL)")
    //            print("\nheader: \(strHeader)")
    //            print("\nparams: \(strParams)")
    //            print("\ndata: \(strResp ?? "")\n")
    //
    //
    //            if resp.error != nil {
    //                callback(nil, resp.error?.localizedDescription ?? "")
    //                return
    //            }
    //            if((resp.value) != nil){
    //                callback(resp.value, "")
    //            }
    //        }
    //    }
    
    //    @available(iOS 13.0.0, *)
    //    static func requestJSON<T: Decodable>(_ url: String, type: T.Type, method: HTTPMethod, parameters: Parameters? = nil) async throws -> T {
    //        return try await DHNetworkTool.shared.session.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default).serializingDecodable().value
    //      }
    
    // MARK: - Bundles
    static func getBundleIds(_ callback:@escaping (([DHBundleIDModel]?, String)->Void)) {
        self.get("/v1/bundleIds") { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let list = [DHBundleIDModel].deserialize(from: data, designatedPath: body) as? [DHBundleIDModel]
                    callback(list, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    static func modifyBundleId(_ bid:String,params:[String:Any], callback:@escaping ((DHBundleIDModel?, String)->Void)) {
        self.patch("/v1/bundleIds/"+bid, params: params) { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let info = DHBundleIDModel.deserialize(from: data, designatedPath: body)
                    callback(info, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    static func delBundleId(_ bid:String, callback:@escaping ((Bool, String)->Void)) {
        self.del("/v1/bundleIds/"+bid) { dataStr, msg in
            if let data = dataStr  {
                delCallback(data, callback: callback)
            }else{
                callback(false, msg)
            }
        }
    }
    static func addBundleId(_ params:[String:Any], callback:@escaping ((DHBundleIDModel?, String)->Void)) {
        self.post("/v1/bundleIds", params: params) { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let info = DHBundleIDModel.deserialize(from: data, designatedPath: body)
                    callback(info, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    
    static func getBundleIdProfile(_ bid:String, callback:@escaping (([DHProfileModel]?, String)->Void)) {
        self.get("/v1/bundleIds/\(bid)/profiles") { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let list = [DHProfileModel].deserialize(from: data, designatedPath: body) as? [DHProfileModel]
                    callback(list, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    
    static func getBundleIdCapabilities(_ bid:String, callback:@escaping (([DHCapabilitiesModel]?, String)->Void)) {
        self.get("/v1/bundleIds/\(bid)/bundleIdCapabilities") { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let list = [DHCapabilitiesModel].deserialize(from: data, designatedPath: body) as? [DHCapabilitiesModel]
                    callback(list, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    
    static func addBundleIdCapability(_ params:[String:Any], callback:@escaping ((DHCapabilitiesModel?, String)->Void)) {
        self.post("/v1/bundleIdCapabilities",params: params) { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let info = DHCapabilitiesModel.deserialize(from: data, designatedPath: body)
                    callback(info, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    
    static func delBundleIdCapability(_ cid:String, params:[String:Any], callback:@escaping ((Bool, String)->Void)) {
        self.del("/v1/bundleIdCapabilities/\(cid)",params: params) { dataStr, msg in
            if let data = dataStr {
                delCallback(data, callback: callback)
            }else{
                callback(false, msg)
            }
        }
    }
    
    // MARK: - Certificates
    static func getCertificates(_ filter:String?="", _ callback:@escaping (([DHCertificateModel]?, String)->Void)) {
        self.get("/v1/certificates\(filter ?? "")") { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let list = [DHCertificateModel].deserialize(from: data, designatedPath: body) as? [DHCertificateModel]
                    callback(list, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    static func revokeCertificate(_ cid:String, callback:@escaping ((Bool, String)->Void)) {
        self.del("/v1/certificates/\(cid)") { dataStr, msg in
            if let data = dataStr {
                delCallback(data, callback: callback)
            }else{
                callback(false, msg)
            }
        }
    }
    static func addCertificate(_ params:[String:Any], callback:@escaping ((DHCertificateModel?, String)->Void)) {
        self.post("/v1/certificates",params: params) { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let info = DHCertificateModel.deserialize(from: data, designatedPath: body)
                    callback(info, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    
    // MARK: - Devices
    static func getDevices(_ callback:@escaping (([DHDecivesModel]?, String)->Void)) {
        self.get("/v1/devices?limit=200") { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let list = [DHDecivesModel].deserialize(from: data, designatedPath: body) as? [DHDecivesModel]
                    callback(list, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    static func addDevices(_ params:[String:Any], callback:@escaping ((DHDecivesModel?, String)->Void)) {
        self.post("/v1/devices",params: params) { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let info = DHDecivesModel.deserialize(from: data, designatedPath: body)
                    callback(info, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    
    static func modifyDevice(_ did:String,params:[String:Any], callback:@escaping ((DHDecivesModel?, String)->Void)) {
        self.patch("/v1/devices/"+did, params: params) { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let info = DHDecivesModel.deserialize(from: data, designatedPath: body)
                    callback(info, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    
    // MARK: - Profiles
    static func getProfiles(_ callback:@escaping (([DHProfileModel]?, String)->Void)) {
        self.get("/v1/profiles?limit=200") { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let list = [DHProfileModel].deserialize(from: data, designatedPath: body) as? [DHProfileModel]
                    callback(list, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    
    static func delProfile(_ pid:String, callback:@escaping ((Bool, String)->Void)) {
        self.del("/v1/profiles/\(pid)") { dataStr, msg in
            if let data = dataStr {
                delCallback(data, callback: callback)
            }else{
                callback(false, msg)
            }
        }
    }
    
    static func getProfileBid(_ pid:String, callback:@escaping ((DHBundleIDModel?, String)->Void)) {
        self.get("/v1/profiles/\(pid)/bundleId") { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let list = DHBundleIDModel.deserialize(from: data, designatedPath: body)
                    callback(list, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    
    static func getProfileDevices(_ pid:String, callback:@escaping (([DHDecivesModel]?, String)->Void)) {
        self.get("/v1/profiles/\(pid)/devices?limit=200") { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let list = [DHDecivesModel].deserialize(from: data, designatedPath: body) as? [DHDecivesModel]
                    callback(list, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    
    static func getProfileCertificates(_ pid:String, callback:@escaping (([DHCertificateModel]?, String)->Void)) {
        self.get("/v1/profiles/\(pid)/certificates?limit=200") { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let list = [DHCertificateModel].deserialize(from: data, designatedPath: body) as? [DHCertificateModel]
                    callback(list, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    
    static func addProfile(_ params:[String:Any], callback:@escaping ((DHProfileModel?, String)->Void)) {
        self.post("/v1/profiles",params: params) { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let info = DHProfileModel.deserialize(from: data, designatedPath: body)
                    callback(info, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
    
    
    // MARK: - Users
    static func getUsers(_ callback:@escaping (([DHUserModel]?, String)->Void)) {
        self.get("/v1/users?limit=200") { dataStr, msg in
            if let data = dataStr, data.hasPrefix("{") {
                if data.contains(errors) {
                    let errStr = errStr(data)
                    callback(nil, errStr)
                }else{
                    let list = [DHUserModel].deserialize(from: data, designatedPath: body) as? [DHUserModel]
                    callback(list, "")
                }
            }else{
                callback(nil, msg)
            }
        }
    }
//    static func addDevices(_ params:[String:Any], callback:@escaping ((DHDecivesModel?, String)->Void)) {
//        self.post("/v1/devices",params: params) { dataStr, msg in
//            if let data = dataStr, data.hasPrefix("{") {
//                if data.contains(errors) {
//                    let errStr = errStr(data)
//                    callback(nil, errStr)
//                }else{
//                    let info = DHDecivesModel.deserialize(from: data, designatedPath: body)
//                    callback(info, "")
//                }
//            }else{
//                callback(nil, msg)
//            }
//        }
//    }
//    
//    static func modifyDevice(_ did:String,params:[String:Any], callback:@escaping ((DHDecivesModel?, String)->Void)) {
//        self.patch("/v1/devices/"+did, params: params) { dataStr, msg in
//            if let data = dataStr, data.hasPrefix("{") {
//                if data.contains(errors) {
//                    let errStr = errStr(data)
//                    callback(nil, errStr)
//                }else{
//                    let info = DHDecivesModel.deserialize(from: data, designatedPath: body)
//                    callback(info, "")
//                }
//            }else{
//                callback(nil, msg)
//            }
//        }
//    }
    
    
    //
    //    static func getConfig() -> DHConfigInfo {
    //        let str = MMKV.default()?.string(forKey: localConfig) ?? ""
    //        if str.count > 0{
    //            let model = DHConfigInfo.deserialize(from: str)!
    //            return model
    //        }else{
    //            let path = Bundle.main.path(forResource: "config.json", ofType: nil)!
    //            let str = try! String(contentsOfFile: path, encoding: .utf8)
    //            let model = DHConfigInfo.deserialize(from: str, designatedPath: body)!
    //            return model
    //        }
    //    }
    //    /// 发送验证码
    //    static func sendCode(_ params:[String:Any], callback:@escaping ((Bool, Bool, String)->Void)) {
    //        self.post("/home/loadCode", params: params) { dataStr, msg in
    //            if let str = dataStr{
    //                let json = JSON(parseJSON: str)
    //                let status = json[code].intValue
    //                let isNew = json[body]["isNew"].boolValue
    //                if 0 == status {
    //                    dhMainQueueAction {
    //                        callback(true, isNew, "")
    //                    }
    //                } else {
    //                    let str = json[errMsg].stringValue
    //                    dhMainQueueAction {
    //                        callback(false, false, str)
    //                    }
    //                }
    //
    //            }else{
    //                dhMainQueueAction {
    //                    callback(false, false, msg)
    //                }
    //            }
    //        }
    //    }
    //    /// 验证码登录
    //    static func codeLogin(_ params:[String:Any], callback:@escaping (Bool, Bool, Bool, String)->Void) {
    //        self.post("/home/loginByCode", params: params) { dataStr, msg in
    //
    //            if let str = dataStr{
    //                let json = JSON(parseJSON: str)
    //                let status = json[code].intValue
    //                let isNew = json[body]["isNew"].boolValue
    //                let canPwd = json[body]["canPwd"].boolValue
    //                let token = json[body]["token"].stringValue
    //                if token.count > 0 {
    //                    MMKV.default()?.set(token, forKey: "token")
    //                }
    //                if 0 == status {
    //                    dhMainQueueAction {
    //                        callback(true, isNew, canPwd, "")
    //                    }
    //                } else {
    //                    let errMsg = json[errMsg].stringValue
    //                    dhMainQueueAction {
    //                        callback(false, false, false, errMsg)
    //                    }
    //                }
    //
    //            }else{
    //                dhMainQueueAction {
    //                    callback(false, false, false, msg)
    //                }
    //            }
    //        }
    //    }
    //
    //    /// 获取本地保存的用户信息
    //    static func getUser() -> DHUserInfo {
    //        if let infoStr = MMKV.default()?.string(forKey: localUser) {
    //            let info = DHUserInfo.deserialize(from: infoStr)!
    //            return info
    //        }else{
    //            return DHUserInfo()
    //        }
    //    }
    //    ///获取用户信息
    //    static func loadUserInfo(_ params:[String:Any], callback:@escaping (Bool, String)->Void) {
    //        self.post("/user/loanUserInfo") { dataStr, msg in
    //            if let data = dataStr, data.hasPrefix("{"){
    //                let userInfo = DHUserInfo.deserialize(from: data, designatedPath: body)!
    //                let userStr = userInfo.toJSONString()!
    //                MMKV.default()?.set(userStr, forKey: localUser)
    //                DHuserManager.shared.user = userInfo
    //                let json = JSON(parseJSON: data)
    //                let code = json[code].intValue
    //                let errMsg = json[errMsg].stringValue
    //                if 0 == code {
    //                    dhMainQueueAction {
    //                        callback(true, "")
    //                    }
    //                }else {
    //                    dhMainQueueAction {
    //                        callback(false, errMsg)
    //                    }
    //                }
    //            }else{
    //                dhMainQueueAction {
    //                    callback(false, msg)
    //                }
    //            }
    //        }
    //    }
    //    /// 退登
    //    static func logout(_ callback:@escaping(Bool, String)->Void) {
    //        self.post("/home/logout") { dataStr, msg in
    //            if let data = dataStr, data.hasPrefix("{"){
    //                let json = JSON(parseJSON: data)
    //                let code = json[code].intValue
    //                let errMsg = json[errMsg].stringValue
    //                if 0 == code {
    //                    MMKV.default()?.removeValue(forKey: "token")
    //                    MMKV.default()?.removeValue(forKey: localUser)
    //                    DHuserManager.shared.user = DHUserInfo()
    //
    //                    dhMainQueueAction {
    //                        let window = UIApplication.shared.keyWindow
    //                        window?.rootViewController = DHBaseNavigationController(rootViewController: DHInputMobileController())
    //                        callback(true, "")
    //                    }
    //                }else {
    //                    dhMainQueueAction {
    //                        callback(false, errMsg)
    //                    }
    //                }
    //            }else{
    //                dhMainQueueAction {
    //                    callback(false, msg)
    //                }
    //            }
    //        }
    //    }
    //
    //    ///  获取Hint数据
    //    static func loadHomeHintList(_ callback:@escaping ([DHHintInfo?]?, String)->Void){
    //        self.post("/home/loadHintList") { dataStr, msg in
    //            if let data = dataStr, data.hasPrefix("{"){
    //                let json = JSON(parseJSON: data)
    //                let code = json[code].intValue
    //                let errMsg = json[errMsg].stringValue
    //                if 0 == code {
    //                    let arr = [DHHintInfo].deserialize(from: data, designatedPath: body)
    //                    dhMainQueueAction {
    //                        callback(arr, "")
    //                    }
    //                }else {
    //                    dhMainQueueAction {
    //                        callback(nil, errMsg)
    //                    }
    //                }
    //            }else{
    //                dhMainQueueAction {
    //                    callback(nil, msg)
    //                }
    //            }
    //        }
    //    }
    //    /// 首页banner
    //    static func loadHomeBannerList(_ callback:@escaping ([DHBannerInfo?]?, String)->Void){
    //        self.post("/home/loadBannerList") { dataStr, msg in
    //            if let data = dataStr, data.hasPrefix("{"){
    //                let json = JSON(parseJSON: data)
    //                let code = json[code].intValue
    //                let errMsg = json[errMsg].stringValue
    //                if 0 == code {
    //                    let arr = [DHBannerInfo].deserialize(from: data, designatedPath: body)!
    //                    dhMainQueueAction {
    //                        callback(arr, "")
    //                    }
    //                }else {
    //                    dhMainQueueAction {
    //                        callback(nil, errMsg)
    //                    }
    //                }
    //            }else{
    //                dhMainQueueAction {
    //                    callback(nil, msg)
    //                }
    //            }
    //        }
    //    }
    //
    //    /// 获取最新一笔订单
    //    static func loadLastOrder(_ callback:@escaping (DHLastOrderInfo?, String)->Void) {
    //        self.post("/apply/loadLastOrder") { dataStr, msg in
    //            if let data = dataStr, data.hasPrefix("{"){
    //                let json = JSON(parseJSON: data)
    //                let code = json[code].intValue
    //                let errMsg = json[errMsg].stringValue
    //                if 0 == code {
    //                    let info = DHLastOrderInfo.deserialize(from: data, designatedPath: body)!
    //                    dhMainQueueAction {
    //                        callback(info, "")
    //                    }
    //                }else {
    //                    dhMainQueueAction {
    //                        callback(nil, errMsg)
    //                    }
    //                }
    //            }else{
    //                dhMainQueueAction {
    //                    callback(nil, msg)
    //                }
    //            }
    //        }
    //    }
}
