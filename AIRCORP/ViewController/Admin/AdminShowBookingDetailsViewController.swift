//
//  AdminShowBookingDetailsViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 12/02/24.
//

import UIKit

class AdminShowBookingDetailsViewController : UIViewController {
    @IBOutlet var topView: UIView!
    @IBOutlet var mView: UIView!
    @IBOutlet var backView: UIView!
    
    @IBOutlet weak var cancelBtn: UIButton!
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
    @IBOutlet weak var sendContractBtn: UIButton!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var mEmail: UILabel!
    @IBOutlet weak var personalView: UIView!
    @IBOutlet weak var resositioningTimeLbl: UILabel!
    @IBOutlet weak var repositioningCostLbl: UILabel!
    
    var userModel : UserModel?
    
    override func viewDidLoad() {
        
        guard
            let bookingModel = bookingModel else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
        }
        
        getUserByID(uid: bookingModel.uid!) { userModel, error in
            if let userModel = userModel {
                self.userModel = userModel
                self.fullName.text = userModel.fullName ?? ""
                self.mEmail.text = userModel.email ?? ""
            }
        }
        
        bookingModel.bookingCreateDate = Date()
        
//        let result = ceil(Double(bookingModel.totalTime!) / Double(30))
//        let intValue = Int(result) - 1
        sendContractBtn.layer.cornerRadius = 8
        cancelBtn.layer.cornerRadius = 8
        
        if bookingModel.status == Status.PENDINGBYADMIN {
            sendContractBtn.isHidden = false
            cancelBtn.isHidden = false
        }
        else {
            sendContractBtn.isHidden = true
            cancelBtn.isHidden = true
        }
        
        
        
        
        costView.layer.cornerRadius = 8
        costView.dropShadow()
        
