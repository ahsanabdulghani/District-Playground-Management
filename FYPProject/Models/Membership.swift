//
//  Membership.swift
//  FYPProject
//
//  Created by apple on 15/04/2023.
//

import Foundation
class Membership: Codable {
    var mfee : Int? = 0
    var disc : Int? = 0
    var m_duration : String? = ""
    var gid : Int? = 0
    
    
    init(fee : Int?, discount : Int?, duration : String?, gid : Int) {
          
            self.mfee = fee
            self.disc = discount
            self.m_duration = duration
            self.gid = gid
            
           
        }
    
}
class MembershipGroundList: Codable {
    var gname : String? = ""
    var gid : Int = 0
 
    
    
    
}
class MembershipGroundGet: Codable {
    var gid : Int? = 0
    var m_duration : String? = ""
    var mfee : Int?
    var gname : String? = ""
    var disc : Int?
    
}
class ViewPendingRequestGet: Codable {
    var gid : Int? = 0
    var gname : String? = ""
    var requestdate : String? = ""
    var name : String? = ""
    var amount : Int?
    var status : String? = ""
    var id : Int = 0

}
class ViewApprovedRequestGet: Codable {
    var gid : Int? = 0
    var gname : String? = ""
    var name : String? = ""
    var joindate : String? = ""
    var duration : String? = ""
    var enddate : String? = ""
    var status : String? = ""
    var id : Int = 0
}


class MembershipManager {
    let apiWrapper = APIWrapper()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var message = ""
    
    func MembershipPost(newMembership: Membership) -> String {
        var memberships: [Membership] = []

        // Create a new Ground instance with the provided gname value

        let userData = try! encoder.encode(newMembership)
        let result = apiWrapper.postMethodCall(controllerName: "apimembership", actionName: "addmembershipdetails", httpBody: userData)

        if result.ResponseCode == 200 {
            // Ok
            guard let data = result.ResponseData else {
                message = result.ResponseMessage
                return message
            }

            // Data is ok
            return result.ResponseMessage
        }
        else {
            message = result.ResponseMessage
        }

        return "Something Went Wrong"
    }
    
    func MembershipUpdatePost(newMembership: Membership) -> String {
        var memberships: [Membership] = []

        // Create a new Ground instance with the provided gname value

        let userData = try! encoder.encode(newMembership)
        let result = apiWrapper.postMethodCall(controllerName: "apimembership", actionName: "update", httpBody: userData)

        if result.ResponseCode == 200 {
            // Ok
            guard let data = result.ResponseData else {
                message = result.ResponseMessage
                return message
            }

            // Data is ok
            return result.ResponseMessage
        }
        else {
            message = result.ResponseMessage
        }

        return "Something Went Wrong"
    }
//    func MembershipPost(newMembership: Membership) -> String? {
//        let userData = try! encoder.encode(newMembership)
//        let result = apiWrapper.postMethodCall(controllerName: "apimembership", actionName: "addmembershipdetails", httpBody: userData)
//
//        if result.ResponseCode == 200 {
//            // Ok
//            return "Added Successfully"
//        } else {
//            return result.ResponseMessage
//        }
//    }

    public func Membershipgroundlist(oid:Int)->[MembershipGroundList]?{
          var Groundlists : [MembershipGroundList]? = nil
        let result=apiWrapper.getMethodCall(controllerName: "apiplayground", actionName: "GroundNameList?id=\(oid)")
          if result.ResponseCode == 200{
              //ok
              guard let data=result.ResponseData else{
                  message=result.ResponseMessage
                  return Groundlists
              }
              //data is ok
            Groundlists=try!decoder.decode([MembershipGroundList].self, from: data)
          }
          else{ message=result.ResponseMessage
              
          }
      return Groundlists
      }
    public func Membershippendingrequest(gid:Int,requestdate:String)->[ViewPendingRequestGet]{
        var pendingRequests: [ViewPendingRequestGet] = []

           let result = apiWrapper.getMethodCall(controllerName: "apimembership", actionName: "Viewpendingrequest?gid=\(gid)&requestdate=\(requestdate)")
           if result.ResponseCode == 200 {
               // OK
               guard let data = result.ResponseData else {
                   message = result.ResponseMessage
                   return pendingRequests
               }
               // Data is OK
               do {
                   pendingRequests = try decoder.decode([ViewPendingRequestGet].self, from: data)
               } catch let error {
                   message = error.localizedDescription
               }
           } else {
               message = result.ResponseMessage
           }
           return pendingRequests
    
}

