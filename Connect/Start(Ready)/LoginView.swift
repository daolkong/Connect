//
//  NamestartView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct LoginView: View {
    @State private var isSigninViewActive = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var retrySignIn = false
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("back")
                    .resizable()
                    .frame(width: 395, height: 1000)
                
                VStack(spacing: 60) {
                    
                    // 로고
                    VStack(spacing: 10) {
                        Image("whitechain")
                            .resizable()
                            .frame(width: 145, height: 145)
                        
                        Text("Connect")
                            .font(.system(size: 75, weight: .black))
                            .foregroundColor(Color.white)
                    }
                    
                    VStack(spacing: 45) {
                        
                        // 이메일 입력
                        ZStack(alignment: .leading) {
                            if email.isEmpty {
                                Text("이메일을 입력해주세요")
                                    .foregroundColor(.white)
                            }
                            TextField("", text: $email)
                                .foregroundColor(.white)
                                .overlay( Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 323, height: 48)
                                    .cornerRadius(50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 50)
                                            .inset(by: 0.75)
                                            .stroke(Color(red: 0.95, green: 0.95, blue: 0.95), lineWidth: 1.5)
                                    )
                                )
                            
                        }
                        .padding(.horizontal,20)

                        ZStack(alignment: .leading) {
                            if password.isEmpty {
                                Text("비밀번호를 입력해주세요")
                                    .foregroundColor(.white)
                            }
                            SecureField("", text: $password)
                                .foregroundColor(.white)
                                .overlay( Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 323, height: 48)
                                    .cornerRadius(50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 50)
                                            .inset(by: 0.75)
                                            .stroke(Color(red: 0.95, green: 0.95, blue: 0.95), lineWidth: 1.5)
                                    )
                                )
                        }
                        .padding(.horizontal,20)
                        
                    }
                    
                    VStack(spacing: 30) {
                        // 로그인 버튼
                        Button {
                            Task {
                                do {
                                    try await authViewModel.signInUser(withEmail: email, password: password)
                                } catch {
                                    retrySignIn = true
                                    errorMessage = error.localizedDescription
                                    print("DEBUG: Failed to sign in \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 323, height: 69)
                                    .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                                    .cornerRadius(50)
                                
                                Text("로그인")
                                    .font(.system(size: 27, weight: .bold))
                                    .foregroundColor(Color.white)
                            }
                        }
                        
                        NavigationLink(destination: SigninView().navigationBarBackButtonHidden(true), isActive: $isSigninViewActive) {
                            EmptyView()
                        }
                        
                        Button(action: {
                            isSigninViewActive = true
                        }) {
                            Text("회원가입 하기")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                        }
                    }
                }
                .frame(width: 333)
                .alert("로그인 실패", isPresented: $retrySignIn) {
                    Button {
                        retrySignIn = false
                    } label: {
                        Text("다시 시도하기")
                    }
                } message: {
                    Text(errorMessage)
                }
            }
            .padding(.bottom,20)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
