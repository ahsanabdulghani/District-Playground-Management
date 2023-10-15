//
//  MembershipViewPendingRequestViewCell.swift
//  FYPProject
//
//  Created by apple on 01/05/2023.
//

import UIKit

class MembershipViewPendingRequestViewCell: UITableViewCell {
    @IBOutlet weak var gnamelbl: UILabel!
    @IBOutlet weak var customernamelbl: UILabel!
    @IBOutlet weak var requestdatelbl: UILabel!
    @IBOutlet weak var amountlbl: UILabel!
    @IBOutlet weak var statuslbl: UILabel!
    
    @IBOutlet weak var acceptbtn: UIButton!
    @IBOutlet weak var removebtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        acceptbtn.layer.cornerRadius=10
        removebtn.layer.cornerRadius=10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
