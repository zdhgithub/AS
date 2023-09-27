//
//  DHCerController.swift
//  AS
//
//  Created by dh on 2023/9/21.
//

import UIKit

/*  https://open-ssl.cn/index/detail/183.html
 //生成自定义.key 私钥
 openssl genrsa -out xxx.key 2048
 //生成RSA公钥 openssl rsa -in xxx.key -pubout -out rsa_public_key.pem

   
 //输出证书注册文件
 openssl req -new -sha256 -key xxx.key -out xxx.csr -subj "/emailAddress=xxxxxxxx@163.com"
 //生成证书 openssl x509 -req -days 365 -in xxx.csr -signkey xxx.key -out cert.crt
   
 //生成pem文件
 openssl x509 -in xxxx.cer -inform DER -out xxxx.pem -outform PEM
   
 //生成p12证书，并设置证书密码
 //如果用mac电脑生成，为了兼容旧版本，可以加-legacy参数
 //openssl pkcs12 -legacy -export -inkey xxx.key -in xxxx.pem -out xxxx.p12 -password pass:123456
 openssl pkcs12 -export -inkey xxx.key -in xxxx.pem -out xxxx.p12 -password pass:123456

 //验证p12证书
 //openssl pkcs12 -legacy -in ios_development.p12 -info
 openssl pkcs12 -in ios_development.p12 -info

 //查看P12证书有效期
 openssl pkcs12 -in ios_development.p12 -clcerts -nodes | openssl x509 -noout -enddate

 //获取证书的序列号和subject
 openssl x509 -in ios_development.cer -noout -serial -subject

 //RSA由私钥文件获取公钥文件
 openssl rsa -in xxx.key -pubout -out xxx_pub.key
 */

class DHCerController: DHBaseViewController {
    
    lazy var tableView:DHBaseTableView = {
        let view = DHBaseTableView()
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 44
        view.sectionHeaderHeight = CGFLOAT_MIN
        view.sectionFooterHeight = CGFLOAT_MIN
        view.dataSource = self
        view.delegate = self
        view.register(UINib(nibName: "DHOneTxtCell", bundle: nil), forCellReuseIdentifier: DHOneTxtCell.description())
        view.tableFooterView = UIView()
        view.mj_header = ZWTRefreshHeader(refreshingBlock: {[weak self] in
            self?.loadDatas()
        })
        return view
    }()
    
    lazy var datas:[DHCertificateModel] = {
        return [DHCertificateModel]()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDatas()
        prepareUI()
    }
    
