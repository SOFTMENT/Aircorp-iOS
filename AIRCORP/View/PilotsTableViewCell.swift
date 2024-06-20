//
//  PilotsTableViewCell.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 03/02/24.
//

import UIKit

class PilotsTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var licenceDaysLeft: UILabel!
    @IBOutlet weak var medicalDaysLeft: UILabel!
    
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mProfile: UIImageView!
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var mEmail: UILabel!
    override class func awakeFromNib() {
        
    }
    
    
}
