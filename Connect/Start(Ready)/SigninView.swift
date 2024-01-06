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
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 430, height: 932)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.02, green: 0.02, blue: 0.02), location: 0.00),
                                Gradient.Stop(color: .white, location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.19, y: 0.02),
                            endPoint: UnitPoint(x: 2.33, y: 2.9)
                        )
                    )
                
                VStack(spacing: 35) {
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing:25) {
                            
                            Spacer()
                                .frame(width: 0)
                            
                            Image("backk")
                                .resizable()
                                .frame(width: 7, height: 13)
                            
                            Text("로그인")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color.white)
                            
                            Spacer()
                            
                        }
                        .frame(width: UIScreen.main.bounds.width == 430 ? 430 : UIScreen.main.bounds.width == 393 ? 393 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 375 : UIScreen.main.bounds.width == 320 ? 320 : 375,
                               height: 20)
                    }
                    
                    Spacer()
                    // 커넥트 마크
                    VStack(spacing: 0) {
                        Image("wwhite")
                            .resizable()
                            .frame(width:85, height: 95)
                        Text("Link life")
                            .font(.system(size: 60, weight: .black))
                            .foregroundColor(Color.white)
                    }
                    
                    // 기본정보 작성
                    VStack(spacing: 45) {
                        
                        ZStack(alignment: .leading) {
                            if userId.isEmpty {
                                Text("아이디")
                                    .foregroundColor(Color.white)
                            }
                            TextField("", text: $userId)
                                .foregroundColor(.white)
                                .overlay( Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: UIScreen.main.bounds.width == 430 ? 360 : UIScreen.main.bounds.width == 428 ? 350 : UIScreen.main.bounds.width == 414 ? 340 : UIScreen.main.bounds.width == 393 ? 323 : UIScreen.main.bounds.width == 390 ? 320 : UIScreen.main.bounds.width == 375 ? 305 : UIScreen.main.bounds.width == 320 ? 250 : 375,
                                           height: UIScreen.main.bounds.height == 932 ? 52 : UIScreen.main.bounds.height == 926 ? 50 : UIScreen.main.bounds.height == 896 ? 48 : UIScreen.main.bounds.height == 852 ? 48 : UIScreen.main.bounds.height == 844 ? 45 : UIScreen.main.bounds.height == 812 ? 45 : UIScreen.main.bounds.height == 667 ? 45: UIScreen.main.bounds.height)
                                          
                                        .cornerRadius(50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .inset(by: 0.75)
                                                .stroke(Color.white)
                                        )
                                )
                        }
                        .padding(.horizontal,50)
                        
                        ZStack(alignment: .leading) {
                            if email.isEmpty {
                                Text("이메일")
                                    .foregroundColor(Color.white)
                            }
                            TextField("", text: $email)
                                .foregroundColor(.white)
                                .overlay( Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: UIScreen.main.bounds.width == 430 ? 360 : UIScreen.main.bounds.width == 428 ? 350 : UIScreen.main.bounds.width == 414 ? 340 : UIScreen.main.bounds.width == 393 ? 323 : UIScreen.main.bounds.width == 390 ? 320 : UIScreen.main.bounds.width == 375 ? 305 : UIScreen.main.bounds.width == 320 ? 250 : 375,
                                           height: UIScreen.main.bounds.height == 932 ? 52 : UIScreen.main.bounds.height == 926 ? 50 : UIScreen.main.bounds.height == 896 ? 48 : UIScreen.main.bounds.height == 852 ? 48 : UIScreen.main.bounds.height == 844 ? 45 : UIScreen.main.bounds.height == 812 ? 45 : UIScreen.main.bounds.height == 667 ? 45: UIScreen.main.bounds.height)
                                        .cornerRadius(50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .inset(by: 0.75)
                                                .stroke(Color.white)
                                        )
                                )
                        }
                        .padding(.horizontal,50)
                        
                        // 비밀번호
                        ZStack(alignment: .leading) {
                            if password.isEmpty {
                                Text("비밀번호")
                                    .foregroundColor(Color.white)
                            }
                            SecureField("", text: $password)
                                .foregroundColor(.white)
                                .overlay( Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: UIScreen.main.bounds.width == 430 ? 360 : UIScreen.main.bounds.width == 428 ? 350 : UIScreen.main.bounds.width == 414 ? 340 : UIScreen.main.bounds.width == 393 ? 323 : UIScreen.main.bounds.width == 390 ? 320 : UIScreen.main.bounds.width == 375 ? 305 : UIScreen.main.bounds.width == 320 ? 250 : 375,
                                           height: UIScreen.main.bounds.height == 932 ? 52 : UIScreen.main.bounds.height == 926 ? 50 : UIScreen.main.bounds.height == 896 ? 48 : UIScreen.main.bounds.height == 852 ? 48 : UIScreen.main.bounds.height == 844 ? 45 : UIScreen.main.bounds.height == 812 ? 45 : UIScreen.main.bounds.height == 667 ? 45: UIScreen.main.bounds.height)
                                        .cornerRadius(50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .inset(by: 0.75)
                                                .stroke(Color.white)
                                        )
                                )
                        }
                        .padding(.horizontal,50)
                        
                        // 해시태그
                        ZStack(alignment: .leading) {
                            if hastags.isEmpty {
                                Text("나를 나타내는 해시태그 4개(# ,# ,# ,# )")
                                    .foregroundColor(Color.white)
                            }
                            TextField("", text: $hastags)
                                .foregroundColor(.white)
                                .overlay( Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: UIScreen.main.bounds.width == 430 ? 360 : UIScreen.main.bounds.width == 428 ? 350 : UIScreen.main.bounds.width == 414 ? 340 : UIScreen.main.bounds.width == 393 ? 323 : UIScreen.main.bounds.width == 390 ? 320 : UIScreen.main.bounds.width == 375 ? 305 : UIScreen.main.bounds.width == 320 ? 250 : 375,
                                           height: UIScreen.main.bounds.height == 932 ? 52 : UIScreen.main.bounds.height == 926 ? 50 : UIScreen.main.bounds.height == 896 ? 48 : UIScreen.main.bounds.height == 852 ? 48 : UIScreen.main.bounds.height == 844 ? 45 : UIScreen.main.bounds.height == 812 ? 45 : UIScreen.main.bounds.height == 667 ? 45: UIScreen.main.bounds.height)
                                        .cornerRadius(50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .inset(by: 0.75)
                                                .stroke(Color.white)
                                        )
                                )
                        }
                        .padding(.horizontal,50)
                    }
                    
                    // 회원가입 버튼
                    Button {
                        print(password)
                        guard !userId.isEmpty else {
                            retrySignUp = true
                            errorMessage = "아이디를 입력해주세요."
                            return
                        }
                        guard !email.isEmpty else {
                            retrySignUp = true
                            errorMessage = "이메일을 입력해주세요."
                            return
                        }
                        guard password.count >= 6 else {
                            retrySignUp = true
                            errorMessage = "비밀번호는 최소 6자리 이상이어야 합니다."
                            return
                        }
                        let hastagArray = hastags.split(separator: "#")
                        guard hastagArray.count == 4 else {
                            retrySignUp = true
                            errorMessage = "나를 나타내는 해시태그 4개를 입력해주세요."
                            return
                        }
                        Task {
                            do {
                                try await authViewModel.registerUser(userId: userId, withEmail: email, password: password, hastags: hastags)
                                isLoginSuccessful = true
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
                                    .opacity(0.00001)
                            }
                            
                            Rectangle()
                                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                                .frame(width: UIScreen.main.bounds.width == 430 ? 360 :
                                        UIScreen.main.bounds.width == 428 ? 350 :
                                        UIScreen.main.bounds.width == 414 ? 340 :
                                        UIScreen.main.bounds.width == 393 ? 323 :
                                        UIScreen.main.bounds.width == 390 ? 320 :
                                        UIScreen.main.bounds.width == 375 ? 305 :
                                        UIScreen.main.bounds.width == 320 ? 250 : 375,
                                       height: UIScreen.main.bounds.height == 932 ? 73 :
                                        UIScreen.main.bounds.height == 926 ? 70 :
                                        UIScreen.main.bounds.height == 896 ? 70 :
                                        UIScreen.main.bounds.height == 852 ? 69 :
                                        UIScreen.main.bounds.height == 844 ? 62 :
                                        UIScreen.main.bounds.height == 812 ? 62 :
                                        UIScreen.main.bounds.height == 667 ? 60: UIScreen.main.bounds.height)
                            
                                .cornerRadius(50)
                            
                            Text("회원가입")
                                .font(.system(size: 27, weight: .bold))
                                .foregroundColor(Color.white)
                        }
                    }
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width == 430 ? 430 : UIScreen.main.bounds.width == 428 ? 428 : UIScreen.main.bounds.width == 414 ? 414 : UIScreen.main.bounds.width == 393 ? 393 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 375 : UIScreen.main.bounds.width == 320 ? 320 : 375,
                       height: UIScreen.main.bounds.height == 932 ? 750 : UIScreen.main.bounds.height == 926 ? 750 : UIScreen.main.bounds.height == 896 ? 630 : UIScreen.main.bounds.height == 852 ? 650 : UIScreen.main.bounds.height == 844 ? 644 : UIScreen.main.bounds.height == 812 ? 612 : UIScreen.main.bounds.height == 667 ? 300: UIScreen.main.bounds.height)
                
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

#Preview {
    SigninView()
}

