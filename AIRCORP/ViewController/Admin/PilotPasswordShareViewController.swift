//
//  PilotPasswordShareViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 03/02/24.
//


import UIKit

class PilotPasswordShareViewController  : UIViewController {
    
    
    @IBOutlet weak var mEmail: UILabel!
    
    @IBOutlet weak var sPassword: UILabel!
    
    @IBOutlet weak var mCopy: UIImageView!
    
    @IBOutlet weak var mView: UIView!
    
    @IBOutlet weak var greatLbl: UILabel!
    
    @IBOutlet weak var dashboardBtn: UIButton!
    
    var fullName : String?
    var email : String?
    var password : String?
    var isUpdated : Bool = false
    override func viewDidLoad() {
        
        guard let email = email , let password = password else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
        }
        
        if isUpdated {
            greatLbl.text = "Great! Pilot account has been updated!"
        }
        
        mEmail.text = email
        sPassword.text = password
        mView.layer.cornerRadius = 8
    
        dashboardBtn.layer.cornerRadius = 8
        
        mCopy.isUserInteractionEnabled = true
        mCopy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyBtnClicked)))
        
        
    }
    
    @objc func copyBtnClicked(){
        self.showSnack(messages: "Copied")
        UIPasteboard.general.string = "Full Name - \(fullName ?? "")\n\nEmail - \(email ?? "")\n\nPassword - \(password ?? "")"
       
    }
    
    @IBAction func dashboardBtnClicked(_ sender: Any) {
        Constants.selectedIndex = 2
        self.beRootScreen(mIdentifier: Constants.StroyBoard.adminTabbarViewController)
    }
}
