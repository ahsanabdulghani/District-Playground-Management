//
//  SignupViewController.swift
//  FYPProject
//
//  Created by apple on 11/01/2023.
//

import UIKit
import DropDown
class SignupViewController: UIViewController {
   
    @IBAction func dropDownClicked(_ sender: Any) {
        dropDown.show()
        
    }
    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    let dropDown = DropDown()
   // var signupuser : [Signup] = []
    let signupmgr = SignupManager()
    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtcontact: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    @IBOutlet weak var txtconfirmpassword: UITextField!
    @IBAction func alreadyregisterbtn(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "displayloginpage") as! LoginViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBOutlet weak var signupbtn: UIButton!
    @IBAction func signupbtn(_ sender: Any) {
//        let controller = self.storyboard?.instantiateViewController(identifier: "mainpage") as! MainViewController
//        self.navigationController?.pushViewController(controller, animated: true)
//
//
//        controller.modalPresentationStyle = .fullScreen
//        present(controller,animated: true)
//        print()
        
        
        guard let email = txtemail.text,
              let password = txtpassword.text,
              let role = dropDownLabel.text,
              let contact = txtcontact.text,
              let name = txtname.text
        else {
                return
             }
        
        if(txtname.text! == "" || txtemail.text! == "" || txtcontact.text! == "" || txtpassword.text! == "" || txtconfirmpassword.text! == "" || dropDownLabel.text! == "Select" )
               {
                  
            let titleString = NSAttributedString(string: "Alert!!!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

            let alert = UIAlertController(title: nil, message: "All Fields are Required", preferredStyle: .alert)
            alert.setValue(titleString, forKey: "attributedTitle")
                   alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                   self.present( alert, animated: true, completion: nil);
               }
        else {
 if(txtpassword.text! != txtconfirmpassword.text! )
               {
    let titleString = NSAttributedString(string: "Alert!!!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

    let alert = UIAlertController(title: nil, message: "Password do not match", preferredStyle: .alert)
    alert.setValue(titleString, forKey: "attributedTitle")
           alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
           self.present( alert, animated: true, completion: nil);
           txtpassword.text = ""
           txtconfirmpassword.text = ""
               }
 else{
        
                // Call SignupManager to signup user
    if let signup = signupmgr.signupUser(email: email, password: password,role: role, contact: contact, name: name) {
                    // Signup successful, do something
                   
        print("User signed up successfully with email: \(signup.email)")
        if signup.role=="admin"
        {
                    let c1 = self.storyboard?.instantiateViewController(identifier: "mainpage")
                    c1?.modalPresentationStyle = .fullScreen
                            present(c1!, animated: true, completion: nil)
        }
        else if signup.role=="user"
        {
            let c1 = self.storyboard?.instantiateViewController(identifier: "tobookgroundpage")
            c1?.modalPresentationStyle = .fullScreen
                    present(c1!, animated: true, completion: nil)
        }
                } else {
                    // Signup failed, show error message
                    print(signupmgr.message)
                }
       
    
            }
      
    }
    }
    @IBAction func cancelbtnsignuppage(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "displayhomeviewpage") as! HomeViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDown.anchorView = dropDownView
        dropDown.dataSource = ["admin", "user"]
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        self.dropDownLabel.text = item }
        dropDownView.layer.borderWidth = 2
          dropDownView.layer.borderColor = UIColor.black.cgColor
          dropDownView.layer.cornerRadius = 15
        
        
        signupbtn.layer.cornerRadius=15
        txtname.layer.cornerRadius=15
        txtemail.layer.cornerRadius=15
        txtpassword.layer.cornerRadius=15
        txtcontact.layer.cornerRadius=15
        txtconfirmpassword.layer.cornerRadius=15
        
    }
    

}
