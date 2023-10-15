//
//  HomeViewController.swift
//  FYPProject
//
//  Created by apple on 12/01/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var togetlistedbtn: UIButton!
    @IBAction func togetlistedbtn(_ sender: Any) {
        
        let controller = self.storyboard?.instantiateViewController(identifier: "displayloginpage") as! LoginViewController
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

    
    @IBOutlet weak var tobookgroundbtn: UIButton!
    
    @IBAction func tobookground(_ sender: Any) {

        let controller = self.storyboard?.instantiateViewController(identifier: "tobookgroundpage") as! ToBookGroundViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
   
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tobookgroundbtn.layer.cornerRadius=15
        togetlistedbtn.layer.cornerRadius=15

        self.navigationController?.isNavigationBarHidden = true
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
