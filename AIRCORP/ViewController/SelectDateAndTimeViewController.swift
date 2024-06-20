//
//  SelectDateAndTimeViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 01/02/24.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FSCalendar


class SelectDateAndTimeViewController : UIViewController {
    let userNotificationCenter = UNUserNotificationCenter.current()
  

    @IBOutlet weak var topTitle: UILabel!
    
    @IBOutlet weak var backView: UIView!
    let datePicker = UIDatePicker()
    var selectedHours = [Int]()
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var morningView: UIView!
    @IBOutlet weak var afternoonView: UIView!
    @IBOutlet weak var eveningView: UIView!
    
    @IBOutlet weak var m12_00am: UIButton!
    @IBOutlet weak var m12_30am: UIButton!
    
    @IBOutlet weak var m01_00am: UIButton!
    @IBOutlet weak var m01_30am: UIButton!
    
    @IBOutlet weak var m02_00am: UIButton!
    @IBOutlet weak var m02_30am: UIButton!
    
    @IBOutlet weak var m03_00am: UIButton!
    @IBOutlet weak var m03_30am: UIButton!
    
    @IBOutlet weak var m04_00am: UIButton!
    @IBOutlet weak var m04_30am: UIButton!
    
    @IBOutlet weak var m05_00am: UIButton!
    @IBOutlet weak var m05_30am: UIButton!
    
    @IBOutlet weak var m06_00am: UIButton!
    @IBOutlet weak var m06_30am: UIButton!
    
    @IBOutlet weak var m07_00am: UIButton!
    @IBOutlet weak var m07_30am: UIButton!
    
    @IBOutlet weak var m08_00am: UIButton!
    @IBOutlet weak var m08_30am: UIButton!
    
    @IBOutlet weak var m09_00am: UIButton!
    @IBOutlet weak var m09_30am: UIButton!
    
    @IBOutlet weak var m10_00am: UIButton!
    @IBOutlet weak var m10_30am: UIButton!
    
    @IBOutlet weak var m11_00am: UIButton!
    @IBOutlet weak var m11_30am: UIButton!
    
    @IBOutlet weak var m12_00pm: UIButton!
    @IBOutlet weak var m12_30pm: UIButton!
    
    @IBOutlet weak var m01_00pm: UIButton!
    @IBOutlet weak var m01_30pm: UIButton!
    
    @IBOutlet weak var m02_00pm: UIButton!
    @IBOutlet weak var m02_30pm: UIButton!
    
    @IBOutlet weak var m03_00pm: UIButton!
    @IBOutlet weak var m03_30pm: UIButton!
    
    @IBOutlet weak var m04_00pm: UIButton!
    @IBOutlet weak var m04_30pm: UIButton!
    
    @IBOutlet weak var m05_00pm: UIButton!
    @IBOutlet weak var m05_30pm: UIButton!
    
    @IBOutlet weak var m06_00pm: UIButton!
    @IBOutlet weak var m06_30pm: UIButton!
    
    @IBOutlet weak var m07_00pm: UIButton!
    @IBOutlet weak var m07_30pm: UIButton!
    
    @IBOutlet weak var m08_00pm: UIButton!
    @IBOutlet weak var m08_30pm: UIButton!
    
    @IBOutlet weak var m09_00pm: UIButton!
    @IBOutlet weak var m09_30pm: UIButton!
    
    @IBOutlet weak var m10_00pm: UIButton!
    @IBOutlet weak var m10_30pm: UIButton!
    
    @IBOutlet weak var m11_00pm: UIButton!
    @IBOutlet weak var m11_30pm: UIButton!

