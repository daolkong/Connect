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
    @State var fullid: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var hastag1: String = ""
    @State var hastag2: String = ""
    @State var hastag3: String = ""
    @State var hastag4: String = ""
    @State var errorMessage = ""
    @State var retrySignUp = false
    
    
    
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
                    
                    
                    VStack(spacing: 20) {
                        // 아이디
                        ZStack() {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 323, height: 48)
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .inset(by: 0.75)
                                        .stroke(Color(red: 0.95, green: 0.95, blue: 0.95), lineWidth: 1.5)
                                )
                            
                            CustomTextField(text: $fullid, placeholder:"아이디")
                                .font(.system(size: 16))
                                .fontWeight(.light)
                                .padding(.horizontal)
                                .textFieldStyle(PlainTextFieldStyle())
                                .textInputAutocapitalization(.never)
                            
                        }
                        .frame(width: 50, height: 48)
                        
                        
                        // 이메일
                        ZStack() {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 323, height: 48)
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .inset(by: 0.75)
                                        .stroke(Color(red: 0.95, green: 0.95, blue: 0.95), lineWidth: 1.5)
                                )
                            
                            CustomTextField(text: $email, placeholder:"이메일")
                                .font(.system(size: 16))
                                .fontWeight(.light)
                                .padding(.horizontal)
                                .textFieldStyle(PlainTextFieldStyle())
                                .textInputAutocapitalization(.never)
                            
                        }
                        .frame(width: 50, height: 48)
                        
                        
                        // 아이디
                        ZStack() {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 323, height: 48)
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .inset(by: 0.75)
                                        .stroke(Color(red: 0.95, green: 0.95, blue: 0.95), lineWidth: 1.5)
                                )
                            
                            CustomTextField(text: $password, placeholder:"비밀번호")
                                .font(.system(size: 16))
                                .fontWeight(.light)
                                .padding(.horizontal)
                                .textFieldStyle(PlainTextFieldStyle())
                                .textInputAutocapitalization(.never)
                            
                        }
                        .frame(width: 50, height: 48)
                        
                        
                        // 해시태그
                        ZStack() {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 323, height: 48)
                                .background(.white)
                                .cornerRadius(50)
                            
                            CustomTextField1(text: $hastag1, text1: $hastag2, text2: $hastag3, text3: $hastag4 ,placeholder: "나를 나타내는 해시태그 4개(쉼표로 표시)")
                                .font(.system(size: 16))
                                .fontWeight(.light)
                                .padding(.horizontal)
                                .textFieldStyle(PlainTextFieldStyle())
                                .textInputAutocapitalization(.never)
                            
                        }
                        .frame(width: 50, height: 48)
                        
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
                                try await authViewModel.registerUser(fullid: fullid, withEmail: email, password: password, hastag1: hastag1, hastag2: hastag2, hastag3: hastag3, hastag4: hastag4)
                                presentationMode.wrappedValue.dismiss()
                            } catch {
                                retrySignUp = true
                                errorMessage = error.localizedDescription
                                print("DEBUG: Failed to sign up \(error.localizedDescription)")
                            }
                        }
                        
                    } label: {
                        ZStack {
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
                .padding(.bottom,40)
            }
        }
        .alert(isPresented: $retrySignUp) {
            Alert(title: Text("회원가입 실패"),
                  message: Text("\(errorMessage)"),
                  dismissButton: .default(Text("다시 시도하기")) {
                retrySignUp = false
            })
        }
        
        
    }
    
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}

