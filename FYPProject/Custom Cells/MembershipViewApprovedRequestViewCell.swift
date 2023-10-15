//
//  MembershipViewApprovedRequestViewCell.swift
//  FYPProject
//
//  Created by apple on 02/05/2023.
//

import UIKit

class MembershipViewApprovedRequestViewCell: UITableViewCell {

    @IBOutlet weak var gnamelbl: UILabel!
    @IBOutlet weak var customernamelbl: UILabel!
    @IBOutlet weak var joindatelbl: UILabel!
    @IBOutlet weak var durationlbl: UILabel!
    @IBOutlet weak var enddatelbl: UILabel!
    @IBOutlet weak var statuslbl: UILabel!
    @IBOutlet weak var cancelbtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cancelbtn.layer.cornerRadius=10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
