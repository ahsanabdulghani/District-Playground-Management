//
//  UpdateSetScheduleViewController.swift
//  FYPProject
//
//  Created by apple on 15/04/2023.
//

import UIKit
import DropDown
class UpdateSetScheduleViewController: UIViewController {

    var manager = ManagegroundscheduleManager()
    var gid=0
    var id = 0

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
 
        let newSchedule = Managegroundschedul(starttime: startTime, endtime: endTime, id: id, fee:fee)

        // Call SchedulePost method to save the new schedule
    
        if let savedSchedules = manager.SchedulePostUpdate(newSchedule: newSchedule) {
            // If the schedule was saved successfully, show a success message and clear the inputs
            showMessage(title: "Success", message: "Schedule Updated.")
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
        var newid=id
        var editSchedule: ManageGroundSetSchedule? = nil
        var api=APIWrapper()
        let result = api.getMethodCall(controllerName: "apischedule", actionName: "Update/\(id)")
        if result.ResponseCode == 200 {
            var data = try! JSONDecoder().decode([ManageGroundSetSchedule].self, from: result.ResponseData!)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            starttimedatepicker.date = formatter.date(from: data[0].starttime ?? "") ?? Date()
            endtimedatepicker.date = formatter.date(from: data[0].endtime ?? "") ?? Date()
            txtfeeperhour.text = String(data[0].fee)
            dropDownLabel.text = data[0].day
            

       
       
    }
        else {
            print(result.ResponseMessage)
        }

    


    

  
}
}
