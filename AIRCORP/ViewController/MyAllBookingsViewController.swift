//
//  MyAllBookingsViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 05/02/24.
//

import UIKit
import SDWebImage
import CropViewController
import FirebaseStorage
import CoreLocation

class MyAllBookingsViewController : UIViewController {
    
    @IBOutlet weak var noBookingsAvailable: UILabel!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var myAllBookings = Array<BookingModel>()

    
    override func viewDidLoad() {
  
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    
        self.ProgressHUDShow(text: "")
        if let user = FirebaseStoreManager.auth.currentUser {
            getAllBookingBy(userId: user.uid, limit: nil) { bookingModels, error in
                self.ProgressHUDHide()
                if let error = error {
                    self.showError(error)
                }
                else {
                    self.myAllBookings.removeAll()
                    self.myAllBookings.append(contentsOf: bookingModels ?? [])
                    self.tableView.reloadData()
                }
            }
        }
        
      
        backView.layer.cornerRadius = 8
        backView.dropShadow()
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewClicked)))

    }
    
    @objc func backViewClicked() {
        self.dismiss(animated: true)
    }
    
    @objc func cellClicked(value : MyGesture) {
        performSegue(withIdentifier: "showBookingDeatilsSeg", sender: self.myAllBookings[value.index] )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBookingDeatilsSeg" {
            if let VC = segue.destination as? ShowBookingDetailsViewController {
                if let bookingModel = sender as? BookingModel {
                    VC.bookingModel = bookingModel
                }
            }
        }
    }
    
    @objc func statusClicked(value : MyGesture){
        let bookingModel = self.myAllBookings[value.index]
        if value.value == Status.PENDINGBYPILOT || value.value == Status.PENDINGBYADMIN {
            self.showMessage(title: "PENDING", message: "Your booking is under review. We're waiting for piolat & admin approval.")
        }
        else if value.value == Status.CANCELED {
            self.showMessage(title: "CANCELED", message: "Your booking has been canceled by admin. Reason : \(bookingModel.cancelReason ?? "N/A")")
        }
        else if value.value == Status.CONFIRMED{
            self.showMessage(title: "CONFIRMED", message: "Your booking has been confirmed. Happy Journey.")
        }
        else if value.value == Status.CONTRACT_WAITING{
            self.showMessage(title: "CONTRACT", message: "We're waitinng for your sign on the contract.")
        }
        else if value.value == Status.COMPLETED {
            self.showMessage(title: "COMPLETED", message: "The booking from \(bookingModel.sourceLocation!) to \(bookingModel.destinationLocation!) has been successfully completed on \(self.convertDateForTicket(bookingModel.completionDate ?? Date())).")
        }
        
    }
    
}

extension MyAllBookingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noBookingsAvailable.isHidden = myAllBookings.count > 0 ? true : false
        return myAllBookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "bookingCell", for: indexPath) as? BookingTableViewCell {
            
            let bookingModel = self.myAllBookings[indexPath.row]
          
            
            cell.mView.dropShadow()
            cell.mView.layer.cornerRadius = 8
            cell.mView.isUserInteractionEnabled = true
            let gest = MyGesture(target: self, action: #selector(cellClicked(value: )))
            gest.index = indexPath.row
            cell.addGestureRecognizer(gest)
            
            cell.mModeView.layer.cornerRadius = cell.mModeView.bounds.height / 2
            cell.statusView.layer.cornerRadius = 4
            
            cell.sourceTime.text = self.convertDateIntoTime(bookingModel.sourceTime!)
            cell.sourceLocationCode.text = bookingModel.sourceLocationCode ?? ""
            cell.sourceLocationName.text = bookingModel.sourceLocation ?? ""
            
            cell.destinationTime.text = self.convertDateIntoTime(bookingModel.destinationTime!)
            cell.destinationLocationCode.text = bookingModel.destinationLocationCode ?? ""
            cell.destinationLocationName.text = bookingModel.destinationLocation ?? ""
            
            if let mode = bookingModel.modeOfTravel {
                if mode == VehicleMode.PLANE {
                    cell.mModeImg.image = UIImage(named: "plane")
                }
                else {
                    cell.mModeImg.image = UIImage(named: "helicopter-silhouette")
                }
            }
            
            if bookingModel.status == Status.PENDINGBYPILOT || bookingModel.status == Status.PENDINGBYADMIN {
                cell.statusLbl.text = "Pending"
            }
            else {
                cell.statusLbl.text = bookingModel.status ?? ""
            }
            cell.statusView.isUserInteractionEnabled = true
            let statusGest = MyGesture(target: self, action: #selector(statusClicked(value: )))
            statusGest.value = bookingModel.status ?? ""
            statusGest.index = indexPath.row
            cell.statusView.addGestureRecognizer(statusGest)
            
            cell.totalDuration.text = convertMinToHourAndMin(totalMin: bookingModel.totalTime ?? 0)
            cell.bookingDate.text = convertDateForBooking(bookingModel.sourceTime ?? Date())
            
            
            
            
            return cell
        }
        return BookingTableViewCell()
    }
    
    
    
}

