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
    
    @Published var notifications = [Notification]()
    
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
            
            guard let fromUserId = Auth.auth().currentUser?.uid else { // 버튼을 누른 사용자 ID
                print("No current user ID found")
                return
            }
            
            // Fetch the name of the user who sent the request.
            db.collection("users").document(fromUserId).getDocument { (userDocSnapshot, error) in
                if let error = error {
                    print("Error fetching user:", error.localizedDescription)
                    return
                }
                
                guard let userDocSnapshot = userDocSnapshot,
                      let userData = userDocSnapshot.data(),
                      let fromUserName = userData["fullid"] as? String,
                      let profileImageUrl = userData["profileImageURL"] as? String else {
                    print("Failed to load sender's info")
                    return
                }
                
                print("Loaded sender's info: fullid=\(fromUserName), profileImageUrl=\(profileImageUrl)")  // Log loaded sender's info.
                
                guard let toFullId = data["fullid"] as? String else {
                    print("Failed to load recipient's fullid")
                    return
                }
                
                // Notification 객체 생성 후 사전 변환
                var notificationObject = Notification(id: UUID().uuidString,
                                                      fromUserId: fromUserId,
                                                      fromUserName: fromUserName,
                                                      fromUserProfileImageUrl: profileImageUrl)
                
                var notificationDict: [String: Any] = [:]
                notificationDict["from"] = notificationObject.fromUserId
                notificationDict["fromUserName"] = notificationObject.fromUserName
                
                // 'to' 필드에는 게시물 작성자의 fullid를 사용합니다.
                notificationDict["to"]     = toFullId
                
                notificationDict["fromUserProfileImageUrl"] = notificationObject.fromUserProfileImageUrl
                
                db.collection("notifications").document(notificationObject.id).setData(notificationDict) {
                    error in
                    
                    if error != nil {
                        
                        print(error!.localizedDescription)
                        
                    } else {
                        
                        print("Notification sent successfully!")
                        
                    }
                    
                }
            }
        }
    }
    
    
    func loadNotifications() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No current user ID found") // Add log message here
            return
        }
        
        print("Current user ID: \(currentUserId)")  // Log the current user's ID
        
        // Fetch the user document from Firestore
        let db = Firestore.firestore()
        
        db.collection("users").document(currentUserId).getDocument { (userDocSnapshot, error) in
            if let error = error {
                print("Error loading user document: \(error.localizedDescription)")
                return
            }
            
            guard let userData = userDocSnapshot?.data(),
                  let currentUserFullId = userData["fullid"] as? String else {
                print("Failed to load fullid for current user")
                return
            }
            
            print("Loaded fullid for current user: \(currentUserFullId)")
            
            db.collection("notifications").whereField("to", isEqualTo: currentUserFullId).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error loading notifications: \(error.localizedDescription)")
                    return
                }
                
                guard let querySnapshot = querySnapshot else {
                    print("No QuerySnapshot returned from listener")
                    return
                }
                
                self.notifications.removeAll()
                
                var addedUserIds: [String] = []  // Keep track of added userIds
                
                for document in querySnapshot.documents {
                    print(document.data())  // Print all fetched documents data
                    
                    if document.exists,
                       let fromUserId = document.data()["from"] as? String,
                       let fromUserName = document.data()["fromUserName"] as? String,
                       let fromUserProfileImageUrl = document.data()["fromUserProfileImageUrl"] as? String {  // Fetch the profile image url
                        
                        print("Loaded notification from user ID: \(fromUserId)")  // Log each loaded notification
                        
                        // Check if this userId has already been added.
                        if !addedUserIds.contains(fromUserId) {
                            self.notifications.append(Notification(id: document.documentID,
                                                                   fromUserId: fromUserId,
                                                                   fromUserName: fromUserName,
                                                                   fromUserProfileImageUrl: fromUserProfileImageUrl))  // Include the profile image url here
                            
                            addedUserIds.append(fromUserId)
                            
                            print("\(document.documentID) notification successfully loaded and appended to notifications array")  // Log successful operation
                            
                        } else {
                            print("\(document.documentID) notification is duplicate and not appended to notifications array")  // Log duplicate detection
                            
                        }
                        
                    } else {
                        print("Failed to load notification or missing fields in document data for id \(document.documentID): \(document.data())")  // Log failed notifications with more details
                        
                    }
                    
                }
                
                if self.notifications.isEmpty{
                    print ("No matching notifications found for current user")
                }else{
                    for item in self.notifications{
                        print ("Notification object - Id:\(item.id), From User Id:\(item.fromUserId), From User Name:\(item.fromUserName)")
                    }
                }
                
            }
        }
    }
}
