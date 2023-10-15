//
//  ManageGroundSetSchedule.swift
//  FYPProject
//
//  Created by apple on 12/04/2023.
//

import Foundation
class ManageGroundSetSchedule:Codable{
    
    var id : Int=0
    var day : String? = ""
    var starttime : String? = ""
    var fee : Int
    var endtime : String? = ""
    var gid: Int
    
    
    
}
class ManageGroundSetScheduleManager{
    let apiWrapper = APIWrapper()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var message = ""
    
    public func ScheduleGet(gid:Int)->[ManageGroundSetSchedule]?{
          var Schedules : [ManageGroundSetSchedule]? = nil
        let result=apiWrapper.getMethodCall(controllerName: "apischedule", actionName: "ViewSchedule?id=\(gid)")
          if result.ResponseCode == 200{
              //ok
              guard let data=result.ResponseData else{
                  message=result.ResponseMessage
                  return Schedules
              }
              //data is ok
            Schedules=try!decoder.decode([ManageGroundSetSchedule].self, from: data)
          }
          else{ message=result.ResponseMessage
              
          }
      return Schedules
      }
    
    public func deleteSchedule(id: Int) -> Bool {
            let result = apiWrapper.getMethodCall(controllerName: "apischedule", actionName: "Delete/\(id)")
            if result.ResponseCode == 200 {
                // Ground deleted successfully
                return true
            } else {
                // Error deleting ground
                message = result.ResponseMessage
                return false
            }
        }
    // * no need function of edit if already use this function in controller *
    
//    public func editSchedule(id: Int) -> ManageGroundSetSchedule? {
//        var editedSchedule: ManageGroundSetSchedule? = nil
//        let result = apiWrapper.getMethodCall(controllerName: "apischedule", actionName: "Update/\(id)")
//        if result.ResponseCode == 200 {
//            guard let data = result.ResponseData else {
//                message = result.ResponseMessage
//                return editedSchedule
//            }
//            editedSchedule = try! decoder.decode(ManageGroundSetSchedule.self, from: data)
//        } else {
//            message = result.ResponseMessage
//        }
//        return editedSchedule
//    }
    
}
