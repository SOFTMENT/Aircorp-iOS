//
//  ViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 29/01/24.
//

import UIKit

class WelcomeViewController :  UIViewController {
    
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        

        
        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
            //if app is first time opened then it will be nil
            userDefaults.setValue(true, forKey: "appFirstTimeOpend")
            
       
            FirebaseStoreManager.messaging.subscribe(toTopic: "aircorp")
            
            // signOut from FIRAuth
            do {
                
                try FirebaseStoreManager.auth.signOut()
            }catch {
                
            }
            // go to beginning of app
        }
        
        
        
        
        if let user = FirebaseStoreManager.auth.currentUser {
            
            self.getUserData(uid:user.uid, showProgress: false)
            
            
        }
        else {
            
            self.gotoSignInViewController()
            
        }
    
        
    }
    
    func gotoSignInViewController(){
        DispatchQueue.main.async {
            self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
        }
    }
    
}
