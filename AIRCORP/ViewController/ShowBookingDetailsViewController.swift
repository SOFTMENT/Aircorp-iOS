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
    
    @IBOutlet weak var resositioningTimeLbl: UILabel!
    @IBOutlet weak var repositioningCostLbl: UILabel!
    
    
    @IBOutlet weak var allTravellers: UILabel!
    override func viewDidLoad() {

        guard
              let bookingModel = bookingModel else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
        }
       
        
      
        bookingModel.bookingCreateDate = Date()
        
       
    
        
        signContactBtn.layer.cornerRadius = 8
        
    
     
        
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
    
    @objc func allTravellersClicked() {
        self.performSegue(withIdentifier: "allTravellers", sender: self.bookingModel!.travellers)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allTravellers"  {
            if let VC = segue.destination as? AllTravellersViewController {
                VC.travellerArray = self.bookingModel!.travellers
            }
        }
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
    
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func backBtnClicked() {
        dismiss(animated: true)
    }
}
