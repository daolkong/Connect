//
//  FirstStartView.swift
//  Connect
//
//  Created by Daol on 2023/09/03.
//

import SwiftUI

struct FirstStartView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var isSignIn = true
    
    var body: some View {
        NavigationStack {
            Group {
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
}

struct FirstStartView_Previews: PreviewProvider {
    static var previews: some View {
        FirstStartView()
            .environmentObject(AuthViewModel())
    }
}
