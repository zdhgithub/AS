//
//  DHBaseScrollView.swift
//  Prestapronto
//
//  Created by dh on 2023/3/7.
//

import UIKit

class DHBaseScrollView: UIScrollView {

    init() {
        super.init(frame: .zero)
        zwt_compatibleiOS11()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        zwt_compatibleiOS11()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        zwt_compatibleiOS11()
    }
}