    public func Membershipapprovedrequest(gid:Int,joindate:String)->[ViewApprovedRequestGet]{
        var approvedRequests: [ViewApprovedRequestGet] = []
           let result = apiWrapper.getMethodCall(controllerName: "apimembership", actionName: "Viewmembers?gid=\(gid)&joindate=\(joindate)")
           if result.ResponseCode == 200 {
               // OK
               guard let data = result.ResponseData else {
                   message = result.ResponseMessage
                   return approvedRequests
               }
               // Data is OK
               do {
                approvedRequests = try decoder.decode([ViewApprovedRequestGet].self, from: data)
               } catch let error {
                   message = error.localizedDescription
               }
           } else {
               message = result.ResponseMessage
           }
           return approvedRequests
    
}

//    public func removeMembershipRequest(mid: Int) -> Bool {
//        let result = apiWrapper.getMethodCall(controllerName: "apimembership", actionName: "RemoveRequest/\(mid)")
//        if result.ResponseCode == 200 {
//            // Membership request removed successfully
//            return true
//        } else {
//            // Error removing membership request
//            message = result.ResponseMessage
//            return false
//        }
//    }
    public func removeMembershipRequest(mid:Int)->String?{
        var message:String? = nil
        let result = apiWrapper.getMethodCall(controllerName: "apimembership", actionName: "RemoveRequest?mid=\(mid)")
        if result.ResponseCode == 200{
            //ok
            guard let data = result.ResponseData else{
                message = result.ResponseMessage
                return message
            }
            //data is ok
            message = try! decoder.decode(String.self, from: data)
        }
        else{
            message = result.ResponseMessage
        }
        return message
    }


    public func acceptMembershipRequest(mid:Int)->String?{
        var message:String? = nil
        let result = apiWrapper.getMethodCall(controllerName: "apimembership", actionName: "AcceptRequest?mid=\(mid)")
        if result.ResponseCode == 200{
            //ok
            guard let data = result.ResponseData else{
                message = result.ResponseMessage
                return message
            }
            //data is ok
            message = try! decoder.decode(String.self, from: data)
        }
        else{
            message = result.ResponseMessage
        }
        return message
    }
    
    public func getMembershipDetails(gid: Int) -> Membership? {
        var member:Membership? = nil
        let result = apiWrapper.getMethodCall(controllerName: "apimembership", actionName: "Getmembershipdetails?gid=\(gid)")
        if result.ResponseCode == 200{
            //ok
            guard let data = result.ResponseData else{
                message = result.ResponseMessage
                return member
            }
            //data is ok
            member = try! decoder.decode(Membership.self, from: data)
        }
        else{
            message = result.ResponseMessage
        }
        return member
    }

    
    
    public func addMembershipRequest(gid: Int, cid: Int, duration: String, amount: Int) -> String? {
        var message:String? = nil
        let result = apiWrapper.getMethodCall(controllerName: "apimembership", actionName: "AddRequest?gid=\(gid)&cid=\(cid)&duration=\(duration)&amount=\(amount)")
        if result.ResponseCode == 200{
            //ok
            guard let data = result.ResponseData else{
                message = result.ResponseMessage
                return message
            }
            //data is ok
            message = try! decoder.decode(String.self, from: data)
        }
        else{
            message = result.ResponseMessage
        }
        return message
    }
    
}
