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
    
    var body: some View {
        
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            ProfileTopNavigationBar(TextLogo: "back1")
        }
        
        VStack(spacing:40) {
            
            // 프로필 사진과 유저 아이디
            VStack(spacing:20) {
                if let urlStr = authViewModel.user?.profileImageURL, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(width: 134, height: 134)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.25), radius: 3.5, x: 0, y: 0)
                        
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image("nonpro")
                        .resizable()
                        .frame(width: 134, height: 134)
                        .shadow(color: .black.opacity(0.25), radius: 3.5, x: 0, y: 0)
                }

                Text(authViewModel.user?.userId ?? "Loading...")
                    .font(.system(size: 50, weight:.bold))
            }

            
            // 개인정보 처리방침 링크
            Button {
                if let url = URL(string: "https://jungbaeck.notion.site/jungbaeck/G-School-42d77688f2f94bc29e519f1efa14170b") {
                        UIApplication.shared.open(url)
                    }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.clear)
                        .frame(width: 338, height: 64)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .inset(by: 1)
                                .stroke(Color(red: 0.12, green: 0.14, blue: 0.14), lineWidth: 2)
                        )
                    
                    Text("개인정보 처리방침")
                        .foregroundColor(Color.black)
                        .font(.system(size: 18, weight:.semibold))
                }
            }
            
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
                        .frame(width: 338, height: 68)
                        .background(Color(red: 0.12, green: 0.14, blue: 0.14))
                        .cornerRadius(35)
                    
                    Text("로그아웃")
                        .font(.system(size: 27, weight:.bold))
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
            
            
        }
        .padding(.bottom,100)
    }
}

struct MypageView_Previews: PreviewProvider {
    static var previews: some View {
        MypageView()
    }
}
