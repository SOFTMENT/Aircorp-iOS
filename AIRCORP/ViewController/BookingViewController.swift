//
//  BookingViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 29/01/24.
//

import UIKit

class BookingViewController : UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var selectTravelingModeTF: UITextField!
    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var departDateView: UIView!
    @IBOutlet weak var departDate: UILabel!
    @IBOutlet weak var returnDateView: UIView!
    @IBOutlet weak var returnDate: UILabel!
    @IBOutlet weak var oneTraveller: UIView!
    @IBOutlet weak var twoTraveller: UIView!
    @IBOutlet weak var threeTraveller: UIView!
    @IBOutlet weak var fourTraveller: UIView!
    @IBOutlet weak var fiveTraveller: UIView!
    @IBOutlet weak var bookBtn: UIButton!
    @IBOutlet weak var oneLbl: UILabel!
    @IBOutlet weak var twoLbl: UILabel!
    @IBOutlet weak var threeLbl: UILabel!
    @IBOutlet weak var fourLbl: UILabel!
    @IBOutlet weak var fiveLbl: UILabel!
    let pickerView = UIPickerView()
    let options = [VehicleMode.HELICOPTER, VehicleMode.PLANE]
    @IBOutlet weak var mView: UIView!
    var totalPassenger = 0
    
    var airportModelFrom : AirportModel?
    var airportModelTo : AirportModel?
    
    var placeModelFrom : Place?
    var placeModelTo : Place?
    
    var departAppointmentModel : AppointmentModel?
    var returnAppointmentModel : AppointmentModel?
    override func viewDidLoad() {
        
        mView.roundTopCorners(cornerRadius: 24)
        
        
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 35/255, green: 50/255, blue: 81/255, alpha: 1)]
        
        
        segmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        oneTraveller.layer.cornerRadius = 8
        oneTraveller.dropShadow()
        
        let gest1 = MyGesture(target: self, action: #selector(travellerClick))
        gest1.index = 1
        oneTraveller.isUserInteractionEnabled = true
        oneTraveller.addGestureRecognizer(gest1)
        
        twoTraveller.layer.cornerRadius = 8
        twoTraveller.dropShadow()
        
        let gest2 = MyGesture(target: self, action: #selector(travellerClick))
        gest2.index = 2
        twoTraveller.isUserInteractionEnabled = true
        twoTraveller.addGestureRecognizer(gest2)
        
        threeTraveller.layer.cornerRadius = 8
        threeTraveller.dropShadow()
        
        let gest3 = MyGesture(target: self, action: #selector(travellerClick))
        gest3.index = 3
        threeTraveller.isUserInteractionEnabled = true
        threeTraveller.addGestureRecognizer(gest3)
        
        fourTraveller.layer.cornerRadius = 8
        fourTraveller.dropShadow()
        
        let gest4 = MyGesture(target: self, action: #selector(travellerClick))
        gest4.index = 4
        fourTraveller.isUserInteractionEnabled = true
        fourTraveller.addGestureRecognizer(gest4)
        
        
        fiveTraveller.layer.cornerRadius = 8
        fiveTraveller.dropShadow()
        
        let gest5 = MyGesture(target: self, action: #selector(travellerClick))
        gest5.index = 5
        fiveTraveller.isUserInteractionEnabled = true
        fiveTraveller.addGestureRecognizer(gest5)
        
        bookBtn.layer.cornerRadius = 8
        
        returnDateView.layer.borderWidth = 0.8
        returnDateView.layer.borderColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        returnDateView.layer.cornerRadius = 8
        returnDateView.isUserInteractionEnabled = true
        returnDateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnDateViewClicked)))
        
        departDateView.layer.borderWidth = 0.8
        departDateView.layer.cornerRadius = 8
        departDateView.layer.borderColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        departDateView.isUserInteractionEnabled = true
        departDateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(departDateViewClicked)))
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        selectTravelingModeTF.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        selectTravelingModeTF.inputAccessoryView = toolBar
        
        
        let tapGesture1 = MyGesture(target: self, action: #selector(locationFieldTapped))
        tapGesture1.index = 1
        fromTF.isUserInteractionEnabled = true
        fromTF.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = MyGesture(target: self, action: #selector(locationFieldTapped))
        tapGesture2.index = 2
        toTF.isUserInteractionEnabled = true
        toTF.addGestureRecognizer(tapGesture2)
        
    }
    
    @objc func departDateViewClicked(){
        let travellingMode = selectTravelingModeTF.text
        if travellingMode == "" {
            self.showSnack(messages: "Select mode of travel")
        }
        else {
            performSegue(withIdentifier: "depatureReturnDateSeg", sender: 1)
        }
      
    }
    
    @objc func returnDateViewClicked(){
      
        if departAppointmentModel != nil {
            let travellingMode = selectTravelingModeTF.text
            if travellingMode == "" {
                self.showSnack(messages: "Select mode of travel")
            }
            else {
                performSegue(withIdentifier: "depatureReturnDateSeg", sender: 2)
            }
           
        }
        else {
            self.showSnack(messages: "Select Depart Date First")
        }
       
    }
    
    
    
    @objc func locationFieldTapped(value : MyGesture) {
        let sVehicleMode = selectTravelingModeTF.text
        if sVehicleMode == "" {
            self.showSnack(messages: "Select travelling mode")
        }
        else {
            if pickerView.selectedRow(inComponent: 0) == 0 {
                performSegue(withIdentifier: "googleLocationSelectSeg", sender: value.index)
            }
            else {
                performSegue(withIdentifier: "locationSelectSeg", sender: value.index)
            }
        }
       
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationSelectSeg" {
            if let VC = segue.destination as? SelectLocationcViewController {
                if let fromToCode = sender as? Int {
                    VC.fromToCode = fromToCode
                    VC.delegate = self
                }
            }
        }
       else if segue.identifier == "googleLocationSelectSeg" {
            if let VC = segue.destination as? SelectHelicopterLocationViewController{
                if let fromToCode = sender as? Int {
                    VC.fromToCode = fromToCode
                    VC.delegate = self
                }
            }
        }
        else if segue.identifier == "depatureReturnDateSeg" {
            if let VC = segue.destination as? SelectDateAndTimeViewController {
                if let depatureReturnCode = sender as? Int {
                    VC.modeOfTravel =  selectTravelingModeTF.text
                    VC.delegate = self
                    VC.departureReturnCode = depatureReturnCode
                }
            }
        }
        else if segue.identifier == "estimationSeg" {
            if let VC = segue.destination as? EstimationViewController {
                if let bookingModel = sender as? BookingModel {
                    VC.bookingModel = bookingModel
                    let mDepartureModel = AppointmentModel()
                    mDepartureModel.selectedHours = Array<Int>()
                    mDepartureModel.selectedHours!.append(contentsOf: self.departAppointmentModel!.selectedHours ?? [])
                    mDepartureModel.appointmentDate = self.departAppointmentModel!.appointmentDate
                    mDepartureModel.appointmentId = self.departAppointmentModel!.appointmentId
                    
                    mDepartureModel.appointmentStarTime = self.departAppointmentModel!.appointmentStarTime
                    mDepartureModel.appointmentDateString = self.departAppointmentModel!.appointmentDateString
                    
                    VC.appointmentDepartModel = mDepartureModel
                 
                    
                    if let returnAppointmentModel = self.returnAppointmentModel {
                        let mReturnModel = AppointmentModel()
                        mReturnModel.selectedHours = Array<Int>()
                        mReturnModel.selectedHours!.append(contentsOf: returnAppointmentModel.selectedHours ?? [])
                        mReturnModel.appointmentDate = returnAppointmentModel.appointmentDate
                        mReturnModel.appointmentId = returnAppointmentModel.appointmentId
                      
                        mReturnModel.appointmentStarTime = returnAppointmentModel.appointmentStarTime
                        mReturnModel.appointmentDateString = returnAppointmentModel.appointmentDateString
                        VC.appointmentReturnModel = mReturnModel
                    }
                    
                }
            }
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc func travellerClick(value : MyGesture){
        allTravellerClear()
        totalPassenger = value.index
        switch value.index {
        case 1 : oneTraveller.backgroundColor = UIColor(red: 241/255, green: 173/255, blue: 72/255, alpha: 1)
            oneLbl.textColor = UIColor.white
        case 2 : twoTraveller.backgroundColor = UIColor(red: 241/255, green: 173/255, blue: 72/255, alpha: 1)
            twoLbl.textColor = UIColor.white
        case 3 : threeTraveller.backgroundColor = UIColor(red: 241/255, green: 173/255, blue: 72/255, alpha: 1)
            threeLbl.textColor = UIColor.white
        case 4 : fourTraveller.backgroundColor = UIColor(red: 241/255, green: 173/255, blue: 72/255, alpha: 1)
            fourLbl.textColor = UIColor.white
        case 5 : fiveTraveller.backgroundColor = UIColor(red: 241/255, green: 173/255, blue: 72/255, alpha: 1)
            fiveLbl.textColor = UIColor.white
        default:
            print("N/A")
        }
    }
    
    func allTravellerClear(){
        
        oneTraveller.backgroundColor = .white
        oneLbl.textColor = UIColor(red: 35/255, green: 50/255, blue: 81/255  , alpha: 1)
        
        twoTraveller.backgroundColor = .white
        twoLbl.textColor = UIColor(red: 35/255, green: 50/255, blue: 81/255  , alpha: 1)
        
        threeTraveller.backgroundColor = .white
        threeLbl.textColor = UIColor(red: 35/255, green: 50/255, blue: 81/255  , alpha: 1)
        
        fourTraveller.backgroundColor = .white
        fourLbl.textColor = UIColor(red: 35/255, green: 50/255, blue: 81/255  , alpha: 1)
        
        fiveTraveller.backgroundColor = .white
        fiveLbl.textColor = UIColor(red: 35/255, green: 50/255, blue: 81/255  , alpha: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let travelingMode = Constants.travelingMode {
       
            if travelingMode == VehicleMode.HELICOPTER {
                threeTraveller.isHidden = false
                fourTraveller.isHidden = false
                fiveTraveller.isHidden = false
            }
            else {
              
              
                fourTraveller.isHidden = true
                fiveTraveller.isHidden = true
            }
            
           
            self.selectTravelingModeTF.text = travelingMode
        }
        
    }
    

    
    @IBAction func bookBtnClicked(_ sender: Any) {
        let travellingMode = selectTravelingModeTF.text
        
        if  travellingMode == "" {
            self.showSnack(messages: "Select Mode of Travel")
        }
        
        var latitudeTo = 0.0
        var longitudeTo = 0.0
        var shortNameTo = ""
        var nameTo = ""
        
        var latitudeFrom = 0.0
        var longitudeFrom = 0.0
        var shortNameFrom = ""
        var nameFrom = ""
        
        if pickerView.selectedRow(inComponent: 0) == 0 {
            if let placeModelTo = self.placeModelTo {
                if let placeModelFrom = self.placeModelFrom {
                    latitudeTo = placeModelTo.latitude!
                    longitudeTo = placeModelTo.longitude!
                    shortNameTo = placeModelTo.shortName!
                    nameTo = placeModelTo.name!
                    
                    latitudeFrom = placeModelFrom.latitude!
                    longitudeFrom = placeModelFrom.longitude!
                    shortNameFrom = placeModelFrom.shortName!
                    nameFrom = placeModelFrom.name!
                }
                else {
                    self.showSnack(messages: "Select Destination")
                    return
                }
            }
            else {
                self.showSnack(messages: "Select Departure")
                return
            }
        }
        else {
            if let airportModelTo = self.airportModelTo {
                if let airportModelFrom = self.airportModelFrom {
                    latitudeTo = Double(airportModelTo.latitude_deg!)!
                    longitudeTo = Double(airportModelTo.longitude_deg!)!
                    shortNameTo = airportModelTo.ident!
                    nameTo = airportModelTo.name!
                    
                    latitudeFrom = Double(airportModelFrom.latitude_deg!)!
                    longitudeFrom =  Double(airportModelFrom.longitude_deg!)!
                    shortNameFrom = airportModelFrom.ident!
                    nameFrom = airportModelFrom.name!
                }
                else {
                    self.showSnack(messages: "Select Destination")
                    return
                }
            }
            else {
                self.showSnack(messages: "Select Departure")
                return
            }
        }
        
       
                if let departAppointmentModel = self.departAppointmentModel {
                    if totalPassenger == 0 {
                        self.showSnack(messages: "Select Passenger")
                    }
                    else {
                        let bookingModel = BookingModel()
                        bookingModel.bookingId = FirebaseStoreManager.db.collection("Bookings").document().documentID
                        bookingModel.status = Status.PENDINGBYPILOT
                        bookingModel.sourceLocation = nameFrom
                        bookingModel.sourceTime = self.combineDateAndTimeString(existingDate: departAppointmentModel.appointmentDate!, timeString: departAppointmentModel.appointmentStarTime!)
                        bookingModel.sourceLocationCode = shortNameFrom
                        bookingModel.totalPassenger = totalPassenger
                        let distance = self.haversineDistance(lat1: latitudeFrom, lon1:longitudeFrom, lat2: latitudeTo, lon2: longitudeTo)
                        
                     
                        let timeInHour = self.calculateTimeInHour(miles: distance)
                    
                      
                        
                        bookingModel.destinationLocation = nameTo
                        bookingModel.destinationTime = bookingModel.sourceTime!.addingTimeInterval(timeInHour * 60 * 60)
                        bookingModel.destinationLocationCode = shortNameTo
                        
                        bookingModel.uid = FirebaseStoreManager.auth.currentUser?.uid
                        bookingModel.totalTime = Int(timeInHour * 60)
                        bookingModel.modeOfTravel = travellingMode
                       
                        self.performSegue(withIdentifier: "estimationSeg", sender: bookingModel)
                        
                    }
                }
                else {
                    self.showSnack(messages: "Select Departure Date")
                }
          
        
    }
    @IBAction func oneWayRoundWaySegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.returnAppointmentModel = nil
            self.returnDate.text = "Choose Date"
        }
    }
    
    func combineDateAndTimeString(existingDate: Date, timeString: String) -> Date? {
        // Create a DateFormatter for the time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"

        // Parse the time string into a Date
        guard let timeDate = timeFormatter.date(from: timeString) else {
            print("Error parsing time string")
            return nil
        }

        // Create a Calendar
        let calendar = Calendar.current

        // Extract components from the existing date
        let existingDateComponents = calendar.dateComponents([.year, .month, .day], from: existingDate)

        // Extract components from the time date
        let timeDateComponents = calendar.dateComponents([.hour, .minute, .second], from: timeDate)

        // Combine the date components
        var combinedComponents = DateComponents()
        combinedComponents.year = existingDateComponents.year
        combinedComponents.month = existingDateComponents.month
        combinedComponents.day = existingDateComponents.day
        combinedComponents.hour = timeDateComponents.hour
        combinedComponents.minute = timeDateComponents.minute
        combinedComponents.second = timeDateComponents.second

        // Create the new Date object
        if let newDate = calendar.date(from: combinedComponents) {
            return newDate
        } else {
            print("Error creating new date")
            return nil
        }
    }

}

