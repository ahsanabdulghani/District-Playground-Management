//
//  Login.swift
//  FYPProject
//
//  Created by apple on 08/03/2023.
//

import Foundation

class Login: Codable {
    var email: String = ""
    var password: String = ""
    var role: String = ""
    var id : Int = 0
}

class LoginManager {
    let apiWrapper = APIWrapper()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var message = ""
    
    public func loginuser(email:String,password:String)->Login?{
          var Logins : Login? = nil
          let result=apiWrapper.getMethodCall(controllerName: "apiAccount", actionName: "login?email=\(email)&password=\(password)")
          if result.ResponseCode == 200{
              //ok
              guard let data=result.ResponseData else{
                  message=result.ResponseMessage
                  return Logins
              }
              //data is ok
              Logins=try!decoder.decode(Login.self, from: data)
          }
          else{ message=result.ResponseMessage
              
          }
      return Logins
      }
    
  }
