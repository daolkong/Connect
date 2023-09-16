//
//  FirstStartView.swift
//  Connect
//
//  Created by Daol on 2023/09/03.
//

import SwiftUI

struct FirstStartView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userDataModel: UserDataModel
    @State var isSignIn = true
    @State var showLoadingScreen = true // Add this state variable
    
    var body: some View {
        NavigationStack {
            Group {
                if showLoadingScreen { // Show the StartView while loading.
                    StartView()
                } else {
                    switch authViewModel.loginState {
                    case .firstLaunch:
                        StartView()
                    case .loggedIn:
                        MainTabbedView()
                    case .loggedOut:
                        LoginView()
                    case .notSigned:
                        SigninView()
                    }
                }
            }
        }.onAppear { // Use onAppear to delay the transition.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjust the delay as needed.
                self.showLoadingScreen = false
            }
        }
    }
}

struct FirstStartView_Previews: PreviewProvider {
    static var previews: some View {
        FirstStartView()
    }
}
