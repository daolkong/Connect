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
import FirebaseStorage  // Add this line at the top of the file.

// 메인 액터 어노테이션을 사용하여 클래스가 메인 스레드에서 실행되도록 합니다.
@MainActor
final class AuthViewModel: ObservableObject {
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    
    @Published var currentUser: User? // add this line
    
    // 로그인 상태를 나타내는 Published 프로퍼티입니다. 이 프로퍼티의 값이 변경될 때마다 SwiftUI 뷰는 자동으로 업데이트됩니다.
    @Published var loginState: LoginState
    
    
    // 현재 로그인한 사용자 정보를 저장하는 Published 프로퍼티입니다.
    @Published var user: User?
    
    // 사용자의 프로필 이미지 URL을 저장하는 private 프로퍼티입니다.
    private var profileImageURL: String?
    
    // 현재 로그인한 사용자의 UID를 가져오는 computed property입니다. 만약 로그인한 사용자가 없다면 빈 문자열을 반환합니다.
    public var uid: String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    // 생성자에서는 현재 로그인 상태를 확인하여 loginState 변수에 할당합니다.
    
    init() {
        loginState = Auth.auth().currentUser != nil ? .loggedIn : .loggedOut
        addAuthListener()
    }
    
    
    func addAuthListener() {
        if authStateDidChangeListenerHandle == nil {
            authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { (auth, firebaseUser) in
                if let firebaseUser = firebaseUser {
                    // Here we create a new user with the info from the FirebaseAuth user
                    self.currentUser = User(email: firebaseUser.email ?? "", userId:"", hastags:"", uid:firebaseUser.uid, friends: [])

                    // Fetch user information immediately after setting currentUser.
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
    
    
    
    // 새로운 사용자를 등록하는 함수입니다. 입력받은 정보와 함께 Firebase Authentication에 요청을 보냅니다.
    func registerUser(userId: String, withEmail email: String, password: String, hastags: String)
    async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = User(email: email, userId: userId, hastags: hastags, uid: result.user.uid, friends: [])
        try await storeUser(with:user)
        loginState = .loggedIn  // 성공적으로 등록하면 로그인 상태로 전환합니다.
    }
    
    
    // 이메일과 비밀번호를 이용해 기존 유저를 로그인 시키는 함수입니다.
    func signInUser(withEmail email:String,password:String) async throws{
        try await Auth.auth().signIn(withEmail :email,password :password)
        loginState = .loggedIn  // 성공적으로 등록하면 로그인 상태로 전환합니다.
    }
    
    func signOutUser() throws{
        try Auth.auth().signOut()
        self.user = nil
        loginState = .loggedOut // 성공적으로 로그아웃하면 로그아웃 상태로 전환합니다.
    }
    
    // Firestore에서 현재 사용자의 정보를 가져오는 함수입니다.
    func fetchUser() async throws{
        guard let user = try? await Firestore.firestore().collection("users").document(uid).getDocument(as: User.self) else {
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
        
        // 직접 URL을 가져오기
        do {
            let url = try await fileRef.downloadURL()
            let urlStr = url.absoluteString
            
            try await Firestore.firestore().collection("users").document(uid).updateData(["profileImageURL": urlStr])

            return urlStr
        } catch {
            throw NSError(domain: "Failed to get download URL", code: -1, userInfo: nil)
         }
    }

    // 이미지를 저장하고 이미지와 관련된 정보를 Firestore에 함께 저장
    func saveImage(_ image: UIImage, userId: String, captureTime: Date) {
        let storage = Storage.storage()
        let storageRef = storage.reference()

        // Convert the image to Data
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            print("Could not convert image to Data")
            return
        }

        // Create a unique identifier for the image
        let imageName = UUID().uuidString

        // Create a reference to the file you want to upload
        let imagesRef = storageRef.child("images/\(imageName).jpg")

        // Upload the file to the path "images/[imageName].jpg"
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

                var post = Post(userId: userId,
                                imageUrl: downloadURL.absoluteString,
                                timestamp: Timestamp(date: captureTime))

                // Get a reference to Firestore Database
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
        // Save the image and get its URL.
        let urlStr = try await saveProfileImage(image)
        
        // Save the image to Firebase Storage and store its info in Firestore.
        saveImage(image, userId: uid, captureTime: Date())
        
        // Update the user object in memory.
        if user?.uploadedImagesURLs == nil {
            user?.uploadedImagesURLs = [urlStr]  // If it's nil, initialize it with the new URL.
        } else {
            user?.uploadedImagesURLs?.append(urlStr)  // If it's not nil, append the new URL.
        }
        
        // Update the user object in Firestore database.
        try await Firestore.firestore().collection("users").document(uid).updateData(["uploadedImagesURLs": FieldValue.arrayUnion([urlStr])])
        
        return urlStr
    }
    
    
}

extension AuthViewModel {
    // MARK: - Helper
    
    // Firestore에 사용자 정보를 저장하는 private helper 함수입니다.
    private func storeUser(with user: User) async throws {
        let encodedUser = try Firestore.Encoder().encode(user)
        try await Firestore.firestore().collection("users").document(uid).setData(encodedUser)
    }
}