extension BookingViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.totalPassenger = 0
        self.allTravellerClear()
        
        self.toTF.text = ""
        self.fromTF.text = ""
        self.airportModelFrom = nil
        self.airportModelTo = nil
        self.placeModelTo = nil
        self.placeModelFrom = nil
        
        if row == 0 {
            threeTraveller.isHidden = false
            fourTraveller.isHidden = false
            fiveTraveller.isHidden = false
        }
        else {
          
            fourTraveller.isHidden = true
            fiveTraveller.isHidden = true
        }
        selectTravelingModeTF.text = options[row]
    }
    
}

extension BookingViewController :  GoogleLocationCallback {
    
    func didLocationSelected(fromToCode: Int, placeModel place : Place) {
        if fromToCode == 1 {
            
            if let placeModelTo = self.placeModelTo {
                if placeModelTo.identifier == place.identifier! {
                    self.showSnack(messages: "Both airport cannot same.")
                    return
                }
            }
            
            self.placeModelFrom = place
            self.fromTF.text = place.name ?? "N/A"
        }
        else {
            
            if let placeModelFrom = self.placeModelFrom {
                if placeModelFrom.identifier  == place.identifier!{
                    self.showSnack(messages: "Both airport cannot same.")
                    return
                }
            }
            
            self.placeModelTo = place
            self.toTF.text = place.name ?? "N/A"
        }
    }
}

