//
//  DHJsonTool.swift
//  AS
//
//  Created by dh on 2023/9/20.
//

import UIKit
import HandyJSON

class DHJsonTool:NSObject{
    
    /**  String ---> T  */
    static func toModel<T:HandyJSON>(_ jsonStr:String,_ modelType:T.Type) ->T? {
        if jsonStr == "" ||  jsonStr.count == 0{
            return nil
        }
        return T.deserialize(from: jsonStr)
    }
    
    /**  Any ---> T  */
    static func toModel<T:HandyJSON>(_ data:AnyObject?,_ modelType:T.Type) ->T? {
        if let dic = data as? [String:Any] {
            return T.deserialize(from: dic)
        }
        return nil
    }
    
    /**  Dic ---> T  */
    static func toModel<T:HandyJSON>(_ dic:[String:Any],_ modelType:T.Type) ->T?  {
        return T.deserialize(from: dic)
    }
    
    /**  Any ---> [T]  */
    static func toModelArray<T:HandyJSON>(_ data:AnyObject?) ->[T]? {
        if let dic = data as? [Any] {
            return [T].deserialize(from: dic) as? [T]
        }
        return nil
    }
    
    /**  String ---> [T]  */
    public static func toModelArray<T:HandyJSON>(_ JSONString:String)throws-> [T]? {
        guard let jsonData = JSONString.data(using: .utf8)else{
            return nil
        }
        if let array = try? JSONSerialization.jsonObject(with:jsonData, options: JSONSerialization.ReadingOptions()) as? [AnyObject] {
            return  DHJsonTool.toModelArray(array as AnyObject) ?? nil
        }
        return nil
    }
    
    /** 对象转JSON */
    static func modelToJson(_ model:HandyBaseModel?) -> String{
        if model == nil {
            //        print(MapError.modelToJsonFailed)
            return ""
        }
        return(model?.toJSONString())!
    }
    
    /** 对象转字典 */
    static func modelToDictionary(_ model:HandyBaseModel?) -> [String:Any] {
        if model == nil{
            //        print(MapError.modelToJsonFailed)
            return [:]
        }
        return(model?.toJSON())!
    }
}
