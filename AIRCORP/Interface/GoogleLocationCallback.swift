//
//  GoogleLocationSelected.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 11/02/24.
//

import UIKit

protocol GoogleLocationCallback {
    
    func didLocationSelected(fromToCode : Int,placeModel : Place)
    
}