        personalView.layer.cornerRadius = 8
        personalView.dropShadow()
        
        
        
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
        
    }
    
    @IBAction func sendContractClicked(_ sender: Any) {
        ProgressHUDShow(text: "")
        
        let htmlBody = """
                        <!DOCTYPE html>
                        <html lang="en">
                        <head>
                            <meta charset="UTF-8">
                            <title>Flight Booking Contract</title>
                            <style>
                                body {
                                    font-family: 'Arial', sans-serif;
                                    margin: 0;
                                    padding: 0;
                                    color: #333;
                                    background-color: #f4f4f4;
                                }
                                .container {
                                    max-width: 600px;
                                    margin: 20px auto;
                                    padding: 20px;
                                    background: #ffffff;
                                    border-radius: 8px;
                                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                                }
                                  .header { background: #007bff; color: #ffffff; padding: 10px; text-align: center; }
                                .content {
                                    font-size: 16px;
                                    line-height: 1.5;
                                }
                                .footer {
                                    margin-top: 20px;
                                    font-size: 14px;
                                    text-align: center;
                                    color: #999;
                                }
                                .button {
                                    display: inline-block;
                                    background-color: #007bff;
                                    color: #ffffff;
                                    padding: 10px 20px;
                                    text-decoration: none;
                                    border-radius: 5px;
                                    font-weight: bold;
                                    margin-top: 20px;
                                }
                            </style>
                        </head>
                        <body>
                        <div class="container">
                            <div class="header">Booking Contract</div>
                            <div class="content">
                                <p>Dear \(self.userModel!.fullName!),</p>
                                <p>We are pleased to inform you that your flight booking has been confirmed. Please find below the details of your flight information:</p>
                                <ul>
                                    <li>Booking Number: \(self.bookingModel!.bookingId!)</li>
                                    <li>Departure: \(self.convertDateAndTimeFormater(self.bookingModel!.sourceTime!)) - \(self.bookingModel!.sourceLocationCode!)</li>
                                    <li>Arrival: \(self.convertDateAndTimeFormater(self.bookingModel!.destinationTime!)) - \(self.bookingModel!.sourceLocationCode!)</li>
                                    <li>Passenger Name(s): \(self.bookingModel!.totalPassenger ?? 1)</li>
                                   
                                </ul>
                                
                               
                                <p>If you have any questions or require further assistance, please do not hesitate to contact us.</p>
                                <p>Thank you for choosing us for your travel needs.</p>
                                <p>Best Regards,</p>
                                <p>AIRCORP</p>
                            </div>
                           
                        </div>
                        </body>
                        </html>
                        """
        
        self.sendMail(name: userModel!.fullName!, email: userModel!.email!, msubject: "Booking Confirmed", body: htmlBody)
        
        PushNotificationSender().sendPushNotification(title: "Booking Confirmed", body: "We are pleased to inform you that your flight booking has been confirmed.", topic: self.userModel!.notificationToken ?? "123")
        
        
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
                        <p>Flight has been confirmed. Here are the details of your upcoming flight:</p>
                        <ul>
                            <li><strong>Customer Name:</strong> \(UserModel.data!.fullName!)</li>
                            <li><strong>Customer Email:</strong> \(UserModel.data!.email!)</li>
                            <li><strong>Total Passenger:</strong> \(self.bookingModel!.totalPassenger ?? 1)</li>
                            <li><strong>Date:</strong> \(self.convertDateAndTimeFormater(Date()))</li>
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
                
                self.sendMail(name: pilotModel!.name!, email: pilotModel!.email!, msubject: "Booking Confirmed", body: body)
                
                PushNotificationSender().sendPushNotification(title: "Booking Confirmed", body: "Flight has been confirmed. Please check app for upcoming flight details.", topic: pilotModel!.notificationToken ?? "123")
                
                
                FirebaseStoreManager.db.collection("Bookings").document(self.bookingModel!.bookingId!).setData(["status" : Status.CONFIRMED],merge: true) { error in
                    self.ProgressHUDHide()
                    if let error = error {
                        self.showError(error.localizedDescription)
                        
                    }
                    else {
                        let alert = UIAlertController(title: "Confirmed", message: "Booking has been confirmed and mail has been sent to pilot and customer.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dashboard", style: .default, handler: { action in
                            self.beRootScreen(mIdentifier: Constants.StroyBoard.adminTabbarViewController)
                        }))
                        self.present(alert, animated: true)
                    }
                }
               
               
                
            }
        }
    }

    @IBAction func cancelBtnClicked(_ sender: Any) {
        let alert = UIAlertController(title: "REJECT BOOKING", message: "Are you sure you want to reject this booking?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { action in
            
            // Create the alert controller
            let alertController = UIAlertController(title: "Enter Reason", message: nil, preferredStyle: .alert)
            
            // Add a text field to the alert controller
            alertController.addTextField { (textField) in
                textField.placeholder = ""
            }
            
            // Create the Submit action
            let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak alertController] _ in
                // Retrieve the first text field in the alertController
                guard let textField = alertController?.textFields?.first else { return }
                
                // Use the text from the text field
                let inputText = textField.text
                if inputText == "" {
                    self.showSnack(messages: "Enter Reason")
                }
                else {
                    self.ProgressHUDShow(text: "Rejecting...")
                    
                    FirebaseStoreManager.db.collection("Bookings").document(self.bookingModel!.bookingId!).setData(["status" : Status.CANCELED,"cancelReason" : inputText!],merge: true) { error in
                        self.ProgressHUDHide()
                        if let error = error {
                            self.showError(error.localizedDescription)
                        }
                        else {
                            
                            let htmlBody = """
<!DOCTYPE html>
<html>
<head>
    <title>Booking Cancellation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            color: #333;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background: #f7f7f7;
            padding: 20px;
            border-radius: 8px;
        }
        h2 {
            color: #d9534f;
        }
        p {
            line-height: 1.6;
        }
        .footer {
            margin-top: 20px;
            font-size: 0.9em;
            text-align: center;
            color: #aaa;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Booking Cancellation</h2>
        <p>Dear \(self.userModel!.fullName!),</p>
        <p>We regret to inform you that your booking with us for [Booking Details] has been cancelled due to \(inputText!). We understand how important your plans are and sincerely apologize for any inconvenience this may cause.</p>
        <p>For any further assistance or queries, please do not hesitate to contact our customer service team.</p>
        <p>We hope to have the opportunity to serve you in the future under better circumstances.</p>
        <p>Thank you for your understanding.</p>
        <p>Warm regards,</p>
        <p>AIRCORP</p>
        
    </div>
</body>
</html>
"""
                            
                            
                            if self.bookingModel!.modeOfTravel == VehicleMode.HELICOPTER {
                                FirebaseStoreManager.db.collection(Appointment.HELICOPTER).document(self.bookingModel!.bookingId!).delete()
                                FirebaseStoreManager.db.collection(Appointment.HELICOPTER).document("\(self.bookingModel!.bookingId!)RETURN").delete()
                            }
                            else {
                                FirebaseStoreManager.db.collection(Appointment.PLANE).document(self.bookingModel!.bookingId!).delete()
                                FirebaseStoreManager.db.collection(Appointment.PLANE).document("\(self.bookingModel!.bookingId!)RETURN").delete()
                            }
                            
                        
                            
                            
                            
                            
                            self.sendMail(name: self.userModel!.fullName!, email: self.userModel!.email!, msubject: "BOOKING CANCELLED", body: htmlBody)
                            
                            let alert = UIAlertController(title: "BOOKING CANCELLED", message: "Booking has been cancelled successfully and sent mail to the client.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dashboard", style: .default, handler: { action in
                                self.beRootScreen(mIdentifier: Constants.StroyBoard.adminTabbarViewController)
                            }))
                            self.present(alert, animated: true)
                        }
                    }
                }
                
            }
            
            // Add the action to the alert controller
            alertController.addAction(submitAction)
            
            // Present the alert controller
            self.present(alertController, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        present(alert, animated: true)
    }
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func backBtnClicked() {
        dismiss(animated: true)
    }
}
