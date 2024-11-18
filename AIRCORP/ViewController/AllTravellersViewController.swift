//
//  AllTravellersViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 02/11/24.
//

import UIKit

class AllTravellersViewController : UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var stack1: UIStackView!
    
    @IBOutlet weak var fullName1: UITextField!
    @IBOutlet weak var passportNumber1: UITextField!
    @IBOutlet weak var dob1: UITextField!
    
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var stack3: UIStackView!
    @IBOutlet weak var stack4: UIStackView!
    @IBOutlet weak var stack5: UIStackView!
    
    
    @IBOutlet weak var fullName2: UITextField!
    @IBOutlet weak var passportNumber2: UITextField!
    @IBOutlet weak var dob2: UITextField!
    
    @IBOutlet weak var fullName3: UITextField!
    @IBOutlet weak var passportNumber3: UITextField!
    @IBOutlet weak var dob3: UITextField!
    
    @IBOutlet weak var fullName4: UITextField!
    @IBOutlet weak var passportNumber4: UITextField!
    @IBOutlet weak var dob4: UITextField!
    
    @IBOutlet weak var fullName5: UITextField!
    @IBOutlet weak var passportNumber5: UITextField!
    
    @IBOutlet weak var dob5: UITextField!
    var travellerArray: [Traveller]?
    
    override func viewDidLoad() {
        
        if travellerArray == nil || travellerArray!.count == 0 {
            
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
        }
        
        backView.isUserInteractionEnabled = true
        backView.layer.cornerRadius = 8
        backView.dropShadow()
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewClicked)))
        
        fullName1.delegate = self
        passportNumber1.delegate = self
        dob1.delegate = self
        
        dob1.setRightIcons(icon: UIImage(systemName: "calendar")!)
        dob2.setRightIcons(icon: UIImage(systemName: "calendar")!)
        dob3.setRightIcons(icon: UIImage(systemName: "calendar")!)
        dob4.setRightIcons(icon: UIImage(systemName: "calendar")!)
        dob5.setRightIcons(icon: UIImage(systemName: "calendar")!)
        
        fullName2.delegate = self
        passportNumber2.delegate = self
        dob2.delegate = self
        
        fullName3.delegate = self
        passportNumber3.delegate = self
        dob3.delegate = self
        
        fullName4.delegate = self
        passportNumber4.delegate = self
        dob4.delegate = self
        
        fullName5.delegate = self
        passportNumber5.delegate = self
        dob5.delegate = self
        
        stack1.isHidden = true
        stack2.isHidden = true
        stack3.isHidden = true
        stack4.isHidden = true
        stack5.isHidden = true
        
       
        for i in 1..<(travellerArray!.count + 1) {
                switch i {
                case 1 : stack1.isHidden = false
                    fullName1.text = travellerArray![0].name
                    passportNumber1.text = travellerArray![0].passportNumber
                    dob1.text = self.convertDateToString(travellerArray![0].dob)
                    
                    break
                case 2 : stack2.isHidden = false
                    fullName2.text = travellerArray![1].name
                    passportNumber2.text = travellerArray![1].passportNumber
                    dob2.text = self.convertDateToString(travellerArray![1].dob)
                    
                    break
                case 3 : stack3.isHidden = false
                    fullName3.text = travellerArray![2].name
                    passportNumber3.text = travellerArray![2].passportNumber
                    dob3.text = self.convertDateToString(travellerArray![2].dob)
                    
                    break
                case 4 : stack4.isHidden = false
                    fullName4.text = travellerArray![3].name
                    passportNumber4.text = travellerArray![3].passportNumber
                    dob4.text = self.convertDateToString(travellerArray![3].dob)
                    
                    break
                case 5 : stack5.isHidden = false
                    fullName5.text = travellerArray![4].name
                    passportNumber5.text = travellerArray![4].passportNumber
                    dob5.text = self.convertDateToString(travellerArray![4].dob)
                    
                    break
                    
                default:
                    print("NIL")
                }
            }
        
    }
    
    @objc func backViewClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AllTravellersViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
           return false // Prevents the keyboard from showing and disables editing
       }
    
}
