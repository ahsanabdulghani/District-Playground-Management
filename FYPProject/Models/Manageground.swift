//
//  Manageground.swift
//  FYPProject
//
//  Created by apple on 01/04/2023.
//

import Foundation

class Manageground: Codable {
    var gid: Int = 0
    var gname: String = ""
    var city: String = ""
    var area: String = ""
    var capacity: Int?
   // var gtype: String = ""
  //  var contact: String = ""
    var description: String = "" 
    var image: String = ""
  //  var address: String = ""
   
   // var size: String = "
    //var oid : Int
    var flist = [Facility]()
    
}
class Managegroun: Codable {
    var gid: Int = 0
    var gname: String = ""
    var city: String = ""
    var area: String = ""
    var capacity: Int?
    var gtype: String = ""
    var contact: String = ""
    var description: String = ""
    var image: String = ""
    var address: String = ""
   
    var size: String = ""
    //var oid : Int
  // var flist = [Facility]()
    var facility : [Int] = []
}

class managegroundManager {
    let apiWrapper = APIWrapper()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var message = ""
    
    public func managegrounds(oid:Int)->[Manageground]?{
          var Managegrounds : [Manageground]? = nil
        let result=apiWrapper.getMethodCall(controllerName: "apiplayground", actionName: "AllGrounds?id=\(oid)")
          if result.ResponseCode == 200{
              //ok
              guard let data=result.ResponseData else{
                  message=result.ResponseMessage
                  return Managegrounds
              }
              //data is ok
            Managegrounds=try!decoder.decode([Manageground].self, from: data)
          }
          else{ message=result.ResponseMessage
              
          }
      return Managegrounds
      }
    public func deleteGround(gid: Int) -> Bool {
            let result = apiWrapper.getMethodCall(controllerName: "apiplayground", actionName: "Delete/\(gid)")
            if result.ResponseCode == 200 {
                // Ground deleted successfully
                return true
            } else {
                // Error deleting ground
                message = result.ResponseMessage
                return false
            }
        }
    public func editGround(gid: Int) -> Manageground? {
        var editedGround: Manageground? = nil
        let result = apiWrapper.getMethodCall(controllerName: "apiplayground", actionName: "Edit/\(gid)")
        if result.ResponseCode == 200 {
            guard let data = result.ResponseData else {
                message = result.ResponseMessage
                return editedGround
            }
            editedGround = try! decoder.decode(Manageground.self, from: data)
        } else {
            message = result.ResponseMessage
        }
        return editedGround
    }
    
  }
