//
//  AircraftTableViewCell.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 05/02/24.
//

import UIKit

class AircraftTableViewCell : UITableViewCell {
    
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var aircraftPic: UIImageView!
    
    @IBOutlet weak var aircraftNumber: UILabel!
    
    @IBOutlet weak var nextServiceDate: UILabel!
    @IBOutlet weak var docDownloadBtn: UIImageView!
    @IBOutlet weak var flyingTime: UILabel!

    @IBOutlet weak var annualDate: UILabel!
    @IBOutlet weak var aircraftCategory: UILabel!
    @IBOutlet weak var numberSeats: UILabel!
    @IBOutlet weak var cruiseSpeed: UILabel!
}
