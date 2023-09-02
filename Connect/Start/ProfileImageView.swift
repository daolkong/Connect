//
//  ProfileImageView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct ProfileImageView: View {
    var body: some View {
        ZStack {
            Image("back")
                .resizable()
                .frame(width: 395, height: 877)
            
            
                
                VStack(spacing: 60) {
                    Text("Connect")
                        .font(.system(size: 60))
                        .foregroundColor(Color.white)
                        .fontWeight(.black)
                    ZStack {
                        Circle()
                            .frame(width: 166, height: 166)
                            .foregroundColor(Color(red: 0.5, green: 0.49, blue: 0.49))
                        
                        Image("whitechain")
                            .resizable()
                            .frame(width: 92, height: 92)
                        
                        Image("Plus")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.top,80)
                            .padding(.leading,90)

                    }
                    
                    Text("프로필 사진을 등록해 주세요!")
                        .font(.system(size: 28))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.white)
                            .frame(width: 214, height: 61)
                            .cornerRadius(50)
                        
                        Text("건너뛰기")
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                    }
                }
            
            .padding(.bottom,100)
        }
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView()
    }
}
