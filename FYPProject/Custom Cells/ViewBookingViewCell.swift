//
//  ViewBookingViewCell.swift
//  FYPProject
//
//  Created by apple on 04/05/2023.
//

import UIKit

class ViewBookingViewCell: UITableViewCell {

    @IBOutlet weak var gnamelbl: UILabel!
    @IBOutlet weak var matchdatelbl: UILabel!
    @IBOutlet weak var todatelbl: UILabel!
    @IBOutlet weak var customernamelbl: UILabel!
    @IBOutlet weak var starttimelbl: UILabel!
    @IBOutlet weak var endtimelbl: UILabel!
    @IBOutlet weak var customerlevellbl: UILabel!
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
