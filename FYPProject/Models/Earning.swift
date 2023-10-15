//
//  Earning.swift
//  FYPProject
//
//  Created by apple on 17/05/2023.
//

import Foundation

class Earning: Codable {
    var totalbookings: Int = 0
    var totalbookingearning: Double = 0.0
    var totalmembers: Int = 0
    var totalmemberearning: Double = 0.0
    var totalearning: Double = 0.0
}

class EarningManager {
    let apiWrapper = APIWrapper()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var message = ""
    
    public func EarningGround(id: Int, startdate: String, enddate: String) -> Earning? {
        var earningResult: Earning? = nil
        let result = apiWrapper.getMethodCall(controllerName: "earning", actionName: "ViewEarnings?id=\(id)&startdate=\(startdate)&enddate=\(enddate)")
        if result.ResponseCode == 200 {
            // OK
            guard let data = result.ResponseData else {
                message = result.ResponseMessage
                return nil
            }
            // Data is OK
            do {
                earningResult = try decoder.decode(Earning.self, from: data)
            } catch let error {
                message = error.localizedDescription
            }
        } else {
            message = result.ResponseMessage
        }
        return earningResult
    }
}
