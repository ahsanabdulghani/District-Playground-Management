//
//  BookingViewController.swift
//  FYPProject
//
//  Created by apple on 13/02/2023.
//

import UIKit
import DropDown
class BookingViewController: UIViewController {
    var isViewingApproved = false
    let membershipManager = MembershipManager()
    let bookingManager = BookingManager()
    let oid = LoginViewController.loggedInUser.id
    var grounds : [MembershipGroundList] = []
    var viewapproved : [Booking] = []
    var viewpending : [Bookingpending] = []
    var gId =  0
    
    @IBOutlet weak var sideMenuItem: UIBarButtonItem!
    @IBAction func dropDownClicked(_ sender: Any) {
        dropDown.show()
        
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var date: UIDatePicker!
    
    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    let dropDown = DropDown()
    
    @IBAction func viewpendingbookingbtn(_ sender: Any) {
//  * This below code for when only single result show on table view *
//        isViewingApproved = false
//        tableView.tag = 0
//        let selectedDate = date.date
//         let dateFormatter = DateFormatter()
//         dateFormatter.dateFormat = "yyyy-MM-dd"
//         let matchdate = dateFormatter.string(from: selectedDate)
//
//         guard let selectedGround = grounds.first(where: { $0.gid == gId }) else {
//             let titleString = NSAttributedString(string: "Alert!!!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//
//             let alert = UIAlertController(title: nil, message: "Please Select the Ground.", preferredStyle: .alert)
//             alert.setValue(titleString, forKey: "attributedTitle")
//             alert.addAction(UIAlertAction(title: "Ok", style: .default))
//             self.present(alert, animated: true, completion: nil)
//             return
//         }
//
//         do {
//             if let pendingRequests = try bookingManager.Bookingpendingrequest(gid: gId, matchdate: matchdate) {
//                 viewpending = pendingRequests
//                 tableView.reloadData()
//             } else {
//                 let alert = UIAlertController(title: nil, message: "Match date not found", preferredStyle: .alert)
//                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                 self.present(alert, animated: true, completion: nil)
//             }
//         } catch {
//             let alert = UIAlertController(title: "Error", message: "An error occurred while retrieving approved requests. Please try again later.", preferredStyle: .alert)
//             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//             self.present(alert, animated: true, completion: nil)
//         }
              //  isViewingApproved = false
                tableView.tag = 0
                let selectedDate = date.date
                 let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "yyyy-MM-dd"
                 let fromdate = dateFormatter.string(from: selectedDate)
        
                 guard let selectedGround = grounds.first(where: { $0.gid == gId }) else {
                     let titleString = NSAttributedString(string: "Alert!!!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        
                     let alert = UIAlertController(title: nil, message: "Please Select the Ground.", preferredStyle: .alert)
                     alert.setValue(titleString, forKey: "attributedTitle")
                     alert.addAction(UIAlertAction(title: "Ok", style: .default))
                     self.present(alert, animated: true, completion: nil)
                     return
                 }
        let pendingRequests = bookingManager.Bookingpendingrequest(gid: gId, Fromdate: fromdate)
        if !pendingRequests.isEmpty {
               viewpending = pendingRequests
        }else {
            let alert = UIAlertController(title: nil, message: "Not found", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
           }
   tableView.reloadData()
        
    }
    @IBAction func viewapprovedbookingbtn(_ sender: Any) {
        
    //    isViewingApproved = true
        tableView.tag = 1
        let selectedDate = date.date
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         let fromdate = dateFormatter.string(from: selectedDate)

         guard let selectedGround = grounds.first(where: { $0.gid == gId }) else {
             let titleString = NSAttributedString(string: "Alert!!!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

             let alert = UIAlertController(title: nil, message: "Please Select the Ground.", preferredStyle: .alert)
             alert.setValue(titleString, forKey: "attributedTitle")
             alert.addAction(UIAlertAction(title: "Ok", style: .default))
             self.present(alert, animated: true, completion: nil)
             return
         }

        
        let approvedRequests = bookingManager.Bookingapprovedrequest(gid: gId, Fromdate: fromdate)
        if !approvedRequests.isEmpty {
                    viewapproved = approvedRequests
                  
                 
             } else {
                 let alert = UIAlertController(title: nil, message: "Not found", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                 self.present(alert, animated: true, completion: nil)
                }
        tableView.reloadData()
    }
    
    @IBAction func acceptbtnclicked(_ sender: UIButton) {
        let bookingid = viewpending[sender.tag].id
            let gid = viewpending[sender.tag].gid
            
        if bookingManager.acceptbooking(id: bookingid) != nil {
                if let index = viewpending.firstIndex(where: { $0.gid == gid }) {
                    viewpending[index].status = "approved"
                    tableView.reloadData()
                }
                let alert = UIAlertController(title: "Success", message: "Booking request has been accepted.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        present(alert, animated: true)
            } else {
                print(bookingManager.message)
            }
    }
    
    @IBAction func removebtnclicked(_ sender: UIButton) {
        if tableView.tag == 0 { // Remove button clicked in viewpending bookings
            let bookingid = viewpending[sender.tag].id
            let gid = viewpending[sender.tag].gid
            
            let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to remove this booking request?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [self] _ in
                if bookingManager.deletebooking(id: bookingid) {
                    if let index = viewpending.firstIndex(where: { $0.gid == gid }) {
                        viewpending.remove(at: index)
                        tableView.reloadData()
                    }
                } else {
                    print(bookingManager.message)
                }
            }))
            
            present(alert, animated: true)
        } else { // Remove button clicked in viewapproved bookings
            let bookingid = viewapproved[sender.tag].id ?? 0
            let gid = viewapproved[sender.tag].gid
            
            let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to remove this booking request?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [self] _ in
                if bookingManager.deletebooking(id: bookingid) {
                    if let index = viewapproved.firstIndex(where: { $0.gid == gid }) {
                        viewapproved.remove(at: index)
                        tableView.reloadData()
                    }
                } else {
                    print(bookingManager.message)
                }
            }))
            
            present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        sideMenuItem.target = revealViewController()
        sideMenuItem.action = #selector(revealViewController()?.revealSideMenu)
        
        tableView.delegate = self
        tableView.dataSource = self
          
            
            //assign viewOutlet to
            dropDown.anchorView = dropDownView
           
            //set data source
        if let groundLists = membershipManager.Membershipgroundlist(oid: oid) {
                // Extract the ground names from the returned array
                let groundNames = groundLists.compactMap { $0.gname }
              grounds = groundLists
                // Set the ground names as the data source for the drop-down list
                dropDown.dataSource = groundNames

            }
           

                // Top of drop down will be below the anchorView
            dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
           

                // Action triggered on selection
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                let selectedGround = self.grounds[index]
                   self.gId = selectedGround.gid
                   self.dropDownLabel.text = item }
           

              dropDownView.layer.borderWidth = 2
                dropDownView.layer.borderColor = UIColor.black.cgColor
                dropDownView.layer.cornerRadius = 5
           
    //            dropDown.backgroundColor = UIColor.gray
    //            dropDown.animationduration = 0.3
    //        dropDown2.backgroundColor = UIColor.gray
    //        dropDown2.animationduration = 0.3

    }
    

    

}
extension BookingViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0
        {
         return viewpending.count
        }
        else{
            return viewapproved.count
        }
      }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        360
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewBookingViewCell", for: indexPath) as! ViewBookingViewCell
        if tableView.tag == 0 { // Pending bookings
                // Configure the cell with "Accept" and "Remove" buttons
                cell.acceptbtn.isHidden = false
                cell.removebtn.isHidden = false
            } else { // Approved bookings
                // Configure the cell with only the "Remove" button
                cell.acceptbtn.isHidden = true
                cell.removebtn.isHidden = false
            }
        if tableView.tag == 0
        {
            
            let request = viewpending[indexPath.row]
            
            cell.gnamelbl.text = request.gname
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                if let matchDateStr = request.Fromdate,
                    let matchDate = dateFormatter.date(from: matchDateStr) {
                    dateFormatter.dateFormat = "MMM dd, yyyy"
                    let formattedDate = dateFormatter.string(from: matchDate)
                    cell.matchdatelbl.text = formattedDate
                } else {
                    cell.matchdatelbl.text = request.Fromdate // Display the original value if the conversion fails
                    print("Date conversion failed for match date:", request.Fromdate)
                }
        
            if let toDateStr = request.Todate,
                let toDate = dateFormatter.date(from: toDateStr) {
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let formattedDate = dateFormatter.string(from: toDate)
                cell.todatelbl.text = formattedDate
            } else {
                cell.todatelbl.text = request.Todate // Display the original value if the conversion fails
                print("Date conversion failed for to date:", request.Todate)
            }

         //   cell.customernamelbl.text = request.c_name
            cell.starttimelbl.text = request.s_time
            cell.endtimelbl.text = request.e_time
            cell.customerlevellbl.text = request.mlevel
            cell.amountlbl.text = String(request.amount!)
            cell.statuslbl.text = request.status
            
   
            
            cell.acceptbtn.tag = indexPath.row
            cell.removebtn.tag = indexPath.row
           // cell.btndelete.tag = schedule.id
            
                    return cell
        

        }
        else{
        let request = viewapproved[indexPath.row]
      
        cell.gnamelbl.text = request.gname
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                if let fromDateStr = request.Fromdate,
                    let fromDate = dateFormatter.date(from: fromDateStr) {
                    dateFormatter.dateFormat = "MMM dd, yyyy"
                    let formattedDate = dateFormatter.string(from: fromDate)
                    cell.matchdatelbl.text = formattedDate
                } else {
                    cell.matchdatelbl.text = request.Fromdate // Display the original value if the conversion fails
                    print("Date conversion failed for match date:", request.Fromdate)
                }
      //  cell.customernamelbl.text = request.c_name
        cell.starttimelbl.text = request.s_time
        cell.endtimelbl.text = request.e_time
        cell.customerlevellbl.text = request.mlevel
        cell.amountlbl.text = String(request.amount!)
        cell.statuslbl.text = request.status
        
//        if isViewingApproved {
//                cell.acceptbtn.isHidden = false
//                cell.removebtn.isHidden = true
//            } else {
//                cell.acceptbtn.isHidden = true
//                cell.removebtn.isHidden = false
//            }
        
    //    cell.acceptbtn.tag = request.gid ?? gId
        cell.acceptbtn.isHidden = true
        cell.removebtn.tag = indexPath.row
       // cell.btndelete.tag = schedule.id
          
                return cell
    }




}
}
