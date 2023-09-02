//
//  HashtagSignView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct HashtagSignView: View {
    @State private var text: String = "" // $text를 정의

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
                    Text("02. 나를 나타낼 수 있는 해시태그 4개!")
                        .font(.system(size: 28))
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .frame(width: 310)
                    
                    TextField("", text: $text)
                        .frame(width: 323, height: 48)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(50)

                }
            }
            .padding(.bottom,220)
        }
    }
}

struct HashtagSignView_Previews: PreviewProvider {
    static var previews: some View {
        HashtagSignView()
    }
}
