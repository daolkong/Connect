//
//  MyprofileView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct MyprofileView: View {
    var body: some View {
        ZStack {
            Image("Rectangle 19")
                .frame(width: 394, height: 844)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.95, green: 0.67, blue: 0.45), location: 0.00),
                            Gradient.Stop(color: .white, location: 1.00),
                        ],
                        startPoint: UnitPoint(x: -0.09, y: -0.13),
                        endPoint: UnitPoint(x: 1.07, y: 1.02)
                    )
                )
            
            VStack(spacing: 30) {
                ProfileTopNavigationBar(imageLogo: "Search2", TextLogo: "back1", AlarmItem: "Profile")
                
                Image("profile")
                    .resizable()
                    .frame(width: 195, height: 195)
                    .shadow(color: .black.opacity(0.25), radius: 3.5, x: 0, y: 0)
                VStack(spacing: 10) {
                    Text("susun_hit")
                        .font(.system(size: 45))
                        .fontWeight(.bold)
                    
                    // 해시태그 4개
                    HStack {
                        Text("# 논어")
                            .font(.system(size: 17))
                            .fontWeight(.regular)
                        
                        Text("# 재즈 사랑")
                            .font(.system(size: 17))
                            .fontWeight(.regular)
                        
                        Text("# 유튜버")
                            .font(.system(size: 17))
                            .fontWeight(.regular)
                        
                        Text("# 국어교사")
                            .font(.system(size: 17))
                            .fontWeight(.regular)
                    }
                    
                }
                
                VStack {
                    // 친구 수
                    HStack(spacing: 20){
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 65, height: 59)
                                .background(Color(red: 0.13, green: 0.14, blue: 0.14))
                                .cornerRadius(20)
                            
                            Image("pp")
                                .resizable()
                                .frame(width: 25, height: 20)
                        }
                        
                        Image("lline")
                            .resizable()
                            .frame(width: 34, height: 4)
                        
                        Text("18")
                            .font(.system(size: 30))
                            .fontWeight(.semibold)
                        
                    }
                    
                    // 총 커넥트 횟수(요청)
                    HStack(spacing: 20) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 65, height: 59)
                                .background(Color(red: 0.13, green: 0.14, blue: 0.14))
                                .cornerRadius(20)
                            
                            Image("ccc")
                                .resizable()
                                .frame(width: 35, height: 35)
                        }
                        
                        Image("lline")
                            .resizable()
                            .frame(width: 34, height: 4)
                        
                        Text("21")
                            .font(.system(size: 30))
                            .fontWeight(.semibold)
                        
                    }
                    
                    // 정보수정 버튼
                    Button(action: {
                        // Add your action here when the button is tapped
                    }) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color(red: 0.97, green: 0.7, blue: 0.49).opacity(0.77))
                                .frame(width: 244, height: 65)
                                .cornerRadius(40)
                            
                            // 펜 모양
                            ZStack {
                                Circle()
                                    .foregroundColor(Color.white)
                                    .frame(width: 35, height: 35)
                                
                                Image("pen")
                                    .resizable()
                                    .frame(width: 17, height: 17)
                            }
                            .padding(.trailing, 130)
                            
                            Text("정보수정")
                                .font(.system(size: 20))
                                .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.14))
                                .fontWeight(.bold)
                                .padding(.leading, 30)
                            
                        }
                    }
                    .padding(.top, 30)
                    
                }
                .padding(.top,60)
            }
            .padding(.bottom,30)
        }
    }
}

struct MyprofileView_Previews: PreviewProvider {
    static var previews: some View {
        MyprofileView()
    }
}
