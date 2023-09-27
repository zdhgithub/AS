//
//  DHAccountController.swift
//  AS
//
//  Created by dh on 2023/9/26.
//

import UIKit
import MMKV
import Alamofire

class DHAccountController: DHBaseViewController {
    
    let accountKey = "account"
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
    
    lazy var datas:[DHAccountModel] = {
        return [DHAccountModel]()
    }()
    
    lazy var addView:DHAddAccountView = {
        let view = DHAddAccountView()
        view.addResult = { ret in
            if ret {
                self.loadDatas()
            }
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Account"
        loadDatas()
        prepareUI()
    }
    
    func prepareUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: dhNavStatusHeight, left: 0, bottom: 0, right: 0))
        }
        zwt_setRightBarItems(byTitle: "添加", titleColor: dhColorMain, target: self, action: #selector(self.addAccountAction))
    }
    
    @objc func addAccountAction(){
        let win = UIApplication.shared.keyWindow
        addView.frame = win!.frame
        win?.addSubview(addView)
    }
    

    func loadDatas(){
        
        let oldStr = MMKV.default()?.string(forKey: accountKey) ?? ""
        if oldStr.count > 0 {
            let models = [DHAccountModel].deserialize(from: oldStr) as? [DHAccountModel]
            tableView.mj_header?.endRefreshing()
            if let infos = models {
                datas.removeAll()
                datas += infos
                tableView.reloadData()
            }
        }
    }
    
}

extension DHAccountController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DHOneTxtCell.description(), for: indexPath) as! DHOneTxtCell
        let info = datas[indexPath.row]
        let infoStr = "\(info.name): \(info.p8keyId)"
        cell.txtLb.text = infoStr
        cell.selBtn.isHidden = info.sel==0
        return cell
    }
}




extension DHAccountController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let info = datas[indexPath.row]
        let oldIdx = datas.firstIndex { acm in
            acm.sel == 1
        }
        info.sel = 1
        
        if let oldIdx = oldIdx,  (oldIdx != indexPath.row) {
            datas[oldIdx].sel = 0
            let indexP = IndexPath(row: oldIdx, section: 0)
            tableView.reloadRows(at: [indexPath,indexP], with: .none)
            
            //清空缓存的jwt，使之从新生成
            let credential = DHAuthCredential(accessToken: "", expiration: Date())
            // 生成授权中心
            let authenticator = DHAuthAuthenticator()
            // 使用授权中心和凭证（若没有可以不传）配置拦截器
            let interceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
            let configuration = URLSessionConfiguration.af.default
            configuration.timeoutIntervalForRequest = 60
            configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
            let session = Session(configuration: configuration, interceptor: interceptor)
            DHNetworkTool.shared.session = session
        }else{
            tableView.reloadRows(at: [indexPath], with: .none)
        }
       let str = datas.toJSONString() ?? ""
        MMKV.default()?.set(str, forKey: accountKey)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = datas[indexPath.row]
  
        
        let actionEdit = UIContextualAction(style: .destructive, title: "编辑") {[weak self] (_, _, completion) in
            self?.addView.account = item
            self?.addAccountAction()
            completion(true)
        }
        actionEdit.backgroundColor = dhColorMain
        let actionDel = UIContextualAction(style: .destructive, title: "删除") {[weak self] (_, _, completion) in
            let alert = ZWTAlertController(title: "您确定要删除吗?", message: "", preferredStyle: .alert)

            let cancel = ZWTAlertAction(title: "取消", style: .cancel) { action in
                completion(true)
            }
            
            
            let confirm = ZWTAlertAction(title: "删除", style: .destructive) { [weak self] action in
                self?.datas.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .none)
                let str = self?.datas.toJSONString() ?? ""
                MMKV.default()?.set(str, forKey: "account")
            }
            alert.addAction(cancel)
            alert.addAction(confirm)
            self?.present(alert, animated: true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [actionDel, actionEdit])
        configuration.performsFirstActionWithFullSwipe = false//禁止滑动到最左边删除
        return configuration
    }
}
