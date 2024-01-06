//
//  Mypage.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct MypageView: View {
    @State private var deleteUserConfirmation = false
    @State private var showLogoutConfirmation = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image("back1")
                    .resizable()
                    .frame(width: 10, height: 16)
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width == 430 ? 390 : UIScreen.main.bounds.width == 393 ? 353 : UIScreen.main.bounds.width == 390 ? 350 : UIScreen.main.bounds.width == 375 ? 335 : UIScreen.main.bounds.width == 320 ? 280 : 375,
               height:15)
        
        
        VStack {
            
            // 프로필 사진과 유저 아이디
            VStack(spacing:20) {
                if let urlStr = authViewModel.user?.profileImageURL, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(width: 150, height: 150)
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
            Spacer()
            
            
            Button {
                if let url = URL(string: "https://amazing-hedgehog-e3c.notion.site/eb10688753b845dc805cd2a5ed8489e5?pvs=4") {
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
                                .stroke(Color(red: 0.39, green: 0.63, blue: 1), lineWidth: 2)
                        )
                    
                    Text("앱 이용약관")
                        .foregroundColor(Color(red: 0.39, green: 0.63, blue: 1))
                        .font(.system(size: 18, weight:.bold))
                }
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
                      showLogoutConfirmation = true
                  } label: {
                      ZStack {
                          Rectangle()
                              .frame(width: 338, height: 68)
                              .background(Color(red: 0.12, green: 0.14, blue: 0.14))
                              .cornerRadius(20)
                          
                          Text("로그아웃")
                              .font(.system(size: 27, weight:.bold))
                              .foregroundColor(Color.white)
                      }
                      .tint(Color.black)
                  }
                  .alert(isPresented: $showLogoutConfirmation) {
                              Alert(
                                  title: Text("로그아웃"),
                                  message: Text("정말 로그아웃 하시겠습니까?"),
                                  primaryButton: .cancel(Text("취소").foregroundColor(.red).fontWeight(.bold)), // Cancel button text color
                                  secondaryButton: .default(Text("로그아웃").foregroundColor(.blue).fontWeight(.bold)) {
                                      do {
                                          try authViewModel.signOutUser()
                                      } catch {
                                          print("DEBUG: Failed to sign out: \(error.localizedDescription)")
                                      }
                                  }
                              )
                          }
            .task {
                do {
                    try await authViewModel.fetchUser()
                } catch {
                    print("DEBUG: Failed to fetch user \(error.localizedDescription)")
                }
            }
            
            Button {
                deleteUserConfirmation = true
            } label: {
                ZStack {
                    Rectangle()
                        .frame(width: 338, height: 38)
                        .cornerRadius(20)

                    Text("회원탈퇴")
                        .foregroundColor(Color(red: 1, green: 0.46, blue: 0.45))
                        .font(.system(size: 18, weight:.semibold))
                }
            }
            .alert(isPresented: $deleteUserConfirmation) {
                Alert(
                    title: Text("정말로 회원탈퇴 하시겠습니까? "),
                    message: Text("계정과 관련된 모든 데이터가 삭제됩니다."),
                    primaryButton: .cancel(Text("취소").foregroundColor(.red).fontWeight(.bold)), // Cancel button text color
                    secondaryButton: .default(Text("회원탈퇴").foregroundColor(.blue).fontWeight(.bold)) {
                        Task {
                            do {
                                try await authViewModel.deleteUser()
                                try authViewModel.signOutUser() // Sign out after deleting the account
                            } catch {
                                print("DEBUG: Failed to delete user: \(error.localizedDescription)")
                            }
                        }
                    }
                )
            }
        }
        .frame(width: UIScreen.main.bounds.width == 430 ? 430 : UIScreen.main.bounds.width == 393 ? 393 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 375 : UIScreen.main.bounds.width == 320 ? 320 : 375,
               height: UIScreen.main.bounds.height == 932 ? 650 : UIScreen.main.bounds.height == 852 ? 580 : UIScreen.main.bounds.height == 844 ? 600 : UIScreen.main.bounds.height == 812 ? 812 : UIScreen.main.bounds.height == 667 ? 500: UIScreen.main.bounds.height)
    }
}

#Preview {
    MypageView()
}
