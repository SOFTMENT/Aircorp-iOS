//
//  AddPilotViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 03/02/24.
//

import UIKit
import CropViewController
import FirebaseStorage
import UniformTypeIdentifiers

class AddPilotViewController : UIViewController {
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var uploadBtn: UIButton!
    var isImageSelected = false
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailAddressTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var ratingExpiryDateTF: UITextField!
    @IBOutlet weak var nmedicalExpiryDate: UITextField!
    @IBOutlet weak var uploadLicenceBtn: UIButton!
    @IBOutlet weak var uploadMedicalBtn: UIButton!
    var licenceURL : URL?
    var licenceType : String?
    var medicalURL : URL?
    var medicalType : String?
    var selectedBtn : String?
    var licenceImage : UIImage?
    var medicalImage : UIImage?
    let ratingExpirePicker = UIDatePicker()
    let medicalExpirePicker = UIDatePicker()
    let pickerView = UIPickerView()
    let options = [VehicleMode.HELICOPTER, VehicleMode.PLANE]
    var totalPilot = 0
    @IBOutlet weak var phoneTF: UITextField!
    
    
    @IBOutlet weak var selectModelTF: UITextField!
    
    
    override func viewDidLoad() {
        
        mImage.layer.cornerRadius = 8
    
        uploadBtn.layer.cornerRadius = 8
        
        backView.layer.cornerRadius = 8
        backView.dropShadow()
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewClicked)))
        
        addBtn.layer.cornerRadius = 8
    
        uploadLicenceBtn.layer.cornerRadius = 8
        uploadLicenceBtn.layer.borderColor = UIColor.lightGray.cgColor
        uploadLicenceBtn.layer.borderWidth = 0.7
        
        uploadMedicalBtn.layer.cornerRadius = 8
        uploadMedicalBtn.layer.borderColor = UIColor.lightGray.cgColor
        uploadMedicalBtn.layer.borderWidth = 0.7
        
        setupRatingDatePicker()
        setupMedicalDatePicker()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        selectModelTF.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        selectModelTF.inputAccessoryView = toolBar
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupMedicalDatePicker() {
           // Configure the date picker
           medicalExpirePicker.datePickerMode = .date
           if #available(iOS 13.4, *) {
               medicalExpirePicker.preferredDatePickerStyle = .wheels
           }
           
           // Use the current date as the initial date
        medicalExpirePicker.date = Date()

           // Respond to date picker events
        medicalExpirePicker.addTarget(self, action: #selector(medicalDateChanged(datePicker: )), for: .valueChanged)

           // Assign date picker to the text field
           nmedicalExpiryDate.inputView =  medicalExpirePicker

           // Add a toolbar with a Done button
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))
           let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           toolbar.setItems([flexSpace, doneButton], animated: true)

           nmedicalExpiryDate.inputAccessoryView = toolbar
       }

       @objc func medicalDateChanged(datePicker: UIDatePicker) {
          
           nmedicalExpiryDate.text = convertDateToString(datePicker.date)
       }
    
    func setupRatingDatePicker() {
           // Configure the date picker
           ratingExpirePicker.datePickerMode = .date
           if #available(iOS 13.4, *) {
              ratingExpirePicker.preferredDatePickerStyle = .wheels
           }
           
           // Use the current date as the initial date
        ratingExpirePicker.date = Date()

           // Respond to date picker events
        ratingExpirePicker.addTarget(self, action: #selector(ratingDateChanged(datePicker: )), for: .valueChanged)

           // Assign date picker to the text field
           ratingExpiryDateTF.inputView = ratingExpirePicker

           // Add a toolbar with a Done button
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))
           let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           toolbar.setItems([flexSpace, doneButton], animated: true)

           ratingExpiryDateTF.inputAccessoryView = toolbar
       }

       @objc func ratingDateChanged(datePicker: UIDatePicker) {
          
           ratingExpiryDateTF.text = convertDateToString(datePicker.date)
       }

       @objc func doneAction() {
           // Dismiss the date picker
           self.view.endEditing(true)
       }
    
    @IBAction func uploadMedicalClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "Upload Medical", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "PDF", style: .default) { (action) in
            
            self.selectedBtn = "medical"
            
            let supportedTypes: [UTType] = [UTType.pdf]
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
       
            documentPicker.delegate = self
            
            self.present(documentPicker, animated: true, completion: nil)
            
        }
        
        let action2 = UIAlertAction(title: "Photo", style: .default) { (action) in
            self.selectedBtn = "medical"
            let image = UIImagePickerController()
            image.delegate = self
            image.title = "Photo"
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
    
    @IBAction func uploadLicenceClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Upload Licence", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "PDF", style: .default) { (action) in
            
            self.selectedBtn = "licence"
            
            let supportedTypes: [UTType] = [UTType.pdf]
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
       
            documentPicker.delegate = self
            
            self.present(documentPicker, animated: true, completion: nil)
            
        }
        
        let action2 = UIAlertAction(title: "Photo", style: .default) { (action) in
            self.selectedBtn = "licence"
            let image = UIImagePickerController()
            image.delegate = self
            image.title = "Photo"
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
    @IBAction func addBtnClicked(_ sender: Any) {
        
        let sFullName = fullNameTF.text
        let sEmail = emailAddressTF.text
        let sPassword = passwordTF.text
        let sRatingExpire = ratingExpiryDateTF.text
        let sMedicalExpire = nmedicalExpiryDate.text
        let sMode = selectModelTF.text
        let sPhone = phoneTF.text
        if !isImageSelected {
            self.showSnack(messages: "Upload Profile Image")
        }
        else if sFullName == "" {
            self.showSnack(messages: "Enter Full Name")
        }
        else if sEmail == "" {
            self.showSnack(messages: "Enter Email Address")
        }
        else if sPassword == "" {
            self.showSnack(messages: "Enter Password")
        }
        else if sMode == "" {
            self.showSnack(messages: "Select Mode")
        }
        else if sPhone == "" {
            self.showSnack(messages: "Enter Phone Number")
        }
        else if sRatingExpire == "" {
            self.showSnack(messages: "Select rating expire date")
        }
        else if sMedicalExpire == "" {
            self.showSnack(messages: "Select Medical expire date")
        }
        else if licenceType == nil {
            self.showSnack(messages: "Upload licence")
        }
        else if medicalType == nil {
            self.showSnack(messages: "Upload medical")
        }
        else {
            
            let pilot = PilotModel()
           
            pilot.email = sEmail
            pilot.name = sFullName
            pilot.password = sPassword
            pilot.canFly = sMode
            pilot.ratingExpireDate = ratingExpirePicker.date
            pilot.licenceDocType = self.licenceType
            pilot.medicalDocType = self.medicalType
            pilot.medicalExpireDate = medicalExpirePicker.date
            pilot.orderIndex = totalPilot
            pilot.phoneNumber = sPhone
            self.ProgressHUDShow(text: "Creating Pilot Account...")
            
            self.createAuthUser(name: sFullName!, email: sEmail!, password: sPassword!, isAdmin: false) { response, value in
                self.ProgressHUDHide()
                if response == "failed" {
                
                    self.showError(value ?? "Error")
                }
                else {
                    pilot.id = value
                    self.ProgressHUDShow(text: "")
                    
                    self.uploadImageOnFirebase(uid: pilot.id!, type: "ProfilePicture") { download,error  in
                        if let error = error {
                            self.ProgressHUDHide()
                            self.showError(error)
                        }
                        else {
                            
                           
                            
                            pilot.profileImage = download
                            if self.licenceType == "image" {
                                self.uploadImageOnFirebase(uid: pilot.id!, type: "Licence") { downloadURL,error  in
                                    if let error = error {
                                        self.ProgressHUDHide()
                                        self.showError(error)
                                    }
                                    else {
                                        pilot.licenceDoc = downloadURL
                                        self.uploadMedical(pilot: pilot)
                                    }
                                    
                                }
                            }
                            else {
                                self.uploadPdfOnFirebase(id: pilot.id!, type: "Licence", mURL: self.licenceURL!) { downloadURL,error  in
                                    if let error = error {
                                        self.ProgressHUDHide()
                                        self.showError(error)
                                        
                                        
                                    }
                                    else {
                                        pilot.licenceDoc = downloadURL
                                        self.uploadMedical(pilot: pilot)
                                    }
                                 
                                }
                            }
                        }
                       
                    }
                    
                }
            }
          
       }
        
    }
    
    func uploadMedical(pilot : PilotModel){
  
        
            if self.medicalType == "image" {
                self.uploadImageOnFirebase(uid: pilot.id!, type: "Medical") { downloadURL,error  in
                    if let error = error {
                        self.ProgressHUDHide()
                        self.showError(error)
                    }
                    else{
                        pilot.licenceDoc = downloadURL
                        self.addPilotOnFirebase(pilotModel: pilot)
                    }
                  
                }
            
            }
            else {
                self.uploadPdfOnFirebase(id:  pilot.id!, type: "Medical", mURL: self.medicalURL!) { downloadURL,error  in
                    if let error = error {
                        self.ProgressHUDHide()
                        self.showError(error)
                        
                        
                    }
                    else {
                        pilot.medicalDoc = downloadURL
                        self.addPilotOnFirebase(pilotModel: pilot)
                    }
                   
                }
            }
        
        
    }
    
    func addPilotOnFirebase(pilotModel : PilotModel){
        
        let userModel = UserModel()
        userModel.uid = pilotModel.id
        userModel.fullName = "PILOT"
        try? FirebaseStoreManager.db.collection("Users").document(pilotModel.id!).setData(from: userModel) { error in
        }
        
                try? FirebaseStoreManager.db.collection("Pilots").document(pilotModel.id!).setData(from: pilotModel) { error in
                    self.ProgressHUDHide()
                    if let error = error {
                        self.showError(error.localizedDescription)
                    }
                    else {
                        self.performSegue(withIdentifier: "sharePilotSeg", sender: pilotModel)
                    }
                }
        
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sharePilotSeg" {
            if let VC = segue.destination as? PilotPasswordShareViewController {
                if let pilotModel = sender as? PilotModel {
                    VC.email = pilotModel.email
                    VC.fullName = pilotModel.name
                    VC.password = pilotModel.password
                }
            }
        }
    }
    
    @objc func backViewClicked(){
        self.dismiss(animated: true)
    }
    
    @IBAction func uploadBtnClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Upload Profile Picture", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Using Camera", style: .default) { (action) in
            self.selectedBtn = "profile"
            let cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.sourceType = .camera
            self.present(cameraPicker, animated: true)
           
            
        }
        
        let action2 = UIAlertAction(title: "From Photo Library", style: .default) { (action) in
            self.selectedBtn = "profile"
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
    func uploadPdfOnFirebase(id : String,type : String, mURL : URL, completion : @escaping (String, _ error : String?) -> Void ) {
        
        let storage = Storage.storage().reference().child("PilotsDocuments").child(type).child("\(id).pdf")
        var downloadUrl = ""
        
        
        let metadata = StorageMetadata()
        //specify MIME type
        
        metadata.contentType = "application/pdf"
       
        let isAccessing = mURL.startAccessingSecurityScopedResource()
        
        if let videoData = try? Data(contentsOf: mURL) {
            
            storage.putData(videoData, metadata: metadata) { metadata, error in
                if error == nil {
                    storage.downloadURL { (url, error) in
                        if error == nil {
                            downloadUrl = url!.absoluteString
                            if isAccessing {
                                mURL.stopAccessingSecurityScopedResource()
                            }
                            completion(downloadUrl,nil)
                        }
                        else {
                            completion(downloadUrl,error!.localizedDescription)
                        }
                      
                       
                        
                    }
                }
                else {
                    if isAccessing {
                        mURL.stopAccessingSecurityScopedResource()
                    }
                    print(error!.localizedDescription)
                    completion(downloadUrl, error!.localizedDescription)
                }
            }
        }
        else {
            if isAccessing {
                mURL.stopAccessingSecurityScopedResource()
            }
            completion(downloadUrl,"ERROR PDF UPLOAD")
           
        }
        
    }
}
extension AddPilotViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
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
        if self.selectedBtn == "profile" {
            isImageSelected = true
            mImage.image = image
        }
        else if selectedBtn == "licence" {
            uploadLicenceBtn.setTitle("Licence Photo Uploaded", for: .normal)
            uploadLicenceBtn.setTitleColor(.white, for: .normal)
            uploadLicenceBtn.tintColor = .white
            uploadLicenceBtn.backgroundColor = UIColor(red: 75/255, green: 181/255, blue: 67/255, alpha: 1)
            
            licenceImage =  image
            licenceType = "image"
        }
        else if selectedBtn == "medical" {
            uploadMedicalBtn.setTitle("Medical Photo Uploaded", for: .normal)
            uploadMedicalBtn.setTitleColor(.white, for: .normal)
          uploadMedicalBtn.tintColor = .white
            uploadMedicalBtn.backgroundColor = UIColor(red: 75/255, green: 181/255, blue: 67/255, alpha: 1)
            
            medicalImage =  image
            medicalType = "image"
        }
            self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageOnFirebase(uid : String, type : String,completion : @escaping (String, _ error : String?) -> Void ) {
        
        let storage = Storage.storage().reference().child("PilotPicture").child(type).child("\(uid).png")
        var downloadUrl = ""
        
        var uploadData : Data!
        
        if type == "Medical" {
            uploadData = (self.medicalImage?.jpegData(compressionQuality: 0.5))!
        }
        else if type == "Licence" {
            uploadData = (self.licenceImage?.jpegData(compressionQuality: 0.5))!
        }
        else {
            uploadData = (self.mImage.image?.jpegData(compressionQuality: 0.5))!
        }
       
        
    
        storage.putData(uploadData, metadata: nil) { (metadata, error) in
            
            if error == nil {
                storage.downloadURL { (url, error) in
                    if error == nil {
                        downloadUrl = url!.absoluteString
                        completion(downloadUrl, nil)
                    }
                    else {
                        completion(downloadUrl, error!.localizedDescription)
                    }
                   
                    
                }
            }
            else {
                completion(downloadUrl, error!.localizedDescription)
            }
            
        }
    }
    
    
}
extension AddPilotViewController : UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        if selectedBtn == "licence" {
            uploadLicenceBtn.setTitle("Licence PDF Uploaded", for: .normal)
            uploadLicenceBtn.setTitleColor(.white, for: .normal)
            uploadLicenceBtn.tintColor = .white
            uploadLicenceBtn.backgroundColor = UIColor(red: 75/255, green: 181/255, blue: 67/255, alpha: 1)
            
            licenceURL = urls[0]
            licenceType = "pdf"
        }
        else if selectedBtn == "medical" {
            uploadMedicalBtn.setTitle("Medical PDF Uploaded", for: .normal)
            uploadMedicalBtn.setTitleColor(.white, for: .normal)
            uploadMedicalBtn.tintColor = .white
            uploadMedicalBtn.backgroundColor = UIColor(red: 75/255, green: 181/255, blue: 67/255, alpha: 1)
            
            medicalURL = urls[0]
            medicalType = "pdf"
        }
      
        
    
    }
}

extension AddPilotViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectModelTF.text = options[row]
    }
    
}
