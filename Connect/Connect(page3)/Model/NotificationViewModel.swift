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
    @Published var latestPostImageUrl: String?
    
    
    func sendRequest(imageId: String) {
        let db = Firestore.firestore()
        
        guard let currentUser = Auth.auth().currentUser else {
            print("No current user found")
            return
        }
        
        let fromUserId = currentUser.uid
        
        print("sendRequest called with imageId: \(imageId)") // 로그 메시지 추가
        
        db.collection("posts").document(imageId).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            guard
                let documentSnapshot=documentSnapshot,
                let data=documentSnapshot.data(),
                let post = try? Firestore.Decoder().decode(Post.self,from:data)
                    
            else {
                print ("Failed to retrieve post or post data")
                return
                
            }
            
            // Fetch user information for the notification.
            db.collection("users").document(fromUserId).getDocument { (userDocSnapshot,error) in
                if error != nil{
                    print ("Error loading user document:",error?.localizedDescription ?? "")
                    return
                }
                
                guard let userData=userDocSnapshot?.data(),
                        let currentUserId=userData["userId"] as? String else {
                      print ("Failed to load userId for current user")
                      return
                  }
                
                let fromUserId = currentUserId
                
                guard
                    let userData=userDocSnapshot?.data(),
                    let userProfileImageURL=userData["profileImageURL"] as? String
                        
                else{
                    print ("Failed to load profileImageUrl for current user")
                    return
                    
                }
                
                self.loadLatestPostImage(fromUserId: fromUserId) { latestPostImageUrl in
                    DispatchQueue.main.async {
                        // If the user has no posts yet, do not proceed with creating a notification.
                        if latestPostImageUrl == nil {
                            print("DBUser has no posts yet. Notification will not be created.")
                            return
                        }
                        
                        let newNotification =
                        Notification(
                            id : UUID().uuidString,
                            fromUserId : fromUserId,
                            toUserId : post.userId,
                            fromUserProfileImageUrl :
                                (userProfileImageURL.isEmpty ? nil :
                                    userProfileImageURL),
                            latestPostImageUrl : latestPostImageUrl,
                            time: Date())
                        
                        self.notifications.append(newNotification)
                        
                        // Save notification to Firestore.
                        do {
                            _=try db.collection ("notifications").addDocument(from:newNotification)
                            print ("Notification saved successfully!")
                            
                        } catch{
                            print ("Error saving notification:",error.localizedDescription)
                            
                        }
                    }
                }
            }
        }
    }

    func loadNotifications() async {
        guard let currentUser = Auth.auth().currentUser else {
            print ("No current user found")
            return
        }
        
        do {
            let userData = try await Firestore.firestore().collection("users").document(currentUser.uid).getDocument()
            guard let currentUserName = userData.get("userId") as? String else {
                print("Failed to load userId for current user")
                return
            }
            
            print("Current userId: \(currentUserName)")
            
            let snapshot = try await Firestore.firestore().collection("notifications")
                .whereField("to", isEqualTo: currentUserName)
                .order(by: "time", descending: true)
                .getDocuments()
            
            print("\(snapshot.documents.count) notifications loaded for user \(currentUserName)")
            
            let newNotifications = snapshot.documents.compactMap { document in
                try? document.data(as: Notification.self)
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.notifications = newNotifications
                
                if self?.notifications.isEmpty == true {
                    print("No matching notifications found for current user")
                } else {
                    for item in self?.notifications ?? [] {
                        print("Notification object - Id: \(item.id), From User Id: \(item.fromUserId)")
                    }
                }
            }
        } catch {
            print("Error loading notifications:", error)
        }
    }

    func addPost(imageUrl: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No current user found")
            return
        }
        
        let userId = currentUser.uid
        
        let db = Firestore.firestore()
        
        let likeCount = 0  // Add this line.
        let post = Post(id: nil, userId: userId, imageUrl: imageUrl, timestamp: Timestamp(date: Date()), likeCount: likeCount)
        
        do {
            _ = try db.collection("posts").addDocument(from: post)
            print("Post saved successfully!")
            
        } catch {
            print("Error saving post:", error.localizedDescription)
        }
    }
    
    private func loadLatestPostImage(fromUserId: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("posts")
            .whereField("userId", isEqualTo: fromUserId)
            .order(by: "timestamp", descending: true)
            .limit(to: 1)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents:", error.localizedDescription)
                    return
                }
                
                guard let document = querySnapshot?.documents.first else {
                    print("No posts found for user \(fromUserId)")
                    
                    // Return a default image URL or an empty string.
                    completion("")
                    
                    return
                }
                
                guard let postImageUrl = document.data()["imageUrl"] as? String else {
                    print("Failed to load imageUrl from post data")
                    
                    // Return a default image URL or an empty string.
                    completion("")
                    
                    return
                }
                
                print("Loaded image URL:", postImageUrl)  // Print the loaded image URL
                
                completion(postImageUrl)
            }
    }
}
