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
import FirebaseStorage

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
    
    
    
    @MainActor func loadPosts(for user: String, tab: Int) async throws -> [Post] {
        let userFullID = (user == "A") ? self.userAFullID : self.userBFullID
        var posts = [Post]()
        
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
        
        if posts.isEmpty {
            throw NSError(domain: "", code: -1, userInfo:[ NSLocalizedDescriptionKey:"No available post for user \(user)"])
        }
        
        return posts
    }
    
    @MainActor func loadPostForUsers(_ users: [String], tab: Int) async {
        for user in users {
            do {
                let posts = try await loadPosts(for: user, tab: tab)
                
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
            } catch {
                print("Error loading post for user \(user): \(error)")
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
    
    @MainActor func uploadImageToFirebaseStorage(image: UIImage, imageName: String) async -> String? {
        let storage = Storage.storage()
        let storageRef = storage.reference()

        guard let data = image.jpegData(compressionQuality: 0.5) else {
            print("Error converting image to data")
            return nil
        }

        // Unique file name
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("images/\(imageName).jpeg")

        do {
            print("Uploading image to Firebase Storage")
            
            _ = try await imageRef.putData(data)
            
            // Delay for 2 seconds to give Firebase some time to generate the download URL after the upload completes.
            await Task.sleep(2 * 1_000_000_000)

            // Get download URL
            guard let downloadURL = try? await imageRef.downloadURL() else {
                throw NSError(domain: "", code: -1, userInfo:[ NSLocalizedDescriptionKey:"Failed getting download URL from \(imageRef.fullPath)"])
            }

            print("Image uploaded successfully. Download URL: \(downloadURL)")
            
            return downloadURL.absoluteString

        } catch {
          print("Error uploading file to Firebase Storage with path \(imageRef.fullPath): \(error)")
          return nil
       }
    }

    func fetchData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
