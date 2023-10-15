//
//  logindetailViewController.swift
//  CalculateBMI
//
//  Created by apple on 17/11/2022.
//  Copyright © 2022 biit. All rights reserved.
//

import UIKit

class logindetailViewController: UIViewController {

    var id1 = ""
    var name1 = ""
    var cgpa1 = ""
    @IBOutlet weak var idtxt: UITextField!
    @IBOutlet weak var nametxt: UITextField!
    @IBOutlet weak var cgpatxt: UITextField!
    
    @IBAction func backbtn(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier:
            "logindetailViewController") as! loginViewController
        
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        controller.modalPresentationStyle = .fullScreen
        present(controller,animated: true)
        print()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        idtxt.text = id1
        nametxt.text = name1
        cgpatxt.text = cgpa1
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
