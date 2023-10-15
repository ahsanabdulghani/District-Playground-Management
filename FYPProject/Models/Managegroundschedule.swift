//
//  Managegroundschedule.swift
//  FYPProject
//
//  Created by apple on 10/04/2023.
//

import Foundation
class Managegroundschedule:Codable {
    var day : String? = ""
    var starttime : String? = ""
    var endtime : String? = ""
    var gid: Int
    var fee : Int
    
    
    
    init(day : String?, starttime : String?, endtime : String?, gid : Int, fee : Int) {
       
        self.gid = gid
        self.starttime = starttime
        self.endtime = endtime
        self.fee = fee
        self.day = day
    }
    
    
    
}
class Managegroundschedul:Codable {
    
    var starttime : String? = ""
    var endtime : String? = ""
    var id: Int
    var fee : Int
    
    
    
    init(starttime : String?, endtime : String?, id : Int, fee : Int) {
       
    
        self.starttime = starttime
        self.endtime = endtime
        self.id = id
        self.fee = fee
    }
    
    
    
}


class ManagegroundscheduleManager{
    let apiWrapper = APIWrapper()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var message = ""
    

func SchedulePost(newSchedule:Managegroundschedule) -> [Managegroundschedule]?{
    var schedules: [Managegroundschedule] = []
     
    let userData = try! encoder.encode(newSchedule)
    let result = apiWrapper.postMethodCall(controllerName: "apischedule", actionName: "Addschedule", httpBody: userData)
    if result.ResponseCode == 200 {
        // Ok
        guard let data = result.ResponseData else {
            message = result.ResponseMessage
            return schedules
        }
        
        // Data is ok
        do {
                    schedules = try decoder.decode([Managegroundschedule].self, from: data)
                } catch let error {
                    print("Error decoding schedule: \(error.localizedDescription)")
                    message = "Error decoding schedule"
                }
    }
    else {
        message = result.ResponseMessage
    }
    
    return schedules
}
    func SchedulePostUpdate(newSchedule:Managegroundschedul) -> [Managegroundschedul]?{
        var schedules: [Managegroundschedul] = []
         
        let userData = try! encoder.encode(newSchedule)
        let result = apiWrapper.postMethodCall(controllerName: "apischedule", actionName: "Update", httpBody: userData)
        if result.ResponseCode == 200 {
            // Ok
            guard let data = result.ResponseData else {
                message = result.ResponseMessage
                return schedules
            }
            
            // Data is ok
            do {
                        schedules = try decoder.decode([Managegroundschedul].self, from: data)
                    } catch let error {
                        print("Error decoding schedule: \(error.localizedDescription)")
                        message = "Error decoding schedule"
                    }
        }
        else {
            message = result.ResponseMessage
        }
        
        return schedules
    }
    
   
}



