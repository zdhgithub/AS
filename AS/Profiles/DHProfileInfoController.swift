//
//  DHProfileInfoController.swift
//  AS
//
//  Created by dh on 2023/9/22.
//

import UIKit

class DHProfileInfoController: DHBaseViewController {

    var profileInfo:DHProfileModel!
    
    lazy var tableView:DHBaseTableView = {
        let view = DHBaseTableView()
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 44
        view.sectionHeaderHeight = 30
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
    
    lazy var datas:[[DHBaseModel]] = {
        return [[DHBaseModel]]()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile Info"
        loadDatas()
        prepareUI()
    }
    
    func prepareUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: dhNavStatusHeight, left: 0, bottom: 0, right: 0))
        }
    }
    
    func loadDatas(){
        ZWTProgressHUD.zwt_showLoadMessage(nil)
        let group = DispatchGroup()
        let pid = profileInfo.id
        var bidList:[DHBundleIDModel] = [DHBundleIDModel]()
        var deviceList:[DHDecivesModel] = [DHDecivesModel]()
        var certificateList:[DHCertificateModel] = [DHCertificateModel]()
        
        group.enter()
        DHNetworkTool.getProfileBid(pid) { bm, errMsg in

            if let bidModel = bm {
                bidList.append(bidModel)
            }
            group.leave()
        }
        
        
        group.enter()
        DHNetworkTool.getProfileDevices(pid) { dms, errMsg in
            if let deviceModels = dms {
                deviceList += deviceModels
            }
            group.leave()
        }
        
        group.enter()
        DHNetworkTool.getProfileCertificates(pid) { cers, errMsg in
            if let cerModels = cers {
                certificateList += cerModels
            }
            group.leave()
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            ZWTProgressHUD.zwt_hideLoad()
            self.tableView.mj_header?.endRefreshing()
            self.datas.removeAll()
            self.datas.append(bidList)
            self.datas.append(certificateList)
            self.datas.append(deviceList)
            self.tableView.reloadData()
        }
        
    }
    
}

extension DHProfileInfoController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        datas.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = datas[section]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DHOneTxtCell.description(), for: indexPath) as! DHOneTxtCell
        let item = datas[indexPath.section][indexPath.row]
        
        if let p = item as? DHBundleIDModel {
            let profileStr = """
                                name: \(p.attributes.name)
                                identifier: \(p.attributes.identifier)
                                platform: \(p.attributes.platform)
                                seedId: \(p.attributes.seedId)
                            """
            cell.txtLb.text = profileStr
        }
        else if let p = item as? DHDecivesModel {
            let profileStr = """
                                 addedDate: \(p.attributes.addedDate)
                                 deviceClass: \(p.attributes.deviceClass)
                                 model: \(p.attributes.model)
                                 name: \(p.attributes.name)
                                 platform: \(p.attributes.platform)
                                 status: \(p.attributes.status)
                                 udid: \(p.attributes.udid)
                            """
            cell.txtLb.text = profileStr
        }
        else{
            let cer = item as! DHCertificateModel
            let capabilitieStr = """
                                                                             serialNumber: \(cer.attributes.serialNumber)
                                                                             displayName: \(cer.attributes.displayName)
                                                                             name: \(cer.attributes.name)
                                                                             csrContent: \(cer.attributes.csrContent)
                                                                             platform: \(cer.attributes.platform)
                                                                             expirationDate: \(cer.attributes.expirationDate)
                                                                             certificateType: \(cer.attributes.certificateType)
                                """
            cell.txtLb.text = capabilitieStr
        }
        
        return cell
    }
}

extension DHProfileInfoController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //分享
        if let item = datas[indexPath.section][indexPath.row] as? DHCertificateModel {
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
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let arr = datas[section]
        if(0 == section) {
            return "Bundle ID"
        }else if(1 == section) {
            return "Certificates(\(arr.count))"
        }else{
            return "Devices(\(arr.count))"
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        
//        if let item = datas[indexPath.section][indexPath.row] as? DHCapabilitiesModel{
//            let actionDelCapability = UIContextualAction(style: .destructive, title: "-Capability") {[weak self] (_, _, completion) in
//                let alert = ZWTAlertController(title: "您确定要删除吗?", message: "", preferredStyle: .alert)
//                let cancel = ZWTAlertAction(title: "取消", style: .cancel) { action in
//                    completion(true)
//                }
//                let confirm = ZWTAlertAction(title: "删除", style: .destructive) { [self] action in
//                    let para = [
//                        "data": [
//                            "attributes": [
//                                "capabilityType": item.attributes.capabilityType
//                            ],
//                            "relationships": [
//                              "bundleId": [
//                                "data": [
//                                    "id": self!.bidInfo.id,
//                                  "type": "bundleIds"
//                                ]
//                              ]
//                            ],
//                            "type": "bundleIdCapabilities"
//                          ]
//                    ]
//                    DHNetworkTool.delBundleIdCapability(item.id, params: para) { ret, errMsg in
//                        if ret{
//                            if(self!.datas[indexPath.section].count == 1){
//                                self!.datas.remove(at: indexPath.section)
//                                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .none)
//    
//                            }else{
//                                self!.datas[indexPath.section].remove(at: indexPath.row)
//                                tableView.deleteRows(at: [indexPath], with: .none)
//                            }
//                        }else{
//                            dhShowErr(errMsg)
//                        }
//                        completion(true)
//                    }
//                }
//                alert.addAction(cancel)
//                alert.addAction(confirm)
//                self?.present(alert, animated: true)
//            }
//            
//            let configuration = UISwipeActionsConfiguration(actions: [actionDelCapability])
//            configuration.performsFirstActionWithFullSwipe = false//禁止滑动到最左边删除
//            return configuration
//        }else{
//            return nil
//        }
//        
//        
//    }
}
