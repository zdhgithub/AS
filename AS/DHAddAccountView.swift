//
//  DHAddAccountView.swift
//  AS
//
//  Created by dh on 2023/9/27.
//

import UIKit
import MMKV
import SnapKit

class DHAddAccountView: UIView {
    
    var account:DHAccountModel?{
        didSet {
            if let info = account {
                markTf.text = info.name
                issTf.text = info.issuserId
                p8keyTf.text = info.p8keyId
                
                mark = info.name
                iss = info.issuserId
                keyId = info.p8keyId
                privateKey = info.p8keyContent
            }
        }
    }
    
    var addResult:((Bool)->())?
    
    var mark:String?
    var iss:String?
    var privateKey:String?
    var keyId:String?
    
    lazy var contentView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.radius = 8
        return view
    }()
    
    lazy var markTf:UITextField = {
        let view = UITextField()
        view.placeholder = "请输入备注"
        view.textColor = dhColor3
        view.font = dhFont14
        return view
    }()
    
    lazy var issTf:UITextField = {
        let view = UITextField()
        view.placeholder = "请输入 Issuser Id"
        view.textColor = dhColor3
        view.font = dhFont14
        return view
    }()
    
    lazy var importKeyBtn:UIButton = {
        let view = UIButton()
        view.contentHorizontalAlignment = .leading
        view.titleLabel?.font = dhFont14
        view.setTitle("Import .p8 key from Files", for: .normal)
        view.setTitleColor(dhColorMain, for: .normal)
        view.setTitleColor(dhColorMain, for: .highlighted)
        view.addTarget(self, action: #selector(self.importP8Action), for: .touchUpInside)
        return view
    }()
    
    lazy var p8keyTf:UITextField = {
        let view = UITextField()
        view.placeholder = "请输入 p8.key Id"
        view.textColor = dhColor3
        view.font = dhFont14
        return view
    }()
    
    lazy var cancelBtn:UIButton = {
        let view = UIButton()
        view.titleLabel?.font = dhFont14
        view.setTitle("取消", for: .normal)
        view.setTitleColor(dhColor9, for: .normal)
        view.setTitleColor(dhColor9, for: .highlighted)
        view.addTarget(self, action: #selector(self.cancelAction), for: .touchUpInside)
        return view
    }()
    
    lazy var confirmBtn:UIButton = {
        let view = UIButton()
        view.titleLabel?.font = dhFont14
        view.setTitle("确定", for: .normal)
        view.setTitleColor(dhColorMain, for: .normal)
        view.setTitleColor(dhColorMain, for: .highlighted)
        view.addTarget(self, action: #selector(self.confirmAction), for: .touchUpInside)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.6)
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func importP8Action(){
        DHFileSelectTool.sharedInstance.openDocument {[weak self] url in
            if var u = url {
                let privateKey = try? String(contentsOf: u)
                u.deletePathExtension()
                let fileName = u.lastPathComponent
                let keyId = fileName.components(separatedBy: "_").last
                self?.privateKey = privateKey
                self?.keyId = keyId
                self?.p8keyTf.text = keyId ?? ""
//                debugPrint(u)
            }
        }
    }
    @objc func cancelAction(){
        removeFromSuperview()
    }
    
    @objc func confirmAction(){
        let markStr = markTf.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let issStr = issTf.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        mark = (markStr?.count ?? 0) > 0 ? markStr : nil
        iss = (issStr?.count ?? 0) > 0 ? issStr : nil
        if let name = mark, let iss = iss, let keyId = keyId, let privateKey = privateKey {
            let info = DHAccountModel()
            info.name = name
            info.issuserId = iss
            info.p8keyId = keyId
            info.p8keyContent = privateKey
            
            
            var ret = false
            let accountKey = "account"
            let oldStr = MMKV.default()?.string(forKey: accountKey) ?? ""
            if oldStr.count > 0 {
                let models = [DHAccountModel].deserialize(from: oldStr) as? [DHAccountModel]
                if var infos = models {
                    let idx = infos.firstIndex { acm in
                        acm.issuserId == info.issuserId
                    }
                    if let idx = idx {
                        infos.remove(at: idx)
                        infos.insert(info, at: idx)
                    }else{
                        infos.insert(info, at: 0)
                    }
                    
                    
                    let arrStr = infos.toJSONString() ?? ""
                    ret = MMKV.default()?.set(arrStr, forKey: accountKey) ?? false
                }
            }else{
                info.sel = 1
                let str = [info].toJSONString() ?? ""
                ret = MMKV.default()?.set(str, forKey: accountKey) ?? false
            }
            ZWTProgressHUD.zwt_showMessage(ret ? "添加成功" : "添加失败")
            cancelAction()
            if let addResult = addResult{
                addResult(ret)
            }
            
                
            
        }else{
            ZWTProgressHUD.zwt_showErrorMessage("请填写全部信息")
            if let addResult = addResult{
                addResult(false)
            }
        }
    }
    
    func prepareUI() {
        addSubview(contentView)
        contentView.addSubview(markTf)
        contentView.addSubview(issTf)
        contentView.addSubview(importKeyBtn)
        contentView.addSubview(p8keyTf)
        contentView.addSubview(cancelBtn)
        contentView.addSubview(confirmBtn)
        
        markTf.becomeFirstResponder()
        contentView.snp.makeConstraints { make in
            make.top.equalTo(36+dhNavStatusHeight)
            make.centerX.equalTo(self)
            make.width.equalTo(dhScreenWidth-24*2)
        }
        markTf.snp.makeConstraints { make in
            make.top.left.equalTo(dhSpaceLeft)
            make.right.equalTo(-dhSpaceRight)
            make.height.equalTo(44)
        }
        issTf.snp.makeConstraints { make in
            make.left.right.equalTo(markTf)
            make.top.equalTo(markTf.snp.bottom)
            make.height.equalTo(44)
        }
        importKeyBtn.snp.makeConstraints { make in
            make.left.right.equalTo(markTf)
            make.top.equalTo(issTf.snp.bottom)
            make.height.equalTo(44)
        }
        p8keyTf.snp.makeConstraints { make in
            make.left.right.equalTo(markTf)
            make.top.equalTo(importKeyBtn.snp.bottom)
            make.height.equalTo(44)
        }
        cancelBtn.snp.makeConstraints { make in
            make.left.equalTo(markTf)
            make.top.equalTo(p8keyTf.snp.bottom)
            make.height.equalTo(44)
        }
        confirmBtn.snp.makeConstraints { make in
            make.left.equalTo(cancelBtn.snp.right)
            make.right.equalTo(markTf)
            make.top.equalTo(p8keyTf.snp.bottom)
            make.height.equalTo(44)
            make.bottom.equalTo(contentView)
            make.width.equalTo(cancelBtn)
        }
    }
}
