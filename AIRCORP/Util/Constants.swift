//
//  Constants.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 29/01/24.
//

import UIKit


class Constants  {
    
    struct StroyBoard {
        
        static let signInViewController = "signInVC"
        static let mainViewController = "mainVC"
        static let adminTabbarViewController = "adminTabVC"
        static let pilotTabbarViewController = "pilotTabVC"
    
    }
    
    static var travelingMode : String?
    static let COST_PER_HOUR = 1200
    static var selectedIndex = 0
}



struct Status {
    static let PENDINGBYPILOT = "PendingPilot"
    static let PENDINGBYADMIN = "PendingAdmin"
    static let CONFIRMED = "Confirmed"
    static let CANCELED = "Canceled"
    static let COMPLETED = "Completed"
    
}

struct VehicleMode {
    static let HELICOPTER = "Helicopter"
    static let PLANE = "Plane"
}

struct Appointment {
    static let HELICOPTER = "HelicopterAppointments"
    static let PLANE = "PlaneAppointments"
}
