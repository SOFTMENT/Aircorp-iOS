//
//  SuccessViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 01/02/24.
//

import UIKit

class SuccessViewController : UIViewController {
    
    @IBOutlet weak var doneBtn: UIButton!
    override func viewDidLoad() {
        doneBtn.layer.cornerRadius = 8
    }
    @IBAction func doneBtnClicked(_ sender: Any) {
        self.beRootScreen(mIdentifier: Constants.StroyBoard.mainViewController)
    }
    
}
