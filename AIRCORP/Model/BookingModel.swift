//
//  BookingModel.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 30/01/24.
//

import UIKit

class BookingModel : NSObject, Codable {
    
    var bookingId : String?
    var uid : String?
    var returnFlight : Bool?
    var sourceLocationCode : String?
    var sourceLocation : String?
    var sourceTime : Date?
    var destinationLocationCode : String?
    var destinationLocation : String?
    var destinationTime : Date?
    var totalTime : Int?
    var repositioningTime : Int?
    var bookingCreateDate : Date?
    var modeOfTravel : String?
    var status : String?
    var piolatID : String?
    var cancelReason : String?
    var completionDate : Date?
    var totalPassenger : Int?
    
    
}
