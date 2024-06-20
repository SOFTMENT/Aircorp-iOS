//
//  ProfileViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 29/01/24.
//

import UIKit
import StoreKit
import CropViewController
import Firebase
import FirebaseFirestore


class ProfileViewController : UIViewController {
    
    @IBOutlet weak var myBookingsView: UIView!
    @IBOutlet weak var deleteAccountBtn: UIView!
    @IBOutlet weak var termsOfService: UIView!
    @IBOutlet weak var privacy: UIView!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var inviteFriends: UIView!
    @IBOutlet weak var rateApp: UIView!
    @IBOutlet weak var helpCentre: UIView!
    @IBOutlet weak var notificationCentre: UIView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var logout: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
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
        
        //HelpCentre
        helpCentre.isUserInteractionEnabled = true
        helpCentre.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(helpCentreBtnClicked)))
        
 
       
        //DELETE ACCOUNT
        
        deleteAccountBtn.isUserInteractionEnabled = true
        deleteAccountBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteAccountBtnClicked)))
                
        
        myBookingsView.isUserInteractionEnabled = true
        myBookingsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myBookingsClicked)))
    }
    
    @objc func myBookingsClicked(){
        performSegue(withIdentifier: "seeAllSeg", sender: nil)
    }
    
    @objc func deleteAccountBtnClicked(){
        let alert = UIAlertController(title: "DELETE ACCOUNT", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            
            if let user = Auth.auth().currentUser {
                
                self.ProgressHUDShow(text: "Account Deleting...")
                let userId = user.uid
                
                        Firestore.firestore().collection("Users").document(userId).delete { error in
                           
                            if error == nil {
                                user.delete { error in
                                    self.ProgressHUDHide()
                                    if error == nil {
                                        self.logout()
                                        
                                    }
                                    else {
                                        self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
                                    }
    
                                
                                }
                                
                            }
                            else {
                       
                                self.showError(error!.localizedDescription)
                            }
                        }
                    
                }
            
            
        }))
        present(alert, animated: true)
    }
    
    @objc func helpCentreBtnClicked(){
        
    
        if let url = URL(string: "mailto:michael@centum.ie") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    @objc func notificationBtnClicked(){
        if let mainView = tabBarController {
            mainView.selectedIndex = 2
        }
    }
    
    
  
    
    
    
    @objc func redirectToTermsOfService() {
        
        guard let url = URL(string: "https://softment.in/terms-of-service/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func redirectToPrivacyPolicy() {
        
        guard let url = URL(string: "https://softment.in/privacy-policy/") else { return}
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




