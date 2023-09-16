//
//  FriendSearchView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct FriendSearchView: View {
    @State var searchText: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userDataModel: UserDataModel
    @State private var activeUserId: String? // Add this line
    
    var body: some View {
        NavigationView {
            VStack {
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
                                                            Text(user.fullid ?? "No Full ID")
                                                                .font(.system(size: 20))
                                                                .foregroundColor(Color.black)
                                                                .fontWeight(.semibold)
                                                            
                                                            Text(user.hastags ?? "No Hashtags")
                                                                .font(.system(size: 12))
                                                                .foregroundColor(Color.black)
                                                                .fontWeight(.regular)
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
            }
            
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
            .environmentObject(AuthViewModel())
            .environmentObject(UserDataModel())
    }
}
