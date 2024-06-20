//
//  FirebaseStoreManager.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 29/01/24.
//

import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

struct FirebaseStoreManager {
    static let db = Firestore.firestore()
    static let auth = Auth.auth()
    static let storage = Storage.storage()
    static let messaging = Messaging.messaging()
    
    
}
