//
//  AdminTabbarViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 03/02/24.
//


import UIKit

class AdminTabbarViewController : UITabBarController, UITabBarControllerDelegate {
  
    var tabBarItems = UITabBarItem()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate  = self
        
        
        let selectedImage1 = UIImage(named: "PNR Code(2)")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "PNR Code")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = deSelectedImage1
        tabBarItems.selectedImage = selectedImage1
        

        
        let selectedImage3 = UIImage(named: "Autopilot")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "Autopilot(2)")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![1]
        tabBarItems.image = deSelectedImage3
        tabBarItems.selectedImage = selectedImage3
        
        let selectedImage4 = UIImage(named: "Air Force Commander Male(2)")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage4 = UIImage(named: "Air Force Commander Male")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![2]
        tabBarItems.image = deSelectedImage4
        tabBarItems.selectedImage = selectedImage4
        
        let selectedImage2 = UIImage(named: "Notification")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "Notification(2)")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![3]
        tabBarItems.image = deSelectedImage2
        tabBarItems.selectedImage = selectedImage2
        
        let selectedImage5 = UIImage(named: "Account")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage5 = UIImage(named: "Account(2)")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![4]
        tabBarItems.image = deSelectedImage5
        tabBarItems.selectedImage = selectedImage5
        
        selectedIndex = Constants.selectedIndex
    }
    
}


