import UIKit

class EstimationViewController : UIViewController {
    @IBOutlet var topView: UIView!
    @IBOutlet var mView: UIView!
    @IBOutlet var backView: UIView!
    var appointmentDepartModel : AppointmentModel?
    var appointmentReturnModel : AppointmentModel?
    
    var bookingModel : BookingModel?
    
    @IBOutlet weak var bookingView: UIView!
    
    
    @IBOutlet weak var sourceTime: UILabel!
    @IBOutlet weak var sourceLocationCode: UILabel!
    @IBOutlet weak var sourceLocationName: UILabel!
    @IBOutlet weak var mModeView: UIView!
    @IBOutlet weak var mModeImg: UIImageView!
    @IBOutlet weak var totalDuration: UILabel!
    @IBOutlet weak var bookingDate: UILabel!
    
    @IBOutlet weak var destinationTime: UILabel!
    @IBOutlet weak var destinationLocationCode: UILabel!
    @IBOutlet weak var destinationLocationName: UILabel!
    @IBOutlet weak var totalTimeFlyingLbl: UILabel!
    @IBOutlet weak var totalTimeFlyingCostLbl: UILabel!
    @IBOutlet weak var totalChargeLbl: UILabel!
    @IBOutlet weak var costView: UIView!
    @IBOutlet weak var bookBtn: UIButton!
    @IBOutlet weak var resositioningTimeLbl: UILabel!
    @IBOutlet weak var repositioningCostLbl: UILabel!
    @IBOutlet weak var allTravellers: UILabel!
    
    
    override func viewDidLoad() {
        
        guard let appointmentDepartModel = appointmentDepartModel,
              let bookingModel = bookingModel else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
        }
        
        
        
        
        appointmentDepartModel.appointmentId = bookingModel.bookingId
        
        
        bookingModel.bookingCreateDate = Date()
        if appointmentReturnModel != nil {
            self.appointmentReturnModel?.appointmentId = bookingModel.bookingId
            
        }
        
        let result = ceil(Double(bookingModel.totalTime!) / Double(30))
        let intValue = Int(result) - 1
        
        for y in 0..<(intValue) {
            
            appointmentDepartModel.selectedHours!.append(appointmentDepartModel.selectedHours![0] + y)
            if let appointmentReturnModel = self.appointmentReturnModel {
                appointmentReturnModel.selectedHours!.append(appointmentReturnModel.selectedHours![0] + y)
            }
            
        }
        
        appointmentDepartModel.selectedHours!.remove(at: 0)
        if let appointmentReturnModel = self.appointmentReturnModel {
            appointmentReturnModel.selectedHours!.remove(at: 0)
        }
        
        
        
        costView.layer.cornerRadius = 8
        costView.dropShadow()
        
        bookBtn.layer.cornerRadius = 8
        backView.dropShadow()
        
        
        
