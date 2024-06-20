//
//  SignContractViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 17/02/24.
//

import UIKit

class SignContractViewController : UIViewController {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var reload: UIView!
    @IBOutlet weak var signView: SignatureView!
    @IBOutlet weak var submitBtn: UIButton!
    var bookingModel : BookingModel?
    
    override func viewDidLoad() {
        
        guard bookingModel != nil else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
        }
        
        signView.layer.cornerRadius = 8
        submitBtn.layer.cornerRadius = 8
        
        backView.layer.cornerRadius = 8
        backView.dropShadow()
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        reload.isUserInteractionEnabled = true
        reload.dropShadow()
        reload.layer.cornerRadius = 8
        reload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reloadBtnClicked)))
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true)
    }
    @objc func reloadBtnClicked(){
        signView.clear()
           
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        if signView.hasSignature() {
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
                    FirebaseStoreManager.db.collection("Bookings").document(self.bookingModel!.bookingId!).setData(["status" : Status.CONFIRMED],merge: true) { error in
                        self.ProgressHUDHide()
                        if let error = error {
                            self.showError(error.localizedDescription)
                        }
                        else {
                            
                            
                            self.performSegue(withIdentifier: "bookingApprovedSeg", sender: nil)
                        }
                    }
                }
                
            }
            
            
            
        }
        else {
            self.showSnack(messages: "Sign Contract")
        }
    }
    
    
}

extension SignatureView  {
    
    func getSignatureImage() -> UIImage? {
            // Begin image context
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            let image = renderer.image { context in
                drawHierarchy(in: bounds, afterScreenUpdates: true)
            }
            return image
        }
}
