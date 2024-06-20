//
//  BookingTableViewCell.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 30/01/24.
//

import UIKit

class BookingTableViewCell : UITableViewCell {
    
    @IBOutlet weak var mView: UIView!
    
    @IBOutlet weak var sourceTime: UILabel!
    @IBOutlet weak var sourceLocationCode: UILabel!
    @IBOutlet weak var sourceLocationName: UILabel!
    @IBOutlet weak var mModeView: UIView!
    @IBOutlet weak var mModeImg: UIImageView!
    @IBOutlet weak var totalDuration: UILabel!
    @IBOutlet weak var bookingDate: UILabel!
    
    @IBOutlet weak var destinationTime: UILabel!
    @IBOutlet weak var destinationLocationCode: UILabel!
    @IBOutlet weak var destinationLocationName: UILabel!
    
    
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var statusLbl: UILabel!
    
    
    override class func awakeFromNib() {
        
    }
    
    
    
    
}
