//
//  Booking.swift
//  FYPProject
//
//  Created by apple on 04/05/2023.
//

import Foundation
class Booking : Codable {
    var gid : Int? = 0
  //  var matchdate : String? = ""
    var c_name : String? = ""
    var s_time : String? = ""
    var e_time : String? = ""
    var mlevel : String? = ""
    var amount : Int?
    var status : String? = ""
    var id : Int? = 0
    
  //  var feeperhr : Double? = 0
 //   var hours : String? = ""
 //   var totalfee : Double? = 0
    var gname : String? = ""
    var Fromdate : String? = ""
    var Todate : String? = ""
    var noofdays : Int? = 0
    var discount : Double? = 0
    var TotalAmount : Double? = 0
    
    var cid : Int? = 0
}
class Bookingpending : Codable {
    var gid : Int? = 0
   // var matchdate : String? = ""
    var Fromdate : String? = ""
    var Todate : String? = ""
    var gname : String? = ""
    var c_name : String? = ""
    var s_time : String? = ""
    var e_time : String? = ""
    var mlevel : String? = ""
    var amount : Int?
    var status : String? = ""
    var id : Int = 0
}
class BookingManager {
    let apiWrapper = APIWrapper()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var message = ""
    
func Bookingapprovedrequest(gid:Int,Fromdate:String)->[Booking]{
    var approvedRequests: [Booking] = []
       let result = apiWrapper.getMethodCall(controllerName: "apibooking", actionName: "ViewApprovedrequestranges?gid=\(gid)&date=\(Fromdate)")
       if result.ResponseCode == 200 {
           // OK
           guard let data = result.ResponseData else {
               message = result.ResponseMessage
               return approvedRequests
           }
           // Data is OK
           do {
            approvedRequests = try decoder.decode([Booking].self, from: data)
           } catch let error {
               message = error.localizedDescription
           }
       } else {
           message = result.ResponseMessage
       }
       return approvedRequests

}
    func Bookingpendingrequest(gid:Int,Fromdate:String)->[Bookingpending]{
        var pendingRequests: [Bookingpending] = []
           let result = apiWrapper.getMethodCall(controllerName: "apibooking", actionName: "ViewPendingRequestsRanges?gid=\(gid)&date=\(Fromdate)")
           if result.ResponseCode == 200 {
               // OK
               guard let data = result.ResponseData else {
                   message = result.ResponseMessage
                   return pendingRequests
               }
               // Data is OK
               do {
                pendingRequests = try decoder.decode([Bookingpending].self, from: data)
               } catch let error {
                   message = error.localizedDescription
               }
           } else {
               message = result.ResponseMessage
           }
           return pendingRequests

    }
    public func deletebooking(id: Int) -> Bool {
            let result = apiWrapper.getMethodCall(controllerName: "apibooking", actionName: "Remove/\(id)")
            if result.ResponseCode == 200 {
                // Booking deleted successfully
                return true
            } else {
                // Error deleting booking
                message = result.ResponseMessage
                return false
            }
        }
    public func acceptbooking(id:Int)->String?{
        var message:String? = nil
        let result = apiWrapper.getMethodCall(controllerName: "apibooking", actionName: "Accept?id=\(id)")
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
    
    func getBookingDetails(booking: Booking) -> Booking? {
        var bookingDetails: Booking?
        let userData = try! encoder.encode(booking)
        let result = apiWrapper.postMethodCall(controllerName: "apibooking", actionName: "BookingdetailsRanges", httpBody: userData)

        if result.ResponseCode == 200 {
            // Ok
            guard let data = result.ResponseData else {
                message = result.ResponseMessage
                return bookingDetails
            }
            do {
                let response = try decoder.decode(Booking.self, from: data)
                bookingDetails = response
            } catch {
                print(error.localizedDescription)
            }
        } else {
            message = result.ResponseMessage
        }
        return bookingDetails
    }

   

    func addBooking(booking: Booking) -> String {
        let userData = try! encoder.encode(booking)
        let result = apiWrapper.postMethodCall(controllerName: "apibooking", actionName: "AddBookingranges", httpBody: userData)

        if result.ResponseCode == 200 {
            // Ok
            guard let data = result.ResponseData else {
                message = result.ResponseMessage
                return message
            }
            do {
                message = try decoder.decode(String.self, from: data)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        else {
            message = result.ResponseMessage
        }
        return message
    }
    
    public func getBookingHistory(id: Int) -> [Booking] {
        var list = [Booking]()
        var message:String? = nil
        let result = apiWrapper.getMethodCall(controllerName: "apibooking", actionName: "bookinghistoryranges?id=\(id)")
        if result.ResponseCode == 200{
            //ok
            guard let data = result.ResponseData else{
                message = result.ResponseMessage
                return list
            }
            
            do {
                list = try decoder.decode([Booking].self, from: data)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        else{
            message = result.ResponseMessage
        }
        return list
    }
    
    public func getBill(bid: Int) -> Booking? {
        var obj : Booking? = nil
        var message:String? = nil
        let result = apiWrapper.getMethodCall(controllerName: "apibooking", actionName: "Billranges?bid=\(bid)")
        if result.ResponseCode == 200{
            //ok
            guard let data = result.ResponseData else{
                message = result.ResponseMessage
                return obj
            }
            
            do {
                obj = try decoder.decode(Booking.self, from: data)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        else{
            message = result.ResponseMessage
        }
        return obj
    }
}
