//
//  EditPilotViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 04/02/24.
//

import UIKit
import CropViewController
import FirebaseStorage
import UniformTypeIdentifiers

class EditPilotViewController : UIViewController {
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var uploadBtn: UIButton!
    var isImageSelected = false
    @IBOutlet weak var fullNameTF: UITextField!
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
    var pilotModel : PilotModel?
    let pickerView = UIPickerView()
    let options = [VehicleMode.HELICOPTER, VehicleMode.PLANE]
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var selectModeTF: UITextField!
    
    
    @IBOutlet weak var deleteBtn: UIView!
    
    override func viewDidLoad() {
        
        guard let pilotModel = pilotModel else {
            
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            
            return
            
        }
        phoneTF.text = pilotModel.phoneNumber ?? ""
        fullNameTF.text = pilotModel.name ?? ""
        selectModeTF.text = pilotModel.canFly ?? ""
        passwordTF.text = pilotModel.password ?? ""
        ratingExpirePicker.date = pilotModel.ratingExpireDate ?? Date()
        medicalExpirePicker.date = pilotModel.medicalExpireDate ?? Date()
        
        ratingExpiryDateTF.text = convertDateToString(pilotModel.ratingExpireDate ?? Date())
        nmedicalExpiryDate.text = convertDateToString(pilotModel.medicalExpireDate ?? Date())
        
        if let medicalDocType = pilotModel.medicalDocType {
            if medicalDocType == "image" {
                uploadMedicalBtn.setTitle("Medical Photo Uploaded", for: .normal)
               
                
            }
            else {
                uploadMedicalBtn.setTitle("Medical PDF Uploaded", for: .normal)
            }
            uploadMedicalBtn.setTitleColor(.white, for: .normal)
            uploadMedicalBtn.tintColor = .white
            uploadMedicalBtn.backgroundColor = UIColor(red: 75/255, green: 181/255, blue: 67/255, alpha: 1)
        }
        
        if let licenceDocType = pilotModel.licenceDocType {
            if licenceDocType == "image" {
            uploadLicenceBtn.setTitle("Licence Photo Uploaded", for: .normal)
               
                
            }
            else {
                uploadLicenceBtn.setTitle("Licence PDF Uploaded", for: .normal)
            }
            uploadLicenceBtn.setTitleColor(.white, for: .normal)
            uploadLicenceBtn.tintColor = .white
            uploadLicenceBtn.backgroundColor = UIColor(red: 75/255, green: 181/255, blue: 67/255, alpha: 1)
        }
        
        mImage.layer.cornerRadius = 8
        if let path = pilotModel.profileImage, !path.isEmpty {
            mImage.sd_setImage(with: URL(string: path), placeholderImage: UIImage(named: "profile-placeholder"))
        }
        
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
        
        deleteBtn.layer.cornerRadius = 8
        deleteBtn.dropShadow()
        deleteBtn.isUserInteractionEnabled = true
        deleteBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteBtnClicked)))
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        selectModeTF.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        selectModeTF.inputAccessoryView = toolBar
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func deleteBtnClicked(){
        let alert = UIAlertController(title: "DELETE ACCOUNT", message: "Are you sure you want to delete this account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            
           
                
            self.ProgressHUDShow(text: "Account Deleting...")
             
            self.deleteUser(uid: self.pilotModel!.id!) { error in
                
                self.ProgressHUDHide()
               
                    
                    FirebaseStoreManager.db.collection("Pilots").document(self.pilotModel!.id!).delete { error in
                       
                        if error == nil {
                            self.showSnack(messages: "Deleted")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                                self.dismiss(animated: true)
                            }
                            
                        }
                        else {
                   
                            self.showError(error!.localizedDescription)
                        }
                    }
                
             
            }
                
                     
                    
                
            
            
        }))
        present(alert, animated: true)
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
        let alert = UIAlertController(title: "Upload Medical", message: "", preferredStyle: .alert)
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
      
        let sPassword = passwordTF.text
        let sRatingExpire = ratingExpiryDateTF.text
        let sMedicalExpire = nmedicalExpiryDate.text
        let sMode = selectModeTF.text
        let sPhone = phoneTF.text
       if sFullName == "" {
            self.showSnack(messages: "Enter Full Name")
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
       
        else {
            
            
            self.pilotModel!.name = sFullName
            self.pilotModel!.password = sPassword
            self.pilotModel!.ratingExpireDate = ratingExpirePicker.date
            self.pilotModel!.medicalExpireDate = medicalExpirePicker.date
            self.pilotModel!.canFly = sMode
            self.pilotModel!.phoneNumber = sPhone
      
            self.ProgressHUDShow(text: "Updating Pilot Account...")
            
            self.updateAuthUser(uid: self.pilotModel!.id!, name: sFullName!, email: self.pilotModel!.email!, password: sPassword!, completion: { response, value in
                
                self.ProgressHUDHide()
                if response == "failed" {
                    
                    self.showError(value ?? "Error")
                }
                else {
                    self.ProgressHUDShow(text: "")
                    if self.isImageSelected {
                        
                        self.uploadImageOnFirebase(uid: self.pilotModel!.id!, type: "ProfilePicture") { download,error  in
                            if let error = error {
                                self.ProgressHUDHide()
                                self.showError(error)
                            }
                            else {
                                
                                
                                self.pilotModel!.profileImage = download
                                if self.licenceType == "image" {
                                    self.pilotModel!.licenceDocType = "image"
                                    self.uploadImageOnFirebase(uid: self.pilotModel!.id!, type: "Licence") { downloadURL,error  in
                                        if let error = error {
                                            self.ProgressHUDHide()
                                            self.showError(error)
                                        }
                                        else {
                                            self.pilotModel!.licenceDoc = downloadURL
                                            self.uploadMedical(pilot: self.pilotModel!)
                                        }
                                        
                                    }
                                }
                                else {
                                    self.pilotModel!.licenceDocType = "pdf"
                                    self.uploadPdfOnFirebase(id: self.pilotModel!.id!, type: "Licence", mURL: self.licenceURL!) { downloadURL,error  in
                                        if let error = error {
                                            self.ProgressHUDHide()
                                            self.showError(error)
                                            
                                        }
                                        else {
                                            self.pilotModel!.licenceDoc = downloadURL
                                            self.uploadMedical(pilot: self.pilotModel!)
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                    }
                    else if let licenceImage = self.licenceType {
                        if self.licenceType == "image" {
                            self.pilotModel!.licenceDocType = "image"
                            self.uploadImageOnFirebase(uid: self.pilotModel!.id!, type: "Licence") { downloadURL,error  in
                                if let error = error {
                                    self.ProgressHUDHide()
                                    self.showError(error)
                                }
                                else {
                                    self.pilotModel!.licenceDoc = downloadURL
                                    self.uploadMedical(pilot: self.pilotModel!)
                                }
                                
                            }
                        }
                        else {
                            self.pilotModel!.licenceDocType = "pdf"
                            self.uploadPdfOnFirebase(id: self.pilotModel!.id!, type: "Licence", mURL: self.licenceURL!) { downloadURL,error  in
                                if let error = error {
                                    self.ProgressHUDHide()
                                    self.showError(error)
                                    
                                }
                                else {
                                    self.pilotModel!.licenceDoc = downloadURL
                                    self.uploadMedical(pilot: self.pilotModel!)
                                }
                                
                            }
                        }
                    }
                    else {
                        self.uploadMedical(pilot: self.pilotModel!)
                    }
                }
                    
                    
                
            })
             
        }
          
       
                                
    }
    
    func uploadMedical(pilot : PilotModel){
        
        if let medicalType = self.medicalType {
            if medicalType == "image" {
                self.pilotModel!.medicalDocType = "image"
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
                self.pilotModel!.medicalDocType = "pdf"
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
        else {
            self.addPilotOnFirebase(pilotModel: pilot)
        }

    }
    
    func addPilotOnFirebase(pilotModel : PilotModel){
        
    
        try? FirebaseStoreManager.db.collection("Pilots").document(pilotModel.id!).setData(from: pilotModel,merge : true) { error in
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
                    VC.isUpdated = true
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
extension EditPilotViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
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
extension EditPilotViewController : UIDocumentPickerDelegate {
    
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

extension EditPilotViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    
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
        
        selectModeTF.text = options[row]
    }
    
}
