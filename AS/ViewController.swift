//
//  ViewController.swift
//  AS
//
//  Created by dh on 2023/9/19.
//

import UIKit

class ViewController: DHBaseViewController {
    
    lazy var tableView:DHBaseTableView = {
        let view = DHBaseTableView()
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 44
        view.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        view.tableFooterView = UIView()
        return view
    }()
    
    lazy var datas:[[String:UIViewController.Type]] = {
        return [
            ["Bundle IDs":DHBIDController.self],
            ["Certificates":DHCerController.self],
            ["Devices":DHDevicesController.self],
            ["Profiles":DHProfilesController.self],
            ["Users":DHUsersController.self]
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "App Store Connect API"
        
        prepareUI()
    }
    
    func prepareUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: dhNavStatusHeight, left: 0, bottom: 0, right: 0))
        }
        
        zwt_setRightBarItems(byTitle: "账户", titleColor: dhColorMain, target: self, action: #selector(self.accountAction))
    }
    
    @objc func accountAction(){
        let vc = DHAccountController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = datas[indexPath.row]
        cell.textLabel?.text = item.keys.first
        return cell
    }
    
}

extension ViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = datas[indexPath.row]
        let vcClass = item.values.first!
        let vc: UIViewController = vcClass.init()
        vc.title = item.keys.first
        navigationController?.pushViewController(vc, animated: true)
    }
}

