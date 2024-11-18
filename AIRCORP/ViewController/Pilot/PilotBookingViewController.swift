//
//  PilotBookingViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 12/02/24.
//
import UIKit
import SDWebImage
import CropViewController
import FirebaseStorage
import CoreLocation

class PilotBookingViewController : UIViewController {

    @IBOutlet weak var mProfile: UIImageView!
    @IBOutlet weak var helloNameLbl: UILabel!
    @IBOutlet weak var weatherView: UIStackView!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noBookingAvailable: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    var bookingModels = Array<BookingModel>()
    var allBookingModels = Array<BookingModel>()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        guard let userModel = PilotModel.data else {
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

        
        helloNameLbl.text = "Hello \(getFirstName(from: userModel.name!)!)"
        if let path = userModel.profileImage, !path.isEmpty {
            mProfile.sd_setImage(with: URL(string: path), placeholderImage: UIImage(named: "profile-placeholder"))
        }
      
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        
        self.ProgressHUDShow(text: "")
        if let user = FirebaseStoreManager.auth.currentUser {
            self.getAllBookingForPilotByUID(uid: user.uid) { bookingModels, error in
                self.ProgressHUDHide()
                if let error = error {
                    self.showError(error)
                }
                else {
                    self.allBookingModels.removeAll()
                    self.allBookingModels.append(contentsOf: bookingModels ?? [])
                    self.filter()
                }
            }
        }
        
        weatherView.isUserInteractionEnabled = true
        weatherView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(weatherViewClicked)))
    }
    
    func filter(){
        self.bookingModels.removeAll()
        if segment.selectedSegmentIndex == 0 {
            self.bookingModels.append(contentsOf: self.allBookingModels)
            self.tableView.reloadData()
        }
        else if segment.selectedSegmentIndex == 1 {
            let pendings = self.allBookingModels.filter { $0.status == Status.PENDINGBYPILOT}
            self.bookingModels.append(contentsOf: pendings)
            self.tableView.reloadData()
        }
        else {
            let approved = self.allBookingModels.filter { $0.status == Status.CONFIRMED}
            self.bookingModels.append(contentsOf: approved)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func segmentChange(_ sender: Any) {
            filter()
    }
    
    
    @objc func weatherViewClicked(){
        self.performSegue(withIdentifier: "weatherSeg", sender: nil)
    }
    

    @objc func cellClicked(value : MyGesture) {
        performSegue(withIdentifier: "showDetailsSeg", sender: self.bookingModels[value.index])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsSeg" {
            if let VC = segue.destination as? PilotShowBookingDetailsViewController {
                if let bookingModel = sender as? BookingModel {
                    VC.bookingModel = bookingModel
                }
            }
        }
    }
    
}

extension PilotBookingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noBookingAvailable.isHidden = self.bookingModels.count > 0 ? true : false
        return self.bookingModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "bookingCell", for: indexPath) as? BookingTableViewCell {
            
            let bookingModel = self.bookingModels[indexPath.row]
          
            
            cell.mView.dropShadow()
            cell.mView.layer.cornerRadius = 8
            cell.mView.isUserInteractionEnabled = true
            let cellGest = MyGesture(target: self, action: #selector(cellClicked(value: )))
            cellGest.index = indexPath.row
            cell.mView.addGestureRecognizer(cellGest)
            
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
            
            if bookingModel.status == Status.PENDINGBYPILOT {
                cell.statusLbl.text = "Pending"
            }
            else if bookingModel.status == Status.PENDINGBYADMIN {
                cell.statusLbl.text = "In Process"
            }
            else {
                cell.statusLbl.text = bookingModel.status ?? ""
            }
            
            cell.totalDuration.text = convertMinToHourAndMin(totalMin: bookingModel.totalTime ?? 0)
            cell.bookingDate.text = convertDateForBooking(bookingModel.sourceTime ?? Date())
            
            
            
            
            return cell
        }
        return BookingTableViewCell()
    }
    
}

extension PilotBookingViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
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

extension PilotBookingViewController : CLLocationManagerDelegate {
    
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
                           self.weatherView.isHidden = true
                           
                       }
                       else {
                           
                           self.weatherView.isHidden = false
                           self.currentTemp.text = "\(weatherModel!.current!.tempC ?? 0)°C"
                         
                       }
                   }
                 
               }
           }
        else {
            self.weatherView.isHidden = true
        }
       }

       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print(error)
           self.weatherView.isHidden = true
       }
}
