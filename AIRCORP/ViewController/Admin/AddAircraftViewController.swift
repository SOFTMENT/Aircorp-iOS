//
//  AddAircraftViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 05/02/24.
//

import UIKit
import UniformTypeIdentifiers
import CropViewController
import FirebaseStorage

class AddAircraftViewController : UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var aircraftPicture: UIImageView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var aircraftNumber: UITextField!
    
    @IBOutlet weak var nextServiceDateTF: UITextField!
    
    @IBOutlet weak var annualDateTF: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var uploadCertificateBtn: UIButton!
    
    let nextServicePicker = UIDatePicker()
    let annualPicker = UIDatePicker()
    var selectedBtn : String?
    var cetificateURL : URL?
    var certificateType  : String?
    var isImageSelected = false
    var certificateImage : UIImage?
    override func viewDidLoad() {
        
        backView.isUserInteractionEnabled = true
        backView.layer.cornerRadius = 8
        backView.dropShadow()
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewClicked)))
        
        uploadBtn.layer.cornerRadius = 8
        aircraftPicture.layer.cornerRadius = 8
        addBtn.layer.cornerRadius = 8
        
        uploadCertificateBtn.layer.cornerRadius = 8
        uploadCertificateBtn.layer.borderColor = UIColor.lightGray.cgColor
        uploadCertificateBtn.layer.borderWidth = 0.7
        
        setupServiceDatePicker()
        setupAnnualDatePicker()
    }
    
    func setupServiceDatePicker() {
           // Configure the date picker
           nextServicePicker.datePickerMode = .date
           if #available(iOS 13.4, *) {
               nextServicePicker.preferredDatePickerStyle = .wheels
           }
           
           // Use the current date as the initial date
        nextServicePicker.date = Date()

           // Respond to date picker events
        nextServicePicker.addTarget(self, action: #selector(serviceDateChanged(datePicker: )), for: .valueChanged)

           // Assign date picker to the text field
           nextServiceDateTF.inputView =   nextServicePicker

           // Add a toolbar with a Done button
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))
           let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           toolbar.setItems([flexSpace, doneButton], animated: true)

           nextServiceDateTF.inputAccessoryView = toolbar
       }

       @objc func serviceDateChanged(datePicker: UIDatePicker) {
          
           nextServiceDateTF.text = convertDateToString(datePicker.date)
       }
    
    func setupAnnualDatePicker() {
           // Configure the date picker
           annualPicker.datePickerMode = .date
           if #available(iOS 13.4, *) {
               annualPicker.preferredDatePickerStyle = .wheels
           }
           
           // Use the current date as the initial date
        annualPicker.date = Date()

           // Respond to date picker events
        annualPicker.addTarget(self, action: #selector(annualDateChanged(datePicker: )), for: .valueChanged)

           // Assign date picker to the text field
           annualDateTF.inputView =  annualPicker

           // Add a toolbar with a Done button
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))
           let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           toolbar.setItems([flexSpace, doneButton], animated: true)

           annualDateTF.inputAccessoryView = toolbar
       }

       @objc func annualDateChanged(datePicker: UIDatePicker) {
          
          annualDateTF.text = convertDateToString(datePicker.date)
       }

       @objc func doneAction() {
           // Dismiss the date picker
           self.view.endEditing(true)
       }
    
    @objc func backViewClicked(){
        self.dismiss(animated: true)
    }
    
    @IBAction func uploadBtnClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "Upload Aircraft Picture", message: "", preferredStyle: .alert)
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
    @IBAction func addBtnClicked(_ sender: Any) {
        
        let sAirCraftNumber = aircraftNumber.text
      
        let sNextService = nextServiceDateTF.text
        let sAnnual = annualDateTF.text
       
        
        if !isImageSelected {
            self.showSnack(messages: "Upload aircraft picture")
        }
        else if sAirCraftNumber == "" {
            self.showSnack(messages: "Enter aircraft number")
        }

        else if sNextService == "" {
            self.showSnack(messages: "Select next service date")
        }
        else if sAnnual == "" {
            self.showSnack(messages: "Select annual date")
        }
       
        else {
            
            let aircraftModel = AircraftModel()
            aircraftModel.id = FirebaseStoreManager.db.collection("Aircrafts").document().documentID
            aircraftModel.aircraftNumber = sAirCraftNumber
            aircraftModel.nextServiceDate = nextServicePicker.date
            aircraftModel.annualDate = annualPicker.date
            aircraftModel.cerificateType = self.certificateType
            aircraftModel.aircraftCreateDate = Date()
            self.ProgressHUDShow(text: "")
            
           
                    
            self.uploadImageOnFirebase(uid: aircraftModel.id!, type: "AircraftPicture") { download,error  in
                        if let error = error {
                            self.ProgressHUDHide()
                            self.showError(error)
                        }
                        else {
                            
                           
                            
                           aircraftModel.picture = download
                            if self.certificateType == "image" {
                                self.uploadImageOnFirebase(uid: aircraftModel.id!, type: "Certificate") { downloadURL,error  in
                                    if let error = error {
                                        self.ProgressHUDHide()
                                        self.showError(error)
                                    }
                                    else {
                                        aircraftModel.certificateDoc = downloadURL
                                        self.uploadAircraftOnFirebase(aircraftModel: aircraftModel)
                                    }
                                    
                                }
                            }
                            else {
                                self.uploadPdfOnFirebase(id: aircraftModel.id!, type: "Certificate", mURL: self.cetificateURL!) { downloadURL,error  in
                                    if let error = error {
                                        self.ProgressHUDHide()
                                        self.showError(error)
                                        
                                        
                                    }
                                    else {
                                       aircraftModel.certificateDoc = downloadURL
                                        self.uploadAircraftOnFirebase(aircraftModel: aircraftModel)
                                    }
                                 
                                }
                            }
                        }
                   
            }
          
       }
        
    }
    
    func uploadAircraftOnFirebase(aircraftModel : AircraftModel){
       try? FirebaseStoreManager.db.collection("Aircrafts").document(aircraftModel.id!).setData(from: aircraftModel) { error in
            self.ProgressHUDHide()
            if let error  = error {
                self.showError(error.localizedDescription)
            }
            else {
                self.showSnack(messages: "Aircraft Added")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @IBAction func uploadCertificateClicked(_ sender: Any) {
     
            let alert = UIAlertController(title: "Upload Certificate", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "PDF", style: .default) { (action) in
                
                self.selectedBtn = "certificate"
                
                let supportedTypes: [UTType] = [UTType.pdf]
                let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
           
                documentPicker.delegate = self
                
                self.present(documentPicker, animated: true, completion: nil)
                
            }
            
            let action2 = UIAlertAction(title: "Photo", style: .default) { (action) in
                self.selectedBtn = "certificate"
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
    
    func uploadPdfOnFirebase(id : String,type : String, mURL : URL, completion : @escaping (String, _ error : String?) -> Void ) {
        
        let storage = Storage.storage().reference().child("AircraftDocuments").child(type).child("\(id).pdf")
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

extension AddAircraftViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
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
            aircraftPicture.image = image
        }
        else if selectedBtn == "certificate" {
            uploadCertificateBtn.setTitle("Cetificate Photo Uploaded", for: .normal)
            uploadCertificateBtn.setTitleColor(.white, for: .normal)
            uploadCertificateBtn.tintColor = .white
            uploadCertificateBtn.backgroundColor = UIColor(red: 75/255, green: 181/255, blue: 67/255, alpha: 1)
            
            certificateImage =  image
            certificateType = "image"
        }
       
            self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageOnFirebase(uid : String, type : String,completion : @escaping (String, _ error : String?) -> Void ) {
        
        let storage = Storage.storage().reference().child("Aircrafts").child(type).child("\(uid).png")
        var downloadUrl = ""
        
        var uploadData : Data!
        if type == "AircraftPicture" {
            uploadData = (self.aircraftPicture.image?.jpegData(compressionQuality: 0.5))!
        }
        else {
            uploadData = (self.certificateImage?.jpegData(compressionQuality: 0.5))!
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
extension AddAircraftViewController : UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
       
            uploadCertificateBtn.setTitle("Certificate PDF Uploaded", for: .normal)
        uploadCertificateBtn.setTitleColor(.white, for: .normal)
        uploadCertificateBtn.tintColor = .white
        uploadCertificateBtn.backgroundColor = UIColor(red: 75/255, green: 181/255, blue: 67/255, alpha: 1)
            
            cetificateURL  = urls[0]
            certificateType = "pdf"
       
    }
}

