//
//  FacilitiesTableViewCell.swift
//  FYPProject
//
//  Created by apple on 15/05/2023.
//

import UIKit

class FacilitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var chkfacility: UIButton!
    @IBOutlet weak var lbfacility_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
}