extension BookingViewController : LocationCallback {
    func didLocationSelected(fromToCode: Int, airportModel: AirportModel) {
        if fromToCode == 1 {
            
            if let airportModelTo = self.airportModelTo {
                if airportModelTo.id! == airportModel.id! {
                    self.showSnack(messages: "Both airport cannot same.")
                    return
                }
            }
            
            self.airportModelFrom = airportModel
            self.fromTF.text = airportModel.name ?? "N/A"
        }
        else {
            
            if let airportModelFrom = self.airportModelFrom {
                if airportModelFrom.id! == airportModel.id! {
                    self.showSnack(messages: "Both airport cannot same.")
                    return
                }
            }
            
            self.airportModelTo = airportModel
            self.toTF.text = airportModel.name ?? "N/A"
        }
    }
}

extension BookingViewController : DateTimeCallback {
    func dateTimeSelected(depatureReturnCode: Int, appointmentModel: AppointmentModel) {
        if depatureReturnCode == 1 {
            self.departAppointmentModel = appointmentModel
            self.departDate.text = self.convertDateForBooking(appointmentModel.appointmentDate!)
            self.returnAppointmentModel = nil
            self.returnDate.text  = "Choose Date"
        }
        
        else if depatureReturnCode == 2 {
            if let departAppointmentModel = self.departAppointmentModel {
                if departAppointmentModel.appointmentDate! > appointmentModel.appointmentDate! {
                    self.showSnack(messages: "Return date must be greater than Depart date")
                    self.returnAppointmentModel = nil
                    self.returnDate.text  = "Choose Date"
                    return
                }
                else if departAppointmentModel.appointmentDate! == appointmentModel.appointmentDate! {
                    if departAppointmentModel.selectedHours![0] > appointmentModel.selectedHours![0] {
                        self.showSnack(messages: "Return time must be greater than Depart time")
                        self.departAppointmentModel = nil
                        self.returnDate.text  = "Choose Date"
                        return
                    }
        
                }
                self.segmentControl.selectedSegmentIndex = 1
                self.returnAppointmentModel = appointmentModel
                self.returnDate.text = self.convertDateForBooking(appointmentModel.appointmentDate!)
            }
           
        }
    }
}
