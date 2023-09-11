//
//  FriendSearchView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct FriendSearchView: View {
    @State  var searchText: String = ""
    @StateObject  var authViewModel = AuthViewModel()
    @StateObject  var userDataModel = UserDataModel()

    var body: some View {
        NavigationView {
            
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 35) {
                        ForEach(userDataModel.users, id: \.uid) { user in
                            NavigationLink(destination: FriendProfileView(user: user)) {
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
