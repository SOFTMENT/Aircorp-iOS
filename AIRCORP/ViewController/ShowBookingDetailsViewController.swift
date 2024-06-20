//
//  ShowBookingDetailsViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 05/02/24.
//


import UIKit

class ShowBookingDetailsViewController : UIViewController {
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
    
    @IBOutlet weak var contactUsBtn: UIButton!
    @IBOutlet weak var signContactBtn: UIButton!
    
    override func viewDidLoad() {

        guard
              let bookingModel = bookingModel else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
        }
       
        
      
        bookingModel.bookingCreateDate = Date()
        
        let result = ceil(Double(bookingModel.totalTime!) / Double(30))
        let intValue = Int(result) - 1
        
    
        
        signContactBtn.layer.cornerRadius = 8
        
        if bookingModel.status == Status.CONTRACT_WAITING {
            self.signContactBtn.isHidden = false
        }
     
        
        costView.layer.cornerRadius = 8
        costView.dropShadow()
        
        
        contactUsBtn.layer.cornerRadius = 8
        contactUsBtn.layer.cornerRadius = 8
        
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
    
    @IBAction func contactUsClicked(_ sender: Any) {
        if let url = URL(string: "mailto:michael@centum.ie") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func signContractClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "signContractSeg", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signContractSeg" {
            if let VC = segue.destination as? SignContractViewController {
                VC.bookingModel = self.bookingModel
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
