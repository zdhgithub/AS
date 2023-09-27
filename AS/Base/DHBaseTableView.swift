//
//  DHBaseTableView.swift
//  Prestapronto
//
//  Created by dh on 2023/3/7.
//

import UIKit

class DHBaseTableView: UITableView {

    init() {
        super.init(frame: .zero, style: .plain)
        zwt_compatibleiOS11()
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
    init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        zwt_compatibleiOS11()
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        zwt_compatibleiOS11()
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        zwt_compatibleiOS11()
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }

}
