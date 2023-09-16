//
//  AlarmLikeView.swift
//  Connect
//
//  Created by Daol on 2023/09/16.
//

import SwiftUI

struct AlarmLikeView: View {
    var body: some View {
        ScrollView {
            ForEach(0..<20, id: \.self) { index in
                
                // 알림창 1
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 369, height: 73)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1137254902, green: 0.1333333333, blue: 0.1333333333, alpha: 0.13)), Color(#colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.01568627451, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                    lineWidth : 2 // Specify your desired line width here
                                ))
                    
                    HStack {
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            Text("susun_hit 님이 회원님의 게시물을 좋아합니다. ")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .frame(width: 300)
                        
                        .padding(.trailing,5)
                        
                        
                        Image("heart button1")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .padding(.leading,30)
                        
                    }
                    .padding(.trailing,50)
                    
                    
                    
                }
            }
      
        }

    }
}

struct AlarmLikeView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmLikeView()
    }
}
