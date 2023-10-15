//
//  LoginViewController.swift
//  FYPProject
//
//  Created by apple on 11/01/2023.
//

import UIKit

class LoginViewController: UIViewController {
      
    public static var loggedInUser = Login()
    var loginuser : [Login] = []
        var loginmgr = LoginManager()
    
    @IBOutlet weak var tbemail: UITextField!
    
    @IBOutlet weak var tbpassword: UITextField!
    
    var isForLogin = false
    var callBack : ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginbtn.layer.cornerRadius=15
        tbemail.layer.cornerRadius=15
        tbpassword.layer.cornerRadius=15
        
//        //Admin
//        tbemail.text = "umair123@gmail.com"
//        tbpassword.text = "123"
        
      //  User
        tbemail.text = "ahsan@gmail.com"
        tbpassword.text = "123456"
        
        
    
    }
    
    
    @IBAction func createaccountbtn(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "displaysignuppage") as! SignupViewController
        self.navigationController?.pushViewController(controller, animated: true)
        
       
    }
   //loginbtn outlet for rounding button
    @IBOutlet weak var loginbtn: UIButton!
    @IBAction func loginbtn(_ sender: Any) {
//        let controller = self.storyboard?.instantiateViewController(identifier: "mainpage") as! MainViewController
//        self.navigationController?.pushViewController(controller, animated: true)
//            controller.modalPresentationStyle = .fullScreen
//            present(controller,animated: true)
//        print()
        
        
        
        if(tbemail.text! == "" || tbpassword.text! == "")
               {

            let titleString = NSAttributedString(string: "Alert!!!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

            let alert = UIAlertController(title: nil, message: "All Fields are Required", preferredStyle: .alert)
            alert.setValue(titleString, forKey: "attributedTitle")
                   alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                   self.present( alert, animated: true, completion: nil);
               }
               else{
                   
               
                //var response:Login?=nil
//                LoginViewController.loggedInUser = loginmgr.loginuser(email: tbemail.text!, password: tbpassword.text!)!
                if let loggedInUser = loginmgr.loginuser(email: tbemail.text!, password: tbpassword.text!) {
                    LoginViewController.loggedInUser = loggedInUser
                    APIWrapper.userData = loggedInUser
                  
                    // Rest of your login code here
                } else {

                    let titleString = NSAttributedString(string: "Login Failed", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

                    let alert = UIAlertController(title: nil, message: "Your email and password is incorrect", preferredStyle: .alert)
                    alert.setValue(titleString, forKey: "attributedTitle")
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                if LoginViewController.loggedInUser != nil
               
               {
                    if(LoginViewController.loggedInUser.role=="admin")
                   {
                       print("Admin")
                       let c = self.storyboard?.instantiateViewController(identifier: "mainpage") as! MainViewController
                        self.navigationController?.pushViewController(c, animated: true)
                       
                   }
                  
                        
                      
                    else if(LoginViewController.loggedInUser.role=="user")
                   {
                       print("User")

                        if isForLogin {
                            callBack?(true)
                            self.navigationController?.popViewController(animated: true)
                        }
                        else {
                            let c1 = self.storyboard?.instantiateViewController(identifier: "tobookgroundpage")
                            c1?.modalPresentationStyle = .fullScreen
                                    present(c1!, animated: true, completion: nil)
                        }
                       
                   }
                        
               }
               else
               {
                   print("Not ok ")
                   let myAlert = UIAlertController(title: "Login Failed", message: "Your email and password is incorrect", preferredStyle: UIAlertController.Style.alert);
                   myAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                   self.present( myAlert, animated: true, completion: nil);
           }
               tbemail.text = ""
               tbpassword.text = ""
               
           }
        
        
        
    }
    
    
    
    
    @IBAction func cancelbtnloginpage(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "displayhomeviewpage") as! HomeViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    
    
    
    
    

    

}
