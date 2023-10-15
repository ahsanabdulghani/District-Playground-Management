//
//  ViewEarningViewCell.swift
//  FYPProject
//
//  Created by apple on 17/05/2023.
//

import UIKit

class ViewEarningViewCell: UITableViewCell {
    @IBOutlet weak var totalbookinglbl: UILabel!
    @IBOutlet weak var totalbookingearninglbl: UILabel!
    @IBOutlet weak var totalmemberslbl: UILabel!
    @IBOutlet weak var totalmembershipearninglbl: UILabel!
    @IBOutlet weak var totalearninglbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
