//
//  UserService.swift
//  Connect
//
//  Created by Daol on 10/22/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

final class UserService {
    @Published var currentUser: DBUser?
    
    static let shared = UserService()
    private init() {
        Task { try await fetchCurrentUser() }
    }
    
    private let userCollection = Firestore.firestore().collection("users")
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.id).setData(from: user, merge: false)
        self.currentUser = user
    }
    
    func fetchCurrentUser() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        self.currentUser = try await userDocument(userId: currentUid).getDocument(as: DBUser.self)
    }
    
    func getUser(userId: String) async throws -> DBUser? {
        try? await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func userExists(userId: String) async throws -> Bool {
        let document = try await userDocument(userId: userId).getDocument()
        return document.exists
    }
    
    func deleteUser(user: DBUser) async throws {
        try await userDocument(userId: user.id).delete()
        self.currentUser = nil
    }

    func resetBadgeCount(userId: String?) async throws {
        guard let userId else { return }
        let data: [String: Any] = [
            "badge_count" : 0
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    //MARK: - Settings Function
    
    func updateUsername(userId: String, username: String) async throws {
        let data: [String: Any] = [
            "username" : username
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateDeleted(userId: String, isDeleted: Bool) async throws {
        let data: [String: Any] = [
            "isDeleted" : isDeleted
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        let data: [String: Any] = [
            "profileImagePath" : path as Any,
            "profileImagePathUrl" : url as Any,
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    //MARK: - Get User Image for Post
    
    func getImageURLPath(userId: String) async throws -> String? {
        let snapshot = try await userDocument(userId: userId).getDocument()
        return snapshot.get("profileImagePathUrl") as? String
    }
    
    func banUser(userId: String) async throws {
        let data: [String: Any] = [
            "isBanned" : true
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
}