    var selectedDate = Date()
    var departureReturnCode : Int?
    var delegate : DateTimeCallback?
    var modeOfTravel : String?
    
    
    override func viewDidLoad() {
    
        guard let departureReturnCode = departureReturnCode, modeOfTravel != nil, delegate != nil else {
            
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
            
        }
        
        if departureReturnCode == 1 {
            self.topTitle.text = "Departure Date"
        }
        else {
            self.topTitle.text = "Return Date"
        }

        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        backView.layer.cornerRadius = 8
        backView.dropShadow()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.select(Date())
        
        
        
        morningView.layer.cornerRadius = 8
        afternoonView.layer.cornerRadius = 8
        eveningView.layer.cornerRadius = 8
    
        getAppointment(dateString: self.convertDateForAppointment(Date()))
        
    }
    
    
    
  
    func getAppointment(dateString : String){
        ProgressHUDShow(text: "Loading...")
        var appointment = ""
        if self.modeOfTravel! == VehicleMode.HELICOPTER {
            appointment = Appointment.HELICOPTER
        }
        else {
            appointment = Appointment.PLANE
        }
        Firestore.firestore().collection(appointment).whereField("appointmentDateString", isEqualTo: dateString).getDocuments { snapshot, error in
            self.ProgressHUDHide()
            if let error = error {
                self.showError(error.localizedDescription)
            }
            else {
                self.refreshUI()
                if let snapshot = snapshot, !snapshot.isEmpty {
                    for qdr in snapshot.documents {
                        if let appointment = try? qdr.data(as: AppointmentModel.self) {
                           
                            self.setTimeUI(selectedHours: appointment.selectedHours)
                        }
                    }
                }
                
            }
        }
    }
    
    
    
    @objc func backBtnClicked() {
        self.dismiss(animated: true)
    }
    
    func nextClicked(startTime : String, startNumber : Int) {
    
        selectedHours.removeAll()
    
       
   
            self.selectedHours.append(startNumber)
      
      

                let appointment = AppointmentModel()
               
               
                appointment.appointmentDate = self.selectedDate
                appointment.appointmentStarTime = startTime

                appointment.appointmentDateString = self.convertDateForAppointment(self.selectedDate)
                appointment.selectedHours = self.selectedHours
             
        self.dismiss(animated: true) {
            self.delegate?.dateTimeSelected(depatureReturnCode: self.departureReturnCode!, appointmentModel: appointment)
        }
            
      
    }
    
    public func refreshUI(){
        resetButton(value: m12_00am)
        resetButton(value: m12_30am)
        resetButton(value: m01_00am)
        resetButton(value: m01_30am)
        resetButton(value: m02_00am)
        resetButton(value: m02_30am)
        resetButton(value: m03_00am)
        resetButton(value: m03_30am)
        resetButton(value: m04_00am)
        resetButton(value: m04_30am)
        resetButton(value: m05_00am)
        resetButton(value: m05_30am)
        resetButton(value: m06_00am)
        resetButton(value: m06_30am)
        resetButton(value: m07_00am)
        resetButton(value: m07_30am)
        resetButton(value: m08_00am)
        resetButton(value: m08_30am)
        resetButton(value: m09_00am)
        resetButton(value: m09_30am)
        resetButton(value: m10_00am)
        resetButton(value: m10_30am)
        resetButton(value: m11_00am)
        resetButton(value: m11_30am)
        resetButton(value: m12_00pm)
        resetButton(value: m12_30pm)
        resetButton(value: m01_00pm)
        resetButton(value: m01_30pm)
        resetButton(value: m02_00pm)
        resetButton(value: m02_30pm)
        resetButton(value: m03_00pm)
        resetButton(value: m03_30pm)
        resetButton(value: m04_00pm)
        resetButton(value: m04_30pm)
        resetButton(value: m05_00pm)
        resetButton(value: m05_30pm)
        resetButton(value: m06_00pm)
        resetButton(value: m06_30pm)
        resetButton(value: m07_00pm)
        resetButton(value: m07_30pm)
        resetButton(value: m08_00pm)
        resetButton(value: m08_30pm)
        resetButton(value: m09_00pm)
        resetButton(value: m09_30pm)
        resetButton(value: m10_00pm)
        resetButton(value: m10_30pm)
        resetButton(value: m11_00pm)
        resetButton(value: m11_30pm)
        
        
    }
    