        self.mView.clipsToBounds = true
        self.mView.layer.cornerRadius = 20
        self.mView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.topView.isUserInteractionEnabled = true
        self.topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backBtnClicked)))
        
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        backView.layer.cornerRadius = 8
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        
        
        
        
        bookingView.dropShadow()
        bookingView.layer.cornerRadius = 8
        
        mModeView.layer.cornerRadius = mModeView.bounds.height / 2
        
        
        
        sourceTime.text = self.convertDateIntoTime(bookingModel.sourceTime!)
        sourceLocationCode.text = bookingModel.sourceLocationCode ?? ""
        sourceLocationName.text = bookingModel.sourceLocation ?? ""
        
        destinationTime.text = self.convertDateIntoTime(bookingModel.destinationTime!)
        destinationLocationCode.text = bookingModel.destinationLocationCode ?? ""
        destinationLocationName.text = bookingModel.destinationLocation ?? ""
        
        
        if let mode = bookingModel.modeOfTravel {
            if mode == VehicleMode.PLANE {
                mModeImg.image = UIImage(named: "plane")
            }
            else {
                mModeImg.image = UIImage(named: "helicopter-silhouette")
            }
        }
        
        
        totalDuration.text = "\(convertMinToHourAndMin(totalMin: bookingModel.totalTime ?? 0)) hours"
        bookingDate.text = convertDateForBooking(bookingModel.sourceTime ?? Date())
        totalTimeFlyingLbl.text = "\(convertMinToHourAndMin(totalMin: bookingModel.totalTime ?? 0)) hours"
        
        resositioningTimeLbl.text = "\(convertMinToHourAndMin(totalMin: self.bookingModel!.repositioningTime ?? 0)) hours"
        
        // Calculate total charge including repositioning
        let timeInHour = Float(bookingModel.totalTime ?? 0) / 60
        let repositioningTimeInHour = Float(bookingModel.repositioningTime ?? 0) / 60
        
        let totalCharge = ((timeInHour + repositioningTimeInHour) * Float(Constants.COST_PER_HOUR))
        totalChargeLbl.text = "£\(totalCharge)"
        totalTimeFlyingCostLbl.text = "£\(timeInHour * Float(Constants.COST_PER_HOUR))"
        
        repositioningCostLbl.text = "£\(repositioningTimeInHour * Float(Constants.COST_PER_HOUR))"
        
        allTravellers.isUserInteractionEnabled = true
        allTravellers.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allTravellersClicked)))
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allTravellers"  {
            if let VC = segue.destination as? AllTravellersViewController {
                VC.travellerArray = self.bookingModel!.travellers
            }
        }
    }
    
    @objc func allTravellersClicked() {
        self.performSegue(withIdentifier: "allTravellers", sender: self.bookingModel!.travellers)
    }
    
    @IBAction func bookBtnClicked(_ sender: Any) {
        
        self.ProgressHUDShow(text: "")
        
            getPilots(By: 0, mode: bookingModel!.modeOfTravel!) { pilotModel, error in
                if let error = error {
                    self.ProgressHUDHide()
                    self.showError(error)
                }
                else {
                    self.bookingModel!.piolatID = pilotModel!.id
                    let body = """
                    <!DOCTYPE html>
                    <html lang="en">
                    <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Booking Confirmation</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4; }
                        .container { background-color: #ffffff; padding: 20px; max-width: 600px; margin: auto; }
                        .header { background: #007bff; color: #ffffff; padding: 10px; text-align: center; }
                        .content { padding: 20px; }
                        .footer { background: #222222; color: #ffffff; padding: 10px; text-align: center; font-size: 12px; }
                    </style>
                    </head>
                    <body>
                    <div class="container">
                        <div class="header">
                            <h2>Booking Confirmation</h2>
                        </div>
                        <div class="content">
                            <p>Dear \(pilotModel!.name!),</p>
                            <p>Flight has been booked. Here are the details of your upcoming flight:</p>
                            <ul>
                                <li><strong>Customer Name:</strong> \(UserModel.data!.fullName!)</li>
                                <li><strong>Customer Email:</strong> \(UserModel.data!.email!)</li>
                                <li><strong>Total Passenger:</strong> \(self.bookingModel!.totalPassenger ?? 1)</li>
                                <li><strong>Flight Number:</strong> \(self.bookingModel!.bookingId!)</li>
                                <li><strong>Date:</strong> \(self.convertDateAndTimeFormater(Date()))</li>
                                <li><strong>Departure Time:</strong> \(self.convertDateAndTimeFormater(self.bookingModel!.sourceTime!))</li>
                                <li><strong>Departure Airport:</strong> \(self.bookingModel!.sourceLocation!)</li>
                                <li><strong>Arrival Airport:</strong> \(self.bookingModel!.destinationLocation!)</li>
                                <li><strong>Aircraft Type:</strong> \(self.bookingModel!.modeOfTravel!)</li>
                            </ul>
                           
                            <p>Best Regards,</p>
                            <p>AIRCORP</p>
                        </div>
                       
                    </div>
                    </body>
                    </html>
"""
                    
                    self.sendMail(name: pilotModel!.name!, email: pilotModel!.email!, msubject: "New Booking", body: body)
                    self.updateDataOnFirebase()
                }
            }
        
  
        
    }
    
    func updateDataOnFirebase(){
        let batch = FirebaseStoreManager.db.batch()
        
        let appointment = self.bookingModel!.modeOfTravel! == VehicleMode.HELICOPTER ? Appointment.HELICOPTER : Appointment.PLANE
        
        try! batch.setData(from: self.appointmentDepartModel!, forDocument: FirebaseStoreManager.db.collection(appointment).document(self.appointmentDepartModel!.appointmentId!))
        
        if let appointmentReturnModel = self.appointmentReturnModel {
            self.bookingModel!.returnFlight = true
            try! batch.setData(from: appointmentReturnModel, forDocument:  FirebaseStoreManager.db.collection(appointment).document("\(appointmentReturnModel.appointmentId!)RETURN"))
        }
    
        try! batch.setData(from: self.bookingModel!, forDocument:  FirebaseStoreManager.db.collection("Bookings").document(self.bookingModel!.bookingId!))
        
        
        batch.commit { error in
            self.ProgressHUDHide()
            if let error = error {
                self.showError(error.localizedDescription)
            }
            else {
                self.performSegue(withIdentifier: "successSeg", sender: nil)
            }
        }
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func backBtnClicked() {
        dismiss(animated: true)
    }
}
