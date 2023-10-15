//
//  MyBookingHistoryTableViewCell.swift
//  FYPProject
//
//  Created by apple on 03/06/2023.
//

import UIKit

class MyBookingHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblGroundName: UILabel!
    
    @IBOutlet weak var lblfromdate: UILabel!
    
    @IBOutlet weak var lbltodate: UILabel!
    @IBOutlet weak var lblBookedby: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnGenerateBill: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
