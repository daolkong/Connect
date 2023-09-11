//
//  HomeView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct HomeView: View {
    @State private var isNavigatingToMyPage = false
    @State private var isNavigatingToHomeGroup = false
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var userDataModel = UserDataModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                
                // 상단 탭뷰
                HStack {
                    Image("align-left")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            isNavigatingToMyPage = true
                        }
                    NavigationLink(destination: MypageView()
                        .navigationBarBackButtonHidden(true), isActive: $isNavigatingToMyPage) {
                            EmptyView()
                        }
                    
                    Spacer().frame(width: 105) // 여기에 Spacer 추가
                    
                    Text("Connect")
                        .font(.system(size: 25))
                        .fontWeight(.semibold)
                    
                    Spacer().frame(width: 105) // 여기에 Spacer 추가
                    
                    Image("users")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            isNavigatingToHomeGroup = true
                        }
                    
                    NavigationLink(destination: HomeGroupView()   .navigationBarBackButtonHidden(true), isActive: $isNavigatingToHomeGroup) {
                        EmptyView()
                    }
                }
                
                ScrollView {
                    VStack(spacing: 1) {
                        
                        // 아래 게시물
                        ForEach(0..<50) { index in
                            VStack(spacing: -19) {
                                // 프로필 상단
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.3))
                                        .frame(width: 430, height: 65)
                                    
                                    HStack {
                                        Image("profile")
                                            .resizable()
                                            .frame(width: 44, height: 44)
                                        
                                        VStack(alignment: .leading) {
                                            
                                            Text(userDataModel.user?.fullid ?? "No Full ID")
                                                .font(.system(size: 20))
                                                .fontWeight(.semibold)
                                            
                                            Text("11:26 PM")
                                                .font(.system(size: 12))
                                                .fontWeight(.regular)
                                            
                                        }
                                        .onAppear(){
                                                  userDataModel.fetchUser()
                                              }
                                        
                                        Spacer()
                                    }
                                    
                                }
                                .padding()
                                
                                // 사진 넘기는 영역
                                imageupload()
                                    .frame(width: 430, height: 430)
                                
                                // 공감과 커넥트 칸
                                HStack(spacing: 36) {
                                    HStack {
                                        Button(action: {
                                            // 버튼이 클릭되었을 때 실행될 액션
                                        }) {
                                            Image("heart button")
                                                .resizable()
                                                .frame(width: 33, height: 33)
                                        }
                                        
                                        Text("Like")
                                            .font(.system(size:20))
                                            .fontWeight(.semibold)
                                    }
                                    HStack {
                                        Button(action: {
                                            // 버튼이 클릭되었을 때 실행될 액션
                                        }) {
                                            Image("Connect button")
                                                .resizable()
                                                .frame(width: 33, height: 33)
                                        }
                                        
                                        Text("Connect (15)")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                    }
                                }
                                .padding(.top,30)
                            }
                        }
                        
                    }
                    
                }
            }
        }
        
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        
        
    }
}
