//
//  FilterTableViewCell.swift
//  AppicDemo
//
//  Created by webwerks on 10/02/23.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    
    @IBOutlet weak var filterNameLbl: UILabel!
    @IBOutlet weak var filterCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
