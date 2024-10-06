//
//  PilotModel.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 03/02/24.
//

import UIKit

class PilotModel : NSObject, Codable {
    
    var id : String?
    var name : String?
    var email : String?
    var password : String?
    var profileImage : String?
    var ratingExpireDate : Date?
    var medicalExpireDate : Date?
    var licenceDoc : String?
    var licenceDocType : String?
    var medicalDocType : String?
    var medicalDoc : String?
    var orderIndex : Int?
    var canFly : String?
    var phoneNumber : String?
    var notificationToken : String?
    
    private static var pilotData: PilotModel?
    
    static var data: PilotModel? {
        set(pilotData) {
            if self.pilotData == nil {
                self.pilotData = pilotData
            }
        }
        get {
            pilotData
        }
    }
}
