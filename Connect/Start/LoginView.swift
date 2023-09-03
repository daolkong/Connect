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
                    .frame(width: 395, height: 900)
                
                VStack(spacing: 60) {
                    
                    // 로고
                    VStack(spacing: 10) {
                        Image("whitechain")
                            .resizable()
                            .frame(width: 145, height: 145)
                        
                        Text("Connect")
                            .font(.system(size: 75))
                            .foregroundColor(Color.white)
                            .fontWeight(.black)
                    }
                    
                    VStack(spacing: 20) {
                        
                        // 이메일 입력
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
                            
                            CustomTextField(text: $email, placeholder:"이메일을 입력해주세요")
                                .font(.system(size:16))
                                .fontWeight(.light)
                                .padding(.horizontal)
                            
                            
                        }
                        .frame(width: 50, height: 48)
                        
                        //비밀번호 입력
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 323, height: 48)
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .inset(by: 0.75)
                                        .stroke(Color(red: 0.95, green: 0.95, blue: 0.95), lineWidth: 1.5)
                                )
                            CustomTextField(text: $password, placeholder:"비밀번호를 입력해주세요")
                                .font(.system(size:16))
                                .fontWeight(.light)
                                .padding(.horizontal)
                        }
                        .frame(width: 50, height: 48)
                        
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
                                    .font(.system(size: 27))
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        NavigationLink(destination: SigninView().navigationBarBackButtonHidden(true), isActive: $isSigninViewActive) {
                            EmptyView()
                        }
                        
                        Button(action: {
                            // "회원가입 하기" 버튼이 클릭되면 SigninView로 이동합니다.
                            isSigninViewActive = true
                        }) {
                            Text("회원가입 하기")
                                .font(.system(size: 18))
                                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                                .fontWeight(.bold)
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
            .padding(.bottom,70)
        }
    }
}

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.textColor = UIColor.white // Text color
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]) // Placeholder color
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}

struct CustomTextField1: UIViewRepresentable {
    @Binding var text: String
    @Binding var text1: String
    @Binding var text2: String
    @Binding var text3: String

    var placeholder: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.textColor = UIColor.black // Text color
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]) // Placeholder color
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
