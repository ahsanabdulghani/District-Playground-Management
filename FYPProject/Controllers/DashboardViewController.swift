//
//  DashboardViewController.swift
//  FYPProject
//
//  Created by apple on 18/01/2023.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBAction func Addgroundbtn(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "Addgrounddetailpage") as! AddGroundDetailViewController
       self.present(controller, animated: true)
//       controller.modalPresentationStyle = .fullScreen
    //   present(controller,animated: true)
        print()
       
       
    }
    @IBAction func adminloginbtn(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "dashboardpage") as! DashboardViewController
        self.navigationController?.pushViewController(controller, animated: true)
    //        controller.modalPresentationStyle = .fullScreen
    //        present(controller,animated: true)
        print()
        
    }
    @IBAction func managegroundClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "managegroundpage") as! ManageGroundViewController
        self.present(controller, animated: true)
//        controller.modalPresentationStyle = .fullScreen
//        present(controller,animated: true)
        print()
        
    }
    @IBAction func addmembershipdetailbtnClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "addmembershipdetailpage") as! AddMembershipDetailViewController
        self.present(controller, animated: true)
       
       
        //controller.modalPresentationStyle = .fullScreen
       // present(controller,animated: true)
        print()
    }
    @IBAction func viewbookingbtnClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "bookingviewpage") as! BookingViewController
        self.present(controller, animated: true)
       
       
        //controller.modalPresentationStyle = .fullScreen
       // present(controller,animated: true)
        print()
        
        
        
    }
    @IBAction func viewearningbtnClicked(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "earningviewpage") as! EarningViewController
        self.present(controller, animated: true)
       
       
        //controller.modalPresentationStyle = .fullScreen
       // present(controller,animated: true)
        print()
    }
 
    @IBAction func logoutbtndashboard(_ sender: Any) {

/*
         push for forward move & pop for back ward move without back button
        self.navigationController?.popViewController(animated: true)
*/
        
//        let controller = self.storyboard?.instantiateViewController(identifier: "displayhomeviewpage") as! HomeViewController
//        self.navigationController?.pushViewController(controller, animated: true)
       
        APIWrapper.userData = Login()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let controller = storyboard.instantiateViewController(withIdentifier: "displayhomeviewpage")
        let navigationController = UINavigationController(rootViewController: controller)
               UIApplication.shared.windows.first?.rootViewController = navigationController
    }
    
    
    
    
    @IBOutlet weak var sideMenuItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                navigationController?.navigationBar.tintColor = .white
                sideMenuItem.target = revealViewController()
                sideMenuItem.action = #selector(revealViewController()?.revealSideMenu)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
