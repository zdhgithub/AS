//
//  DHJWTTool.swift
//  AS
//
//  Created by dh on 2023/9/19.
//

import UIKit
import SwiftJWT
import MMKV

class DHJWTTool: NSObject {

    static func genToken() -> (token:String, date:Date){
        struct ASClaims: Claims {
            let iss: String
            let iat: Date
            let exp: Date
            let aud: String
//            let scope:[String]
        }
        
        let str = MMKV.default()?.string(forKey: "account")
        let infos = [DHAccountModel].deserialize(from: str) as? [DHAccountModel]
        if let infos = infos{
            let info = infos.first { acm in
                acm.sel == 1
            }
            if let info = info {
                //最多申请20分钟的
                let myHeader = Header(kid: info.p8keyId)
                let exp = Date(timeIntervalSinceNow: 60*20)
                let myClaims = ASClaims(iss: info.issuserId, iat: Date(), exp: exp, aud: "appstoreconnect-v1")
                var myJWT = JWT(header: myHeader, claims: myClaims)

//                let privateKeyPath = URL(fileURLWithPath: Bundle.main.path(forResource: "AuthKey_QCF8Y8LV2V.p8", ofType: nil)!)
//                let privateKey: Data = try! Data(contentsOf: privateKeyPath, options: .alwaysMapped)
                let privateKey: Data = info.p8keyContent.data(using: .utf8)!
                
                let jwtSigner = JWTSigner.es256(privateKey: privateKey)
                let signedJWT = try! myJWT.sign(using: jwtSigner)
                
                print(signedJWT)
                return (signedJWT, exp)
            }else{
                return ("", Date())
            }
        }else{
            return ("", Date())
        }
    }
    
}
