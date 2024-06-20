//
//  AirportModel.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 31/01/24.
//


import UIKit

class AirportModel : NSObject, Codable {
    
    var id : Int?
    var ident : String?
    var type : String?
    var name : String?
    var latitude_deg : String?
    var longitude_deg : String?
    var continent : String?
    var iso_country : String?
    var municipality : String?
    var scheduled_service : String?
    var gps_code : String?
    var iata_code : String?
    var local_code : String?
    var home_link : String?
    var keywords : String?
    
}
