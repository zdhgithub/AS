//
//  DHJSTool.swift
//  JWTDemo
//
//  Created by dh on 2023/9/25.
//

import UIKit
import JavaScriptCore

/*
 let privateKeyPem = "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDwd49n/ZXxKUlA\nwrjSqa7v4tuDIJQ9J/+0KedRrjXGToHLjq20hKFFLP5UgSTcaunP7DSV6W9F3QjV\nH+pkk2exwugqeY3ePisHhDzQGIdUA64RtnwnH17MZZP0SOuqiM+K8elR4Fv2M7VF\nHWkiG+Imo1e6EY9D7QnhA7gK8ViULB4OOn8cbWVuuH5GoYnq78EKJbuzhJLGH5La\nl3YUzXzp7A3dod5z0CD9nG4u56bA5xnPQ9AfDEr2F+eRi5Bpxifg8IHMg+1MsPx3\n04llVWoAECHc8QHLmC7mNSDKxfZrnDNc1qOWzllHXjAD4QXzfiNFCWCc+TXS5yF5\npBoPqdFfAgMBAAECggEANMliKydRK4PvJy63qNMD6ngHzPSxZe1qZe/O7jDKcDJa\nrscu3ZJB3rAeUomZAGPd2L1W29PHD/SSFErxxstO94g8M9rEKFXIV1mRifLgfjJi\nm1POVD5ALqlbvcPmK+TlfnBVUhpoxZabQ8VNh2XMksPHpbpmEzitMv6Af7J0Se4q\naQ+OjBWlaCbqx0W62vtWP/ESv5eygLp9EchnaiVaIViTX+CWtWkzj2UrjQ1wlA3J\nq91BEQbQ31Vwq9anser1JZmm4FDLdwasuKUGl5YHaHKsC0jAHMeq393TlxwNhWKA\nfcsMlr+VM5JKwljCkjJNEZOGHuW3Ajg0U+BwX1IpZQKBgQD6mKYwWIEBh+2dbQSn\nXVBaLaEpLn9C7eB8Y6ZU5cbHMyY0x8hDDBp6j0ToJP9rbKOsCqXEhUyRyLk+NW5F\nVyeB9l3yfAEEuzBfHKpWnV6OtdIjorT9J5bAG6lpWtv3DTmQMniK3zmv3w8IM6Dt\nrMt/K9DHCOOTOnwCi5RrZqRX1QKBgQD1pv7AkTk6FEmDiprztlL2KgQQ9s7yt/5/\nWWdRIUZ2Y4tjptJ4Tjh5ushlEgxcb5SMukn8StdrIMiVP0OIb4WZ6/taEK35l4qH\n2s4atAX/8m8Y1wHeH75IWsQrlS6XxTyjtj19hHaLpwISq9MkDEfntfP7IQvXSTPe\nQSgZyYNyYwKBgE24pmJ8MJau981JkJXv5Qny+PbyytmROXya022lTj9d582a4Mua\np2O3p6FwSB+jNCgZrUwEI7lbTcizfZ3X6BLwvDaGqzIydFArbdErQbZ1QdV3kzao\n3qJ6cdKRMYOwAFhuruAzV4rqXZknmhPc8chhaIEyipKRIwEPFVsyHGp5AoGAJ3Nr\nREfOVfp+F+cBnZQxXKFAx+yrLaXI9HDKO+hJJag08YsQEAwX28zYdAri+1FcHQGp\n8h+e2vCH5hgj41xtq1uPoVY+anAg6lKEeRtiP0mS9/1HqoGUkJArIwixU+R0KaKR\n23+TfjgTCCaaIRbr0VWSWkljWm7CKrZyFzoapxsCgYEA5YhXi6zaHPqd4FcY9D2f\n5jYHnBKJipshbPAIOE0/tpjyniAuj/ZUBDZFqm5NLi1ppC/hFFbFonlaCOjcRDqQ\nUG8EJFRG3EqKzHw3vw3V3cQBE7BCf5PDcAO/R6zw2lOac5f3SmcRI0WysLERb0IE\nNrj7sKI5QZmcixYyG9G3eao=\n-----END PRIVATE KEY-----\n";
 
 let cerBase64 = "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";
 let certDer = forge.util.decode64(cerBase64);
 var certAsn1 = forge.asn1.fromDer(certDer)
 var cert = forge.pki.certificateFromAsn1(certAsn1);

 console.log('serialNumber: '+cert.serialNumber);
 console.log('version: '+cert.version);
 console.log('publicKey: '+cert.publicKey);

 var privateKey = pki.privateKeyFromPem(privateKeyPem);
 var p12Asn1 = forge.pkcs12.toPkcs12Asn1(privateKey, cert, '123456',{algorithm: '3des'});
 console.log('p12Asn1: '+p12Asn1);

 // base64-encode p12
 var p12Der = forge.asn1.toDer(p12Asn1).getBytes();
 var p12b64 = forge.util.encode64(p12Der);

 // console.log('p12Der: ' + p12Der);

 console.log('p12b64: ' + p12b64);
 */

class DHJSTool: NSObject {

    private let forge: JSValue
    
    public init?(forgePath: String? = nil) {
        let jsContext = JSContext()!
        let window = JSValue(newObjectIn: jsContext)
        jsContext.setObject(window, forKeyedSubscript: "window" as NSString)

        guard let hgPath = forgePath ?? Bundle.main.path(forResource: "forge.min.js", ofType: nil) else {
            return nil
        }

        
        let hgJs = try! String.init(contentsOfFile: hgPath)
        let value = jsContext.evaluateScript(hgJs)
        if value?.toBool() != true {
            return nil
        }
        //window?.objectForKeyedSubscript("forge").toDictionary()
        guard let hljs = window?.objectForKeyedSubscript("forge") else {
            return nil
        }
        self.forge = hljs
    }
    
    func cer2p12(privateKeyPem:String, cerBase64:String) -> String {
        
//        let certDer = forge.util.decode64(cerBase64);
//        var certAsn1 = forge.asn1.fromDer(certDer)
//        var cert = forge.pki.certificateFromAsn1(certAsn1);
        
        let util = forge.objectForKeyedSubscript("util")!
        let cerDer = util.invokeMethod("decode64", withArguments: [cerBase64])!
        
        let asn1 = forge.objectForKeyedSubscript("asn1")!
        let certAsn1 = asn1.invokeMethod("fromDer", withArguments: [cerDer])!
        
        let pki  = forge.objectForKeyedSubscript("pki")!
        let cert = pki.invokeMethod("certificateFromAsn1", withArguments: [certAsn1])!
        let serialNumber = cert.objectForKeyedSubscript("serialNumber")
        
//        var privateKey = pki.privateKeyFromPem(privateKeyPem);
//        var p12Asn1 = forge.pkcs12.toPkcs12Asn1(privateKey, cert, '123456',{algorithm: '3des'});
        let privateKey = pki.invokeMethod("privateKeyFromPem", withArguments: [privateKeyPem])!
        
        let pkcs12 = forge.objectForKeyedSubscript("pkcs12")!
        let p12Asn1 = pkcs12.invokeMethod("toPkcs12Asn1", withArguments: [privateKey, cert, "123456", ["algorithm":"3des"]])!
        
//        var p12Der = forge.asn1.toDer(p12Asn1).getBytes();
//        var p12b64 = forge.util.encode64(p12Der);
        
        let p12Der = asn1.invokeMethod("toDer", withArguments: [p12Asn1]).invokeMethod("getBytes", withArguments: [])!
        let p12B64 = util.invokeMethod("encode64", withArguments: [p12Der])!
        
        return p12B64.toString()
    }
}
