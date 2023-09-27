//
//  DHOneTxtCell.swift
//  AS
//
//  Created by dh on 2023/9/20.
//

import UIKit

class DHOneTxtCell: UITableViewCell {

    @IBOutlet weak var selBtn: UIButton!
    @IBOutlet weak var txtLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selBtn.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
