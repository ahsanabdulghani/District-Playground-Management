//
//  Signup.swift
//  FYPProject
//
//  Created by apple on 09/03/2023.
//

//
//  Signup.swift
//  FYPProject
//
//  Created by apple on 09/03/2023.
//

import Foundation

class Signup: Codable {
    var email: String = ""
    var password: String = ""
    var role: String = ""
    var contact: String = ""
    var name: String = ""
    
    init(email: String, password: String, role: String, contact: String, name: String) {
        self.email = email
        self.password = password
        self.role = role
        self.contact = contact
        self.name = name
    }
}

class SignupManager {
    let apiWrapper = APIWrapper()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var message = ""
    
    func signupUser(email: String, password: String, role: String, contact: String, name: String) -> Signup? {
        var signup: Signup? = nil
        let user = Signup(email: email, password: password, role: role, contact: contact, name: name)
        let userData = try! encoder.encode(user)
        let result = apiWrapper.postMethodCall(controllerName: "apiAccount", actionName: "Signup?email=\(email)&password=\(password)&role=\(role)&contact=\(contact)&name=\(name)", httpBody: userData)
       
        if result.ResponseCode == 200 {
            //ok
            guard let data = result.ResponseData else {
                message = result.ResponseMessage
                return signup
            }
            //data is ok
            signup = try! decoder.decode(Signup.self, from: data)
        } else {
            message = result.ResponseMessage
        }
        return signup
    }
    
//    public func signupuser(email:String,password:String,contact:String,name:String)->Signup?{
//          var Signups : Signup? = nil
//        let user = Signup(email: email, password: password, contact: contact, name: name)
//        let userData = try! encoder.encode(user)
//        let result=apiWrapper.postMethodCall(controllerName: "apiAccount", actionName: "Signup", httpBody: userData)
//          if result.ResponseCode == 200{
//              //ok
//              guard let data=result.ResponseData else{
//                  message=result.ResponseMessage
//                  return Signups
//              }
//              //data is ok
//              Signups=try!decoder.decode(Signup.self, from: data)
//          }
//          else{ message=result.ResponseMessage
//
//          }
//      return Signups
//      }
    
    
}
