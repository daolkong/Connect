//
//  SomeViewModel.swift
//  Connect
//
//  Created by Daol on 10/22/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import Combine

struct SomeView: View {
    @StateObject private var vm: SomeViewModel = SomeViewModel()
    var body: some View {
        Button {
            Task {
                try await vm.signInApple
            }
        } label: {
            Text("apple login")
        }

    }
}

@MainActor
final class SomeViewModel: ObservableObject {
    @Published var loading: Bool = false
    @Published var currentUser: DBUser?
    private var cancellables = Set<AnyCancellable>()
    
    func signInApple() async throws {
        let tokens = try await SignInWithAppleHelper.shared.startSignInWithAppleFlow()
        let authDataResult = try await AuthService.shared.signInWithApple(tokens: tokens)
        
//        let user = DBUser(auth: authDataResult)
//        try await checkUserCreatedAndThenCreate(user: user)
    }
    
    func checkUserCreatedAndThenCreate(user: DBUser) async throws {
        let userExists = try await UserService.shared.userExists(userId: user.id)
        if !userExists {
            try await UserService.shared.createNewUser(user: user)
        }
        self.currentUser = user
        let userRef = Firestore.firestore().collection("users").document(user.id)
    }
        
}

