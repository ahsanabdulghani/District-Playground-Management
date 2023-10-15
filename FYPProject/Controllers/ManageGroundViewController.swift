//
//  ManageGroundViewController.swift
//  FYPProject
//
//  Created by apple on 19/01/2023.
//

import UIKit

class ManageGroundViewController: UIViewController, UISearchBarDelegate {

    
     public static var gid = 0
    public static var gname = ""
       var mymanageGrounds=[Manageground]()
       let manageGroundsMgr = managegroundManager()
       let oid = LoginViewController.loggedInUser.id
    
    var resultmymanageGrounds = [Manageground]()
    @IBOutlet weak var tableView: UITableView!
    func searchBarTextDidBeginEditing(_ searchbar: UISearchBar) {
        isSearchActive = true
    }
    func searchBarTextDidEndEditing(_ searchbar: UISearchBar) {
        isSearchActive = false
        self.tableView.reloadData()
    }
    func searchBar(_ searchbar: UISearchBar, textDidChange searchText: String) {
        resultmymanageGrounds.removeAll()
        for ground in mymanageGrounds{
            if ground.gname.lowercased().contains(searchText.lowercased()) {
                resultmymanageGrounds.append(ground)
            }
        }
        isSearchActive = !resultmymanageGrounds.isEmpty
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
        isSearchActive = false
        searchbar.text = ""
        resultmymanageGrounds.removeAll()
        self.tableView.reloadData()
        
        
        
    }
   
    var isSearchActive = false
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var sideMenuItem: UIBarButtonItem!
    @IBAction func manageschedulelistbtn(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(identifier: "manageschedulelistpage") as! ManageScheduleListViewController
        self.present(controller, animated: true)
        controller.gid=sender.tag
//        controller.modalPresentationStyle = .fullScreen
//        present(controller,animated: true)
  //      ManageGroundViewController.gid = sender.tag
        print()
    }
    
    public func reloadData(){
        if let manageGrounds =  self.manageGroundsMgr.managegrounds(oid: self.oid) {
            self.mymanageGrounds = manageGrounds
            self.tableView.reloadData()
        }
    }
    
    @IBAction func editbtnmovetoaddground(_ sender: UIButton) {
//        let controller = self.storyboard?.instantiateViewController(identifier: "Addgrounddetailpage") as! AddGroundDetailViewController
//        controller.isForUpdate = true
//        controller.id = sender.tag
//        controller.caller = self
//        self.present(controller, animated: true)
        let controller = self.storyboard?.instantiateViewController(identifier: "UpdateGroundDetailViewpage") as! UpdateGroundDetailViewController
        controller.id=sender.tag

        controller.caller = self
        self.present(controller, animated: true)
    

        
        
      //  controller.modalPresentationStyle = .fullScreen
       // present(controller,animated: true)
//        print()
//        let  row = sender.tag
//        let ground = resultmymanageGrounds[row]
    }
    @IBAction func deletebtnmanageground(_ sender: UIButton) {
//        let alert = UIAlertController(title: "Alert!!!", message: "Data Deleted!!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default))
//        self.present(alert, animated: true, completion: nil)
//        let groundgid = sender.tag
//        if manageGroundsMgr.deleteGround(gid: groundgid){
//            if let manageGrounds = manageGroundsMgr.managegrounds(oid: oid) {
//                    mymanageGrounds = manageGrounds
//                    tableView.reloadData()
//                } else {
//                    print(manageGroundsMgr.message)
//                }
//        }
//        else
//        {
//            print(manageGroundsMgr.message)
//        }
        let groundgid = sender.tag
        
            let confirmAlert = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete this ground?", preferredStyle: .alert)
            
            confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        confirmAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] (_) in
                
                let deleteAlert = UIAlertController(title: "Alert!!!", message: "Data Deleted!!", preferredStyle: .alert)
                deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(deleteAlert, animated: true, completion: nil)
                
                if self.manageGroundsMgr.deleteGround(gid: groundgid) {
                    if let manageGrounds = self.manageGroundsMgr.managegrounds(oid:oid) {
                        self.mymanageGrounds = manageGrounds
                        self.tableView.reloadData()
                    } else {
                        print(self.manageGroundsMgr.message)
                    }
                } else {
                    print(self.manageGroundsMgr.message)
                }
            }))
            
            self.present(confirmAlert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        sideMenuItem.target = revealViewController()
        sideMenuItem.action = #selector(revealViewController()?.revealSideMenu)
       
        // Set up the table view
                tableView.delegate = self
                tableView.dataSource = self
                tableView.tableFooterView = UIView() // To hide empty table view cells
        searchbar.delegate = self
        searchbar.autocapitalizationType = .sentences //when first letter lowercase show in searchbar
       
        

//        mymanageGrounds = manageGroundsMgr.managegrounds(oid: oid)
       
                  // manageGrounds = fetchedGrounds
            
//                   tableView.reloadData()
//               } else {
//                   print(manageGroundsMgr.message)
//               }
//                let api = APIWrapper()
//        let result=api.getMethodCall(controllerName: "apiplayground", actionName: "AllGrounds?oid=\(oid)")
//        if (result.ResponseCode == 200)
//        {
//            mymanageGrounds = try!JSONDecoder().decode([Manageground].self, from: result.ResponseData!)
//            tableView.reloadData()
//
//        }
        if let manageGrounds = manageGroundsMgr.managegrounds(oid: oid) {
            mymanageGrounds = manageGrounds
            print(mymanageGrounds)
            tableView.reloadData()
        }
        else {
            print(manageGroundsMgr.message)
        }
        
        
      
        
//        searchbar.layer.cornerRadius=15

    }
    
    
}

extension ManageGroundViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearchActive == false{
            return mymanageGrounds.count
        }
        else{
            return resultmymanageGrounds.count
        }
      }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageGroundCell", for: indexPath) as! ManageGroundCell
                var ground = mymanageGrounds[indexPath.row]
        if isSearchActive {
            ground = resultmymanageGrounds[indexPath.row]
        }
        cell.labelGname.text = ground.gname
        cell.CoverPicture.image = Utilities.getImageFromURL(name: ground.image)
        cell.btnEdit.tag = ground.gid
        cell.btnDelete.tag = ground.gid
        print(ground.gid)
        cell.btnsetschedule.tag = ground.gid
        
        cell.facilityList = ground.flist
        cell.collectionView.reloadData()
        
       // tableView.reloadData()
                return cell
    }
   
    
    
    
}
