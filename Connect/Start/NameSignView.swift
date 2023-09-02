//
//  NamestartView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct NameSignView: View {
    var body: some View {
        ZStack {
            Image("back")
                .resizable()
                .frame(width: 395, height: 877)
            
            VStack(spacing: 60) {
                
                VStack(spacing: 0) {
                    Image("whitechain")
                        .resizable()
                        .frame(width: 145, height: 145)
                    
                    Text("Connect")
                        .font(.system(size: 80))
                        .foregroundColor(Color.white)
                        .fontWeight(.black)
                }
                
                VStack(spacing: 40) {
                    Text("01. 이름을 입력해주세요")
                        .font(.system(size: 28))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 323, height: 48)
                        .background(.white.opacity(0.9))
                        .cornerRadius(50)
                }
            }
            .padding(.bottom,220)
        }
    }
}

struct NameSignView_Previews: PreviewProvider {
    static var previews: some View {
        NameSignView()
    }
}
