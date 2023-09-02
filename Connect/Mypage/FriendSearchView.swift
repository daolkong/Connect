//
//  FriendSearchView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct FriendSearchView: View {
    @State private var searchText: String = "" // $text를 정의

    var body: some View {
        VStack {
            FriendTopNavigationBar(TextLogo: "back1", AlarmItem: "Moment Save")

            // 검색 바
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 355, height: 47)
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
                .padding(.leading, 40)
            }
            
            ScrollView {
                VStack(spacing: 40) {
                    ForEach(0..<40, id: \.self) { index in
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            
                            VStack(alignment: .leading) {
                                Text("susun_hit")
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                
                                Text("# 논어 # 재즈 사랑 # 국어교사 # 유튜버 ")
                                    .font(.system(size: 12))
                                    .fontWeight(.regular)
                            }
                        }
                        .frame(width: 390, height: 49)
                    }
                }
                .padding(.trailing,90)
                .padding(.top,20)


            }
            .frame(width: 390, height: 650)


        }
    }
}

struct FriendSearchView_Previews: PreviewProvider {
    static var previews: some View {
        FriendSearchView()
    }
}
