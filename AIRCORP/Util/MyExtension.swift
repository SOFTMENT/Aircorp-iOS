//
//  MyExtension.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 29/01/24.
//

import UIKit
import MBProgressHUD
import TTGSnackbar
import GoogleSignIn
import AVFoundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFunctions
extension UIView {
    
    func addBorderColourAndRadius(){
       layer.cornerRadius = 8
     layer.borderWidth = 0.5
        layer.borderColor = UIColor(red: 57/255, green: 1, blue: 20/255, alpha: 1).cgColor
    }
    
}

extension Int {
    func numberFormator() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? "ERROR"
    }
}

extension UITextField {
    
    func setLeftView(image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 10, width: 22, height: 22)) // set your Own size
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 45))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
        self.tintColor = .lightGray
        
    }
    
    func setRightView(image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 10, width: 22, height: 22)) // set your Own size
        iconView.image = image
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 45))
        iconContainerView.addSubview(iconView)
        rightView = iconContainerView
        
        rightViewMode = .always
        self.tintColor = .lightGray
        
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        
        self.rightView = paddingView
        self.rightViewMode = .always
        
    }
    
    func changePlaceholderColour()  {
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)])
    }
    
    
    
    /// set icon of 20x20 with left padding of 8px
    func setLeftIcons(icon: UIImage) {
        
        let padding = 8
        let size = 20
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        iconView.image = icon
        outerView.addSubview(iconView)
        
        leftView = outerView
        leftViewMode = .always
    }
    
    
    
    
    /// set icon of 20x20 with left padding of 8px
    func setRightIcons(icon: UIImage) {
        
        let padding = 8
        let size = 18
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: -padding, y: 0, width: size, height: size))
        iconView.image = icon
        iconView.tintColor = .black
        outerView.addSubview(iconView)
        
        rightView = outerView
        rightViewMode = .always
    }
    
}

extension Date {
    
    
    func removeTimeStamp() -> Date? {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return  nil
        }
        return date
    }
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        return "a moment ago"
    }
}




extension UIViewController {
    