    func prepareUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: dhNavStatusHeight, left: 0, bottom: 0, right: 0))
        }
        zwt_setRightBarItems(byTitle: "添加", titleColor: dhColorMain, target: self, action: #selector(self.create))
        
//        let add = dh_setRightBarItems(byTitle: "添加", titleColor: dhColorMain, target: self, action: #selector(self.create))!
//        let exportKey = dh_setRightBarItems(byTitle: "导出key", titleColor: dhColorMain, target: self, action: #selector(self.exportKey))!
//        navigationItem.rightBarButtonItems = [add, exportKey]
    }
    
    @objc func exportKey() {
//        let keypath = Bundle.main.path(forResource: "13mini.key", ofType: nil)!
//        let keyUrl = NSURL(fileURLWithPath: keypath) as URL
//        presentSystemShareContent(nil, image: nil, linkURL: keyUrl, data: nil) { type, ret, items, err in
//            debugPrint("")
//        }
        
        
//        let base64P12 = "MIIMCgIBAzCCC9AGCSqGSIb3DQEHAaCCC8EEggu9MIILuTCCBnAGCSqGSIb3DQEHAaCCBmEEggZdMIIGWTCCBlUGCyqGSIb3DQEMCgEDoIIGHTCCBhkGCiqGSIb3DQEJFgGgggYJBIIGBTCCBgEwggTpoAMCAQICEFuDSEgfNsZ6BDiCOgBnejwwDQYJKoZIhvcNAQELBQAwdTFEMEIGA1UEAww7QXBwbGUgV29ybGR3aWRlIERldmVsb3BlciBSZWxhdGlvbnMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxCzAJBgNVBAsMAkczMRMwEQYDVQQKDApBcHBsZSBJbmMuMQswCQYDVQQGEwJVUzAeFw0yMzA5MjIwNzU0NDJaFw0yNDA5MjEwNzU0NDFaMIHcMRowGAYKCZImiZPyLGQBAQwKUUNGOFk4TFYyVjE3MDUGA1UEAwwuaVBob25lIERldmVsb3BlcjogQ3JlYXRlZCB2aWEgQVBJIChRQ0Y4WThMVjJWKTETMBEGA1UECwwKUlVUTTQzNkFRQjFjMGEGA1UECgxaR2VuZXJhbCBPZmZpY2Ugb2YgU2hlbnpoZW4gTXVuaWNpcGFsIENvbW1pdHRlZSBvZiB0aGUgQ2hpbmVzZSBwZW9wbGUncyBQb2xpdGljYWwgQ29uc3VsdGF0MQswCQYDVQQGEwJVUzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPB3j2f9lfEpSUDCuNKpru/i24MglD0n/7Qp51GuNcZOgcuOrbSEoUUs/lSBJNxq6c/sNJXpb0XdCNUf6mSTZ7HC6Cp5jd4+KweEPNAYh1QDrhG2fCcfXsxlk/RI66qIz4rx6VHgW/YztUUdaSIb4iajV7oRj0PtCeEDuArxWJQsHg46fxxtZW64fkahiervwQolu7OEksYfktqXdhTNfOnsDd2h3nPQIP2cbi7npsDnGc9D0B8MSvYX55GLkGnGJ+DwgcyD7Uyw/HfTiWVVagAQIdzxAcuYLuY1IMrF9mucM1zWo5bOWUdeMAPhBfN+I0UJYJz5NdLnIXmkGg+p0V8CAwEAAaOCAiMwggIfMAwGA1UdEwEB/wQCMAAwHwYDVR0jBBgwFoAUCf7AFZD5r2QKkhK5JihjDJfsp7IwcAYIKwYBBQUHAQEEZDBiMC0GCCsGAQUFBzAChiFodHRwOi8vY2VydHMuYXBwbGUuY29tL3d3ZHJnMy5kZXIwMQYIKwYBBQUHMAGGJWh0dHA6Ly9vY3NwLmFwcGxlLmNvbS9vY3NwMDMtd3dkcmczMDMwggEeBgNVHSAEggEVMIIBETCCAQ0GCSqGSIb3Y2QFATCB/zCBwwYIKwYBBQUHAgIwgbYMgbNSZWxpYW5jZSBvbiB0aGlzIGNlcnRpZmljYXRlIGJ5IGFueSBwYXJ0eSBhc3N1bWVzIGFjY2VwdGFuY2Ugb2YgdGhlIHRoZW4gYXBwbGljYWJsZSBzdGFuZGFyZCB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB1c2UsIGNlcnRpZmljYXRlIHBvbGljeSBhbmQgY2VydGlmaWNhdGlvbiBwcmFjdGljZSBzdGF0ZW1lbnRzLjA3BggrBgEFBQcCARYraHR0cHM6Ly93d3cuYXBwbGUuY29tL2NlcnRpZmljYXRlYXV0aG9yaXR5LzAWBgNVHSUBAf8EDDAKBggrBgEFBQcDAzAdBgNVHQ4EFgQUSv4E2/t2fhID9Mv18olooC1LUbwwDgYDVR0PAQH/BAQDAgeAMBMGCiqGSIb3Y2QGAQIBAf8EAgUAMA0GCSqGS                                                          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"
//        
//        if let decodedData = Data(base64Encoded:base64P12 , options: .ignoreUnknownCharacters) {
//            let url = decodedData.write(withName: "aaaa.p12")
//            presentSystemShareContent(nil, image: nil, linkURL: url, data: nil) { type, ret, items, err in
//                debugPrint("")
//            }
//        }
    }
    
    @objc func create(){
        let alert = ZWTAlertController(title: "添加证书", message: "", preferredStyle: .actionSheet)
        
        let cancel = ZWTAlertAction(title: "取消", style: .cancel)
        /*
         IOS_DEVELOPMENT
         IOS_DISTRIBUTION
         MAC_APP_DISTRIBUTION
         MAC_INSTALLER_DISTRIBUTION
         MAC_APP_DEVELOPMENT
         DEVELOPER_ID_KEXT
         DEVELOPER_ID_APPLICATION
         DEVELOPMENT
         DISTRIBUTION
         PASS_TYPE_ID
         PASS_TYPE_ID_WITH_NFC
         */
        let typeStr = """
IOS_DEVELOPMENT
IOS_DISTRIBUTION
DEVELOPER_ID_KEXT
DEVELOPER_ID_APPLICATION
DEVELOPMENT
DISTRIBUTION
PASS_TYPE_ID
PASS_TYPE_ID_WITH_NFC
"""
        /* csrContent
         "-----BEGIN CERTIFICATE REQUEST-----\nMIICZjCCAU4CAQAwITEfMB0GCSqGSIb3DQEJARYQeHh4eHh4eHhAMTYzLmNvbTCC\nASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPB3j2f9lfEpSUDCuNKpru/i\n24MglD0n/7Qp51GuNcZOgcuOrbSEoUUs/lSBJNxq6c/sNJXpb0XdCNUf6mSTZ7HC\n6Cp5jd4+KweEPNAYh1QDrhG2fCcfXsxlk/RI66qIz4rx6VHgW/YztUUdaSIb4iaj\nV7oRj0PtCeEDuArxWJQsHg46fxxtZW64fkahiervwQolu7OEksYfktqXdhTNfOns\nDd2h3nPQIP2cbi7npsDnGc9D0B8MSvYX55GLkGnGJ+DwgcyD7Uyw/HfTiWVVagAQ\nIdzxAcuYLuY1IMrF9mucM1zWo5bOWUdeMAPhBfN+I0UJYJz5NdLnIXmkGg+p0V8C\nAwEAAaAAMA0GCSqGSIb3DQEBCwUAA4IBAQC6RK41NSFiNI74CTDjVcv/TU/BQu//\nRwkdOtuN4NyagndV2oKdUuA6mAEIRZdO9XGvvOP6Sb6tl9RB9hl+x3ywsxuDYWFU\n73tEtvZYPlYQnV84L6DuQHx+6aD1lOlL5/TBeqXk2Wx001hEjiwvfxb4/ZjV/QHW\nnQgD1jFJPVY3wcJXtQyi8nnpH4idKygq+NdXC72sF8MWDhQGiCMTIusGXS6AFbG1\nmrmoAW8R6jj+r5qfHLOsq5FeIx0VN9CgyCZlHGzBCYEVLcm70isv2lKR0p1d6z4+\nQ9RY/udEPkNJBtSzwtshZPC8FyuJu7PoPKgyQSHZuuP0wGGHWritzGfe\n-----END CERTIFICATE REQUEST-----"
         */
        let csrPath = Bundle.main.path(forResource: "13mini.csr", ofType: nil)!
        let csrContent = try! String(contentsOfFile: csrPath)
        let types = typeStr.split(separator: "\n")
        for type in types {
            let certificateType = String(type)
            let confirm = ZWTAlertAction(title: certificateType, style: .default) { action in
                let para = [
                    "data": [
                      "attributes": [
                        "certificateType": certificateType,
                        "csrContent": csrContent
                      ],
                      "type": "certificates"
                    ]
                  ]
                ZWTProgressHUD.zwt_showLoadMessage(nil)
                DHNetworkTool.addCertificate(para) { [weak self] cer, errMsg in
                    ZWTProgressHUD.zwt_hideLoad()
                    if let c = cer{
                        self!.datas.insert(c, at: 0)
                        let indexpath = IndexPath(row: 0, section: 0)
                        self?.tableView.insertRows(at: [indexpath], with: .none)
                    }else{
                        dhShowErr(errMsg)
                    }
                }
            }
            alert.addAction(confirm)
        }
        
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func loadDatas(){
        ZWTProgressHUD.zwt_showLoadMessage(nil)
        DHNetworkTool.getCertificates {[weak self] cers, errMsg in
            self?.tableView.mj_header?.endRefreshing()
            ZWTProgressHUD.zwt_hideLoad()
            if let cerList = cers{
                self?.datas.removeAll()
                self?.datas += cerList
                self?.tableView.reloadData()
            }else{
                dhShowErr(errMsg)
            }
        }
    }
    
}

