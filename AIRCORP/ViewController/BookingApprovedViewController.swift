//
//  BookingApprovedViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 17/02/24.
//

import UIKit
import Lottie

class BookingApprovedViewController : UIViewController {
    
    @IBOutlet weak var animation: LottieAnimationView!
    
    override func viewDidLoad() {
        
        animation.loopMode = .loop
        animation.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now()  + 3) {
            self.beRootScreen(mIdentifier: Constants.StroyBoard.mainViewController)
        }
        
    }
    
}