    func getAllBookingBy(userId uid : String, limit : Int?, completion : @escaping (_ bookingModels : Array<BookingModel>?, _ error : String?)-> Void) {
        
        var query = FirebaseStoreManager.db.collection("Bookings").order(by: "bookingCreateDate",descending: true).whereField("uid", isEqualTo: uid)
        if let limit = limit {
            query = query.limit(to: limit)
        }
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            }
            else {
                var bookingModels = Array<BookingModel>()
                if let snapshot = snapshot {
                    for qdr in snapshot.documents {
                        if let bookingModel = try? qdr.data(as: BookingModel.self) {
                            bookingModels.append(bookingModel)
                        }
                    }
                }
                completion(bookingModels,nil)
            }
        }
    }
    
    func sendMail(name : String, email : String, msubject : String, body : String){
        let url = URL(string: "https://softment.com/aircorp/php-mailer/sendmail.php")!
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
          
          let parameters: [String: String] = [
              "to_name": name,
              "to_email": email,
              "subject": msubject,
              "body": body
          ]
          
          let parameterArray = parameters.map { key, value in
              return "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
          }
          
          request.httpBody = parameterArray.joined(separator: "&").data(using: .utf8)
          
          let task = URLSession.shared.dataTask(with: request) { data, response, error in
              if let error = error {
                  print("Error with sending email: \(error)")
                  return
              }
              
              guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                  print("Error in the response or statusCode")
                  return
              }
              
              if let responseString = String(data: data, encoding: .utf8) {
                  print("Response String: \(responseString)")
              }
          }
          
          task.resume()
    }
    
    func getPilots(By orderIndex : Int, mode : String,completion : @escaping (_ pilotModel : PilotModel?, _ error : String?)->Void) {
        
        Firestore.firestore().collection("Pilots").whereField("orderIndex", isEqualTo: 0).whereField("canFly", isEqualTo: mode).getDocuments { snapshot, error in
            
            if let error  = error {
                completion(nil, error.localizedDescription)
            }
            else {
                if let snapshot = snapshot, !snapshot.documents.isEmpty {
                    if let pilotModel = try? snapshot.documents.first!.data(as: PilotModel.self) {
                        completion(pilotModel, nil)
                    }
                    else {
                        completion(nil, "Sorry! Pilot not available or Server Error")
                    }
                }
                else {
                    completion(nil, "Sorry! Pilot not available")
                }
            }
            
        }
        
    }
    
    func getAllPilots(completion : @escaping  (_ categories : Array<PilotModel>?)->Void){
        Firestore.firestore().collection("Pilots").order(by: "orderIndex").addSnapshotListener { snapshot, error in
            if let snapshot = snapshot, !snapshot.isEmpty {
                var pilots = Array<PilotModel>()
                for qdr in snapshot.documents {
                    if let pilotModel = try? qdr.data(as:PilotModel.self) {
                        pilots.append(pilotModel)
                    }
                }
                completion(pilots)
            }
            else {
                completion(nil)
            }
        }
    }
    
    func getAllAircrafts(completion : @escaping (_ aircraftModels : Array<AircraftModel>?, _ error : String?)-> Void) {
        
        let query = FirebaseStoreManager.db.collection("Aircrafts").order(by: "aircraftCreateDate",descending: true)
     
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            }
            else {
                var aircraftModels = Array<AircraftModel>()
                if let snapshot = snapshot {
                    for qdr in snapshot.documents {
                        if let aircraftModel = try? qdr.data(as: AircraftModel.self) {
                            aircraftModels.append(aircraftModel)
                        }
                    }
                }
                completion(aircraftModels,nil)
            }
        }
    }
    func getAllBookingForPilotByUID(uid : String,completion : @escaping (_ bookingModels : Array<BookingModel>?, _ error : String?)-> Void) {
        
        let query = FirebaseStoreManager.db.collection("Bookings").order(by: "bookingCreateDate",descending: true).whereField("piolatID", isEqualTo: uid)
     
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            }
            else {
                var bookingModels = Array<BookingModel>()
                if let snapshot = snapshot {
                    for qdr in snapshot.documents {
                        if let bookingModel = try? qdr.data(as: BookingModel.self) {
                            bookingModels.append(bookingModel)
                        }
                    }
                }
                completion(bookingModels,nil)
            }
        }
    }
    
    func getAllBookings(completion : @escaping (_ bookingModels : Array<BookingModel>?, _ error : String?)-> Void) {
        
        let query = FirebaseStoreManager.db.collection("Bookings").order(by: "bookingCreateDate",descending: true)
     
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            }
            else {
                var bookingModels = Array<BookingModel>()
                if let snapshot = snapshot {
                    for qdr in snapshot.documents {
                        if let bookingModel = try? qdr.data(as: BookingModel.self) {
                            bookingModels.append(bookingModel)
                        }
                    }
                }
                completion(bookingModels,nil)
            }
        }
    }
    
    func loginWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting : self) { [unowned self] result, error in
            
            if let error = error {
                self.showError(error.localizedDescription)
                return
            }
            
            guard let user = result?.user,
              let idToken = user.idToken?.tokenString
            else {
             return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            self.authWithFirebase(credential: credential,type: "google", displayName: "")
            
        }
    }
    
    func getAge(birthDay : Date) -> Int{
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDay, to: now)
        return ageComponents.year!
        
    }
    
    func showSnack(messages : String) {
        
        let snackbar = TTGSnackbar(message: messages, duration: .long)
        snackbar.messageLabel.textAlignment = .center
        snackbar.show()
    }
    
    func DownloadProgressHUDShow(text : String) -> MBProgressHUD{
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.mode = .indeterminate
        loading.label.text =  text
        loading.label.font = UIFont(name: "Roboto-Medium", size: 11)
        return loading
    }
    func DownloadProgressHUDUpdate(loading : MBProgressHUD, text : String) {
        
        loading.label.text =  text
        
    }
    func ProgressHUDShow(text : String) {
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.mode = .indeterminate
        loading.label.text =  text
        loading.label.font = UIFont(name: "Roboto-Medium", size: 11)
    }
    
    func ProgressHUDHide(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func convertMinToHourAndMin(totalMin : Int) -> String{
       
        let hour = totalMin / 60
        let min = totalMin % 60
        return String(format: "%02d:%02d", hour, min)
    }
    
    
    func addUserData(userData : UserModel) {
        
        ProgressHUDShow(text: "")
        try?  FirebaseStoreManager.db.collection("Users").document(userData.uid ?? "123").setData(from: userData,completion: { error in
            self.ProgressHUDHide()
            if error != nil {
                self.showError(error!.localizedDescription)
            }
            else {
                self.getUserData(uid: userData.uid ?? "123", showProgress: true)
                
            }
            
        })
    }
    
    
    
    func updateUserData(userModel : UserModel, completion : @escaping (_ error : Error?)->Void){
        try? FirebaseStoreManager.db.collection("Users").document(FirebaseStoreManager.auth.currentUser!.uid).setData(from: userModel, merge : true, completion: { error in
           completion(error)
            
        })
    }
   
    func compressVideo(sourceURL: URL, completion: @escaping (URL?, Error?) -> Void) {
       let asset = AVAsset(url: sourceURL)
       let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
       
       let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
       let compressedURL = documentsDirectory.appendingPathComponent("compressedVideo.mp4")
       
       do {
           if FileManager.default.fileExists(atPath: compressedURL.path) {
               try FileManager.default.removeItem(at: compressedURL)
           }
       } catch {}


       exportSession?.outputURL = compressedURL
       exportSession?.outputFileType = .mp4
       exportSession?.exportAsynchronously {
           switch exportSession?.status {
           case .completed:
               completion(compressedURL, nil)
           case .failed, .cancelled:
               completion(nil, exportSession?.error)
           default:
               break
           }
       }
   }
    func getPilotData(uid : String, showProgress : Bool)  {
        if showProgress {
            ProgressHUDShow(text: "")
        }
       
        FirebaseStoreManager.db.collection("Pilots").document(uid)
             .getDocument(as: PilotModel.self, completion: { result in
                 if showProgress {
                     self.ProgressHUDHide()
                 }
                switch result {
                case .success(let pilotModel):
                    
                    PilotModel.data = pilotModel
                    
                   
                        //self.showError("Please enable server to Production Mode")
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.pilotTabbarViewController)
                   
                   
                    
                    
                case .failure(_):
                    DispatchQueue.main.async {
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
                    }
                   
                }
            })
           
        
    }
    
    func getUserByID(uid : String , completion : @escaping (_ userModel : UserModel?, _ error  : String?)->Void){
        
        FirebaseStoreManager.db.collection("Users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(nil,error.localizedDescription)
            }
            else {
                if let snapshot = snapshot, snapshot.exists {
                    if let userModel = try? snapshot.data(as: UserModel.self) {
                        completion(userModel, nil)
                    }
                    else {
                        completion(nil,"User does not exist.")
                    }
                }
                else {
                    completion(nil,"User does not exist.")
                }
            }
        }
        
    }
    
    func getOnlyUserData(uid : String, showProgress : Bool)  {
        
        if showProgress {
            ProgressHUDShow(text: "")
        }
        
        FirebaseStoreManager.db.collection("Users").document(uid)
             .getDocument(as: UserModel.self, completion: { result in
                 if showProgress {
                     self.ProgressHUDHide()
                 }
                switch result {
                case .success(let userModel):
                    
                    UserModel.data = userModel
                    
                        //self.showError("Please enable server to Production Mode")
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.mainViewController)
                    
                   
                    
                    
                case .failure(_):
                    DispatchQueue.main.async {
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
                    }
                   
                }
            })
           
        
    }
    func getUserData(uid : String, showProgress : Bool)  {
        
        if showProgress {
            ProgressHUDShow(text: "")
        }
        
        FirebaseStoreManager.db.collection("Users").document(uid)
             .getDocument(as: UserModel.self, completion: { result in
                 if showProgress {
                     self.ProgressHUDHide()
                 }
                switch result {
                case .success(let userModel):
                    
                    UserModel.data = userModel
                    
                    if userModel.uid! == "GQX45tl32VNtEdEUnoSoSXuq9js2" {
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.adminTabbarViewController)
                    }
                    if userModel.fullName == "PILOT" {
                        self.getPilotData(uid: uid, showProgress: showProgress)
                    }
                    else {
                        //self.showError("Please enable server to Production Mode")
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.mainViewController)
                    }
                   
                    
                    
                case .failure(_):
                    DispatchQueue.main.async {
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
                    }
                   
                }
            })
           
        
    }
    
    enum MediaType {
        case image(UIImage, folderName: String)
        case video(URL, folderName: String)
        case audio(audioPath: URL, folderName: String)
    }



    
    func navigateToAnotherScreen(mIdentifier : String)  {
        
        let destinationVC = getViewControllerUsingIdentifier(mIdentifier: mIdentifier)
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true) {
            
        }
    }
    
  
    
    func getViewControllerUsingIdentifier(mIdentifier : String) -> UIViewController{
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let adminStoryboard = UIStoryboard(name: "Admin", bundle: Bundle.main)
        let pilotStoryboard = UIStoryboard(name: "Pilot", bundle: Bundle.main)
        
        switch mIdentifier {
        case Constants.StroyBoard.signInViewController:
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? SignInViewController)!
            
        case Constants.StroyBoard.adminTabbarViewController:
            return (adminStoryboard.instantiateViewController(identifier: mIdentifier) as? AdminTabbarViewController)!
            
        case Constants.StroyBoard.pilotTabbarViewController:
            return (pilotStoryboard.instantiateViewController(identifier: mIdentifier) as? PilotTabbarViewController)!
            
        case Constants.StroyBoard.mainViewController :
            return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? MainViewController)!
            
        
            
            
        default:
            return (mainStoryboard.instantiateViewController(identifier: Constants.StroyBoard.signInViewController) as? SignInViewController)!
        }
    }
    
    func beRootScreen(mIdentifier : String) {
        
        guard let window = self.view.window else {
            self.view.window?.rootViewController = getViewControllerUsingIdentifier(mIdentifier: mIdentifier)
            self.view.window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = getViewControllerUsingIdentifier(mIdentifier: mIdentifier)
        window.makeKeyAndVisible()
        
        
    }
    
    func getFirstName(from fullName: String) -> String? {
        let nameComponents = fullName.components(separatedBy: " ")
        return nameComponents.first
    }

    
    func convertDateToMonthFormater(_ date: Date) -> String
    {
        let df = DateFormatter()
        df.dateFormat = "MMMM"
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.timeZone = TimeZone.current
        return df.string(from: date)
        
    }
    func createDottedLine(for view: UIView, strokeColor: UIColor, lineWidth: CGFloat) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = [2, 3] // Adjust these values as per your requirement
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: view.bounds.midY),
                                CGPoint(x: view.bounds.width, y: view.bounds.midY)]) // Horizontal line
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }

    public func getDateDifference(startDate : Date, endDate : Date) -> String {
          //milliseconds
        var different = endDate.mMillisecondsSince1970 - startDate.mMillisecondsSince1970

          let secondsInMilli = 1000;
          let  minutesInMilli = secondsInMilli * 60;
          let hoursInMilli = minutesInMilli * 60;
          let daysInMilli = hoursInMilli * 24;

          let elapsedDays = different / Int64(daysInMilli)
        different = different % Int64(daysInMilli)

            let  elapsedHours = different / Int64(daysInMilli)
        different = different % Int64(hoursInMilli);

         let elapsedMinutes = different / Int64(daysInMilli)

         let diff = String(format: "%d:d %d:h %d:m",elapsedDays, elapsedHours, elapsedMinutes)
        return diff.replacingOccurrences(of: ":", with: "")
      }
    func convertDateAndTimeFormater(_ date: Date) -> String
    {
        let df = DateFormatter()
        df.dateFormat = "dd-MMM-yyyy, hh:mm a"
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.timeZone = TimeZone.current
        return df.string(from: date)
        
    }
    func convertDateForAppointment(_ date: Date) -> String
    {
        let df = DateFormatter()
        df.dateFormat = "ddMMyyyy"
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.timeZone = TimeZone.current
        return df.string(from: date)
        
    }
    
    func getAirports()-> [AirportModel]?{
        if let url = Bundle.main.url(forResource: "airports", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let airports = try decoder.decode([AirportModel].self, from: data)
               
                let europeanAirports = airports.filter { $0.continent == "EU" }
                
                return europeanAirports
                
            
            } catch {
                print("Error loading or parsing airport.json:", error)
                return nil
            }
        }
        
        return nil
    }
    
    func calculateTimeInHour(miles : Double)->Double{
        return ((miles / 270) * 1.2) + 0.3
    }
    
    
    
    func haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let R = 6371.0 // Earth radius in kilometers
        let phi1 = lat1 * .pi / 180
        let phi2 = lat2 * .pi / 180
        let deltaPhi = (lat2 - lat1) * .pi / 180
        let deltaLambda = (lon2 - lon1) * .pi / 180

        let a = sin(deltaPhi/2) * sin(deltaPhi/2) +
                cos(phi1) * cos(phi2) *
                sin(deltaLambda/2) * sin(deltaLambda/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))

        let distanceInKilometers = R * c
        let distanceInNauticalMiles = distanceInKilometers / 1.852

        return distanceInNauticalMiles
    }
    
    func getWeatherInformation(key : String,lat : Double, long : Double, completion : @escaping (_ weatherModel : WeatherModel?, _ error : String?)->Void){
        var request = URLRequest(url: URL(string: "https://api.weatherapi.com/v1/current.json?key=\(key)&q=\(lat)%2C\(long)")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let _ = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            else {
                completion(nil, "error")
                return
            }

            let decoder = JSONDecoder()

            do {
                let weatherModel = try decoder.decode(WeatherModel.self, from: data)
                completion(weatherModel, nil)
            } catch {
                completion(nil, error.localizedDescription)
            }
        }

        task.resume()

    }
    
    func createAuthUser(name : String, email : String, password : String,isAdmin : Bool, completion : @escaping (String?, String?)->Void){
        
        lazy var functions = Functions.functions()
        
        functions.httpsCallable("createUser").call(["name" : name, "email" : email,"password": password, "isAdmin" : isAdmin] as [String : Any]) { result, error in
            if let error = error {
                completion("failed",error.localizedDescription)
            }
            else {
                if let result = result, let data = result.data as? [String : String] {
                    if let response = data["response"] {
                        
                        completion(response,data["value"])
                       
                    }
                }
            }
        }
    }
    
    func deleteUser(uid : String, completion : @escaping (_ error : String?)->Void){
        lazy var functions = Functions.functions()
        
        functions.httpsCallable("deleteUser").call(["uid" : uid]) { result, error in
            if let error = error {
                completion(error.localizedDescription)
            }
            else {
                completion(nil)
            }
        }
        
    }
    
    func daysBetweenDates(currentDate: Date, futureDate: Date) -> Int {
        let calendar = Calendar.current

        let dateComponents = calendar.dateComponents([.day], from: currentDate, to: futureDate)
        
        return dateComponents.day ?? 0
    }
    
    func updateAuthUser(uid : String,name : String, email : String, password : String, completion : @escaping (String?, String?)->Void){
        
        lazy var functions = Functions.functions()
        
        functions.httpsCallable("updateUser").call(["uid" : uid, "name" : name, "email" : email,"password": password]) { result, error in
            if let error = error {
                completion(nil,error.localizedDescription)
            }
            else {
                if let result = result, let data = result.data as? [String : String] {
                    if let response = data["response"] {
                        
                        completion(response,data["value"])
                       
                    }
                }
            }
        }
    }
    
    func convertDateToString(_ date: Date) -> String
    {
        let df = DateFormatter()
        df.dateFormat = "dd-MMM-yyyy"
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.timeZone = TimeZone.current
        return df.string(from: date)
        
    }
    
 
    
    func convertDateForTicket(_ date: Date) -> String
    {
        let df = DateFormatter()
        df.dateFormat = "E,MMM dd, yyyy hh:mm a"
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.timeZone = TimeZone.current
        return df.string(from: date)
        
    }
    
    
    
    func convertDateIntoTime(_ date: Date) -> String
    {
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.timeZone = TimeZone.current
        return "\(df.string(from: date))"
        
        
    }
    
    

    
    func convertDateIntoDayForRecurringVoucher(_ date: Date) -> String
    {
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.timeZone = TimeZone.current
        return "\(df.string(from: date))"
        
    }
    
    func convertDateForBooking(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMM"
        return dateFormatter.string(from: date)
    }
  
    func convertTimeFormater(_ date: Date) -> String
    {
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.timeZone = TimeZone.current
        return df.string(from: date)
        
    }
    
    
    func showError(_ message : String) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showMessage(title : String,message : String, shouldDismiss : Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok",style: .default) { action in
            if shouldDismiss {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func authWithFirebase(credential : AuthCredential, type : String,displayName : String) {
        
        ProgressHUDShow(text: "")
        
        FirebaseStoreManager.auth.signIn(with: credential) { (authResult, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error != nil {
                
                self.showError(error!.localizedDescription)
            }
            else {
                let user = authResult!.user
                let ref =  FirebaseStoreManager.db.collection("Users").document(user.uid)
                ref.getDocument { (snapshot, error) in
                    if error != nil {
                        self.showError(error!.localizedDescription)
                    }
                    else {
                        if let doc = snapshot {
                            if doc.exists {
                                self.getUserData(uid: user.uid, showProgress: true)
                                
                            }
                            else {
                                
                                
                                var emailId = ""
                                let provider =  user.providerData
                                var name = ""
                                for firUserInfo in provider {
                                    if let email = firUserInfo.email {
                                        emailId = email
                                    }
                                }
                                
                                if type == "apple" {
                                    name = displayName
                                }
                                else {
                                    name = user.displayName!.capitalized
                                }
                                
                                let userData = UserModel()
                                userData.fullName = name
                                userData.email = emailId
                                userData.uid = user.uid
                                userData.registredAt = user.metadata.creationDate ?? Date()
                                userData.regiType = type
                                
                                self.addUserData(userData: userData)
                            }
                        }
                        
                    }
                }
                
            }
            
        }
    }
    
    
    public func logout(){
        UserModel.clearUserData()
        do {
            try FirebaseStoreManager.auth.signOut()
            self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
        }
        catch {
            self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
        }
    }
    
}






extension UIImageView {
    func makeRounded() {
        
        //self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        // self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        
    }
    
    
    
    
}



extension UIView {
    
    func roundTopCorners(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Top left and top right corners
    }
    
    public var safeAreaFrame: CGFloat {
        if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.currentUIWindow() {
                return window.safeAreaInsets.bottom
            }
            
        }
        else  {
            let window = UIApplication.shared.keyWindow
            return window!.safeAreaInsets.bottom
        }
        return 34
    }
    
    func smoothShadow(){
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 5
        //        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 1.8)
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                     y: bounds.maxY - layer.shadowRadius,
                                                     width: bounds.width,
                                                     height: layer.shadowRadius)).cgPath
    }
    
    func installBlurEffect(isTop : Bool) {
        self.backgroundColor = UIColor.clear
        var blurFrame = self.bounds
        
        if isTop {
            var statusBarHeight : CGFloat = 0.0
            if #available(iOS 13.0, *) {
                if let window = UIApplication.shared.currentUIWindow() {
                    statusBarHeight = window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                }
                
            } else {
                statusBarHeight = UIApplication.shared.statusBarFrame.height
            }
            
            blurFrame.size.height += statusBarHeight
            blurFrame.origin.y -= statusBarHeight
            
        }
        else {
            if let window = UIApplication.shared.currentUIWindow() {
                let bottomPadding = window.safeAreaInsets.bottom
                blurFrame.size.height += bottomPadding
            }
            
            
            //  blurFrame.origin.y += bottomPadding
        }
        let blur = UIBlurEffect(style:.light)
        let visualeffect = UIVisualEffectView(effect: blur)
        visualeffect.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 0.7)
        visualeffect.frame = blurFrame
        self.addSubview(visualeffect)
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 2
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        layer.mask = mask
        
    }
}


extension Date {
    public func setTime(hour: Int, min: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        
        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        
        return cal.date(from: components)
    }
}

extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}


public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }
        
        return window
        
    }
}

extension Date {
    var mMillisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