    public func resetButton(value : UIButton) {
        value.setTitleColor(.white, for: .normal)
        value.isEnabled = true
        value.layer.cornerRadius = 8
        value.isUserInteractionEnabled = true
        value.isEnabled = true
        value.backgroundColor = UIColor(red: 75/255, green: 181/255, blue: 67/255, alpha: 1)
    }
    
    public func setTimeUI(selectedHours : [Int]?) {
        
    
        guard let selectedHours = selectedHours else {
            return
        }
        
        for x in 0..<(selectedHours.count) {
            var btn : UIButton?
            switch selectedHours[x] {
            case 0: btn = self.m12_00am
                break
            case 1: btn = self.m12_30am
                break
            case 2: btn = self.m01_00am
                break
            case 3: btn = self.m01_30am
                break
            case 4: btn = self.m02_00am
                break
            case 5: btn = self.m02_30am
                break
            case 6: btn = self.m03_00am
                break
            case 7: btn = self.m03_30am
                break
            case 8: btn = self.m04_00am
                break
            case 9: btn = self.m04_30am
                break
            case 10: btn = self.m05_00am
                break
            case 11: btn = self.m05_30am
                break
            case 12: btn = self.m06_00am
                break
            case 13: btn = self.m06_30am
                break
            case 14: btn = self.m07_00am
                break
            case 15: btn = self.m07_30am
                break
            case 16: btn = self.m08_00am
                break
            case 18: btn = self.m09_00am
                break
            case 19: btn = self.m09_30am
                break
            case 20: btn = self.m10_00am
                break
            case 21: btn = self.m10_30am
                break
            case 22: btn = self.m11_00am
                break
            case 23: btn = self.m11_30am
                break
            case 24: btn = self.m12_00pm
                break
            case 25: btn = self.m12_30pm
                break
            case 26: btn = self.m01_00pm
                break
            case 27: btn = self.m01_30pm
                break
            case 28: btn = self.m02_00pm
                break
            case 29: btn = self.m02_30pm
                break
            case 30: btn = self.m03_00pm
                break
            case 31: btn = self.m03_30pm
                break
            case 32: btn = self.m04_00pm
                break
            case 33: btn = self.m04_30pm
                break
            case 34: btn = self.m05_00pm
                break
            case 35: btn = self.m05_30pm
                break
            case 36: btn = self.m06_00pm
                break
            case 37: btn = self.m06_30pm
                break
            case 38: btn = self.m07_00pm
                break
            case 39: btn = self.m07_30pm
                break
            case 40: btn = self.m08_00pm
                break
            case 41: btn = self.m08_30pm
                break
            case 42: btn = self.m09_00pm
                break
            case 43: btn = self.m09_30pm
                break
            case 44: btn = self.m10_00pm
                break
            case 45: btn = self.m10_30pm
                break
            case 46: btn = self.m11_00pm
                break
            case 47: btn = self.m11_30pm
                break
                
                
            default : print("NULL")
                
            }
            
            if let btn = btn {
                btn.backgroundColor = UIColor(red: 174/255, green: 174/255, blue: 174/255, alpha: 1)
                btn.setTitleColor(.white, for: .normal)
                btn.layer.cornerRadius = 8
                btn.isUserInteractionEnabled = false
                btn.isEnabled = false
            }
            
        }
        
    }
    
    
    
