//
//  AddTravellersViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 29/10/24.
//


import UIKit

class AddTravellersViewController : UIViewController {
    
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
    @IBOutlet weak var bookBtn: UIButton!
    var appointmentDepartModel : AppointmentModel?
    var appointmentReturnModel : AppointmentModel?
    var bookingModel : BookingModel?
    
    // Create a date picker
       let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    let datePicker3 = UIDatePicker()
    let datePicker4 = UIDatePicker()
    let datePicker5 = UIDatePicker()
    override func viewDidLoad() {
        guard let bookingModel = bookingModel else {
            self.dismiss(animated: true)
            return
        }
        backView.isUserInteractionEnabled = true
        backView.layer.cornerRadius = 8
        backView.dropShadow()
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewClicked)))
        
        bookBtn.layer.cornerRadius = 8
       
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
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewClicked)))
        
        stack1.isHidden = true
        stack2.isHidden = true
        stack3.isHidden = true
        stack4.isHidden = true
        stack5.isHidden = true
        
        if let travellers = bookingModel.totalPassenger {
            for i in 1..<(travellers + 1){
                switch i {
                case 1 : stack1.isHidden = false
                    break
                case 2 : stack2.isHidden = false
                    break
                case 3 : stack3.isHidden = false
                    break
                case 4 : stack4.isHidden = false
                    break
                case 5 : stack5.isHidden = false
                    break
                    
                default:
                    print("NIL")
                }
            }
        }
        
        // Configure the date picker
                datePicker1.datePickerMode = .date
                datePicker1.preferredDatePickerStyle = .wheels // You can also use .inline or .compact
                
                // Set the date picker as the input view for the text field
                dob1.inputView = datePicker1
                
                // Add a toolbar with a Done button
                let toolbar1 = UIToolbar()
                toolbar1.sizeToFit()
                let doneButton1 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed1))
                toolbar1.setItems([doneButton1], animated: true)
                
                // Set the toolbar as the input accessory view
                dob1.inputAccessoryView = toolbar1
        
        datePicker2.datePickerMode = .date
        datePicker2.preferredDatePickerStyle = .wheels // You can also use .inline or .compact
        
        // Set the date picker as the input view for the text field
        dob2.inputView = datePicker2
        
        // Add a toolbar with a Done button
        let toolbar2 = UIToolbar()
        toolbar2.sizeToFit()
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed2))
        toolbar2.setItems([doneButton2], animated: true)
        
        // Set the toolbar as the input accessory view
        dob2.inputAccessoryView = toolbar2
        
        datePicker3.datePickerMode = .date
        datePicker3.preferredDatePickerStyle = .wheels // You can also use .inline or .compact
        
        // Set the date picker as the input view for the text field
        dob3.inputView = datePicker3
        
        // Add a toolbar with a Done button
        let toolbar3 = UIToolbar()
        toolbar3.sizeToFit()
        let doneButton3 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed3))
        toolbar3.setItems([doneButton3], animated: true)
        
        // Set the toolbar as the input accessory view
        dob3.inputAccessoryView = toolbar3
        
        datePicker4.datePickerMode = .date
        datePicker4.preferredDatePickerStyle = .wheels // You can also use .inline or .compact
        
        // Set the date picker as the input view for the text field
        dob4.inputView = datePicker4
        
        // Add a toolbar with a Done button
        let toolbar4 = UIToolbar()
        toolbar4.sizeToFit()
        let doneButton4 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed4))
        toolbar4.setItems([doneButton4], animated: true)
        
        // Set the toolbar as the input accessory view
        dob4.inputAccessoryView = toolbar4
        
        
        datePicker5.datePickerMode = .date
        datePicker5.preferredDatePickerStyle = .wheels // You can also use .inline or .compact
        
        // Set the date picker as the input view for the text field
        dob5.inputView = datePicker5
        
        // Add a toolbar with a Done button
        let toolbar5 = UIToolbar()
        toolbar5.sizeToFit()
        let doneButton5 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed5))
        toolbar5.setItems([doneButton5], animated: true)
        
        // Set the toolbar as the input accessory view
        dob5.inputAccessoryView = toolbar5
        
        
    }
    
    // Called when Done button is pressed
     @objc func donePressed1() {
      
         
         // Set the text field to show the selected date
         dob1.text = self.convertDateToString(self.datePicker1.date)
         
         // Dismiss the date picker
       dob1.resignFirstResponder()
     }
    
    // Called when Done button is pressed
     @objc func donePressed2() {
      
         // Set the text field to show the selected date
        dob2.text = self.convertDateToString(self.datePicker2.date)
         
         // Dismiss the date picker
       dob2.resignFirstResponder()
     }
    
    
    
    
    // Called when Done button is pressed
     @objc func donePressed3() {
      
         
         // Set the text field to show the selected date
         dob3.text = self.convertDateToString(self.datePicker3.date)
         
         // Dismiss the date picker
       dob3.resignFirstResponder()
     }
    // Called when Done button is pressed
     @objc func donePressed4() {
      
         
         // Set the text field to show the selected date
         dob4.text = self.convertDateToString(self.datePicker4.date)
         
         // Dismiss the date picker
       dob4.resignFirstResponder()
     }
    
    
    // Called when Done button is pressed
    @objc func donePressed5(){
      
         
         // Set the text field to show the selected date
         dob5.text = self.convertDateToString(self.datePicker5.date)
         
         // Dismiss the date picker
       dob5.resignFirstResponder()
     }

    
    @objc func viewClicked() {
        self.view.endEditing(true)
    }
    
    @objc func backViewClicked(){
        self.dismiss(animated : true)
    }
    
    @IBAction func bookBtnClicked(_ sender: Any) {
        var travellers = [Traveller]()
        if !stack1.isHidden {
            let sFullname = fullName1.text
            let sPassport = passportNumber1.text
            let sDob = dob1.text
            
            if sFullname == "" {
                self.showSnack(messages: "Enter traveller 1 full name")
                return
            }
            else if sPassport == "" {
                self.showSnack(messages: "Enter traveller 1 passport number")
                return
            }
            else if sDob == "" {
                self.showSnack(messages: "Enter traveller 1 date of birth")
                return
            }
            else {
                let traveller = Traveller(name: sFullname ?? "", dob: datePicker1.date, passportNumber: sPassport ?? "")
                travellers.append(traveller)
            }
        }
        if !stack2.isHidden {
            let sFullname = fullName2.text
            let sPassport = passportNumber2.text
            let sDob = dob2.text
            
            if sFullname == "" {
                self.showSnack(messages: "Enter traveller 2 full name")
                return
            }
            else if sPassport == "" {
                self.showSnack(messages: "Enter traveller 2 passport number")
                return
            }
            else if sDob == "" {
                self.showSnack(messages: "Enter traveller 2 date of birth")
                return
            }
            else {
                let traveller = Traveller(name: sFullname ?? "", dob: datePicker2.date, passportNumber: sPassport ?? "")
                travellers.append(traveller)
            }
        }
        if !stack3.isHidden {
            let sFullname = fullName3.text
            let sPassport = passportNumber3.text
            let sDob = dob3.text
            
            if sFullname == "" {
                self.showSnack(messages: "Enter traveller 3 full name")
                return
            }
            else if sPassport == "" {
                self.showSnack(messages: "Enter traveller 3 passport number")
                return
            }
            else if sDob == "" {
                self.showSnack(messages: "Enter traveller 3 date of birth")
                return
            }
            else {
                let traveller = Traveller(name: sFullname ?? "", dob: datePicker3.date, passportNumber: sPassport ?? "")
                travellers.append(traveller)
            }
        }
        if !stack4.isHidden {
            let sFullname = fullName4.text
            let sPassport = passportNumber4.text
            let sDob = dob4.text
            
            if sFullname == "" {
                self.showSnack(messages: "Enter traveller 4 full name")
                return
            }
            else if sPassport == "" {
                self.showSnack(messages: "Enter traveller 4 passport number")
                return
            }
            else if sDob == "" {
                self.showSnack(messages: "Enter traveller 4 date of birth")
                return
            }
            else {
                let traveller = Traveller(name: sFullname ?? "", dob: datePicker4.date, passportNumber: sPassport ?? "")
                travellers.append(traveller)
            }
        }
        if !stack5.isHidden {
            let sFullname = fullName5.text
            let sPassport = passportNumber5.text
            let sDob = dob5.text
            
            if sFullname == "" {
                self.showSnack(messages: "Enter traveller 5 full name")
                return
            }
            else if sPassport == "" {
                self.showSnack(messages: "Enter traveller 5 passport number")
                return
            }
            else if sDob == "" {
                self.showSnack(messages: "Enter traveller 5 date of birth")
                return
            }
            else {
                let traveller = Traveller(name: sFullname ?? "", dob: datePicker5.date, passportNumber: sPassport ?? "")
                travellers.append(traveller)
            }
        }
        
        bookingModel?.travellers = travellers
        performSegue(withIdentifier: "estimateSeg", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "estimateSeg"  {
            if let VC = segue.destination as? EstimationViewController {
                VC.appointmentDepartModel = self.appointmentDepartModel
                VC.appointmentReturnModel = self.appointmentReturnModel
                VC.bookingModel = self.bookingModel
            }
        }
    }
    
}


extension AddTravellersViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
