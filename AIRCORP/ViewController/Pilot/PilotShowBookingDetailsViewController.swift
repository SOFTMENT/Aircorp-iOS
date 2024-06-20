//
//  PilotShowBookingDetailsViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 12/02/24.
//

import UIKit

class PilotShowBookingDetailsViewController : UIViewController {
    @IBOutlet var topView: UIView!
    @IBOutlet var mView: UIView!
    @IBOutlet var backView: UIView!

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
    
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    
 
    
    override func viewDidLoad() {

        guard let bookingModel = bookingModel else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
        }
       
        bookingModel.bookingCreateDate = Date()
        
        let result = ceil(Double(bookingModel.totalTime!) / Double(30))
        let intValue = Int(result) - 1
       
    
        rejectBtn.layer.cornerRadius = 8
        acceptBtn.layer.cornerRadius = 8
        
        if bookingModel.status == Status.PENDINGBYPILOT {
            rejectBtn.isHidden = false
            acceptBtn.isHidden = false
        }
        else {
            rejectBtn.isHidden = true
            acceptBtn.isHidden = true
        }
        
        costView.layer.cornerRadius = 8
        costView.dropShadow()
    
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
        
      
        totalDuration.text = "\(convertMinToHourAndMin(totalMin: bookingModel.totalTime ?? 0)) hour"
        bookingDate.text = convertDateForBooking(bookingModel.sourceTime ?? Date())
        
        
        totalTimeFlyingLbl.text = "\(convertMinToHourAndMin(totalMin: bookingModel.totalTime ?? 0)) hour"
       
        let timeInHour = Float(self.bookingModel!.totalTime!) / Float(60)
        totalChargeLbl.text = "£\(timeInHour * Float(Constants.COST_PER_HOUR))"
        totalTimeFlyingCostLbl.text = "£\(timeInHour * Float(Constants.COST_PER_HOUR))"
     
    }
    

    @IBAction func rejectBtnClicked(_ sender: Any) {
        let alert = UIAlertController(title: "REJECT", message: "Are you sure you want to reject this booking?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { action in
            self.ProgressHUDShow(text: "")
            if self.bookingModel != nil {
              
                
                self.getPilots(By: (PilotModel.data!.orderIndex ?? 0) + 1, mode: VehicleMode.HELICOPTER) { pilotModel, error in
                    self.ProgressHUDHide()
                    if let error = error {
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
                                    <li><strong>Flight Number:</strong> \(self.bookingModel!.bookingId!)</li>
                                    <li><strong>Date:</strong> \(self.convertDateForBooking(Date()))</li>
                                    <li><strong>Departure Time:</strong> \(self.convertDateForBooking(self.bookingModel!.sourceTime!))</li>
                                    <li><strong>Departure Airport:</strong> \(self.bookingModel!.sourceLocation!)</li>
                                    <li><strong>Arrival Airport:</strong> \(self.bookingModel!.destinationLocation!)</li>
                                    <li><strong>Aircraft Type:</strong> \(self.bookingModel!.modeOfTravel!)</li>
                                </ul>
                               
                                <p>Best Regards,</p>
                                <p>AIRCORP</p>
                            </div>
                           `
                        </div>
                        </body>
                        </html>
    """
                        
                        self.sendMail(name: pilotModel!.name!, email: pilotModel!.email!, msubject: "New Booking", body: body)
                        self.updateDataOnFirebase()
                    }
                
                }
               
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func updateDataOnFirebase(){
    
        try? FirebaseStoreManager.db.collection("Bookings").document(self.bookingModel!.bookingId!).setData(from: bookingModel!,merge : true)
        let alert = UIAlertController(title: "REJECTED", message: "This booking successfully rejected by you and we have assigned new pilot for this.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dashnoard", style: .default, handler: { action in
            self.beRootScreen(mIdentifier: Constants.StroyBoard.pilotTabbarViewController)
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func acceptBtnClicked(_ sender: Any) {
        let alert = UIAlertController(title: "ACCEPT", message: "Are you sure you want to accept this booking?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { action in
            self.ProgressHUDShow(text: "")
            FirebaseStoreManager.db.collection("Bookings").document(self.bookingModel!.bookingId!).setData(["status" : Status.PENDINGBYADMIN],merge: true) { error in
                self.ProgressHUDHide()
                if let error = error {
                    self.showError(error.localizedDescription)
                }
                else {
                    let alert = UIAlertController(title: "ACCEPTED", message: "Thank you for accepting this booking. Now We're waiting for admin and client for contract signature.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dashboard", style: .default, handler: { action in
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.pilotTabbarViewController)
                    }))
                    self.present(alert, animated: true)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func backBtnClicked() {
        dismiss(animated: true)
    }
}
