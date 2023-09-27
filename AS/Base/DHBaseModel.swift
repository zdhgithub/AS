//
//  DHBaseModel.swift
//  Prestapronto
//
//  Created by dh on 2023/3/9.
//

import UIKit
import HandyJSON

class HandyBaseModel: HandyJSON {
    required init() {}
    func mapping(mapper: HelpingMapper) {   //自定义解析规则，日期数字颜色，如果要指定解析格式，子类实现重写此方法即可
    //        mapper <<<
    //            date <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd")
    //
    //        mapper <<<
    //            decimal <-- NSDecimalNumberTransform()
    //
    //        mapper <<<
    //            url <-- URLTransform(shouldEncodeURLString: false)
    //
    //        mapper <<<
    //            data <-- DataTransform()
    //
    //        mapper <<<
    //            color <-- HexColorTransform()
          }
}

class DHLinks:HandyBaseModel{
    var links:DHUrl!
}

class DHUrl:HandyBaseModel{
    var url:String = ""
    var related:String = ""
    
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            url <-- "self"
    }
}

//class DHBaseModel<A,R>: HandyBaseModel where A:HandyJSON, R:HandyJSON  {
class DHBaseModel: HandyBaseModel {
    var id:String=""
    var type:String=""
    //是否选中
    var sel:Bool = false
}
