//
//  DHSSLTool.swift
//  AS
//
//  Created by dh on 2023/9/25.
//

import UIKit
import OpenSSL

class DHSSLTool: NSObject {
    // https://stackoverflow.com/questions/26883342/ios-how-to-create-pkcs12-p12-keystore-from-private-key-and-x509certificate-in
    static func createP12(pemCertificate: String, pemPrivateKey: String, namep12:String, exportCer:@escaping ()->()) -> URL? {
        
//        let head = "-----BEGIN CERTIFICATE REQUEST-----\n"
//        let foot = "-----END CERTIFICATE REQUEST-----\n"
        
        let cerS = "-----BEGIN CERTIFICATE-----"
        let cerE = "-----END CERTIFICATE-----"
        
        let keyS = "-----BEGIN PRIVATE KEY-----"
        let keyE = "-----END PRIVATE KEY-----"
//         let pemPrivateKey = "-----BEGIN RSA PRIVATE KEY-----\n\(secPrivateKeyBase64)\n-----END RSA PRIVATE KEY-----\n"
        // Read certificate
        let buffer = BIO_new(BIO_s_mem())
        var pemCer = pemCertificate
        if(!pemCer.hasPrefix(cerS)){
            pemCer = "\(cerS)\n\(pemCer)\n\(cerE)\n"
        }
        pemCer.data(using: .utf8)!.withUnsafeBytes({ (bytes: UnsafePointer<Int8>) -> Void in
            BIO_puts(buffer, bytes)
        })
        let certificate = PEM_read_bio_X509(buffer, nil, nil, nil)
        X509_print_fp(stdout, certificate)
        
        // Read private key
        var pemPri = pemPrivateKey
        if(!pemPri.hasPrefix(keyS)){
            pemPri = "\(keyS)\n\(pemPri)\n\(keyE)\n"
        }
        let privateKeyBuffer = BIO_new(BIO_s_mem())
        pemPri.data(using: .utf8)!.withUnsafeBytes({ (bytes: UnsafePointer<Int8>) -> Void in
            BIO_puts(privateKeyBuffer, bytes)
        })
        let privateKey = PEM_read_bio_PrivateKey(privateKeyBuffer, nil, nil, nil)
        PEM_write_PrivateKey(stdout, privateKey, nil, nil, 0, nil, nil)
        // Check if private key matches certificate
        guard X509_check_private_key(certificate, privateKey) == 1 else {
            NSLog("Private key does not match certificate")
//            dhShowErr("该证书不是你创建的，不能导出p12文件")
            ZWTAlertController.showAlert(withTitle: "", message: "该证书不是你创建的，不能导出p12文件,是否导出CER？", textAlignment: .center, titleArray: ["取消", "导出CER"]) { idx in
                if 1 == idx{
                    exportCer()
                }else{
                    
                }
            }
            return nil
        }
        // Set OpenSSL parameters
//        OPENSSL_add_all_algorithms_noconf()
//        ERR_load_crypto_strings()
        // Create P12 keystore
        let passPhrase = UnsafeMutablePointer(mutating: ("123456" as NSString).utf8String)
        let name = UnsafeMutablePointer(mutating: ("SSL Certificate" as NSString).utf8String)
        guard let p12 = PKCS12_create(passPhrase, name, privateKey, certificate, nil, 0, 0, 0, 0, 0) else {
            NSLog("Cannot create P12 keystore:")
            ERR_print_errors_fp(stderr)
            return nil
        }
        // Save P12 keystore
        let fileManager = FileManager.default
        let tempDirectory = NSTemporaryDirectory() as NSString
        let path = tempDirectory.appendingPathComponent("\(namep12).p12")
        fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        guard let fileHandle = FileHandle(forWritingAtPath: path) else {
            NSLog("Cannot open file handle: \(path)")
            return nil
        }
        let p12File = fdopen(fileHandle.fileDescriptor, "w")
        i2d_PKCS12_fp(p12File, p12)
        fclose(p12File)
        fileHandle.closeFile()
        
        let p12Url = NSURL(fileURLWithPath: path) as URL
        return p12Url
    }

}
