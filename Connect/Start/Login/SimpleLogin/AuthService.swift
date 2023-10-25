//
//  AuthService.swift
//  Connect
//
//  Created by Daol on 10/22/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseCore
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    var username: String?
    var providerID: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.username = user.displayName
        self.providerID = user.providerData[0].providerID
    }
}

enum AuthProviderOption: String {
    case google = "google.com"
    case apple = "apple.com"
    case github = "github.com"
}

final class AuthService {
    static let shared = AuthService()
    @Published var userSession: AuthDataResultModel?
    private init() {
        self.userSession = try? getAuthenticatedUser()
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        
        return providers
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        self.userSession = nil
    }
    
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        try await user.delete()
        self.userSession = nil
    }
}

//MARK: - Sign In SSO
extension AuthService {
    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
        let credential = OAuthProvider.appleCredential(withIDToken: tokens.token, rawNonce: tokens.nonce, fullName: tokens.name)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}

//extension AuthService {
//    func linkApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
//        let credential = OAuthProvider.credential(withProviderID: AuthProviderOption.apple.rawValue, idToken: tokens.token, rawNonce: tokens.nonce)
//        return try await linkCredential(credential: credential)
//    }
//
//    func linkGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
//        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
//        return try await linkCredential(credential: credential)
//    }
//
//    private func linkCredential(credential: AuthCredential) async throws -> AuthDataResultModel {
//        guard let user = Auth.auth().currentUser else {
//            throw URLError(.badURL)
//        }
//        let authDataResult = try await user.link(with: credential)
//        return AuthDataResultModel(user: authDataResult.user)
//    }
//}

