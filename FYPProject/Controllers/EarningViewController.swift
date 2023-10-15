//
//  EarningViewController.swift
//  FYPProject
//
//  Created by apple on 13/02/2023.
//

import UIKit
import DropDown
class EarningViewController: UIViewController {
    let membershipManager = MembershipManager()
    var viewearning : Earning?
    let earningManager = EarningManager()
    let oid = LoginViewController.loggedInUser.id
    var grounds : [MembershipGroundList] = []
    var gId =  0
    @IBOutlet weak var fdate: UIDatePicker!
    @IBOutlet weak var tdate: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sideMenuItem: UIBarButtonItem!
    @IBAction func dropDownClicked(_ sender: Any) {
        dropDown.show()
        
    }
   
    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    let dropDown = DropDown()

    @IBAction func Submittedbtn(_ sender: Any) {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let fromDate = dateFormatter.string(from: fdate.date)
            let toDate = dateFormatter.string(from: tdate.date)
        
        guard let selectedGround = grounds.first(where: { $0.gid == gId }) else {
            let titleString = NSAttributedString(string: "Alert!!!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

            let alert = UIAlertController(title: nil, message: "Please Select the Ground.", preferredStyle: .alert)
            alert.setValue(titleString, forKey: "attributedTitle")
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }

        
            if let earning = earningManager.EarningGround(id: gId, startdate: fromDate, enddate: toDate) {
                // Earning data retrieved successfully
                viewearning = earning
                tableView.reloadData()
            } else {
                // Error occurred while fetching earning data
                // Show an alert or display an error message to the user
                let alert = UIAlertController(title: "Error", message: earningManager.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        sideMenuItem.target = revealViewController()
        sideMenuItem.action = #selector(revealViewController()?.revealSideMenu)

        
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
        
        tableView.delegate = self
        tableView.dataSource = self
       

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
extension EarningViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

         return viewearning != nil ? 1 : 0

      }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewEarningViewCell", for: indexPath) as! ViewEarningViewCell
       if let request = viewearning {

        cell.totalbookinglbl.text = String(request.totalbookings)
        cell.totalbookingearninglbl.text = "Rs. \(String(request.totalbookingearning))/-"
        cell.totalmemberslbl.text = String(request.totalmembers)
        cell.totalmembershipearninglbl.text = "Rs. \(String(request.totalmemberearning))/-"
        cell.totalearninglbl.text = "Rs. \(String(request.totalearning))/-"

        }
                return cell
    }




}
