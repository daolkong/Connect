//
//  HashtagSignView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI


struct SigninView: View {
    @State private var text: String = "" // $text를 정의
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var userId: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var hastags: String = ""
    @State var errorMessage = ""
    @State var retrySignUp = false
    @State private var isLoginSuccessful = false

   
    var body: some View {
        NavigationView {
            ZStack {
                Image("back")
                    .resizable()
                    .frame(width: 395, height: 877)
                
                VStack(spacing: 40) {
                    
                    Button(action: {
                        // Dismiss the view when the button is tapped
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        SigninTopNavigationBar()
                    }
                    
                    // 로고
                    VStack(spacing: 0) {
                        Image("whitechain")
                            .resizable()
                            .frame(width: 145, height: 145)
                        
                        Text("Connect")
                            .font(.system(size: 80))
                            .foregroundColor(Color.white)
                            .fontWeight(.black)
                    }
                    
                    
                    VStack(spacing: 45) {
                        // 아이디
                        ZStack(alignment: .leading) {
                            if userId.isEmpty {
                                Text("아이디")
                                    .foregroundColor(.white)  // Change color here
                            }
                            TextField("", text: $userId)
                                .foregroundColor(.white)  // Change color here
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
                        .padding(.horizontal,50)

                        // 이메일
                        ZStack(alignment: .leading) {
                            if email.isEmpty {
                                Text("이메일")
                                    .foregroundColor(.white)  // Change color here
                            }
                            TextField("", text: $email)
                                .foregroundColor(.white)  // Change color here
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
                        .padding(.horizontal,50)
                        
                        // 비밀번호
                        ZStack(alignment: .leading) {
                            if password.isEmpty {
                                Text("비밀번호")
                                    .foregroundColor(.white)  // Change color here
                            }
                            SecureField("", text: $password)
                                .foregroundColor(.white)  // Change color here
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
                        .padding(.horizontal,50)

                        // 해시태그
                        ZStack(alignment: .leading) {
                            if hastags.isEmpty {
                                Text("나를 나타내는 해시태그 4개(쉼표로 구분)")
                                    .foregroundColor(.white)  // Change color here
                            }
                            TextField("", text: $hastags)
                                .foregroundColor(.white)  // Change color here
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
                        .padding(.horizontal,50)

                    }
                    
                    // 회원가입 버튼
                    Button {
                        print(password)
                        guard password.count >= 6 else {
                            retrySignUp = true
                            errorMessage = "비밀번호는 최소 6자리 이상이어야 합니다."
                            return
                        }
                        Task {
                            do {
                                try await authViewModel.registerUser(userId: userId, withEmail: email, password: password, hastags: hastags)
                                isLoginSuccessful = true // <- 여기에 추가
                            } catch {
                                retrySignUp = true
                                errorMessage = error.localizedDescription
                                print("DEBUG: Failed to sign up \(error.localizedDescription)")
                            }
                        }
                        
                    } label: {
                        ZStack {
                            // Add this NavigationLink:
                                 if isLoginSuccessful {
                                     NavigationLink(destination: MyprofileView(), isActive: $isLoginSuccessful) { EmptyView() }
                                         .hidden()
                                         .frame(width: 0, height: 0)
                                         .disabled(true)
                                         .allowsHitTesting(false)
                                         .opacity(0.00001) // Make it invisible but still active.
                                  }
                            
                            
                            Rectangle()
                                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                                .frame(width: 323, height: 69)
                                .cornerRadius(50)
                            
                            Text("회원가입")
                                .font(.system(size: 27))
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                            
                        }
                    }
                    
                }
                .padding(.bottom,50)
            }
        }
        .alert("회원가입 실패", isPresented: $retrySignUp) {
            Button {
                retrySignUp = false
            } label: {
                Text("다시 시도하기")
            }
        } message: {
            Text("\(errorMessage)")
            
        }
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}

