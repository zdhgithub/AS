//
//  DHBIDController.swift
//  AS
//
//  Created by dh on 2023/9/20.
//

import UIKit

class DHBIDController: DHBaseViewController {
    
    lazy var tableView:DHBaseTableView = {
        let view = DHBaseTableView()
        view.delegate = self
        view.dataSource = self
        view.estimatedRowHeight = 44
        view.rowHeight = UITableView.automaticDimension
        view.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
//        view.register(UINib(nibName: "DHBIDCell", bundle: nil), forCellReuseIdentifier: DHBIDCell.description())
        view.tableFooterView = UIView()
        view.mj_header = ZWTRefreshHeader(refreshingBlock: {[weak self] in
            self?.loadDatas()
        })
        return view
    }()
    
    lazy var datas:[DHBundleIDModel] = {
        return [DHBundleIDModel]()
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
    }
    
    @objc func create(){
        debugPrint("添加")
        
        let alert = ZWTAlertController(title: "添加", message: "", preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "请输入描述"
        }
        alert.addTextField { tf in
            tf.placeholder = "请输入包名"
        }
        let cancel = ZWTAlertAction(title: "取消", style: .cancel)
        let confirm = ZWTAlertAction(title: "确定", style: .default) { action in
            let para = [
                "data": [
                  "attributes": [
                    "name": alert.textFields?.first?.text ?? "xxx",
                    "platform": "IOS",// IOS MAC_OS
                    "identifier":alert.textFields?.last?.text ?? "",
                  ],
                  "type": "bundleIds"
                ]
              ]
            ZWTProgressHUD.zwt_showLoadMessage(nil)
            DHNetworkTool.addBundleId(para) { [self] model, errMsg in
                ZWTProgressHUD.zwt_hideLoad()
                if let md = model{
                    self.datas.insert(md, at: 0)
                    let indexpath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexpath], with: .none)
                }
            }
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    
    func loadDatas(){
        ZWTProgressHUD.zwt_showLoadMessage(nil)
        DHNetworkTool.getBundleIds { [weak self] models, errMsg  in
            ZWTProgressHUD.zwt_hideLoad()
            self?.tableView.mj_header?.endRefreshing()
            if let ms = models {
                self?.datas.removeAll()
                self?.datas += ms
                self?.tableView.reloadData()
            }else{
                dhShowErr(errMsg)
            }
        }
    }



}

extension DHBIDController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = datas[indexPath.row]
        cell.textLabel?.text =  item.attributes.name + ": " + item.attributes.identifier
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
}

extension DHBIDController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = datas[indexPath.row]
        let vc = DHBIDInfoController()
        vc.title = "Bundle Id Info"
        vc.bidInfo = item
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = datas[indexPath.row]
        
        let actionModify = UIContextualAction(style: .normal, title: "改名") {[weak self] (_, _, completion) in
            debugPrint("改名")
            let alert = ZWTAlertController(title: "改名", message: "", preferredStyle: .alert)
            alert.addTextField { tf in
                
            }
            let cancel = ZWTAlertAction(title: "取消", style: .cancel) { action in
                completion(true)
            }
            let confirm = ZWTAlertAction(title: "确定", style: .default) { action in
                let para = [
                    "data": [
                      "attributes": [
                        "name": alert.textFields?.first?.text ?? "xxx"
                      ],
                      "id":item.id,
                      "type": "bundleIds"
                    ]
                  ]
                ZWTProgressHUD.zwt_showLoadMessage(nil)
                DHNetworkTool.modifyBundleId(item.id, params: para) { model, errMsg in
                    ZWTProgressHUD.zwt_hideLoad()
                    if let md = model{
                        item.attributes.name = md.attributes.name
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }
                    completion(true)
                }
            }
            alert.addAction(cancel)
            alert.addAction(confirm)
            self?.present(alert, animated: true)
        }
        
        let actionDel = UIContextualAction(style: .destructive, title: "删除") {[weak self] (_, _, completion) in
            debugPrint("删除")
            let alert = ZWTAlertController(title: "您确定要删除吗?", message: "", preferredStyle: .alert)
            let cancel = ZWTAlertAction(title: "取消", style: .cancel) { action in
                completion(true)
            }
            let confirm = ZWTAlertAction(title: "删除", style: .destructive) { action in
                ZWTProgressHUD.zwt_showLoadMessage(nil)
                DHNetworkTool.delBundleId(item.id) { ret, errMsg in
                    ZWTProgressHUD.zwt_hideLoad()
                    if ret{
                        self?.datas.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .none)
                    }
                    completion(true)
                }
            }
            alert.addAction(cancel)
            alert.addAction(confirm)
            self?.present(alert, animated: true)
        }
        /*
         ICLOUD
         IN_APP_PURCHASE
         GAME_CENTER
         PUSH_NOTIFICATIONS
         WALLET
         INTER_APP_AUDIO
         MAPS
         ASSOCIATED_DOMAINS
         PERSONAL_VPN
         APP_GROUPS
         HEALTHKIT
         HOMEKIT
         WIRELESS_ACCESSORY_CONFIGURATION
         APPLE_PAY
         DATA_PROTECTION
         SIRIKIT
         NETWORK_EXTENSIONS
         MULTIPATH
         HOT_SPOT
         NFC_TAG_READING
         CLASSKIT
         AUTOFILL_CREDENTIAL_PROVIDER
         ACCESS_WIFI_INFORMATION
         NETWORK_CUSTOM_PROTOCOL
         COREMEDIA_HLS_LOW_LATENCY
         SYSTEM_EXTENSION_INSTALL
         USER_MANAGEMENT
         APPLE_ID_AUTH
         */
        let actionAddCapability = UIContextualAction(style: .normal, title: "+Capability") {[weak self] (_, _, completion) in
            let alert = ZWTAlertController(title: "添加 Capability", message: "", preferredStyle: .actionSheet)
            let cancel = ZWTAlertAction(title: "取消", style: .cancel) { action in
                completion(true)
            }
            
            let str = """
PUSH_NOTIFICATIONS
ASSOCIATED_DOMAINS
PERSONAL_VPN
APP_GROUPS
WIRELESS_ACCESSORY_CONFIGURATION
NETWORK_EXTENSIONS
AUTOFILL_CREDENTIAL_PROVIDER
ACCESS_WIFI_INFORMATION
NETWORK_CUSTOM_PROTOCOL
APPLE_ID_AUTH
"""
            let arr = str.split(separator: "\n")
            for capaStr in arr {
                let capa = String(capaStr)
                let confirm = ZWTAlertAction(title: capa, style: .default) { action in
                    let para = [
                        "data": [
                            "attributes": [
                              "capabilityType": capa
                            ],
                            "relationships": [
                              "bundleId": [
                                "data": [
                                    "id": item.id,
                                  "type": "bundleIds"
                                ]
                              ]
                            ],
                            "type": "bundleIdCapabilities"
                          ]
                    ]
                    ZWTProgressHUD.zwt_showLoadMessage(nil)
                    DHNetworkTool.addBundleIdCapability(para) { cm, errMsg in
                        ZWTProgressHUD.zwt_hideLoad()

                        if let model = cm{
                            ZWTProgressHUD.zwt_showMessage("add success")
                        }else{
                            ZWTProgressHUD.zwt_showMessage("add fail: \(errMsg)")
                        }
                        completion(true)
                    }
                }
                alert.addAction(confirm)
            }
            
            alert.addAction(cancel)
            
            self?.present(alert, animated: true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [actionModify,actionDel, actionAddCapability])
        configuration.performsFirstActionWithFullSwipe = false//禁止滑动到最左边删除
        return configuration
    }
}
