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
        
        let result = ceil(Double(bookingModel.totalTime!) / Double(30))
        let intValue = Int(result) - 1
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
        
        
        totalDuration.text = "\(convertMinToHourAndMin(totalMin: bookingModel.totalTime ?? 0)) hour"
        bookingDate.text = convertDateForBooking(bookingModel.sourceTime ?? Date())
        
        
        totalTimeFlyingLbl.text = "\(convertMinToHourAndMin(totalMin: bookingModel.totalTime ?? 0)) hour"
        
        let timeInHour = Float(self.bookingModel!.totalTime!) / Float(60)
        totalChargeLbl.text = "£\(timeInHour * Float(Constants.COST_PER_HOUR))"
        totalTimeFlyingCostLbl.text = "£\(timeInHour * Float(Constants.COST_PER_HOUR))"
        
    }
    
    @IBAction func sendContractClicked(_ sender: Any) {
        ProgressHUDShow(text: "Sending Contract...")
        
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
                                <p>We are pleased to inform you that your flight booking is almost confirmed. Please find below the details of your contract and flight information:</p>
                                <ul>
                                    <li>Booking Number: \(self.bookingModel!.bookingId!)</li>
                                    <li>Departure: \(self.convertDateAndTimeFormater(self.bookingModel!.sourceTime!)) - \(self.bookingModel!.sourceLocationCode!)</li>
                                    <li>Arrival: \(self.convertDateAndTimeFormater(self.bookingModel!.destinationTime!)) - \(self.bookingModel!.sourceLocationCode!)</li>
                                    <li>Passenger Name(s): \(self.bookingModel!.totalPassenger ?? 1)</li>
                                   
                                </ul>
                                <p>To view and sign your flight booking contract, please open app and click on your booking.</p>
                               
                                <p>If you have any questions or require further assistance, please do not hesitate to contact us.</p>
                                <p>Thank you for choosing us for your travel needs.</p>
                                <p>Best Regards,</p>
                                <p>AIRCORP</p>
                            </div>
                           
                        </div>
                        </body>
                        </html>
                        """
        
        self.sendMail(name: userModel!.fullName!, email: userModel!.email!, msubject: "CONTRACT", body: htmlBody)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
           
            FirebaseStoreManager.db.collection("Bookings").document(self.bookingModel!.bookingId!).setData(["status" : Status.CONTRACT_WAITING], merge: true) { error in
                self.ProgressHUDHide()
                if let error = error {
                    self.showError(error.localizedDescription)
                }
                else {
                    let alert = UIAlertController(title: "CONTRACT SENT", message: "Contract has been sent successfully to the client.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dashboard", style: .default, handler: { action in
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.adminTabbarViewController)
                    }))
                    self.present(alert, animated: true)
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
