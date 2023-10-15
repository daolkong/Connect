//
//  SharedViewModel.swift
//  Connect
//
//  Created by Daol on 10/10/23.
//

import Foundation
import FirebaseFirestore

class SharedViewModel: ObservableObject {
    @Published var userAFullID: String = ""
    @Published var userBFullID: String = ""
    
    // Add this function to update the userBFullID when a new notification is received.
    func updateToUserInNotification(notificationId:String){
        Firestore.firestore().collection("notifications").document(notificationId).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting document:",error)
                return
            }
            
            guard
                let documentSnapshot=documentSnapshot,
                let data=documentSnapshot.data(),
                var notification=try? Firestore.Decoder().decode(Notification.self,from:data)
                
            else{
                print ("Failed to retrieve notification or notification data")
                
                return
                
            }
            
            self.userBFullID = notification.toUserId
            
        }
        
     }
}
