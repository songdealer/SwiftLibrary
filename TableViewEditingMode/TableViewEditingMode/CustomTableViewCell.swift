//
//  CustomTableViewCell.swift
//  TableViewEditingMode
//
//  Created by MinG._. on 25/01/2020.
//  Copyright © 2020 MinG._. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    static let identifier = "Custom"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
