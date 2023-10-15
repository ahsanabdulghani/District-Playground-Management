//
//  ViewApprovedRequestViewController.swift
//  FYPProject
//
//  Created by apple on 02/05/2023.
//

import UIKit
import DropDown
class ViewApprovedRequestViewController: UIViewController {
    let membershipManager = MembershipManager()
    var viewapproved = [ViewApprovedRequestGet]()
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

                let selectedDate = date.date
                 let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "yyyy-MM-dd"
                
                 let joinDate = dateFormatter.string(from: selectedDate)


                 guard let selectedGround = grounds.first(where: { $0.gid == gId }) else {
                     let titleString = NSAttributedString(string: "Alert!!!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

                     let alert = UIAlertController(title: nil, message: "Please Select the Ground.", preferredStyle: .alert)
                     alert.setValue(titleString, forKey: "attributedTitle")
                     alert.addAction(UIAlertAction(title: "Ok", style: .default))
                     self.present(alert, animated: true, completion: nil)
                     return
                 }

               let approvedRequests = membershipManager.Membershipapprovedrequest(gid: gId, joindate: joinDate)
                if !approvedRequests.isEmpty {
                       viewapproved = approvedRequests
                }else {
                    let alert = UIAlertController(title: nil, message: "Join date not found", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                   }
           tableView.reloadData()
            }
            @IBAction func Cancelbtnclicked(_ sender: UIButton) {
                
                let membershipid = viewapproved[sender.tag].id
                   let gid = viewapproved[sender.tag].gid
                   
                   let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to remove this membership request?", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [self] _ in
                       if (membershipManager.removeMembershipRequest(mid: membershipid) != nil) {
                           if let index = viewapproved.firstIndex(where: { $0.gid == gid }) {
                            viewapproved.remove(at: index)
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
        extension ViewApprovedRequestViewController : UITableViewDataSource, UITableViewDelegate{
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

                 return viewapproved.count

              }
            func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                280
            }

            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MembershipViewApprovedRequestViewCell", for: indexPath) as! MembershipViewApprovedRequestViewCell
                let request = viewapproved[indexPath.row]

                cell.gnamelbl.text = request.gname
                cell.customernamelbl.text = request.name
                let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    
                    if let joinDateStr = request.joindate,
                        let joinDate = dateFormatter.date(from: joinDateStr) {
                        dateFormatter.dateFormat = "MMM dd, yyyy"
                        let formattedDate = dateFormatter.string(from: joinDate)
                        cell.joindatelbl.text = formattedDate
                    } else {
                        cell.joindatelbl.text = request.joindate // Display the original value if the conversion fails
                        print("Date conversion failed for match date:", request.joindate)
                    }
                cell.durationlbl.text = request.duration
                let dateFormatter1 = DateFormatter()
                    dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    
                    if let endDateStr = request.enddate,
                        let endDate = dateFormatter1.date(from: endDateStr) {
                        dateFormatter1.dateFormat = "MMM dd, yyyy"
                        let formattedDate = dateFormatter.string(from: endDate)
                        cell.enddatelbl.text = formattedDate
                    } else {
                        cell.enddatelbl.text = request.enddate // Display the original value if the conversion fails
                        print("Date conversion failed for match date:", request.enddate)
                    }
                cell.statuslbl.text = request.status
            //   cell.acceptbtn.tag = request.gid!
        //        cell.removebtn.tag = request.gid!
               // cell.btndelete.tag = schedule.id
                cell.cancelbtn.tag = indexPath.row
                        return cell
            }




        }
