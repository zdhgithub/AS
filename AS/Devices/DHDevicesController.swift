//
//  DHDevicesController.swift
//  AS
//
//  Created by dh on 2023/9/21.
//

import UIKit

class DHDevicesController: DHBaseViewController {
    
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
    
    lazy var datas:[DHDecivesModel] = {
        return [DHDecivesModel]()
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
        let alert = ZWTAlertController(title: "添加设备", message: "", preferredStyle: .alert)
        
        alert.addTextField { tf in
            tf.placeholder = "请输入描述"
        }
        alert.addTextField { tf in
            tf.placeholder = "请输入udid"
        }
        
        let cancel = ZWTAlertAction(title: "取消", style: .cancel)
        let confirm = ZWTAlertAction(title: "确定", style: .default) { action in
            let name:String = (alert.textFields?.first?.text)!
            let udid:String = (alert.textFields?.last?.text!)!
            let para = [
                "data": [
                  "attributes": [
                    "name": name.count > 0 ? name : "13mini",
                    "platform": "IOS",//IOS MAC_OS
                    "udid": udid.count > 0 ? udid : "00008110-000C2DA8260A801E"
                  ],
                  "type": "devices"
                ]
              ]
            ZWTProgressHUD.zwt_showLoadMessage(nil)
            DHNetworkTool.addDevices(para) { [self] model, errMsg in
                ZWTProgressHUD.zwt_hideLoad()
                if let md = model{
                    self.datas.insert(md, at: 0)
                    let indexpath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexpath], with: .none)
                }else{
                    dhShowErr(errMsg)
                }
            }
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    func loadDatas(){
        ZWTProgressHUD.zwt_showLoadMessage(nil)
        DHNetworkTool.getDevices({[weak self] ds, errMsg in
            self?.tableView.mj_header?.endRefreshing()
            ZWTProgressHUD.zwt_hideLoad()
            if let dList = ds{
                self?.datas.removeAll()
                self?.datas += dList
                self?.title = "Devices(\(dList.count))"
                self?.tableView.reloadData()
            }else{
                dhShowErr(errMsg)
            }
        })
    }
    
}

extension DHDevicesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DHOneTxtCell.description(), for: indexPath) as! DHOneTxtCell
        let cer = datas[indexPath.row]
        let cerInfoStr = """
                                         addedDate: \(cer.attributes.addedDate)
                                         deviceClass: \(cer.attributes.deviceClass)
                                         model: \(cer.attributes.model)
                                         name: \(cer.attributes.name)
                                         platform: \(cer.attributes.platform)
                                         status: \(cer.attributes.status)
                                         udid: \(cer.attributes.udid)
                            """
        cell.txtLb.text = cerInfoStr
        return cell
    }
}




extension DHDevicesController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = datas[indexPath.row]
        let did = item.id
        
        let actionRevokeCer = UIContextualAction(style: .destructive, title: "Modify") {[weak self] (_, _, completion) in
            let alert = ZWTAlertController(title: "您确定要Modify吗?", message: "", preferredStyle: .alert)

            alert.addTextField { tf in
                tf.placeholder = "请输入描述"
            }
            alert.addTextField { tf in
                tf.placeholder = "是否禁用(0/1)，默认启用"
                tf.keyboardType = .numberPad
            }
            let cancel = ZWTAlertAction(title: "取消", style: .cancel) { action in
                completion(true)
            }
            
            
            let confirm = ZWTAlertAction(title: "确定", style: .default) { action in
                let nameStr:String = (alert.textFields?.first?.text)!
                let name = nameStr.count>0 ? nameStr : item.attributes.name
                let statusStr:String = (alert.textFields?.last?.text!)!
                let status = ("0" == statusStr) ? "DISABLED" : "ENABLED"
                
                let para = [
                    "data": [
                        "attributes": [
                            "name":name,
                            "status":status
                        ],
                        "id":did,
                        "type": "devices"
                    ]
                ]
                ZWTProgressHUD.zwt_showLoadMessage(nil)
                DHNetworkTool.modifyDevice(did, params: para) { model, errMsg in
                    ZWTProgressHUD.zwt_hideLoad()
                    if let md = model{
                        item.attributes.name = name
                        item.attributes.status = status
                        tableView.reloadRows(at: [indexPath], with: .none)
                    }else{
                        dhShowErr(errMsg)
                    }
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
