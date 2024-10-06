//
//  AddNotificationViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 03/02/24.
//
import UIKit
import Firebase

class AddNotificationViewController : UIViewController {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var notificationMessage: UITextView!
    @IBOutlet weak var notificationTitle: UITextField!
    
    @IBOutlet weak var addBtn: UIButton!
    override func viewDidLoad() {
        backView.dropShadow()
        backView.layer.cornerRadius = 8
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewClicked)))
        
        
        notificationMessage.layer.cornerRadius = 8
        notificationMessage.layer.borderWidth = 0.8
        notificationMessage.layer.borderColor = UIColor.lightGray.cgColor
        notificationMessage.contentInset = UIEdgeInsets(top: 6, left: 5, bottom: 6, right: 6)
        notificationMessage.delegate = self
        addBtn.layer.cornerRadius = 8
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @IBAction func sentBtnClicked(_ sender: Any) {
        
        guard let sTitle = notificationTitle.text, !sTitle.isEmpty else {
            self.showSnack(messages: "Enter Title")
            return
        }
        guard let sMessage = notificationMessage.text, !sMessage.isEmpty else {
         
            self.showSnack(messages: "Enter Message")
            return
        }
        self.view.endEditing(true)
        let docRef =  Firestore.firestore().collection("Notifications").document()
        docRef.setData(["notificationTime" : Date(),"title" : sTitle, "message" : sMessage,"notificationId": docRef.documentID])
       // PushNotificationSender().sendPushNotificationToTopic(title: sTitle, body: sMessage)
        
        notificationTitle.text = ""
        notificationMessage.text = ""
      
        self.showSnack(messages: "Notification has been sent")
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.dismiss(animated: true)
        }
    }
    

    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    
    @objc func backViewClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension AddNotificationViewController : UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    
    
}
