//
//  HomeGroupView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

let numberOfItems = 50 // 표시할 아이템 수에 따라 값을 조정하세요

struct HomeGroupView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                
                HomeTopNavigationBar(imageLogo: "users", TextLogo: "align-left", AlarmItem: "Connect")
                
                // 그룹 스크롤
                ScrollView(.horizontal) {
                    HStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color(red: 0.52, green: 0.69, blue: 0.94))
                                .frame(width: 94, height: 41)
                                .cornerRadius(30)
                            
                            Text("우리들의 헬스모임 ")
                                .font(.system(size: 13))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .frame(width: 49)
                        }
                        
                        ForEach(0..<12, id: \.self) { _ in
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color.white)
                                    .frame(width: 94, height: 41)
                                    .cornerRadius(30)
                                    .overlay(
                                      RoundedRectangle(cornerRadius: 30)
                                        .inset(by: 1)
                                        .stroke(Color(red: 0.52, green: 0.69, blue: 0.94), lineWidth: 2)
                                    )
                        
                                
                                Text("수선팀")
                                    .font(.system(size: 13))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.52, green: 0.69, blue: 0.94))
                                    .frame(width: 48)
                                
                            
                            }
                        }
                    }
                }
                .padding(.leading,9)

                
                
                ScrollView {
                    
                    VStack(spacing: 10) {
                        
                        // 1등 게시물 별도
                        VStack(spacing: 0) {
                            // 프로필 상단
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.3))
                                    .frame(width: 390, height: 65)

                                HStack {
                                    Image("profile")
                                        .resizable()
                                        .frame(width: 44, height: 44)

                                    VStack(alignment: .leading) {
                                        Text("susun_hit")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)

                                        Text("11:26 PM")
                                            .font(.system(size: 12))
                                            .fontWeight(.regular)

                                    }
                                    Spacer()

                                    ZStack {
                                        Image("medal")
                                            .resizable()
                                            .frame(width: 25, height: 36)

                                        Text("1")
                                            .font(.system(size: 13))
                                            .fontWeight(.bold)
                                            .padding(.bottom,10)

                                    }
                                }
                                .padding()

                            }

                            // 사진 넘기는 영역
                            TabView {
                                Rectangle()
                                    .frame(width: 393, height: 393)

                                Rectangle()
                                    .frame(width: 393, height: 393)
                            }
                            .frame(width: 393, height: 393)
                            .tabViewStyle(.page(indexDisplayMode: .always))

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

                                    Text("Like (31)")
                                        .font(.system(size: 20))
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
                            .padding(.top,15)
                        }
                        
                        ForEach(0..<numberOfItems) { index in
                            VStack(spacing: 0) {
                                // 프로필 상단
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.3))
                                        .frame(width: 390, height: 65)

                                    HStack {
                                        Image("profile")
                                            .resizable()
                                            .frame(width: 44, height: 44)

                                        VStack(alignment: .leading) {
                                            Text("susun_hit")
                                                .font(.system(size: 20))
                                                .fontWeight(.semibold)

                                            Text("11:26 PM")
                                                .font(.system(size: 12))
                                                .fontWeight(.regular)

                                        }
                                        Spacer()

                                      
                                    }
                                    .padding()

                                }

                                // 사진 넘기는 영역
                                TabView {
                                    Rectangle()
                                        .frame(width: 393, height: 393)

                                    Rectangle()
                                        .frame(width: 393, height: 393)
                                }
                                .frame(width: 393, height: 393)
                                .tabViewStyle(.page(indexDisplayMode: .always))

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

                                        Text("Like (31)")
                                            .font(.system(size: 20))
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
                                .padding(.top,15)
                            }
                        }

                    }
                }

            }
        }
    }
}

struct HomeGroupView_Previews: PreviewProvider {
    static var previews: some View {
        HomeGroupView()
    }
}
