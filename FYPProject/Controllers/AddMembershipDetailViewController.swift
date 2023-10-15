//
//  AddMembershipDetailViewController.swift
//  FYPProject
//
//  Created by apple on 13/02/2023.
//

import UIKit
import DropDown
class AddMembershipDetailViewController: UIViewController {
    let membershipManager = MembershipManager()
    let oid = LoginViewController.loggedInUser.id
    var grounds : [MembershipGroundList] = []
    var gId =  0
    
 
    
    @IBOutlet weak var addlbl: UIButton!
    @IBOutlet weak var updatelbl: UIButton!
    @IBOutlet weak var viewpendinglbl: UIButton!
    @IBOutlet weak var viewgroundmemberlbl: UIButton!
    @IBOutlet weak var txtmembershipfee: UITextField!
    
    @IBOutlet weak var txtmembershipfeediscount: UITextField!
    @IBOutlet weak var sideMenuItem: UIBarButtonItem!
    @IBAction func dropDownClicked(_ sender: Any) {
        dropDown.show()
        
    }
   
    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    @IBAction func dropDown2Clicked(_ sender: Any) {
        dropDown2.show()
        
    }
    @IBOutlet weak var dropDown2Label: UILabel!
    @IBOutlet weak var dropDown2View: UIView!
    //create variable of dropDown
    let dropDown = DropDown()
    let dropDown2 = DropDown()

    @IBAction func addbtnclicked(_ sender: Any)

    {
        
            // Check if all required fields are filled
            guard let fee = txtmembershipfee.text, !fee.isEmpty,
                  let discount = txtmembershipfeediscount.text, !discount.isEmpty,
                  let duration:String? = dropDown2Label.text!.components(separatedBy: " ")[0], !duration!.isEmpty,
                  let gid = dropDownLabel.text, !gid.isEmpty else{
                      // Show error message if any of the required fields is empty

                let titleString = NSAttributedString(string: "Alert!!!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

                let alert = UIAlertController(title: nil, message: "Please fill in all the required fields.", preferredStyle: .alert)
                alert.setValue(titleString, forKey: "attributedTitle")
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
            }
        
            // Create a new Membership instance with the provided details
        let newMembership = Membership(fee: Int(fee) ?? 0, discount: Int(discount) ?? 0, duration: duration, gid: gId)
            // Call the MembershipManager's MembershipPost method to add the new membership
        if let addedMembership:String? = membershipManager.MembershipPost(newMembership: newMembership) {
                
                // Membership added successfully
         
            let titleString = NSAttributedString(string: "Alert!!!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

            let alert = UIAlertController(title: nil, message: addedMembership, preferredStyle: .alert)
            alert.setValue(titleString, forKey: "attributedTitle")
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
            } else {
                // Error occurred while adding membership
                let alert = UIAlertController(title: "Error", message: "Failed to add membership.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        

    }

      
    @IBAction func updatebtnclicked(_ sender: UIButton) {
       // if dropDown.indexForSelectedRow!>0
//        if ((dropDownLabel.text?.isEmpty) != nil){
            if dropDownLabel.text == "Select" {
            let titleString = NSAttributedString(string: "Error", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

            let alert = UIAlertController(title: nil, message: "Please Select the Ground.", preferredStyle: .alert)
            alert.setValue(titleString, forKey: "attributedTitle")

            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    
        else
        {
        let controller = self.storyboard?.instantiateViewController(identifier: "UpdateMembershipDetailViewpage") as! UpdateMembershipDetailViewController
        controller.id=gId
        print(controller.id)

        self.present(controller, animated: true)
        }
      
       
        
    }
    @IBAction func viewpendingrequest(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "ViewPendingRequestViewpage") as! ViewPendingRequestViewController
        self.present(controller, animated: true)
//        controller.modalPresentationStyle = .fullScreen
//        present(controller,animated: true)
        print()
    }
    @IBAction func viewgroundmembers(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "ViewApprovedRequestViewpage") as! ViewApprovedRequestViewController
        self.present(controller, animated: true)
//        controller.modalPresentationStyle = .fullScreen
//        present(controller,animated: true)
        print()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        sideMenuItem.target = revealViewController()
        sideMenuItem.action = #selector(revealViewController()?.revealSideMenu)
        //assign viewOutlet to
        dropDown.anchorView = dropDownView
        dropDown2.anchorView = dropDown2View
        //set data source
        
        if let groundLists = membershipManager.Membershipgroundlist(oid: oid) {
                // Extract the ground names from the returned array
                let groundNames = groundLists.compactMap { $0.gname }
              grounds = groundLists
                // Set the ground names as the data source for the drop-down list
                dropDown.dataSource = groundNames

            }
        

        
        dropDown2.dataSource = ["1 Month", "2 Month",
        "6 Month"]

            // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown2.bottomOffset = CGPoint(x: 0, y:(dropDown2.anchorView?.plainView.bounds.height)!)

            // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String ) in
//            self.gId = self.grounds[index].gid
//        self.dropDownLabel.text = item
            let selectedGround = self.grounds[index]
               self.gId = selectedGround.gid
               self.dropDownLabel.text = item
        }
        dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
        self.dropDown2Label.text = item }

          dropDownView.layer.borderWidth = 2
            dropDownView.layer.borderColor = UIColor.black.cgColor
            dropDownView.layer.cornerRadius = 5
        dropDown2View.layer.borderWidth = 2
          dropDown2View.layer.borderColor = UIColor.black.cgColor
          dropDown2View.layer.cornerRadius = 5
          
        addlbl.layer.cornerRadius = 15
        updatelbl.layer.cornerRadius = 15
        viewpendinglbl.layer.cornerRadius = 15
        viewgroundmemberlbl.layer.cornerRadius = 15
    }
    

    
}
