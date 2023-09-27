//
//  DHProfileAddController.swift
//  AS
//
//  Created by dh on 2023/9/26.
//

import UIKit

class DHProfileAddController: DHBaseViewController {
    
    var profileType:String?
    var name:String?
    var bidSel:DHBundleIDModel?
    
    lazy var cersSel:[DHCertificateModel] = {
        return [DHCertificateModel]()
    }()
    lazy var devicesSel:[DHDecivesModel] = {
        return [DHDecivesModel]()
    }()

    lazy var tableView:DHBaseTableView = {
        let view = DHBaseTableView()
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 44
        view.sectionHeaderHeight = 30
        view.sectionFooterHeight = CGFLOAT_MIN
        view.dataSource = self
        view.delegate = self
        view.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        view.tableFooterView = UIView()
        view.mj_header = ZWTRefreshHeader(refreshingBlock: {[weak self] in
            self?.loadDatas()
        })
        return view
    }()
    
    lazy var datas:[String] = {
        return ["选择类型:", "选择包名:", "选择证书:"]
    }()
    
    lazy var networkDatas:[[DHBaseModel]] = {
        return [[DHBaseModel]]()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile Add"
        loadDatas()
        prepareUI()
    }
    
    func prepareUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: dhNavStatusHeight, left: 0, bottom: 0, right: 0))
        }
        
        zwt_setRightBarItems(byTitle: "添加", titleColor: dhColorMain, target: self, action: #selector(self.addAction))
    }
    
    @objc func addAction(){
        if let _ = profileType, cersSel.count > 0, devicesSel.count > 0 {
            let alert = ZWTAlertController(title: "添加", message: "", preferredStyle: .alert)
            alert.addTextField { tf in
                tf.placeholder = "请输入描述"
            }
            let cancel = ZWTAlertAction(title: "取消", style: .cancel)
            let confirm = ZWTAlertAction(title: "确定", style: .default) { action in
                let name = alert.textFields?.first?.text ?? ""
                var certificates = [[String:String]]()
                var devices = [[String:String]]()
                for cer in self.cersSel {
                    let item = ["id": cer.id,"type": "certificates"]
                    certificates.append(item)
                }
                for device in self.devicesSel {
                    let item = ["id": device.id,"type": "devices"]
                    devices.append(item)
                }
                let para = [
                    "data": [
                      "attributes": [
                        "name": name,
                        "profileType": self.profileType
                      ],
                      "relationships": [
                        "bundleId": [
                          "data": [
                            "id": self.bidSel?.id,
                            "type": "bundleIds"
                          ]
                        ],
                        "certificates": [
                          "data": certificates
                        ],
                        "devices": [
                          "data": devices
                        ]
                      ],
                      "type": "profiles"
                    ]
                  ]
                ZWTProgressHUD.zwt_showLoadMessage(nil)
                DHNetworkTool.addProfile(para) { profile, errMsg in
                    ZWTProgressHUD.zwt_hideLoad()
                    if let p = profile{
                        ZWTProgressHUD.zwt_showMessage("add success")
                    }else{
                        dhShowErr(errMsg)
                    }
                }
            }
            alert.addAction(cancel)
            alert.addAction(confirm)
            present(alert, animated: true)
        }else{
            ZWTProgressHUD.zwt_showMessage("请先选择以下选项")
        }
        
    }
    
    func loadDatas(){
        ZWTProgressHUD.zwt_showLoadMessage(nil)
        let group = DispatchGroup()

        var bidList:[DHBundleIDModel] = [DHBundleIDModel]()
        var certificateList:[DHCertificateModel] = [DHCertificateModel]()
        var deviceList:[DHDecivesModel] = [DHDecivesModel]()
        
        group.enter()
        DHNetworkTool.getBundleIds { bids, errmsg in
            if let bidModels = bids {
                bidList += bidModels
            }else{
                dhShowErr(errMsg)
            }
            group.leave()
        }

            
/*
 IOS_DEVELOPMENT, IOS_DISTRIBUTION, MAC_APP_DISTRIBUTION, MAC_INSTALLER_DISTRIBUTION, MAC_APP_DEVELOPMENT, DEVELOPER_ID_KEXT, DEVELOPER_ID_APPLICATION, DEVELOPMENT, DISTRIBUTION, PASS_TYPE_ID, PASS_TYPE_ID_WITH_NFC
 */
        group.enter()
        DHNetworkTool.getCertificates("?filter[certificateType]=IOS_DEVELOPMENT,IOS_DISTRIBUTION,DEVELOPMENT,DISTRIBUTION"){cers, errMsg in
            if let cerList = cers {
                certificateList += cerList
            }
            group.leave()
        }
        
        group.enter()
        DHNetworkTool.getDevices{ds, errMsg in
            if let deviceModels = ds {
                deviceList += deviceModels
            }
            group.leave()
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            ZWTProgressHUD.zwt_hideLoad()
            self.tableView.mj_header?.endRefreshing()
            self.networkDatas.removeAll()
            self.networkDatas.append(bidList)
            self.networkDatas.append(certificateList)
            self.networkDatas.append(deviceList)
            
            self.devicesSel.removeAll()
            self.devicesSel += deviceList
//            self.tableView.reloadData()
        }
        
    }
    
}

extension DHProfileAddController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = datas[indexPath.row]
        cell.textLabel?.text = item

        return cell
    }
}

extension DHProfileAddController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = datas[indexPath.row]
     
        if 0 == indexPath.row {
            let types = """
IOS_APP_DEVELOPMENT
IOS_APP_STORE
IOS_APP_ADHOC
IOS_APP_INHOUSE
"""
            let titles = (types as NSString).components(separatedBy: "\n") as [String]
            let alert = ZWTAlertController.alert(withTitle: "请选择描述文件类型", message: "", textAlignment: .center, style: .actionSheet, titleArray: titles) { index in
                debugPrint(index)
                if(index < titles.count){
                    self.profileType = titles[index]
                    self.datas[indexPath.row] = "选择类型：" + titles[index]
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
            present(alert, animated: true)
        }
        else if 1 == indexPath.row{
            if let bids = networkDatas.first as? [DHBundleIDModel] {
                var titles = [String]()
                for bid  in bids {
                    titles.append("\(bid.attributes.name): \(bid.attributes.identifier)")
                }
                let alert = ZWTAlertController.alert(withTitle: "请选择包名", message: "", textAlignment: .center, style: .actionSheet, titleArray: titles) { index in
                    debugPrint(index)
                    if(index < titles.count){
                        self.bidSel = bids[index]
                        self.datas[indexPath.row] = "选择包名：" + titles[index]
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
                present(alert, animated: true)
            }
        }else{
            if let _ = profileType, let cers = networkDatas[1] as? [DHCertificateModel] {
                var titles = [String]()
                for cer  in cers {
                    titles.append("\(cer.attributes.name)")
                }
                let alert = ZWTAlertController.alert(withTitle: "请选择证书", message: "", textAlignment: .center, style: .actionSheet, titleArray: titles) { index in
                    debugPrint(index)
                    if(index < titles.count){
                        let cer = cers[index]
                        self.cersSel.removeAll()
                        self.cersSel.append(cer)
                        self.datas[indexPath.row] = "选择证书：" + titles[index]
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
                present(alert, animated: true)
            }else{
                ZWTProgressHUD.zwt_showMessage("请先选择描述文件类型")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let arr = datas[section]
        if(0 == section) {
            return "Select Bundle ID"
        }else if(1 == section) {
            return "Select Certificates(\(arr.count))"
        }else{
            return "Select Devices(\(arr.count))"
        }
    }
}
