//
//  NamestartView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI
import FirebaseAuth

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
                
                VStack(spacing: 60) {
                    
                    // 로고
                    VStack(spacing: 10) {
                        Image("wwhite")
                            .resizable()
                            .frame(width: 110, height: 130)
                        
                        Text("Link life")
                            .font(.system(size: 70, weight: .black))
                            .foregroundColor(Color.white)
                    }
                    
                    VStack(spacing: 45) {
                        
                        // 이메일 입력
                        ZStack(alignment: .leading) {
                            if email.isEmpty {
                                Text("이메일을 입력해주세요")
                                    .foregroundColor(Color.white)
                            }
                            TextField("", text: $email)
                                .foregroundColor(.white)
                                .overlay( Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: UIScreen.main.bounds.width == 430 ? 340 :
                                            UIScreen.main.bounds.width == 428 ? 330 :
                                            UIScreen.main.bounds.width == 414 ? 333 :
                                            UIScreen.main.bounds.width == 393 ? 333 :
                                            UIScreen.main.bounds.width == 390 ? 340 :
                                            UIScreen.main.bounds.width == 375 ? 325 :
                                            UIScreen.main.bounds.width == 320 ? 250 : 375,
                                           height: UIScreen.main.bounds.height == 932 ? 52 :
                                            UIScreen.main.bounds.height == 926 ? 50 :
                                            UIScreen.main.bounds.height == 896 ? 50 :
                                            UIScreen.main.bounds.height == 852 ? 48 :
                                            UIScreen.main.bounds.height == 844 ? 48 :
                                            UIScreen.main.bounds.height == 812 ? 48 :
                                            UIScreen.main.bounds.height == 667 ? 48: UIScreen.main.bounds.height)
                                          
                                        .cornerRadius(50)
                                          
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .inset(by: 0.75)
                                                .stroke(Color.white)
                                        )
                                )
                            
                        }
                        .padding(.horizontal,20)
                        
                        ZStack(alignment: .leading) {
                            if password.isEmpty {
                                Text("비밀번호를 입력해주세요")
                                    .foregroundColor(Color.white)
                            }
                            SecureField("", text: $password)
                                .foregroundColor(.white)
                                .overlay( Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: UIScreen.main.bounds.width == 430 ? 340 :
                                            UIScreen.main.bounds.width == 428 ? 330 :
                                            UIScreen.main.bounds.width == 414 ? 333 :
                                            UIScreen.main.bounds.width == 393 ? 333 :
                                            UIScreen.main.bounds.width == 390 ? 340 :
                                            UIScreen.main.bounds.width == 375 ? 325 :
                                            UIScreen.main.bounds.width == 320 ? 250 : 375,
                                           height: UIScreen.main.bounds.height == 932 ? 52 :
                                            UIScreen.main.bounds.height == 926 ? 50 :
                                            UIScreen.main.bounds.height == 896 ? 50 :
                                            UIScreen.main.bounds.height == 852 ? 48 :
                                            UIScreen.main.bounds.height == 844 ? 48 :
                                            UIScreen.main.bounds.height == 812 ? 48 :
                                            UIScreen.main.bounds.height == 667 ? 48: UIScreen.main.bounds.height)
                                          
                                        .cornerRadius(50)
                                          
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .inset(by: 0.75)
                                                .stroke(Color.white)
                                        )
                                )
                        }
                        .padding(.horizontal,20)
                        
                    }
                    
                    VStack(spacing: 10) {
                        // 로그인 버튼
                        Button {
                            Task {
                                do {
                                    try await authViewModel.signInUser(withEmail: email, password: password)
                                } catch let error as NSError {
                                    switch error.localizedDescription {
                                    case "auth/user-not-found", "auth/wrong-password":
                                        errorMessage = "이메일 혹은 비밀번호가 일치하지 않습니다."
                                    case "auth/email-already-in-use":
                                        errorMessage = "이미 사용 중인 이메일입니다."
                                    case "auth/weak-password":
                                        errorMessage = "비밀번호는 6글자 이상이어야 합니다."
                                    case "auth/network-request-failed":
                                        errorMessage = "네트워크 연결에 실패 하였습니다."
                                    case "auth/invalid-email":
                                        errorMessage = "잘못된 이메일 형식입니다."
                                    case "auth/internal-error":
                                        errorMessage = "잘못된 요청입니다."
                                    default:
                                        errorMessage = "로그인에 실패 하였습니다."
                                    }
                                    retrySignIn = true
                                    print("DEBUG: Failed to sign in \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: UIScreen.main.bounds.width == 430 ? 340 :
                                            UIScreen.main.bounds.width == 428 ? 330 :
                                            UIScreen.main.bounds.width == 414 ? 324 :
                                            UIScreen.main.bounds.width == 393 ? 323 :
                                            UIScreen.main.bounds.width == 390 ? 320 :
                                            UIScreen.main.bounds.width == 375 ? 325 :
                                            UIScreen.main.bounds.width == 320 ? 250 : 375,
                                           height: UIScreen.main.bounds.height == 932 ? 69 :
                                            UIScreen.main.bounds.height == 926 ? 68 :
                                            UIScreen.main.bounds.height == 896 ? 68 :
                                            UIScreen.main.bounds.height == 852 ? 69 :
                                            UIScreen.main.bounds.height == 844 ? 69 :
                                            UIScreen.main.bounds.height == 812 ? 69 :
                                            UIScreen.main.bounds.height == 667 ? 69: UIScreen.main.bounds.height)
                                
                                    .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                                    .cornerRadius(50)
                                
                                
                                Text("로그인")
                                    .font(.system(size: 27, weight: .bold))
                                    .foregroundColor(Color.white)
                            }
                        }
                        
                        NavigationLink(destination: AllowView().navigationBarBackButtonHidden(true), isActive: $isSigninViewActive) {
                            EmptyView()
                        }
                        
                        Button(action: {
                            isSigninViewActive = true
                        }) {
                            Text("회원가입 하기")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.white)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom,10)

//
//            .frame(width: UIScreen.main.bounds.width == 1024 ? 1024 : UIScreen.main.bounds.width == 820 ? 820 : UIScreen.main.bounds.width == 768 ? 768 : UIScreen.main.bounds.width == 430 ? 430 : UIScreen.main.bounds.width == 428 ? 428 : UIScreen.main.bounds.width == 414 ? 414 : UIScreen.main.bounds.width == 393 ? 393 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 375 : UIScreen.main.bounds.width == 320 ? 320 : 375,
//                   height: UIScreen.main.bounds.height == 164 ? 126 : UIScreen.main.bounds.height == 1194 ? 154 : UIScreen.main.bounds.height == 1024 ? 1024 : UIScreen.main.bounds.height == 932 ? 912 : UIScreen.main.bounds.height == 926 ? 926 : UIScreen.main.bounds.height == 896 ? 876 : UIScreen.main.bounds.height == 852 ? 852 : UIScreen.main.bounds.height == 844 ? 844 : UIScreen.main.bounds.height == 812 ? 812 : UIScreen.main.bounds.height == 667 ? 667 : UIScreen.main.bounds.height)
        }
    }
}

#Preview {
    LoginView()
}