    @IBAction func m12_00amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "12:00 am",startNumber: 0)
        
        
    }
    @IBAction func m12_30amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "12:30 am",startNumber: 1)
        
        
    }
    
    @IBAction func m01_00amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "01:00 am",startNumber: 2)
        
        
    }
    
    @IBAction func m01_30amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "01:30 am",startNumber: 3)
        
        
    }
    
    @IBAction func m02_00amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "02:00 am",startNumber: 4)
        
        
    }
    @IBAction func m02_30amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "02:30 am",startNumber: 5)
        
        
    }
    @IBAction func m03_00amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "03:00 am",startNumber: 6)
        
        
    }
    @IBAction func m03_30amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "03:30 am",startNumber: 7)
        
        
    }
    @IBAction func m04_00amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "04:00 am",startNumber: 8)
        
        
    }
    @IBAction func m04_30amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "04:30 am",startNumber: 9)
        
        
    }
    @IBAction func m05_00amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "05:00 am",startNumber: 10)
        
        
    }
    @IBAction func m05_30amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "05:30 am",startNumber: 11)
        
        
    }
    @IBAction func m06_00amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "06:00 am",startNumber: 12)
        
        
    }
    @IBAction func m06_30amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "06:30 am",startNumber: 13)
        
        
    }
    @IBAction func m07_00amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "07:00 am",startNumber: 14)
        
        
    }
    @IBAction func m07_30amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "07:30 am",startNumber: 15)
        
        
    }
    @IBAction func m08_00amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "08:00 am",startNumber: 16)
        
        
    }
    @IBAction func m08_30amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "08:30 am",startNumber: 17)
        
        
    }
    @IBAction func m09_00amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "09:00 am",startNumber: 18)
        
        
    }
    @IBAction func m09_30amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "09:30 am",startNumber: 19)
        
        
    }
    @IBAction func m10_00amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "10:00 am",startNumber: 20)
        
        
    }
    @IBAction func m10_30amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "10:30 am",startNumber: 21)
        
        
    }
    @IBAction func m11_00amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "11:00 am",startNumber: 22)
        
        
    }
    @IBAction func m11_30amClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "11:30 am",startNumber: 23)
        
        
    }
    @IBAction func m12_00pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "12:00 pm",startNumber: 24)
        
        
    }
    
    @IBAction func m12_30pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "12:30 pm",startNumber: 25)
        
        
    }
    
    @IBAction func m01_00pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "01:00 pm",startNumber: 26)
        
        
    }
    
    @IBAction func m01_30pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "01:30 pm",startNumber: 27)
        
        
    }
    @IBAction func m02_00pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "02:00 pm",startNumber: 28)
        
        
    }
    @IBAction func m02_30pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "02:30 pm",startNumber: 29)
        
        
    }
    @IBAction func m03_00pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "03:00 pm",startNumber: 30)
        
        
    }
    @IBAction func m03_30pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "03:30 pm",startNumber: 31)
        
        
    }
    @IBAction func m04_00pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "04:00 pm",startNumber: 32)
        
        
    }
    @IBAction func m04_30pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "04:30 pm",startNumber: 33)
        
        
    }
    @IBAction func m05_00pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "05:00 pm",startNumber: 34)
        
        
    }
    @IBAction func m05_30pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "05:30 pm",startNumber: 35)
        
        
    }
    @IBAction func m06_00pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "06:00 pm",startNumber: 36)
        
        
    }
    @IBAction func m06_30pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "06:30 pm",startNumber: 37)
        
        
    }
    @IBAction func m07_00pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "07:00 pm",startNumber: 38)
        
        
    }
    @IBAction func m07_30pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "07:30 pm",startNumber: 39)
        
        
    }
    @IBAction func m08_00pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "08:00 pm",startNumber: 40)
        
        
    }
    @IBAction func m08_30pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "08:30 pm",startNumber: 41)
        
        
    }
    @IBAction func m09_00pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "09:00 pm",startNumber: 42)
        
        
    }
    @IBAction func m09_30pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "09:30 pm",startNumber: 43)
        
        
    }
    @IBAction func m10_00pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "10:00 pm",startNumber: 44)
        
        
    }
    @IBAction func m10_30pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "10:30 pm",startNumber: 45)
        
        
    }
    @IBAction func m11_00pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "11:00 pm",startNumber: 46)
        
        
    }
    @IBAction func m11_30pmClicked(_ sender: UIButton) {
        
        nextClicked(startTime: "11:30 pm",startNumber: 47)
        
        
    }
    

}

extension SelectDateAndTimeViewController  : FSCalendarDelegate, FSCalendarDataSource {
    
    
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        //let minimumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        
        var currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.day = -1
        currentDate = Calendar.current.date(byAdding: dateComponents, to: currentDate)!
        
        if date.compare(currentDate) == .orderedAscending {
            return false
        }
        else {
            return true
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        getAppointment(dateString: self.convertDateForAppointment(date))
    }
    
    
    
}


