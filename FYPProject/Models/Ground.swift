//
//  Ground.swift
//  FYPProject
//
//  Created by apple on 17/03/2023.
//

import Foundation

class Ground: Codable {
    var gid : Int? = 0
    var image : String? = ""
    var gname : String? = ""
    var city : String? = ""
    var area : String? = ""
    var capacity : Int? = 0
    var gtype : String? = ""
    var contact : String? = ""
    var size : String? = ""
    var description : String? = ""
    var address : String? = ""
    var ownerid : Int? = 0
    var facility : String? = ""
    var flist : [Facility]? = []
    
    var averagerating : Double? = 0.0
    var totalreviews : Int? = 0
    
    init(gid: Int?, image : String?, gname : String?, city : String?, area : String?, capacity : Int?, gtype : String?, contact : String?, size : String?, description : String?, address : String?, ownerid: Int?, facility : String?, flist: [Facility]?, averagerating : Double?, totalreviews : Int?) {
        
        self.gid = gid
        self.image = image
        self.gname = gname
        self.city = city
        self.area = area
        self.capacity = capacity
        self.gtype = gtype
        self.contact = contact
        self.size = size
        self.description = description
        self.address = address
        self.ownerid = ownerid
        self.facility = facility
        self.flist = flist
        self.averagerating = averagerating
        self.totalreviews = totalreviews
    }
    
    init() {
        
    }
}

class GroundManager {
    
    let apiWrapper = APIWrapper()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var message = ""
    
    func GroundPost(newGround: Ground) -> [Ground]? {
        var grounds: [Ground] = []
        
        // Create a new Ground instance with the provided gname value
        
        let userData = try! encoder.encode(newGround)
        let result = apiWrapper.postMethodCall(controllerName: "apiplayground", actionName: "Addground", httpBody: userData)
       
        if result.ResponseCode == 200 {
            // Ok
            guard let data = result.ResponseData else {
                message = result.ResponseMessage
                return grounds
            }
            
            // Data is ok
            grounds = try! decoder.decode([Ground].self, from: data)
        }
        else {
            message = result.ResponseMessage
        }
        
        return grounds
    }

    func GroundPostupdate(newGround: Ground) -> [Ground]? {
        var grounds: [Ground] = []
        
        // Create a new Ground instance with the provided gname value
        
        let userData = try! encoder.encode(newGround)
        let result = apiWrapper.postMethodCall(controllerName: "apiplayground", actionName: "Edit", httpBody: userData)
       
        if result.ResponseCode == 200 {
            // Ok
            guard let data = result.ResponseData else {
                message = result.ResponseMessage
                return grounds
            }
            
            // Data is ok
            grounds = try! decoder.decode([Ground].self, from: data)
        }
        else {
            message = result.ResponseMessage
        }
        
        return grounds
    }
    
    
    func AvailableGrounds(ground: GroundRequest) -> [Ground] {
        var grounds: [Ground] = []
        let data = try! encoder.encode(ground)
        let actionName = "AvailableGroundsRange?city=\(ground.city)&area=\(ground.area)&gtype=\(ground.gtype)&stime=\(ground.stime)&etime=\(ground.etime)&fromdate=\(ground.fromdate)&todate=\(ground.todate)&&list[]=\(ground.facilities)"
        let result = apiWrapper.postMethodCall(controllerName: "apiplayground", actionName: actionName, httpBody: data)
       
        if result.ResponseCode == 200 {
            // Ok
            guard let data = result.ResponseData else {
                message = result.ResponseMessage
                return grounds
            }
            
            // Data is ok
            grounds = try! decoder.decode([Ground].self, from: data)
        }
        else {
            message = result.ResponseMessage
        }
        
        return grounds
    }
    
    func groundDetails(gid: Int) -> Ground {
        let api = APIWrapper()
        let response =  api.getMethodCall(controllerName: "apiplayground", actionName: "grounddetails?gid=\(gid)")
        if response.ResponseCode == 200 {
            do {
                let ground = try JSONDecoder().decode(Ground.self, from: response.ResponseData!)
                print(ground)
                return ground
            }
            catch {
                print("error: \(error)")
            }
        }
        else{
            print(response.ResponseMessage)
        }
        return Ground()
    }
    
    func addRating(gid: Int, cid: Int, comment: String, rating: Int) -> String {
        let ground = Ground()
        let data = try! encoder.encode(ground)
        let actionName = "AddRating?gid=\(gid)&cid=\(cid)&comment=\(comment)&rating=\(rating)"
        let result = apiWrapper.postMethodCall(controllerName: "Rating", actionName: actionName, httpBody: data)
       
        if result.ResponseCode == 200 {
            // Ok
            guard let data = result.ResponseData else {
                message = result.ResponseMessage
                return message
            }
            
            // Data is ok
            message = try! decoder.decode(String.self, from: data)
        }
        else {
            message = result.ResponseMessage
        }
        
        return message
    }
    
}
//struct fname:Codable{
//    var id: Int? = 0
//    var name: String? = ""
////    var isSelected:Bool=false
//}


class GroundRequest: Codable {
    var city : String = ""
    var area : String = ""
    var gtype : String = ""
    var stime : String = ""
    var etime : String = ""
    var fromdate : String = ""
    var todate : String = ""
    var facilities : String = ""
}

class Facility: Codable {
    var id : Int? = 0
    var name : String? = ""
    
    var isSelected : Bool? = false
}
