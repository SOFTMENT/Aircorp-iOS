//
//  NotificationModel.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 03/02/24.
//

import UIKit

class NotificationModel: NSObject, Codable {
    
    var title : String?
    var message : String?
    var notificationTime : Date?
    var notificationId : String?
}
