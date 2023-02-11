//
//  FilterDetailTableViewCell.swift
//  AppicDemo
//
//  Created by webwerks on 10/02/23.
//

import UIKit

class FilterDetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var checkUnchekBtn: UIButton!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
