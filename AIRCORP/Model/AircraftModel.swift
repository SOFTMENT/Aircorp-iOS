//
//  AircraftModel.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 05/02/24.
//

import UIKit

class AircraftModel : NSObject, Codable {
    
    var id : String?
    var aircraftNumber : String?
    var picture : String?
    var cerificateType : String?
    var certificateDoc : String?
    var nextServiceDate : Date?
    var annualDate : Date?
    var aircraftCreateDate : Date?
    
    var flyingTime : String?
    var aircraftType : String?
    var numberOfPassengersSeats : String?
    var cruiseSpeed : String?
    
}