extension DHCerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DHOneTxtCell.description(), for: indexPath) as! DHOneTxtCell
        let cer = datas[indexPath.row]
        let cerInfoStr = """
                                         serialNumber: \(cer.attributes.serialNumber)
                                         displayName: \(cer.attributes.displayName)
                                         name: \(cer.attributes.name)
                                         csrContent: \(cer.attributes.csrContent)
                                         platform: \(cer.attributes.platform)
                                         expirationDate: \(cer.attributes.expirationDate)
                                         certificateType: \(cer.attributes.certificateType)
                            """
        cell.txtLb.text = cerInfoStr
        return cell
    }
}


extension DHCerController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //分享
        let item = datas[indexPath.row]
        let certificateContent = item.attributes.certificateContent
        
        
        let keypath = Bundle.main.path(forResource: "13mini.key", ofType: nil)!
        let privateKeyPem = try! String(contentsOfFile: keypath)
        let exportCer = {
            if let decodedData = Data(base64Encoded:certificateContent , options: .ignoreUnknownCharacters), let decodedString = String(data: decodedData, encoding: .ascii) {
                debugPrint(decodedString)
                let url = decodedData.write(withName: "\(item.attributes.name).cer")
                //type:com.apple.UIKit.activity.AirDrop
                self.presentSystemShareContent(nil, image: nil, linkURL: url, data: nil) { type, ret, items, err in
                    debugPrint("")
                }
            }
        }
        if let p12Url =  DHSSLTool.createP12(pemCertificate: certificateContent, pemPrivateKey: privateKeyPem, namep12: item.attributes.name, exportCer: exportCer){
            presentSystemShareContent(nil, image: nil, linkURL: p12Url, data: nil) { type, ret, items, err in
                debugPrint("")
            }
        }
        
