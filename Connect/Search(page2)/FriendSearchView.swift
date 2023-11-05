//
//  Time_sellectView.swift
//  Connect
//
//  Created by Daol on 2023/09/08.
//

import SwiftUI

struct FriendSearchView: View {
    @State private var tabSelection = 1
    @State private var searchText: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userDataModel: UserDataModel
    @State private var activeUserId: String? 
    
    var body: some View {
        VStack {
            HStack {
                Text("친구 검색")
                    .font(.system(size: 23, weight:.bold))
                Spacer()
            }
            .padding(.horizontal,35)
            .frame(width: 390, height: 27)
            
            // 친구 검색 바
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
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color(red: 0.52, green: 0.69, blue: 0.94))
                }
                .padding(.leading, 40)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 35) {
                    ForEach(userDataModel.users, id: \.uid) { user in
                        NavigationLink(destination: FriendProfileView(user: user)
                            .navigationBarBackButtonHidden(true), // 이 부분 수정
                                       isActive:
                                        Binding(
                                            get:{ self.activeUserId == user.uid },
                                            set:{ _ in self.activeUserId = nil })) {
                                                
                                                HStack {
                                                    Image("profile")
                                                        .resizable()
                                                        .frame(width: 44, height: 44)
                                                    
                                                    VStack(alignment: .leading) {
                                                        Text(user.userId ?? "No Full ID")
                                                            .font(.system(size: 20, weight:.semibold))
                                                            .foregroundColor(Color.black)
                                                        
                                                        Text(user.hastags ?? "No Hashtags")
                                                            .font(.system(size: 12, weight:.regular))
                                                            .foregroundColor(Color.black)
                                                    }
                                                }
                                                .onTapGesture{
                                                    self.activeUserId = user.uid
                                                }
                                                
                                                .frame(width: 390, height: 49)
                                            }
                    }
                    
                }
                .padding(.trailing, 190)
                .padding(.top, 20)
            }
            .frame(width: 390, height: 650)
            
            .onAppear() {
                userDataModel.fetchUser()
                userDataModel.fetchUsers()
            }
        }
    }
}

struct FriendSearchView_Previews: PreviewProvider {
    static var previews: some View {
        FriendSearchView()
    }
}
