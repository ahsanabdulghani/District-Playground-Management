//
//  GenerateBillViewController.swift
//  FYPProject
//
//  Created by apple on 29/05/2023.
//

import UIKit

class GenerateBillViewController: UIViewController {

    @IBOutlet weak var lblGroundName: UILabel!
    @IBOutlet weak var lblfromdate: UILabel!
    
    @IBOutlet weak var lbltodate: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    var bid = Int()
    var totalAmount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBill()
    }
    
    func getBill() {
        let manager = BookingManager()
        if let booking = manager.getBill(bid: bid) {
            print(booking)
            
            lblGroundName.text = booking.gname
            lblfromdate.text = changeDateFormat(previousFormat: "yyyy-MM-dd'T'HH:mm:ss", newFormat: "dd MMM, yyyy", dateStr: booking.Fromdate ?? "")
            lbltodate.text = changeDateFormat(previousFormat: "yyyy-MM-dd'T'HH:mm:ss", newFormat: "dd MMM, yyyy", dateStr: booking.Todate ?? "")
            
            
            let startTime = changeDateFormat(previousFormat: "HH:mm:ss", newFormat: "h:mm a", dateStr: booking.s_time ?? "")
            let endTime = changeDateFormat(previousFormat: "HH:mm:ss", newFormat: "h:mm a", dateStr: booking.e_time ?? "")
            lblTiming.text = "\(startTime) to \(endTime)"
            
            if booking.TotalAmount == 0.0 {
                lblTotal.text = String(totalAmount)
            }
            else {
                lblTotal.text = String(booking.TotalAmount ?? 0.0)
            }
        }
        
    }

    @IBAction func onClickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
