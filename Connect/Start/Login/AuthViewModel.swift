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

// 메인 액터 어노테이션을 사용하여 클래스가 메인 스레드에서 실행되도록 합니다.
@MainActor
final class AuthViewModel: ObservableObject {
    // 로그인 상태를 나타내는 Published 프로퍼티입니다. 이 프로퍼티의 값이 변경될 때마다 SwiftUI 뷰는 자동으로 업데이트됩니다.
    @Published var loginState: LoginState
    
    // 현재 로그인한 사용자 정보를 저장하는 Published 프로퍼티입니다.
    @Published var user: User?
    
    // 사용자의 프로필 이미지 URL을 저장하는 private 프로퍼티입니다.
    private var profileImageURL: String?
    
    // 현재 로그인한 사용자의 UID를 가져오는 computed property입니다. 만약 로그인한 사용자가 없다면 빈 문자열을 반환합니다.
    private var uid: String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    // 생성자에서는 현재 로그인 상태를 확인하여 loginState 변수에 할당합니다.
    init() {
        loginState = Auth.auth().currentUser != nil ? .loggedIn : .loggedOut
    }
    
    // 새로운 사용자를 등록하는 함수입니다. 입력받은 정보와 함께 Firebase Authentication에 요청을 보냅니다.
    func registerUser(fullid: String, withEmail email: String, password: String, hastag1: String, hastag2: String,  hastag3: String, hastag4: String)
    async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = User(email: email, fullid: fullid, hastag1: hastag1, hastag2: hastag2, hastag3: hastag3, hastag4: hastag4, uid: result.user.uid)
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
        self.user=user
    }
    
    // 사용자의 프로필 이미지를 저장하는 함수입니다.
    func saveProfileImage(item: PhotosPickerItem) async throws -> String{
        guard let data = try await item.loadTransferable(type: Data.self) else { return ""}
        let (path, _) = try await StorageManager.shared.saveImage(data: data)
        profileImageURL = path
        return path
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
