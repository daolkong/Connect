//
//  FriendSearchView.swift
//  Connect
//
//  Created by Daol on 2023/09/08.
//

import SwiftUI
import Kingfisher

struct FriendSearchView: View {
    @State private var tabSelection = 1
    @State private var searchText: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userDataModel: UserDataModel
    @State private var activeUserId: String?

    var body: some View {
        VStack(spacing: 20) {
            // Friend search title
            HStack {
                Text("친구검색")
                    .font(.system(size: 23, weight: .bold))
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width == 430 ? 390 : UIScreen.main.bounds.width == 393 ? 348 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 330 : UIScreen.main.bounds.width == 320 ? 320 : 375,
                   height: 17)
            // friend search bar
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: UIScreen.main.bounds.width == 430 ? 390 : UIScreen.main.bounds.width == 393 ? 355 : UIScreen.main.bounds.width == 390 ? 340 : UIScreen.main.bounds.width == 375 ? 340 : UIScreen.main.bounds.width == 320 ? 250 : 375,
                           height: UIScreen.main.bounds.height == 932 ? 47 : UIScreen.main.bounds.height == 852 ? 42 : UIScreen.main.bounds.height == 844 ? 47 : UIScreen.main.bounds.height == 812 ? 47 : UIScreen.main.bounds.height == 667 ? 42 : UIScreen.main.bounds.height)
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

                    TextField("Search...", text: $searchText)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color(red: 0.52, green: 0.69, blue: 0.94))
                }
                .padding(.leading, 40)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 35) {

                    ForEach(userDataModel.users.filter({ user in
                        searchText.isEmpty ? true : user.userId.lowercased().contains(searchText.lowercased())
                    }), id: \.uid) { user in
                        NavigationLink(destination: FriendProfileView(user: user)
                            .navigationBarBackButtonHidden(true),
                                       isActive: Binding(
                                           get: { self.activeUserId == user.uid },
                                           set: { _ in self.activeUserId = nil })) {
                            HStack {
                                HStack {
                                    if let urlStr = user.profileImageURL, let url = URL(string: urlStr) {
                                        KFImage(url)
                                            .cacheOriginalImage()
                                            .resizable()
                                            .frame(width: 44, height: 44)
                                            .clipShape(Circle())
                                    } else {
                                        Image("nonpro")
                                            .resizable()
                                            .frame(width: 44, height: 44)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(user.userId)
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(Color.black)

                                        Text(user.hastags)
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(Color.black)
                                    }
                                }
                                Spacer()
                            }
                            .onTapGesture {
                                self.activeUserId = user.uid
                            }
                        }
                    }
                    
                    if userDataModel.users.isEmpty {
                        ProgressView("데이터를 불러오는 중 입니다...") // Message to display while loading data
                            .progressViewStyle(CircularProgressViewStyle())
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 30) // add padding
            }
            .frame(width: UIScreen.main.bounds.width == 430 ? 390 : UIScreen.main.bounds.width == 393 ? 355 : UIScreen.main.bounds.width == 390 ? 340 : UIScreen.main.bounds.width == 375 ? 325 : UIScreen.main.bounds.width == 320 ? 250 : 375)
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
