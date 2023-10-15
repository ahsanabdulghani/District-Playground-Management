//
//  ManageScheduleListViewController.swift
//  FYPProject
//
//  Created by apple on 23/01/2023.
//

import UIKit
import DropDown
class ManageScheduleListViewController: UIViewController {
    var mgr = ManageGroundSetScheduleManager()
    var mySchedule = [ManageGroundSetSchedule]()
    var manager = ManagegroundscheduleManager()
   // var gid = ManageGroundViewController.gid
    var gid=0
   // var id = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var starttimedatepicker: UIDatePicker!
    @IBOutlet weak var endtimedatepicker: UIDatePicker!
    @IBOutlet weak var txtfeeperhour: UITextField!
    @IBOutlet weak var sideMenuItem: UIBarButtonItem!
    @IBAction func dropDownClicked(_ sender: Any) {
        dropDown.show()
        
    }
   
    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    @IBAction func Addbtn(_ sender: Any)
        {
            // Create a new Managegroundschedule object with user-entered data
            let day = dropDownLabel.text ?? ""
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let startTime = formatter.string(from: starttimedatepicker.date)
            let endTime = formatter.string(from: endtimedatepicker.date)
            guard let fee = Int(txtfeeperhour.text ?? "") else {
                // Show an error message if fee is not a valid integer
                showMessage(title: "Error", message: "Fee must be a valid integer.")
                return
            }
     
        let newSchedule = Managegroundschedule(day: day, starttime: startTime, endtime: endTime, gid: gid, fee:fee)

            // Call SchedulePost method to save the new schedule
        
            if let savedSchedules = manager.SchedulePost(newSchedule: newSchedule) {
                // If the schedule was saved successfully, show a success message and clear the inputs
                showMessage(title: "Success", message: "Schedule added.")
                dropDownLabel.text = ""
                txtfeeperhour.text = ""
            } else {
                // If there was an error saving the schedule, show an error message
                showMessage(title: "Error", message: manager.message)
            }
        }

        func showMessage(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    
    @IBAction func Viewbtn(_ sender: Any) {
        if let ManageSchedule = mgr.ScheduleGet(gid: gid) {
            mySchedule = ManageSchedule
            tableView.reloadData()
            } else {
                print(manager.message)
            }

    }
    @IBAction func updatebtn(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(identifier: "UpdateSetScheduleViewpage") as! UpdateSetScheduleViewController
        controller.id=sender.tag
        
       
        self.present(controller, animated: true)
       
    }
    @IBAction func deletebtn(_ sender: UIButton) {
        let Scheduleid = sender.tag
        
            let confirmAlert = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete this Schedule?", preferredStyle: .alert)
            
            confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        confirmAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] (_) in
                
                let deleteAlert = UIAlertController(title: "Alert!!!", message: "Data Deleted!!", preferredStyle: .alert)
                deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(deleteAlert, animated: true, completion: nil)
                
                if self.mgr.deleteSchedule(id: Scheduleid) {
                    if let manageSchedules = self.mgr.ScheduleGet(gid:gid) {
                        self.mySchedule = manageSchedules
                        self.tableView.reloadData()
                    } else {
                        print(self.mgr.message)
                    }
                } else {
                    print(self.mgr.message)
                }
            }))
            
            self.present(confirmAlert, animated: true, completion: nil)
            
        }
    let dropDown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        sideMenuItem.target = revealViewController()
        sideMenuItem.action = #selector(revealViewController()?.revealSideMenu)
        
        //assign viewOutlet to
        dropDown.anchorView = dropDownView
       
        //set data source
        dropDown.dataSource = ["Monday", "Tuesday",
        "Wednesday","Thursday","Friday","Saturday","Sunday"]
       

            // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
       

            // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        self.dropDownLabel.text = item }
       

          dropDownView.layer.borderWidth = 2
            dropDownView.layer.borderColor = UIColor.black.cgColor
            dropDownView.layer.cornerRadius = 5
        tableView.delegate = self
        tableView.dataSource = self
       
//            dropDown.backgroundColor = UIColor.gray
//            dropDown.animationduration = 0.3
//        dropDown2.backgroundColor = UIColor.gray
//        dropDown2.animationduration = 0.3

       
       
    }
    

    

}
extension ManageScheduleListViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

         return mySchedule.count

      }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageGroundSetScheduleCell", for: indexPath) as! ManageGroundSetScheduleCell
        let schedule = mySchedule[indexPath.row]

        cell.Daylbl.text = schedule.day
        cell.Feeperhourlbl.text = String(schedule.fee)
        cell.stime.text = schedule.starttime
        cell.etime.text = schedule.endtime
        cell.btnupdate.tag = schedule.id
        cell.btndelete.tag = schedule.id
       // cell.btndelete.tag = schedule.id

                return cell
    }




}
