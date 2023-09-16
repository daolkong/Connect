//
//  ConnectTodayView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI
import URLImage
import FirebaseFirestore
import FirebaseAuth

struct ConnectTodayView: View {
    @State private var tabSelection = 1
    @State private var posts: [Post] = []
    
    var body: some View {
        VStack(spacing: 35) {
            ScrollView {
                VStack {
                    // 1번째줄
                    HStack(spacing: 17) {
                        VStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 159, height: 159)
                                    .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.3))
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
                                
                                
                                Text("커넥트 앨범의 이름을 정해주세요")
                                    .font(.system(size :17))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                            }
                            
                            
                            Image("12")
                                .resizable()
                                .frame(width: 159, height: 159)
                            
                            Text("커넥트 대기중")
                                .font(.system(size :17 ))
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                            
                            
                            Image("non")
                                .resizable()
                                .frame(width: 159, height: 159)
                            
                            
                            Text("서로의 추억을 만들어보세요!")
                                .font(.system(size :17 ))
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                        }
                    }
                }
            }
        }
    }
    
    
}

struct ConnectTodayView_Previews: PreviewProvider {
    static var previews:some View{
        ConnectTodayView()
    }
}

