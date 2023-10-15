//
//  ViewPendingRequestViewController.swift
//  FYPProject
//
//  Created by apple on 30/04/2023.
//

import UIKit
import DropDown
class ViewPendingRequestViewController: UIViewController {
    let membershipManager = MembershipManager()
    var viewpending = [ViewPendingRequestGet]()
    let oid = LoginViewController.loggedInUser.id
    var grounds : [MembershipGroundList] = []
    
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
    @IBAction func Viewbtn(_ sender: Any) {
        //  * This below code for when only single result show on table view *
        
//        let selectedDate = date.date
//         let dateFormatter = DateFormatter()
//         dateFormatter.dateFormat = "yyyy-MM-dd"
//         let requestDate = dateFormatter.string(from: selectedDate)
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
//            if let pendingRequests = try membershipManager.Membershippendingrequest(gid: gId, requestdate: requestDate) {
//                 viewpending = [pendingRequests]
//                 tableView.reloadData()
//             } else {
//                 let alert = UIAlertController(title: nil, message: "Requested date not found", preferredStyle: .alert)
//                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                 self.present(alert, animated: true, completion: nil)
//             }
//         } catch {
//             let alert = UIAlertController(title: "Error", message: "An error occurred while retrieving pending requests. Please try again later.", preferredStyle: .alert)
//             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//             self.present(alert, animated: true, completion: nil)
//         }
//
        
    //    * This below code for date show with time component *
        
        let selectedDate = date.date

               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd"
               let requestDate = dateFormatter.string(from: selectedDate)

               guard let selectedGround = grounds.first(where: { $0.gid == gId }) else {
                   let titleString = NSAttributedString(string: "Alert!!!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

                   let alert = UIAlertController(title: nil, message: "Please Select the Ground.", preferredStyle: .alert)
                   alert.setValue(titleString, forKey: "attributedTitle")
                   alert.addAction(UIAlertAction(title: "Ok", style: .default))
                   self.present(alert, animated: true, completion: nil)
                   return
               }
        let pendingRequests = membershipManager.Membershippendingrequest(gid: gId, requestdate: requestDate)
        if !pendingRequests.isEmpty {
               viewpending = pendingRequests
        }else {
            let alert = UIAlertController(title: nil, message: "Requested date not found", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
           }
   tableView.reloadData()
       
       
        
        
    }
    @IBAction func Acceptbtnclicked(_ sender: UIButton) {
        let membershipid = viewpending[sender.tag].id
            let gid = viewpending[sender.tag].gid
            
            if let message = membershipManager.acceptMembershipRequest(mid: membershipid) {
                if let index = viewpending.firstIndex(where: { $0.gid == gid }) {
                    viewpending[index].status = "approved"
                    tableView.reloadData()
                }
                let alert = UIAlertController(title: "Success", message: "Membership request has been accepted.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        present(alert, animated: true)
            } else {
                print(membershipManager.message)
            }
    }
    @IBAction func Removebtnclicked(_ sender: UIButton) {
        // * This code without showing message to remove membership request *
        
//        let membershipid = viewpending[sender.tag].id
//        let gid = viewpending[sender.tag].gid
////           print("Your gid is :",indexpath)
//
//        if (membershipManager.removeMembershipRequest(mid: membershipid) != nil) {
//               if let index = viewpending.firstIndex(where: { $0.gid == gid }) {
//                   viewpending.remove(at: index)
//                   tableView.reloadData()
//               }
//           } else {
//               print(membershipManager.message)
//           }
        let membershipid = viewpending[sender.tag].id
           let gid = viewpending[sender.tag].gid
           
           let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to remove this membership request?", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [self] _ in
               if (membershipManager.removeMembershipRequest(mid: membershipid) != nil) {
                   if let index = viewpending.firstIndex(where: { $0.gid == gid }) {
                       viewpending.remove(at: index)
                       tableView.reloadData()
                   }
               } else {
                   print(membershipManager.message)
               }
           }))
           
           present(alert, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
            super.viewDidLoad()
            navigationController?.navigationBar.tintColor = .white
            sideMenuItem.target = revealViewController()
            sideMenuItem.action = #selector(revealViewController()?.revealSideMenu)
                
                //assign viewOutlet to
                dropDown.anchorView = dropDownView
        tableView.delegate = self
        tableView.dataSource = self
        
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
                       self.dropDownLabel.text = item
                       }
               

                  dropDownView.layer.borderWidth = 2
                    dropDownView.layer.borderColor = UIColor.black.cgColor
                    dropDownView.layer.cornerRadius = 5
               
        //            dropDown.backgroundColor = UIColor.gray
        //            dropDown.animationduration = 0.3
        //        dropDown2.backgroundColor = UIColor.gray
        //        dropDown2.animationduration = 0.3

        
    }
    

    
    

}
extension ViewPendingRequestViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

         return viewpending.count

      }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembershipViewPendingRequestViewCell", for: indexPath) as! MembershipViewPendingRequestViewCell
        let request = viewpending[indexPath.row]
        
        cell.gnamelbl.text = request.gname
        cell.customernamelbl.text = request.name
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if let requestDateStr = request.requestdate,
                let requestDate = dateFormatter.date(from: requestDateStr) {
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let formattedDate = dateFormatter.string(from: requestDate)
                cell.requestdatelbl.text = formattedDate
            } else {
                cell.requestdatelbl.text = request.requestdate // Display the original value if the conversion fails
                print("Date conversion failed for match date:", request.requestdate)
            }
        
        cell.amountlbl.text = String(request.amount!)
        cell.statuslbl.text = request.status
        cell.acceptbtn.tag = indexPath.row
        cell.removebtn.tag = indexPath.row

        return cell
    }






}
