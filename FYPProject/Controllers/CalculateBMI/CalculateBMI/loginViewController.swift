//
//  loginViewController.swift
//  CalculateBMI
//
//  Created by apple on 17/11/2022.
//  Copyright © 2022 biit. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {


    @IBOutlet weak var txtenterid: UITextField!
    @IBOutlet weak var txtentername: UITextField!
    @IBOutlet weak var txtentercgpa: UITextField!
    
    @IBAction func savebtn(_ sender: Any) {
        
        let id = txtenterid.text!
        let name = txtentername.text!
        let cgpa = txtentercgpa.text!
        
        let controller = self.storyboard?.instantiateViewController(identifier: "display") as! logindetailViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
        controller.id1 = id
        controller.name1 = name
        controller.cgpa1 = cgpa

        controller.modalPresentationStyle = .fullScreen
        present(controller,animated: true)
        print()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
