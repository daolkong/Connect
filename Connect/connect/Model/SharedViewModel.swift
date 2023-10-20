//
//  SharedViewModel.swift
//  Connect
//
//  Created by Daol on 10/10/23.
//
import SwiftUI
import Combine
import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class SharedViewModel: ObservableObject {
    @Published var userAFullID: String = ""
    @Published var userBFullID: String = ""
    @Published var buttonClickCount = 0
    
    @Published var tabSelection1 = 0
    @Published var tabSelection2 = 0
    @Published var tabSelection3 = 0
    @Published var tabSelection4 = 0
    
    @Published var postsA1: [Post] = []
    @Published var postsA2: [Post] = []
    @Published var postsA3: [Post] = []
    @Published var postsA4: [Post] = []
    @Published var postsB1: [Post] = []
    @Published var postsB2: [Post] = []
    @Published var postsB3: [Post] = []
    @Published var postsB4: [Post] = []
    
    @Published var userProfileImageUrl: String = ""
    
    @Published var fromUserProfileImageUrls: [String?] = [nil, nil, nil, nil]
    @Published var currentUserProfileImageUrl: String?
    
    @Published var connectModel = ConnectModel(selectedTab1: 1, selectedTab2: 1, selectedTab3: 1, selectedTab4: 1,
                                               postA1ID: nil, postB1ID: nil,
                                               postA2ID: nil, postB2ID: nil,
                                               postA3ID: nil, postB3ID: nil,
                                               postA4ID: nil, postB4ID:nil)
    
    
    @MainActor func loadPosts(for user: String, tab: Int) async -> [Post] {
        let userFullID = (user == "A") ? self.userAFullID : self.userBFullID
        var posts = [Post]()
        
        do {
            let querySnapshot = try await Firestore.firestore().collection("posts").whereField("userId", isEqualTo: userFullID).order(by:"timestamp", descending:true).limit(to: 1).getDocuments()
            
            for (index, document) in querySnapshot.documents.enumerated() {
                let data = document.data()
                let id = document.documentID
                
                var post = Post(id: id,
                                userId: data["userId"] as? String ?? "",
                                imageUrl: data["imageUrl"] as? String ?? "",
                                timestamp: data["timestamp"] as? Timestamp ?? Timestamp())
                
                post.tag = "\(user)_\(tab)_\(id)_\(index)"
                
                posts.append(post)
            }
            
            
        } catch {
            print("Error getting documents: \(error)")
        }
        
        return posts
    }
    
    @MainActor func loadPostForUsers(_ users: [String], tab: Int) async {
        for user in users {
            let posts = await loadPosts(for: user, tab: tab)
            
            switch tab {
            case 1:
                if user == "A" {
                    self.postsA1 = posts
                } else {
                    self.postsB1 = posts
                }
            case 2:
                if user == "A" {
                    self.postsA2 = posts
                } else {
                    self.postsB2 = posts
                }
            case 3:
                if user == "A" {
                    self.postsA3 = posts
                } else {
                    self.postsB3 = posts
                }
            case 4:
                if user == "A" {
                    self.postsA4 = posts
                } else {
                    self.postsB4 = posts
                }
            default:
                break
            }
        }
    }
    // Add this function to update the userBFullID when a new notification is received.
    func updateToUserInNotification(notificationId: String) {
        Firestore.firestore().collection("notifications").document(notificationId).getDocument { [weak self] (documentSnapshot, error) in
            guard let `self` = self else { return }
            
            if let error = error {
                print("Error getting document:", error)
                return
            }
            
            guard
                let documentSnapshot = documentSnapshot,
                let data = documentSnapshot.data(),
                var notification = try? Firestore.Decoder().decode(Notification.self, from: data)
            else {
                print("Failed to retrieve notification or notification data")
                return
            }
        }
    }
    
    @MainActor func handleButtonClick(notification: Notification) async {
        if buttonClickCount < 4 {
            buttonClickCount += 1
            
            userAFullID = notification.fromUserId
            userBFullID = notification.toUserId
            
            await loadPostForUsers(["A", "B"], tab : buttonClickCount)
            
            switch buttonClickCount {
            case 1:
                self.tabSelection1 = buttonClickCount
                
                if let postIdA = self.postsA1.first?.id, let postIdB = self.postsB1.first?.id {
                    connectModel.postA1ID = postIdA
                    connectModel.postB1ID = postIdB
                }
                
            case 2:
                self.tabSelection2 = buttonClickCount
                
                if let postIdA = self.postsA2.first?.id, let postIdB = self.postsB2.first?.id {
                    connectModel.postA2ID = postIdA
                    connectModel.postB2ID = postIdB
                }
            case 3:
                self.tabSelection3 = buttonClickCount
                
                if let postIdA = self.postsA3.first?.id, let postIdB = self.postsB3.first?.id {
                    connectModel.postA3ID = postIdA
                    connectModel.postB3ID = postIdB
                }
            case 4:
                self.tabSelection2 = buttonClickCount
                
                if let postIdA = self.postsA4.first?.id, let postIdB = self.postsB4.first?.id {
                    connectModel.postA4ID = postIdA
                    connectModel.postB4ID = postIdB
                }
                
            default:
                break
            }
            
            await saveButtonClickCounts()
            await saveUserSelection()
            
        } else {
            print("Button has been clicked maximum number of times today.")
        }
    }
    
    @MainActor func saveButtonClickCounts() async {
        let userId = Auth.auth().currentUser?.uid ?? ""
        do {
            try await Firestore.firestore().collection("users").document(userId).setData([
                "buttonClickCount": self.buttonClickCount,
                "lastClickedDate": Date(),
                "tabSelection1": self.tabSelection1, // Save current selections in Firestore
                "tabSelection2": self.tabSelection2,
                "tabSelection3": self.tabSelection3,
                "tabSelecton4": self.tabSelection4,
            ], merge: true)
        } catch {
            print("Error saving button click count: \(error)")
        }
    }
    
    @MainActor func loadButtonClickCount() async {
        let userId = Auth.auth().currentUser?.uid ?? ""
        do {
            let userDocument = try await Firestore.firestore().collection("users").document(userId).getDocument()
            if let userData = userDocument.data() {
                if Calendar.current.isDateInToday(userData["lastClickedDate"] as? Date ?? Date()) {
                    for i in 1...4 {
                        
                        let keyForButtonClicks = "buttonClickCount\(i)"
                        let keyForTabSelections = "tabSelection\(i)"
                        
                        if userData[keyForButtonClicks] != nil && userData[keyForTabSelections] != nil {
                            
                            switch i{
                            case 1:
                                self.buttonClickCount = userData[keyForButtonClicks] as? Int ?? 0
                                self.tabSelection1 = userData[keyForTabSelections] as? Int ?? i
                                
                                if (self.buttonClickCount > 0 && self.buttonClickCount <= 4) {
                                    await loadPostForUsers(["A", "B"], tab: self.tabSelection1)
                                }
                            case 2:
                                self.buttonClickCount = userData[keyForButtonClicks] as? Int ?? 0
                                self.tabSelection2 = userData[keyForTabSelections] as? Int ?? i
                                
                                if (self.buttonClickCount > 0 && self.buttonClickCount <= 4) {
                                    await loadPostForUsers(["A", "B"], tab: self.tabSelection2)
                                }
                            case 3:
                                self.buttonClickCount = userData[keyForButtonClicks] as? Int ?? 0
                                self.tabSelection3 = userData[keyForTabSelections] as? Int ?? i
                                
                                if (self.buttonClickCount > 0 && self.buttonClickCount <= 4) {
                                    await loadPostForUsers(["A", "B"], tab: self.tabSelection3)
                                }
                            case 4:
                                self.buttonClickCount = userData[keyForButtonClicks] as? Int ?? 0
                                self.tabSelection4 = userData[keyForTabSelections] as? Int ?? i
                                
                                if (self.buttonClickCount > 0 && self.buttonClickCount <= 4) {
                                    await loadPostForUsers(["A", "B"], tab: self.tabSelection4)
                                }
                            default:
                                break
                            }
                        }
                    }
                } else {
                    self.buttonClickCount = 0
                }
                
            }
            
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
    @MainActor func saveUserSelection() async {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await Firestore.firestore().collection("userSelections").document(userID).setData(from :connectModel)
        } catch {
            print("Failed to save user selection:", error)
        }
    }
    
    func loadUserSelect() async {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        do {
            let documentSnapshot = try await Firestore.firestore().collection("userSelections").document(userID).getDocument()
            
            
            if let data = documentSnapshot.data(),
               var connectModel = try? Firestore.Decoder().decode(ConnectModel.self, from: data) {
                
                
                // Here you update the tab selections based on the loaded data.
                DispatchQueue.main.async {
                    self.tabSelection1 = connectModel.selectedTab1
                    self.tabSelection2 = connectModel.selectedTab2
                    self.tabSelection3 = connectModel.selectedTab3
                    self.tabSelection4 = connectModel.selectedTab4
                }
                
            } else {
                DispatchQueue.main.async {
                    self.tabSelection1 = 0
                }
            }
            
        } catch {
            print("Failed to load user selection:", error)
        }
    }
    
    @MainActor func getUserProfileImageUrl(userId: String) async -> String {
        var imageUrl = ""
        
        do {
            let userDocument = try await Firestore.firestore().collection("users").document(userId).getDocument()
            if let userData = userDocument.data() {
                imageUrl = userData["profileImageUrl"] as? String ?? ""
            }
        } catch {
            print("Error getting user profile image url: \(error)")
        }
        
        return imageUrl
    }
    
    func loadUserProfileImage(userId: String) async {
        self.userProfileImageUrl = await getUserProfileImageUrl(userId: userId)
    }
    
    func loadCurrentUserProfileImage() async {
          guard let userId = Auth.auth().currentUser?.uid else { return }
          
          do {
              let docSnapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
              if let docData = docSnapshot.data(),
                 let imageUrlString = docData["profileImageURL"] as? String {
                  DispatchQueue.main.async { self.currentUserProfileImageUrl = imageUrlString }
              }
          } catch {
              print("Failed to fetch user document:", error)
          }
      }
    
    private let db = Firestore.firestore()

    func saveTabState() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await db.collection("users").document(userId).setData([
                "tabSelection1": tabSelection1,
                "tabSelection2": tabSelection2,
                "tabSelection3": tabSelection3,
                "tabSelection4": tabSelection4
            ], merge: true)
        } catch {
            print("Failed to save user's tab state: \(error)")
        }
    }
    
    func loadTabState() {
        let docRef = Firestore.firestore().collection("your_collection").document("your_document")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.tabSelection1 = document.get("selectedTab1") as? Int ?? 0
                self.tabSelection2 = document.get("selectedTab2") as? Int ?? 0
                self.tabSelection3 = document.get("selectedTab3") as? Int ?? 0
                self.tabSelection4 = document.get("selectedTab4") as? Int ?? 0
            } else {
                print("Document does not exist")
            }
        }
    }
}

