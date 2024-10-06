//
//  MainViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 29/01/24.
//
import UIKit
import FirebaseMessaging

class MainViewController : UITabBarController, UITabBarControllerDelegate {
  
    var tabBarItems = UITabBarItem()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate  = self
        
        
        let selectedImage1 = UIImage(named: "Home")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "Home(8)")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = deSelectedImage1
        tabBarItems.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "PNR Code(2)")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "PNR Code")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![1]
        tabBarItems.image = deSelectedImage2
        tabBarItems.selectedImage = selectedImage2
        
        let selectedImage3 = UIImage(named: "Notification")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "Notification(2)")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![2]
        tabBarItems.image = deSelectedImage3
        tabBarItems.selectedImage = selectedImage3
        
        let selectedImage4 = UIImage(named: "Location(2)")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage4 = UIImage(named: "Location")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![3]
        tabBarItems.image = deSelectedImage4
        tabBarItems.selectedImage = selectedImage4
        
        let selectedImage5 = UIImage(named: "Account")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage5 = UIImage(named: "Account(2)")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![4]
        tabBarItems.image = deSelectedImage5
        tabBarItems.selectedImage = selectedImage5
        
        updateFCMToken()
    }
    
    // Updates the FCM token for notifications
    func updateFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error)")
            } else if let token = token {
                self.updateUserNotificationToken(token)
            }
        }
    }
    
    // Helper function to update user and business notification tokens
    private func updateUserNotificationToken(_ token: String) {
        if let currentUser = FirebaseStoreManager.auth.currentUser {
            UserModel.data?.notificationToken = token
            FirebaseStoreManager.db.collection("Users").document(currentUser.uid)
                .setData(["notificationToken": token], merge: true)

        } else {
            self.logout()
        }
    }

}


