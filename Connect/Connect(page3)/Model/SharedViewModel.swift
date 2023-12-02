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
    @Published var userANImageUrl: String = ""
    @Published var userBNImageUrl: String = ""
    @Published var buttonClickCount = 0
    @Published var tabSelection1 = 0
    @Published var tabSelection2 = 0
    @Published var tabSelection3 = 0
    @Published var tabSelection4 = 0
    @Published var isImageLoaded: Bool = false
    @Published var userANImageUrls: [String?] = [nil, nil, nil, nil]
    @Published var userBNImageUrls: [String?] = [nil, nil, nil, nil]
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
    
    @Published var userAIds: [String] = []
    
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
                            timestamp: data["timestamp"] as? Timestamp ?? Timestamp(),
                            likeCount: data["likeCount"] as? Int ?? 0) // 'likeCount'를 추가했습니다.
            
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
            guard self != nil else { return }
            
            if let error = error {
                print("Error getting document:", error)
                return
            }
            
            guard
                let documentSnapshot = documentSnapshot,
                let _ = documentSnapshot.data()
            else {
                print("Failed to retrieve notification or notification data")
                return
            }
        }
    }

    func userIdsMatchingCurrentUserId(currentUserId: String, completion: @escaping ([String]?, Error?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .whereField("userId", isEqualTo: currentUserId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(nil, error)
                    return
                }
                
                var matchingUserIds: [String] = []
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let userId = data["userId"] as? String {
                        matchingUserIds.append(userId)
                    }
                }
                
                completion(matchingUserIds, nil)
            }
    }
    
    @MainActor func getUserProfileImageUrl(userId: String) async throws -> String? {
        let userDocument = try await Firestore.firestore().collection("users").document(userId).getDocument()
        if let userData = userDocument.data(), let imageUrl = userData["profileImageURL"] as? String {
            return imageUrl
        } else {
            throw NSError(domain: "", code: -1, userInfo:[ NSLocalizedDescriptionKey:"No available profile image url for user \(userId)"])
        }
    }
    
    func loadUserProfileImage(userId: String) async {
        do {
            if let imageUrl = try await getUserProfileImageUrl(userId: userId) {
                self.userProfileImageUrl = imageUrl
            } else {
                print("프로필 이미지 URL이 없습니다.")
            }
        } catch {
            print("프로필 이미지 URL을 가져오는 중 오류 발생: \(error)")
        }
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
        
        guard let data = image.jpegData(compressionQuality: 1) else {
            print("Error converting image to data")
            return nil
        }
        
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("images/\(imageName).jpeg")
        
        do {
            print("Uploading image to Firebase Storage")
            
            _ = imageRef.putData(data)

            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
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
    
    @MainActor func loadImagesForToday(userId: String) async throws {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd"
        let dateString = dateFormatter.string(from: currentDate)
        
        let docRef = Firestore.firestore().collection("ConnectDB").document(dateString)
        let snapshot = try await docRef.getDocument()
        
        if snapshot.exists {
            if let data = snapshot.data(),
               let userData = data[userId] as? [String: Any] {
                for tagIndex in 1...4 {
                    if let tagData = userData["tag\(tagIndex)"] as? [String: Any],
                       let userANImageUrl = tagData["userANImageUrl"] as? String,
                       let userBNImageUrl = tagData["userBNImageUrl"] as? String {
                        self.userANImageUrls[tagIndex-1] = userANImageUrl
                        self.userBNImageUrls[tagIndex-1] = userBNImageUrl
                    }
                }
                await self.loadImageURLs()
                self.isImageLoaded = true
            } else {
                self.isImageLoaded = false
                throw NSError(domain: "", code: -1, userInfo:[ NSLocalizedDescriptionKey:"No available image for user \(userId)"])
            }
        } else {
            self.isImageLoaded = false
            throw NSError(domain: "", code: -1, userInfo:[ NSLocalizedDescriptionKey:"No available image for user \(userId)"])
        }
    }
    
    func getFetchedUserAId(from collectionName: String, on date: Date, for userId: String) async throws -> [String] {
        let db = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd"
        let documentId = dateFormatter.string(from: date)
        
        guard let document = try? await db.collection(collectionName).document(documentId).getDocument(),
              let data = document.data() else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get document"])
        }
        
        guard let userData = data[userId] as? [String: Any] else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data for user \(userId)"])
        }
        
        var userAIds: [String] = []
        
        for i in 1...4 {
            let tag = "tag\(i)"
            
            if let tagData = userData[tag] as? [String: Any],
               let userAId = tagData["userAId"] as? String {
                userAIds.append(userAId)
            }
        }
        
        return userAIds
    }
    
    @MainActor func loadImageURLs() async {
        for tagIndex in 1...4 {
            if let urlA = URL(string: self.userANImageUrls[tagIndex-1] ?? "") {
                do {
                    let dataA = try await self.fetchData(from: urlA)
                    if let _ = UIImage(data: dataA) {
                        self.fromUserProfileImageUrls[tagIndex-1] = self.userANImageUrls[tagIndex-1]
                    }
                } catch {
                    print("Failed to load image data: \(error)")
                }
            }
            if let urlB = URL(string: self.userBNImageUrls[tagIndex-1] ?? "") {
                do {
                    let dataB = try await self.fetchData(from: urlB)
                    if let _ = UIImage(data: dataB) {
                        self.fromUserProfileImageUrls[tagIndex-1] = self.userBNImageUrls[tagIndex-1]
                    }
                } catch {
                    print("Failed to load image data: \(error)")
                }
            }
        }
    }
    
    func fetchUserProfileImageUrl(userId: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting document:", error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let userData = documentSnapshot?.data(),
                  let profileImageUrl = userData["profileImageURL"] as? String else {
                print("Failed to load profileImageUrl for user \(userId)")
                completion(nil)
                return
            }
            
            completion(profileImageUrl)
        }
    }
    
    func loadUserProfileImageUrl(userId: String, userBId: String) async throws -> (String?, String?) {
        guard !userId.isEmpty else {
            print("UserId is empty")
            return (nil, nil)
        }
        
        let db = Firestore.firestore()
        
        let querySnapshotA = try await db.collection("DBUser").document(userId).getDocument()
        let querySnapshotB = try await db.collection("DBUser").document(userBId).getDocument()
        
        guard let documentDataA = querySnapshotA.data(),
              let documentDataB = querySnapshotB.data() else {
            print("No user found with userId: \(userId) or \(userBId)")
            return (nil, nil)
        }
        
        if let profileImageUrlA = documentDataA["profileImageURL"] as? String, let profileImageUrlB = documentDataB["profileImageURL"] as? String {
            return (profileImageUrlA, profileImageUrlB)
        } else {
            print("Failed to load profileImageUrl from user data")
            return (nil, nil)
        }
    }
    
    func fetchUserAId(from collectionName: String, on date: Date, for userId: String) async {
        do {
            let fetchedIds = try await getFetchedUserAId(from: collectionName, on: date, for: userId)
            DispatchQueue.main.async {
                self.userAIds = fetchedIds
            }
        } catch {
            print("Error fetching user A id:", error)
        }
    }
    
    @MainActor func increaseButtonClickCount(toUserId: String, fromUserId: String) async throws {
        print("fromUserId: \(fromUserId)")
        let db = Firestore.firestore()
        let documentRef = db.collection("Connect Numer").document(toUserId)

        let document = try await documentRef.getDocument()

        if let data = document.data(), let count = data["buttonClickCount"] as? Int {
            print("Increasing button click count for \(fromUserId)")
            try await documentRef.updateData(["buttonClickCount": count + 1, "fromUserId": fromUserId])
            print("Successfully increased button click count for \(fromUserId)")
            UserDefaults.standard.set(count + 1, forKey: "buttonClickCount")

            if let userCount = data[fromUserId] as? Int {
                try await documentRef.updateData([fromUserId: userCount + 1])
            } else {
                try await documentRef.setData([fromUserId: 1], merge: true)
            }
        } else {
            print("Setting button click count for \(fromUserId) to 1")
            try await documentRef.setData(["buttonClickCount": 1, "fromUserId": fromUserId], merge: true)
            print("Successfully set button click count for \(fromUserId) to 1")
            UserDefaults.standard.set(1, forKey: "buttonClickCount")

            try await documentRef.setData([fromUserId: 1], merge: true)
        }
    }

    @MainActor func getConnectNumer(userId: String) async throws -> [String: Int] {
        let db = Firestore.firestore()
        let documentRef = db.collection("Connect Numer").document(userId)

        let document = try await documentRef.getDocument()
        let data = document.data() as? [String: Int] ?? [:]

        return data
    }
    
    func getHighestTagNumber(date: String) async throws -> Int {
        let db = Firestore.firestore()
        let documentRef = db.collection("ConnectDB").document(date)
        let document = try await documentRef.getDocument()
        
        guard let data = document.data() else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not retrieve data"])
        }
        
        var highestTagNumber = 0
        for (_, userData) in data {
            if let userDataDict = userData as? [String: Any] {
                for key in userDataDict.keys {
                    if key.hasPrefix("tag") {
                        if let tagNumber = Int(key.dropFirst(3)), tagNumber > highestTagNumber {
                            highestTagNumber = tagNumber
                        }
                    }
                }
            }
        }
        
        if highestTagNumber == 0 {
            highestTagNumber = 1
        }
        return highestTagNumber
    }
}
