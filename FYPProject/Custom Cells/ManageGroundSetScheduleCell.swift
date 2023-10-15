//
//  ManageGroundSetScheduleCell.swift
//  FYPProject
//
//  Created by apple on 11/04/2023.
//

import UIKit

class ManageGroundSetScheduleCell: UITableViewCell {
    @IBOutlet weak var Daylbl: UILabel!
    
    @IBOutlet weak var Feeperhourlbl: UILabel!
    @IBOutlet weak var stime: UILabel!
    @IBOutlet weak var etime: UILabel!
    
    @IBOutlet weak var btnupdate: UIButton!
    @IBOutlet weak var btndelete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnupdate.layer.cornerRadius=10
        btndelete.layer.cornerRadius=10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
