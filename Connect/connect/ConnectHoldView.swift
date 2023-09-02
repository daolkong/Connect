//
//  ConnectHoldView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct ConnectHoldView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 35) {
                ConnectTopNavigationBar(imageLogo: "alarm", TextLogo: "align-left", AlarmItem: "Connect Gallery")
                // 스위치
                ZStack {
                    Rectangle()
                        .frame(width: 185, height: 64)
                        .background(Color(red: 0.12, green: 0.14, blue: 0.14))
                        .cornerRadius(35)
                    ZStack {
                        Circle()
                            .frame(width: 46, height: 46)
                            .foregroundColor(Color(red: 0.52, green: 0.69, blue: 0.94))
                        
                        Text("오늘")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                    }
                    .padding(.trailing,110)
                    
                    Text("보관함")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.leading,110)
                    
                    
                }
                
                ScrollView {
                    VStack {
                        // 1번째줄
                        HStack(spacing: 17) {
                            // 갤러리 1
                            VStack {
                                ZStack {
                                    Image("connect1")
                                        .resizable()
                                        .frame(width: 159, height: 159)
                                    
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 159, height: 159)
                                        .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.35))
                                        .cornerRadius(21)
                                    
                                    Image("profile")
                                        .resizable()
                                        .frame(width: 47, height: 47)
                                        .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                        .padding(.leading,50)
                                        .padding(.top,50)
                                    
                                    Image("Mask group")
                                        .resizable()
                                        .frame(width: 47, height: 47)
                                        .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                        .padding(.leading,90)
                                        .padding(.top,90)
                                    
                                }
                                Text("# 운동 # 일상")
                                    .font(.system(size: 17))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.33, green: 0.53, blue: 0.84))
                                    .frame(width: 111, height: 41)
                            }
                            // 갤러리 2
                            VStack {
                                ZStack {
                                    Image("12")
                                        .resizable()
                                        .frame(width: 159, height: 159)
                                    
                                    Image("profile")
                                        .resizable()
                                        .frame(width: 47, height: 47)
                                        .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                        .padding(.trailing,55)
                                        .padding(.top,70)
                                    
                                    Image("Mask group")
                                        .resizable()
                                        .frame(width: 47, height: 47)
                                        .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                        .padding(.leading,72)
                                        .padding(.bottom,70)
                                }
                                
                                Text("커넥트대기중    ..jy200..")
                                    .font(.system(size: 17))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    .frame(width: 95, height: 41)
                                    
                            }
                        }
                        // 2번째줄
                        HStack(spacing: 17) {
                            // 갤러리 1
                                VStack {
                                    Image("non")
                                        .resizable()
                                        .frame(width: 159, height: 159)
                                    
                                    Text("서로의 추억을 만들어보세요!")
                                        .font(.system(size: 17))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                        .frame(width: 111, height: 41)
                                }
                                // 갤러리 2
                                VStack {
                                    Image("non")
                                        .resizable()
                                        .frame(width: 159, height: 159)
                                    
                                    Text("서로의 추억을 만들어보세요!")
                                        .font(.system(size: 17))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                        .frame(width: 111, height: 41)
                                }
                            
                            
                            
                            
                        }
                     
                    }
                }
                
            }
        }
    }
}

struct ConnectHoldView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectHoldView()
    }
}
