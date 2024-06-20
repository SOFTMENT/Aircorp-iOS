//
//  ManageNotificationViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 03/02/24.
//

import UIKit
import Firebase

class ManageNotificationViewController : UIViewController {
    @IBOutlet weak var tableView: UITableView!
  

    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var no_notifications_available: UILabel!
    var notifications : [NotificationModel] = []
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addView.isUserInteractionEnabled = true
        addView.layer.cornerRadius = 8
    
        
        addView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addViewClicked)))
       
        getAllNotifications()
    }
    
    @objc func backViewClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addViewClicked(){
        performSegue(withIdentifier: "addNotificationSeg", sender: nil)
    }
    
    
    
    public func getAllNotifications(){
        ProgressHUDShow(text: "")
        Firestore.firestore().collection("Notifications").order(by: "notificationTime",descending: true).addSnapshotListener { snapshot, error in
            self.ProgressHUDHide()
            if error == nil {
                self.notifications.removeAll()
                if let snap = snapshot, !snap.isEmpty {
                    for qdr in  snap.documents{
                        if let notification = try? qdr.data(as: NotificationModel.self) {
                            self.notifications.append(notification)
                        }
                    }
                    
                }
                self.tableView.reloadData()
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
    }
    
    @objc func deleteBtnClicked(value : MyGesture) {
      
        let alert = UIAlertController(title: "Delete Notification", message: "Are you sure you want to delete this notification.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.ProgressHUDShow(text: "Deleting...")
            Firestore.firestore().collection("Notifications").document(value.id).delete { error in
                if let error = error {
                    self.showError(error.localizedDescription)
                }
                else {
                    self.showSnack(messages: "Deleted")
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
}

extension ManageNotificationViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notifications.count > 0 {
            no_notifications_available.isHidden = true
        }
        else {
            no_notifications_available.isHidden = false
        }
        
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "notificationscell", for: indexPath) as? AdminNotificationsTableViewCell {
            
            cell.mView.dropShadow()
            cell.mView.layer.cornerRadius = 12
            
            let notification = notifications[indexPath.row]
            cell.mTitle.text = notification.title ?? "Something Went Wrong"
            cell.mMessage.text = notification.message ?? "Something Went Wrong"
            cell.mHour.text = (notification.notificationTime ?? Date()).timeAgoSinceDate()
            cell.deleteBtn.isUserInteractionEnabled = true
            let deleteTap = MyGesture(target: self, action: #selector(deleteBtnClicked(value:)))
            deleteTap.id = notification.notificationId ?? "1"
            cell.deleteBtn.addGestureRecognizer(deleteTap)
            return cell
        }
        return AdminNotificationsTableViewCell()
    }
    
    
}
