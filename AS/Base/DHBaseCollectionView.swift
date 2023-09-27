//
//  DHBaseCollectionView.swift
//  Prestapronto
//
//  Created by dh on 2023/3/13.
//

import UIKit

class DHBaseCollectionView: UICollectionView {

    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        zwt_compatibleiOS11()
    }
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        zwt_compatibleiOS11()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        zwt_compatibleiOS11()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        zwt_compatibleiOS11()
    }

}
