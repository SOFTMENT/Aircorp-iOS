//
//  LocationCallback.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 01/02/24.
//

import UIKit

protocol LocationCallback  {
    
    func didLocationSelected(fromToCode : Int,airportModel : AirportModel)
    
}