//        let forge = DHJSTool()
//        if let p12B64 = forge?.cer2p12(privateKeyPem: privateKeyPem, cerBase64: certificateContent){
//            if let decodedData = Data(base64Encoded:p12B64 , options: .ignoreUnknownCharacters) {
//                let url = decodedData.write(withName: "\(item.attributes.name).p12")
//                //type:com.apple.UIKit.activity.AirDrop
//                presentSystemShareContent(nil, image: nil, linkURL: url, data: nil) { type, ret, items, err in
//                    debugPrint("")
//                }
//            }
//        } 
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = datas[indexPath.row]
        let actionRevokeCer = UIContextualAction(style: .destructive, title: "Revoke") {[weak self] (_, _, completion) in
            let alert = ZWTAlertController(title: "您确定要Revoke吗?", message: "", preferredStyle: .alert)
            let cancel = ZWTAlertAction(title: "取消", style: .cancel) { action in
                completion(true)
            }
            let confirm = ZWTAlertAction(title: "Revoke", style: .destructive) { [self] action in
                ZWTProgressHUD.zwt_showLoadMessage(nil)
                DHNetworkTool.revokeCertificate(item.id) { ret, errMsg in
                    ZWTProgressHUD.zwt_hideLoad()
                    if ret{
                        self!.datas.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .none)
                    }else{
                        dhShowErr(errMsg)
                    }
                    completion(true)
                }
            }
            alert.addAction(cancel)
            alert.addAction(confirm)
            self?.present(alert, animated: true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [actionRevokeCer])
        configuration.performsFirstActionWithFullSwipe = false//禁止滑动到最左边删除
        return configuration
    }
}
