//
//  AppointmentModel.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 01/02/24.
//

import UIKit

class AppointmentModel : NSObject, Codable {
    var appointmentId : String?
    var appointmentDate : Date?
    var appointmentStarTime : String?
    var appointmentDateString : String?
    var selectedHours : [Int]?
}
