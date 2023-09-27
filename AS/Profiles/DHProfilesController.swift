//
//  DHProfilesController.swift
//  AS
//
//  Created by dh on 2023/9/21.
//

import UIKit

class DHProfilesController: DHBaseViewController {

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
    
    lazy var datas:[DHProfileModel] = {
        return [DHProfileModel]()
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
        let vc = DHProfileAddController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadDatas(){
        ZWTProgressHUD.zwt_showLoadMessage(nil)
        DHNetworkTool.getProfiles({[weak self] ds, errMsg in
            self?.tableView.mj_header?.endRefreshing()
            ZWTProgressHUD.zwt_hideLoad()
            if let dList = ds{
                self?.datas.removeAll()
                self?.datas += dList
                self?.title = "Profiles(\(dList.count))"
                self?.tableView.reloadData()
            }else{
                dhShowErr(errMsg)
            }
        })
    }
    
}

extension DHProfilesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DHOneTxtCell.description(), for: indexPath) as! DHOneTxtCell
        let p = datas[indexPath.row]
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
        return cell
    }
}


extension DHProfilesController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = datas[indexPath.row]
        let vc = DHProfileInfoController()
        vc.profileInfo = item
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = datas[indexPath.row]
        let did = item.id
        
        let actionRevokeCer = UIContextualAction(style: .destructive, title: "Delete") {[weak self] (_, _, completion) in
            let alert = ZWTAlertController(title: "您确定要Delete吗?", message: "", preferredStyle: .alert)

            let cancel = ZWTAlertAction(title: "取消", style: .cancel) { action in
                completion(true)
            }
            
            let confirm = ZWTAlertAction(title: "确定", style: .destructive) { action in
                ZWTProgressHUD.zwt_showLoadMessage(nil)
                DHNetworkTool.delProfile(did) { ret, errMsg in
                    ZWTProgressHUD.zwt_hideLoad()
                    if ret {
                        self?.datas.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .none)
                        self?.title = "Profiles(\(self?.datas.count ?? 0)"
                    }else{
                        dhShowErr(errMsg)
                    }
                }
            }
            alert.addAction(cancel)
            alert.addAction(confirm)
            self?.present(alert, animated: true)
        }
        
        
        let export = UIContextualAction(style: .normal, title: "export") {[weak self] _, _, completion in
            //分享描述文件
            let profileContent = item.attributes.profileContent
            if let decodedData = Data(base64Encoded:profileContent , options: .ignoreUnknownCharacters) {

                let url = decodedData.write(withName: "\(item.attributes.name).mobileprovision")
                //type:com.apple.UIKit.activity.AirDrop
                self?.presentSystemShareContent(nil, image: nil, linkURL: url, data: nil) { type, ret, items, err in
                    debugPrint("")
                    completion(ret)
                }
            }
            completion(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [actionRevokeCer,export])
        configuration.performsFirstActionWithFullSwipe = false//禁止滑动到最左边删除
        return configuration
    }
}
