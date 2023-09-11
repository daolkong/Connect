//
//  Mypage.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct MypageView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var isDarkModeOn = false
    @State var isalarmOn = false
    @State var isNoticeActive = false
    
    var body: some View {
        
        // 프로필
        VStack {
            Button(action: {
                // Dismiss the view when the button is tapped
                presentationMode.wrappedValue.dismiss()
            }) {
                ProfileTopNavigationBar(TextLogo: "back1")
            }
            
            VStack {
                Image("profile")
                    .resizable()
                    .frame(width: 104, height: 104)
                    .shadow(color: .black.opacity(0.25), radius: 3.5, x: 0, y: 0)
                
                Text("susun_hit")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                
                // 설정 정보
                VStack(spacing: 27) {
                    VStack(spacing: 27) {
                        HStack {
                            Toggle("다크모드", isOn: $isDarkModeOn)
                                .tint(Color(red: 0.52, green: 0.69, blue: 0.94))
                                .font(.system(size: 18))
                            
                        }
                        
                        HStack {
                            Toggle("알림 켜고 끄기", isOn: $isalarmOn)
                                .tint(Color(red: 0.52, green: 0.69, blue: 0.94))
                                .font(.system(size: 18))
                            
                        }
                    }
                    
                    Divider()
                    
                    VStack(spacing: 27) {
                        
                        HStack {
                            Text("공지사항")
                                .tint(.primary)
                                .font(.system(size: 18))
                            
                            Spacer()
                            
                            
                        }
                        
                        HStack {
                            Text("개발자에게 문의")
                                .tint(.primary)
                                .font(.system(size: 18))
                            
                            Spacer()
                            
                        }
                        
                    }
                    
                    Divider()
                    
                    VStack(spacing: 27) {
                        
                        HStack {
                            Text("버전 1.0")
                                .tint(.primary)
                                .font(.system(size: 18))
                            
                            Spacer()
                            
                        }
                        
                        HStack {
                            Text("개인정보 처리방침")
                                .tint(.primary)
                                .font(.system(size: 18))
                            
                            Spacer()
                        }
                    }
                }
                .padding(.top,20)
                
                //로그아웃 버튼
                Button {
                    do {
                        try authViewModel.signOutUser()
                    } catch {
                        print("DEBUG: Failed to sign out: \(error.localizedDescription)")
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 185, height: 64)
                            .background(Color(red: 0.12, green: 0.14, blue: 0.14))
                            .cornerRadius(35)
                        
                        Text("로그아웃")
                            .font(.system(size: 27))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                    }
                    .tint(Color.black)
                }
                .task {
                    do {
                        try await authViewModel.fetchUser()
                    } catch {
                        print("DEBUG: Failed to fetch user \(error.localizedDescription)")
                    }
                }
                .padding(.top,70)
                
                
            }
            .padding(.horizontal, 36)

        }

        
    }
}

struct MypageView_Previews: PreviewProvider {
    static var previews: some View {
        MypageView()
    }
}
