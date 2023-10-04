//
//  NotificationViewModel.swift
//  Connect
//
//  Created by Daol on 10/4/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class NotificationViewModel: ObservableObject {
    
    @Published var notifications: [Notification] = []
    
    func sendRequest(imageId: String) {
        let db = Firestore.firestore()
        
        print("sendRequest called with imageId: \(imageId)") // 로그 메시지 추가
        
        db.collection("posts").document(imageId).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            guard let documentSnapshot = documentSnapshot else {
                print("Failed to retrieve document")
                return
            }
            
            guard let data = documentSnapshot.data() else {
                print("Document data is empty")
                return
            }
            
            if let fromUserId = Auth.auth().currentUser?.uid { // 버튼을 누른 사용자 ID
                
                // Fetch the name of the user who sent the request.
                db.collection("users").document(fromUserId).getDocument { (userDocSnapshot, error) in
                    if let userDocSnapshot = userDocSnapshot,
                       let userData = userDocSnapshot.data(),
                       let fromUserName = userData["fullid"] as? String {
                        
                        if let toUserId = data["fullid"] as? String { // Use 'fullid' instead of 'userId'
                            
                            // Notification 객체 생성 후 사전 변환
                            var notificationObject = Notification(id: UUID().uuidString,
                                                                  fromUserId: fromUserId,
                                                                  fromUserName: fromUserName)
                            
                            var notificationDict:[String:Any] = [:]
                            notificationDict["from"]  = notificationObject.fromUserId
                            
                            // Add the sender's name to the dictionary.
                            notificationDict["fromUserName"]  = notificationObject.fromUserName
                            
                            // Add recipient's userId to the dictionary.
                            notificationDict["to"]  = toUserId
                            
                            db.collection("notifications").document(notificationObject.id).setData(notificationDict){ error in
                                
                                if error != nil {
                                    print(error!.localizedDescription)
                                } else {
                                    print("Notification sent successfully!")
                                }
                                
                            }
                        }
                    } else if let error = error{
                        print("Error fetching user:", error.localizedDescription)
                    }
                    
                }
                
            }
            else if let error = error{
                print("Error fetching post:", error.localizedDescription)
            }
            
        }
        
    }
    
    func loadNotifications() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        // Fetch the user document from Firestore
        let db = Firestore.firestore()
        db.collection("users").document(currentUserId).getDocument { (documentSnapshot, error) in
            if let documentSnapshot = documentSnapshot,
               let data = documentSnapshot.data(),
               let currentUserFullName = data["fullid"] as? String {
                
                // Now we have the full name of the current user.
                // We can use it to filter notifications.
                db.collection("notifications").whereField("to", isEqualTo: currentUserFullName).addSnapshotListener{ (querySnapShot,error) in
                    
                    if let error = error {
                        print("Error loading notifications: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let querySnapShot = querySnapShot else{
                        print("No QuerySnapshot returned from listener")
                        return
                    }
                    
                    self.notifications.removeAll()
                    
                    var addedUserIds: [String] = []  // Keep track of added userIds
                    
                    for document in querySnapShot.documents{
                        if document.exists ,
                           let fromUserId = document.data()["from"] as? String ,
                           let fromUserName = document.data()["fromUserName"] as? String {
                            
                            // Check if this userId has already been added.
                            if !addedUserIds.contains(fromUserId) {
                                self.notifications.append(Notification(id:document.documentID , fromUserId:fromUserId, fromUserName:fromUserName))
                                addedUserIds.append(fromUserId)
                            }
                            
                        }
                    }
                }
                
            } else if let error = error {
                print("Error fetching user:", error.localizedDescription)
            }
        }
    }
}
