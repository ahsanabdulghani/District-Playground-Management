//
//  BookingdetailsViewController.swift
//  FYPProject
//
//  Created by apple on 29/05/2023.
//

import UIKit

class BookingdetailsViewController: UIViewController {

    @IBOutlet weak var lblgroundname: UILabel!
    @IBOutlet weak var vBookingDetails: UIView!

    @IBOutlet weak var lblfromdate: UILabel!
    @IBOutlet weak var lbltodate: UILabel!
    @IBOutlet weak var lblNoofdays: UILabel!
    @IBOutlet weak var lblMembershipDiscount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    var gid = Int()
    var fromDate = String()
    var toDate = String()
    var startTime = String()
    var endTime = String()
    var bookingDetails : Booking?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        fromDate = dateFormatter1.string(from: Date())
        print(fromDate)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        toDate = dateFormatter2.string(from: Date())
        print(toDate)
        dateFormatter1.dateFormat = "HH:mm"
        startTime = dateFormatter1.string(from: Date())
        print(startTime)
        endTime = dateFormatter1.string(from: Date())
        print(endTime)
        
    }
    
    @IBAction func onClickfromDatePicker(_ sender: UIDatePicker) {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        
        fromDate = dateFormatter1.string(from: sender.date)
        print(fromDate)
    }
    @IBAction func onClicktoDatePicker(_ sender: UIDatePicker) {
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        
        toDate = dateFormatter2.string(from: sender.date)
        print(toDate)
    }
    
    @IBAction func onClickStartTimePicker(_ sender: UIDatePicker) {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm"
        
        startTime = dateFormatter1.string(from: sender.date)
        print(startTime)
    }
    
    @IBAction func onClickEndTimePicker(_ sender: UIDatePicker) {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm"
        
        endTime = dateFormatter1.string(from: sender.date)
        print(endTime)
    }
    
    @IBAction func onClickCalculateFeeBtn(_ sender: Any) {
        let id = APIWrapper.userData.id
        if id == 0 {
            let controller = self.storyboard?.instantiateViewController(identifier: "displayloginpage") as! LoginViewController
            controller.callBack = { [self] isSuccess in
                if isSuccess {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.getBookingDetails()
                    })
                }
            }
            controller.isForLogin = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            getBookingDetails()
        }
    }
    
    @IBAction func onClickBookNowBtn(_ sender: Any) {
        let id = APIWrapper.userData.id
        if id == 0 {
            let controller = self.storyboard?.instantiateViewController(identifier: "displayloginpage") as! LoginViewController
            controller.callBack = { [self] isSuccess in
                if isSuccess {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.addBooking()
                    })
                }
            }
            controller.isForLogin = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            addBooking()
        }
    }
    
    @IBAction func backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getBookingDetails() {
      //  let id = APIWrapper.userData.id
        let booking = Booking()
        booking.gid = gid
        booking.Fromdate = fromDate
        booking.Todate = toDate
        booking.s_time = startTime
        booking.e_time = endTime
        booking.cid = APIWrapper.userData.id
        print(gid)

        let manager = BookingManager()
        bookingDetails = manager.getBookingDetails(booking: booking)
        print(bookingDetails)
        print("*************")
        if bookingDetails != nil {
            vBookingDetails.isHidden = false

            if let fromDate = bookingDetails?.Fromdate {
                lblfromdate.text = String(fromDate.prefix(10))
            } else {
                lblfromdate.text = ""
            }

            if let toDate = bookingDetails?.Todate {
                lbltodate.text = String(toDate.prefix(10))
            } else {
                lbltodate.text = ""
            }

            lblgroundname.text = bookingDetails?.gname ?? ""
//            lblfromdate.text = bookingDetails?.Fromdate ?? ""
//            lbltodate.text = bookingDetails?.Todate ?? ""
            lblNoofdays.text = String(bookingDetails?.noofdays ?? 0)
            lblMembershipDiscount.text = String(bookingDetails?.discount ?? 0.0)
            lblTotalAmount.text = String(bookingDetails?.TotalAmount ?? 0.0)
            
        }
        else {
            vBookingDetails.isHidden = true
        
              //  let message = manager.message
            let alert = UIAlertController(title: "Alert", message: manager.message , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            
             

//            let alert = UIAlertController(title: "Alert", message:  , preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)


        }
     

    }
    
  
   




    
    func addBooking() {
        let cid = APIWrapper.userData.id
        let booking = Booking()
        booking.cid = cid
        booking.gid = gid
        booking.Fromdate = fromDate
        booking.Todate = toDate
        booking.s_time = startTime
        booking.e_time = endTime
        print(cid)
        print(gid)
        
        let manager = BookingManager()
        let message = manager.addBooking(booking: booking)
        print(message)
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
