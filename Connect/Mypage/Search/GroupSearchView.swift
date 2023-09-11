//
//  GroupSearchView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct GroupSearchView: View {
    @State private var searchText: String = "" // $text를 정의
    
    var body: some View {
        VStack {

            // 검색 바
            
            ScrollView {
                VStack(spacing: 40) {
                    ForEach(0..<40, id: \.self) { index in
                        HStack {
                            ZStack {
                                Image("profile")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .shadow(color: .black.opacity(0.15), radius: 3.5, x: 0, y: 0)
                                    .padding(.trailing,20)
                                    .padding(.bottom,30)

                                Image("pro3")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .shadow(color: .black.opacity(0.15), radius: 3.5, x: 0, y: 0)
                                    .padding(.leading,20)
                                    .padding(.bottom,10)
                                
                                Image("pro2")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .shadow(color: .black.opacity(0.15), radius: 3.5, x: 0, y: 0)
                                    .padding(.trailing,18)
                                    .padding(.top,10)
                         
                            }
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text("우리들의 헬스모임 ")
                                    .font(.system(size: 17)) // 이 부분은 원하는 폰트 크기로 변경
                                    .fontWeight(.semibold)
                                    + Text("(100+)")
                                    .font(.system(size: 13)) // 변경할 폰트 크기로 설정
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 0.42, green: 0.61, blue: 0.89))
                                
                                Text("하루에 한번 모임 만남을 가집니다. 근손실 방지방지!!!")
                                    .font(.system(size: 12))
                                    .fontWeight(.regular)
                            }
                        }
                        .frame(width: 390, height: 49)
                    }
                }
                .padding(.trailing,40)
                .padding(.top,20)


            }
            .frame(width: 390, height: 650)
        }
    }
}

struct GroupSearchView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSearchView()
    }
}
