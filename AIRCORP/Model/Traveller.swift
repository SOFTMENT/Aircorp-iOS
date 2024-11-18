//
//  Traveller.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 01/11/24.
//

import Foundation

class Traveller: NSObject, Codable {
    var name: String
    var dob: Date
    var passportNumber: String
    
    init(name: String, dob: Date, passportNumber: String) {
        self.name = name
        self.dob = dob
        self.passportNumber = passportNumber
    }
}
