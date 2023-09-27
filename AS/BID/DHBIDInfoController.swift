//
//  DHBIDInfoController.swift
//  AS
//
//  Created by dh on 2023/9/20.
//

import UIKit

class DHBIDInfoController: DHBaseViewController {
    
    var bidInfo:DHBundleIDModel!
    
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
        
        let group = DispatchGroup()
        var profileList:[DHProfileModel] = [DHProfileModel]()
        var capabilityList:[DHCapabilitiesModel] = [DHCapabilitiesModel]()
        
        ZWTProgressHUD.zwt_showLoadMessage(nil)
        group.enter()
        DHNetworkTool.getBundleIdProfile(bidInfo.id) {profiles, errMsg in
            
            if let ps = profiles {
                profileList += ps
            }
            group.leave()
        }
        
        
        group.enter()
        DHNetworkTool.getBundleIdCapabilities(bidInfo.id) {capabilities, errMsg in
            
            if let cs = capabilities {
                capabilityList += cs
            }
            group.leave()
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            ZWTProgressHUD.zwt_hideLoad()
            self.tableView.mj_header?.endRefreshing()
            self.datas.removeAll()
            self.datas.append(profileList)
            self.datas.append(capabilityList)
            self.tableView.reloadData()
        }
        
    }
    
}

extension DHBIDInfoController: UITableViewDataSource {
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
        
        if let p = item as? DHProfileModel {
            let profileStr = """
                                profileState: \(p.attributes.profileState)
                                createdDate: \(p.attributes.createdDate)
                                profileType: \(p.attributes.profileType)
                                name: \(p.attributes.name)
                                uuid: \(p.attributes.uuid)
                                platform: \(p.attributes.platform)
                                expirationDate: \(p.attributes.expirationDate)
                            """
            cell.txtLb.text = profileStr
        }else{
            let c = item as! DHCapabilitiesModel
            let capabilitieStr = """
                                    capabilityType: \(c.attributes.capabilityType)
                                """
            cell.txtLb.text = capabilitieStr
        }
        
        return cell
    }
    
    
    
    
}
extension DHBIDInfoController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //分享描述文件
        if let item = datas[indexPath.section][indexPath.row] as? DHProfileModel{
            let profileContent = item.attributes.profileContent
            if let decodedData = Data(base64Encoded:profileContent , options: .ignoreUnknownCharacters), let decodedString = String(data: decodedData, encoding: .ascii) {
//                debugPrint(decodedString)
               
               let url = decodedData.write(withName: "\(item.attributes.name).mobileprovision")
                //type:com.apple.UIKit.activity.AirDrop
                presentSystemShareContent(nil, image: nil, linkURL: url, data: nil) { type, ret, items, err in
                    debugPrint("")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (0 == section) ? "Profiles" : "Capabilities"
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if let item = datas[indexPath.section][indexPath.row] as? DHCapabilitiesModel{
            let actionDelCapability = UIContextualAction(style: .destructive, title: "-Capability") {[weak self] (_, _, completion) in
                let alert = ZWTAlertController(title: "您确定要删除吗?", message: "", preferredStyle: .alert)
                let cancel = ZWTAlertAction(title: "取消", style: .cancel) { action in
                    completion(true)
                }
                let confirm = ZWTAlertAction(title: "删除", style: .destructive) { [self] action in
                    let para = [
                        "data": [
                            "attributes": [
                                "capabilityType": item.attributes.capabilityType
                            ],
                            "relationships": [
                              "bundleId": [
                                "data": [
                                    "id": self!.bidInfo.id,
                                  "type": "bundleIds"
                                ]
                              ]
                            ],
                            "type": "bundleIdCapabilities"
                          ]
                    ]
                    ZWTProgressHUD.zwt_showLoadMessage(nil)
                    DHNetworkTool.delBundleIdCapability(item.id, params: para) { ret, errMsg in
                        ZWTProgressHUD.zwt_hideLoad()
                        if ret{
                            if(self!.datas[indexPath.section].count == 1){
                                self!.datas.remove(at: indexPath.section)
                                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .none)
    
                            }else{
                                self!.datas[indexPath.section].remove(at: indexPath.row)
                                tableView.deleteRows(at: [indexPath], with: .none)
                            }
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
            
            let configuration = UISwipeActionsConfiguration(actions: [actionDelCapability])
            configuration.performsFirstActionWithFullSwipe = false//禁止滑动到最左边删除
            return configuration
        }else{
            return nil
        }
        
        
    }
}
