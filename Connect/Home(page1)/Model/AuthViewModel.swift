//
//  AuthViewModel.swift
//  Connect
//
//  Created by Daol on 2023/09/02.
//

import Foundation
import PhotosUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import _PhotosUI_SwiftUI
import FirebaseStorage  

@MainActor
final class AuthViewModel: ObservableObject {
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    @Published var currentUser: DBUser?
    
    @Published var loginState: LoginState
    
    @Published var user: DBUser?
    
    private var profileImageURL: String?
    
    public var uid: String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    init() {
        loginState = Auth.auth().currentUser != nil ? .loggedIn : .loggedOut
        addAuthListener()
    }
    
    func addAuthListener() {
        if authStateDidChangeListenerHandle == nil {
            authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { (auth, firebaseUser) in
                if let firebaseUser = firebaseUser {
                    self.currentUser = DBUser(email: firebaseUser.email ?? "", userId:"", hastags:"", uid:firebaseUser.uid, friends: [])

                    Task {
                        do {
                            try await self.fetchUser()
                        } catch {
                            print("Error fetching user: \(error)")
                        }
                    }
                } else {
                    self.currentUser = nil
                }
            }
        }
    }
    
    func removeAuthListener() {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
            authStateDidChangeListenerHandle = nil
        }
    }
    
    func updateUserProfileImageURL(_ url: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user"])
        }

        let db = Firestore.firestore()
        try await db.collection("users").document(uid).updateData([
            "profileImageURL": url
        ])
    }

    func registerUser(userId: String, withEmail email: String, password: String, hastags: String)
    async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = DBUser(email: email, userId: userId, hastags: hastags, uid: result.user.uid, friends: [])
        try await storeUser(with:user)
        loginState = .loggedIn
    }
    
    func signInUser(withEmail email:String,password:String) async throws{
        try await Auth.auth().signIn(withEmail :email,password :password)
        loginState = .loggedIn
    }
    
    func signOutUser() throws{
        try Auth.auth().signOut()
        self.user = nil
        loginState = .loggedOut
    }
    
    func fetchUser() async throws{
        guard let user = try? await Firestore.firestore().collection("users").document(uid).getDocument(as: DBUser.self) else {
            return
        }
        self.user = user
    }
    
    func saveProfileImage(_ image: UIImage) async throws -> String {
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw NSError(domain: "Failed to convert image to data", code: -1, userInfo: nil)
        }
        
        let storageRef = Storage.storage().reference()
        let filename = UUID().uuidString + ".jpg"
        let fileRef = storageRef.child("profile_images/\(filename)")
        
        _ = try await fileRef.putDataAsync(data, metadata: nil)
        
        do {
            let url = try await fileRef.downloadURL()
            let urlStr = url.absoluteString
            
            try await Firestore.firestore().collection("users").document(uid).updateData(["profileImageURL": urlStr])

            return urlStr
        } catch {
            throw NSError(domain: "Failed to get download URL", code: -1, userInfo: nil)
         }
    }

    func saveImage(_ image: UIImage, userId: String, captureTime: Date) {
        let storage = Storage.storage()
        let storageRef = storage.reference()

        guard let imageData = image.jpegData(compressionQuality: 1) else {
            print("Could not convert image to Data")
            return
        }

        let imageName = UUID().uuidString

        let imagesRef = storageRef.child("images/\(imageName).jpg")

        imagesRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print("Error uploading image")
                return
            }

            imagesRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error getting download URL")
                    return
                }

                let post = Post(userId: userId,
                                imageUrl: downloadURL.absoluteString,
                                timestamp: Timestamp(date: captureTime),
                                likeCount: 0)

                let db = Firestore.firestore()

                db.collection("posts").addDocument(data:
                    post.asDictionary()) { err in

                        if let err = err {
                            print("Error writing document \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
            }
         }
    }
    
    func saveAndStoreImage(_ image: UIImage) async throws -> String {
        let urlStr = try await saveProfileImage(image)
        
        saveImage(image, userId: uid, captureTime: Date())
        
        if user?.uploadedImagesURLs == nil {
            user?.uploadedImagesURLs = [urlStr]
        } else {
            user?.uploadedImagesURLs?.append(urlStr)
        }
        
        try await Firestore.firestore().collection("users").document(uid).updateData(["uploadedImagesURLs": FieldValue.arrayUnion([urlStr])])
        return urlStr
    }
    
    func loadProfileImageData(_ uid: String, completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()

        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching user document:", error.localizedDescription)
                return
            }

            guard let document = querySnapshot?.documents.first else {
                print("No documents found for user \(uid)")
                return
            }

            let userData = document.data()

            if userData.isEmpty {
                print("User document data is nil for user \(uid)")
                return
            }

            guard let profileImageUrl = userData["profileImageURL"] as? String else {
                print("No profile image URL found for user \(uid), full data: \(userData)")
                return
            }

            DispatchQueue.main.async {
                completion(profileImageUrl)
            }
        }
    }
    
    func deleteUser() async throws {
        let user = Auth.auth().currentUser
        do {
            try await user?.delete()
            print("User deleted")
        } catch let error {
            print("Error deleting user: \(error)")
        }
    }
}

extension AuthViewModel {
    // MARK: - Helper
        private func storeUser(with user: DBUser) async throws {
        let encodedUser = try Firestore.Encoder().encode(user)
        try await Firestore.firestore().collection("users").document(uid).setData(encodedUser)
    }
}

