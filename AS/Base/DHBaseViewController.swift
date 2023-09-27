//
//  DHBaseViewController.swift
//  Prestapronto
//
//  Created by dh on 2023/3/7.
//

import UIKit
import SnapKit
import MMKV
import RxSwift
import RxCocoa
import Toast_Swift

class DHBaseViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = dhColorBg
    }
    
    deinit {
        print( NSStringFromClass(self.classForCoder) + " 销毁了")
    }
 

}
