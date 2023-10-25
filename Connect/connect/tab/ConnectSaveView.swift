//
//  ConnectSaveView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct ConnectSaveView: View {
    @State private var searchText: String = "" // $text를 정의

    var body: some View {
        NavigationView {
            VStack(spacing: 35) {
                // 검색 바
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 318, height: 47)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .inset(by: 1)
                                .stroke(Color(red: 0.52, green: 0.69, blue: 0.94), lineWidth: 2)
                        )

                    HStack(spacing: 15) {
                        Image("search")
                            .resizable()
                            .frame(width: 17, height: 17)

                        Image("Vector 27")
                            .resizable()
                            .frame(width: 1, height: 14)

                        TextField("Search...", text: $searchText) // 여기서 searchText는 문자열 바인딩 변수여야 합니다.
                            .font(.system(size: 17))
                            .fontWeight(.regular)
                            .foregroundColor(Color(red: 0.52, green: 0.69, blue: 0.94))
                    }
                    .padding(.leading, 60)
                }

                // 게시물
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
                                    .font(.subheadline)
                                    .font(.system(size: 17))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.33, green: 0.53, blue: 0.84))
                                    .frame(width: 111, height: 41)
                            }
                            // 갤러리 2
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
                        }
                        // 2번째줄
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
                        }
                        // 3번째줄
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
                        }
                        // 4번째줄
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
                        }
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
                        }
                 
                     
                    }
                }
                
                Spacer()
            }
        }
    }
}


struct ConnectSaveView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectSaveView()
    }
}
