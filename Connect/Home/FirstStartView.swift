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
    @State var isStartView = true // 추가
    
    var body: some View {
        NavigationView {
            Group {
                if isStartView { // 추가
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
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 추가
                isStartView = false
            }
        }
    }
}

struct FirstStartView_Previews: PreviewProvider {
    static var previews: some View {
        FirstStartView()
            .environmentObject(AuthViewModel())
            .environmentObject(UserDataModel())
        
    }
}
