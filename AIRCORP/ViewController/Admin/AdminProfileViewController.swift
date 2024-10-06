//
//  AdminProfileViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 03/02/24.
//

import UIKit
import StoreKit
import CropViewController
import Firebase
import FirebaseFirestore


class AdminProfileViewController : UIViewController {
    

    @IBOutlet weak var termsOfService: UIView!
    @IBOutlet weak var privacy: UIView!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var inviteFriends: UIView!
    @IBOutlet weak var rateApp: UIView!
   
    @IBOutlet weak var notificationCentre: UIView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var logout: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var aircraftView: UIView!
    
    var isProfilePicChanged = false
    var downloadURL : String = ""
    
    override func viewDidLoad() {
        
        profileImage.makeRounded()


        guard let user = UserModel.data else {
            return
        }
    
        
        name.text = user.fullName
        email.text = user.email
        
        if let image = user.profilePic, image != "" {
            profileImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profile-placeholder"), options: .continueInBackground, completed: nil)
        }
        
  
        rateApp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rateAppBtnClicked)))
        inviteFriends.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inviteFriendBtnClicked)))
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        version.text  = "\(appVersion ?? "1.0")"
        
        privacy.isUserInteractionEnabled = true
        privacy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToPrivacyPolicy)))
        
        termsOfService.isUserInteractionEnabled = true
        termsOfService.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToPrivacyPolicy)))
        
        //Logout
        logout.isUserInteractionEnabled = true
        logout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutBtnClicked)))
        
        
       
        //NotificationCentre
        notificationCentre.isUserInteractionEnabled = true
        notificationCentre.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notificationBtnClicked)))
  
      
             
   
        aircraftView.isUserInteractionEnabled = true
        aircraftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(airCraftClicked)))
            

        
    }


    
    @objc func airCraftClicked(){
        if let adminTab = tabBarController {
            adminTab.selectedIndex = 1
        }
    }
    
    @objc func notificationBtnClicked(){
        if let adminTab = tabBarController {
            adminTab.selectedIndex = 3
        }
    }
    

    @objc func redirectToTermsOfService() {
        
        guard let url = URL(string: "https://softment.com/terms-of-service/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func redirectToPrivacyPolicy() {
        
        guard let url = URL(string: "https://softment.com/privacy-policy/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func inviteFriendBtnClicked(){
        
        let someText:String = "Check Out AIRCORP App Now."
        let objectsToShare:URL = URL(string: "https://apps.apple.com/us/app/AIRCORP/id6476836413?ls=1&mt=8")!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func rateAppBtnClicked(){
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.windows.first?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "6476836413") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
 
    @objc func logoutBtnClicked(){
        
        let alert = UIAlertController(title: "LOGOUT", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
            self.logout()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
      
    }

    
   
    
    
}




