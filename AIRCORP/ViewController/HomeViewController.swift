//
//  HomeViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 29/01/24.
//

import UIKit
import SDWebImage
import CropViewController
import FirebaseStorage
import CoreLocation

class HomeViewController : UIViewController {
    
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mProfile: UIImageView!
    @IBOutlet weak var helloNameLbl: UILabel!
    @IBOutlet weak var weatherView: UIStackView!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var helicopterView: UIView!
    @IBOutlet weak var flightView: UIView!
    @IBOutlet weak var seeAllBtn: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noBookingAvailable: UILabel!
    var last5Bookings = Array<BookingModel>()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        guard let userModel = UserModel.data else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.logout()
            }
            return
        }
        
        locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
               locationManager.requestWhenInUseAuthorization()
               locationManager.requestLocation()
        
        mProfile.makeRounded()
        mProfile.layer.borderColor = UIColor.white.cgColor
        mProfile.layer.borderWidth = 1
        mProfile.isUserInteractionEnabled = true
        mProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeProfilePic)))
        
        helloNameLbl.text = "Hello \(getFirstName(from: userModel.fullName!)!)"
        if let path = userModel.profilePic, !path.isEmpty {
            mProfile.sd_setImage(with: URL(string: path), placeholderImage: UIImage(named: "profile-placeholder"))
        }
        helicopterView.layer.cornerRadius = 8
        helicopterView.isUserInteractionEnabled = true
        helicopterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(helicopterViewClicked)))
        
        flightView.layer.cornerRadius = 8
        flightView.isUserInteractionEnabled = true
        flightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flightViewClicked)))
        
        seeAllBtn.isUserInteractionEnabled = true
        seeAllBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seeAllClicked)))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        mView.roundTopCorners(cornerRadius: 24)
        
        self.ProgressHUDShow(text: "")
        if let user = FirebaseStoreManager.auth.currentUser {
            getAllBookingBy(userId: user.uid, limit: 5) { bookingModels, error in
                self.ProgressHUDHide()
                if let error = error {
                    self.showError(error)
                }
                else {
                    self.last5Bookings.removeAll()
                    self.last5Bookings.append(contentsOf: bookingModels ?? [])
                    self.tableView.reloadData()
                }
            }
        }
        
      
        weatherView.isUserInteractionEnabled = true
        weatherView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(weatherViewClicked)))
    }
    
    @objc func weatherViewClicked(){
        self.performSegue(withIdentifier: "weatherSeg", sender: nil)
    }
    
    @objc func flightViewClicked(){
        if let tabBar = tabBarController as? MainViewController {
            Constants.travelingMode = VehicleMode.PLANE
            tabBar.selectedIndex = 1
          
        }
    }
    
    @objc func helicopterViewClicked(){
        if let tabBar = tabBarController as? MainViewController {
            Constants.travelingMode = VehicleMode.HELICOPTER
            tabBar.selectedIndex = 1
           
        }
        
    }
    
    @objc func changeProfilePic(){
        let alert = UIAlertController(title: "Upload Profile Picture", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Using Camera", style: .default) { (action) in
            let cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.sourceType = .camera
            self.present(cameraPicker, animated: true)
           
            
        }
        
        let action2 = UIAlertAction(title: "From Photo Library", style: .default) { (action) in
       
            let image = UIImagePickerController()
            image.delegate = self
            image.title = "Profile Picture"
            image.sourceType = .photoLibrary
            
            self.present(image,animated: true)
            

        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        self.present(alert,animated: true,completion: nil)
    }
    
    @objc func seeAllClicked(){
        performSegue(withIdentifier: "seeAllSeg", sender: nil)
    }
    
    @objc func cellClicked(value : MyGesture) {
        performSegue(withIdentifier: "showBookingDeatilsSeg", sender: self.last5Bookings[value.index])
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
        let bookingModel = self.last5Bookings[value.index]
        if value.value == Status.PENDINGBYPILOT || value.value == Status.PENDINGBYADMIN {
            self.showMessage(title: "PENDING", message: "Your booking is under review. We're waiting for piolat & admin approval.")
        }
       
        else if value.value == Status.CANCELED {
            self.showMessage(title: "CANCELED", message: "Your booking has been canceled by admin. Reason : \(bookingModel.cancelReason ?? "N/A")")
        }
        else if value.value == Status.CONFIRMED{
            self.showMessage(title: "CONFIRMED", message: "Your booking has been confirmed. Happy Journey.")
        }
        else if value.value == Status.COMPLETED {
            self.showMessage(title: "COMPLETED", message: "The booking from \(bookingModel.sourceLocation!) to \(bookingModel.destinationLocation!) has been successfully completed on \(self.convertDateForTicket(bookingModel.completionDate ?? Date())).")
        }
    }
    
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noBookingAvailable.isHidden = last5Bookings.count > 0 ? true : false
        return last5Bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "bookingCell", for: indexPath) as? BookingTableViewCell {
            
            let bookingModel = self.last5Bookings[indexPath.row]
          
            
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
extension HomeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.originalImage] as? UIImage {
            
            self.dismiss(animated: true) {
                
                let cropViewController = CropViewController(image: editedImage)
                cropViewController.title = picker.title
                cropViewController.delegate = self
                cropViewController.customAspectRatio = CGSize(width: 1  , height: 1)
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.aspectRatioPickerButtonHidden = true
                self.present(cropViewController, animated: true, completion: nil)
            }
 
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
          
            self.mProfile.image = image
        
        self.uploadImageOnFirebase(uid: FirebaseStoreManager.auth.currentUser!.uid) { downloadURL in
            UserModel.data!.profilePic = downloadURL
            FirebaseStoreManager.db.collection("Users").document(FirebaseStoreManager.auth.currentUser!.uid).setData(["profilePic":downloadURL],merge: true)
        }
        
            self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageOnFirebase(uid : String,completion : @escaping (String) -> Void ) {
        
        let storage = Storage.storage().reference().child("ProfilePicture").child(uid).child("\(uid).png")
        var downloadUrl = ""
        
        var uploadData : Data!
        uploadData = (self.mProfile.image?.jpegData(compressionQuality: 0.5))!
        
    
        storage.putData(uploadData, metadata: nil) { (metadata, error) in
            
            if error == nil {
                storage.downloadURL { (url, error) in
                    if error == nil {
                        downloadUrl = url!.absoluteString
                    }
                    completion(downloadUrl)
                    
                }
            }
            else {
                completion(downloadUrl)
            }
            
        }
    }
    
    
}

extension HomeViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          if status == .authorizedWhenInUse || status == .authorizedAlways {
              locationManager.startUpdatingLocation()
          }
      }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.first {
               self.getWeatherInformation(key: "6fba7bc9c41e4f8fa6c20654243101", lat: location.coordinate.latitude, long: location.coordinate.longitude) { weatherModel, error in
                   DispatchQueue.main.async {
                       if let error = error {
                           print(error)
                          // self.weatherView.isHidden = true
                           
                       }
                       else {
                           
                           self.weatherView.isHidden = false
                           self.currentTemp.text = "\(weatherModel!.current!.tempC ?? 0)°C"
                         
                       }
                   }
                 
               }
           }
        else {
          //  self.weatherView.isHidden = true
        }
       }

       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print(error)
           //self.weatherView.isHidden = true
       }
}
