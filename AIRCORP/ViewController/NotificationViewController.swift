//
//  NotificationViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 29/01/24.
//

import UIKit
import Firebase

class NotificationViewController : UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var no_notifications_available: UILabel!
    

    var notifications : [NotificationModel] = []
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
    
        getAllNotifications()
    }
    
    @objc func backViewClicked(){
        self.dismiss(animated: true, completion: nil)
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
  
}

extension NotificationViewController : UITableViewDelegate, UITableViewDataSource {
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
          
            return cell
        }
        return AdminNotificationsTableViewCell()
    }
    
    
}

