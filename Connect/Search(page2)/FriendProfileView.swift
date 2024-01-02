//
//  FriendProfileView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI
import Kingfisher

struct FriendProfileView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var userDataModel = UserDataModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingAlert = false
    
    let user : DBUser
    var uid: String?
    
    func addFriend(_ friendUser: DBUser) {
        guard let currentUser = authViewModel.currentUser else {
            print("Error: No current user found")
            return
        }
        userDataModel.addFriend(currentUser.uid , friendUser.uid) { result in
            switch result {
            case .success():
                print("Successfully added friend to current user's friends list")
                userDataModel.getCurrentUser(uid: authViewModel.uid)
                userDataModel.getCurrentUser(uid: friendUser.uid)
            case .failure(let error):
                print("Error adding friend to current user's friends list: \(error)")
            }
        }
        userDataModel.addFriend(friendUser.uid, currentUser.uid) { result in
            switch result {
            case .success():
                print("Successfully added current user to friend's friends list")
                userDataModel.getCurrentUser(uid: authViewModel.uid)
                userDataModel.fetchUser()
            case .failure(let error):
                print("Error adding current user to friend's friends list: \(error)")
            }
        }
    }

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 430, height: 844)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.96, green: 0.67, blue: 0.45), location: 0.00),
                            Gradient.Stop(color: .white, location: 1.00),
                        ],
                        startPoint: UnitPoint(x: -0.09, y: -0.13),
                        endPoint: UnitPoint(x: 1.07, y: 1.02)
                    )
                )
            VStack(spacing: 30) {
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 11) {
                        Image("back1")
                            .resizable()
                            .frame(width: 10, height: 16)
                        Spacer()
                    }
                }
                .frame(width: UIScreen.main.bounds.width == 430 ? 390 : UIScreen.main.bounds.width == 393 ? 353 : UIScreen.main.bounds.width == 390 ? 350 : UIScreen.main.bounds.width == 375 ? 335 : UIScreen.main.bounds.width == 320 ? 280 : 375,
                       height:15)
                
                if let urlStr = user.profileImageURL, let url = URL(string: urlStr) {
                    KFImage(url)
                        .cacheOriginalImage()
                        .resizable()
                        .frame(width: 195, height: 195)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.25), radius: 3.5, x: 0, y: 0)
                    
                } else {
                    Image("nonpro")
                        .resizable()
                        .frame(width: 195, height: 195)
                }
                
                VStack(spacing: 10) {
                    Text(user.userId)
                        .font(.system(size: 45, weight:.bold))
                    
                    Text(user.hastags)
                        .font(.system(size: 17))
                    
                }
                
                VStack {
                    // 친구 수
                    HStack(spacing: 20){
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 65, height: 59)
                                .background(Color(red: 0.13, green: 0.14, blue: 0.14))
                                .cornerRadius(20)
                            
                            Image("pp")
                                .resizable()
                                .frame(width: 25, height: 20)
                        }
                        
                        Image("lline")
                            .resizable()
                            .frame(width: 34, height: 4)
                        
                        Text("\(userDataModel.user?.friends.count ?? 0)")
                            .font(.system(size: 30, weight:.semibold))
                          
                    }
                    
                    // 친구추가 버튼
                    Button(action: {
                        addFriend(user)
                        self.showingAlert = true
                        self.userDataModel.getCurrentUser(uid: authViewModel.uid)
                    }) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color(red: 0.96, green: 0.75, blue: 0.58))
                                .frame(width: 244, height: 65)
                                .cornerRadius(40)
                            
                            // 펜 모양
                            ZStack {
                                Circle()
                                    .foregroundColor(Color.white)
                                    .frame(width: 35, height: 35)
                                
                                Image("plus 1")
                                    .resizable()
                                    .frame(width: 11, height: 11)
                            }
                            .padding(.trailing, 130)
                            
                            Text("친구추가")
                                .font(.system(size: 20, weight:.bold))
                                .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.14))
                                .padding(.leading,30)
                        }
                    }
                    .padding(.top, 30)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("친구추가 완료"), message: Text("친구추가 되었습니다"), dismissButton: .default(Text("확인")))
                    }
                }
                .padding(.top,30)
            }
            .onAppear() {
                userDataModel.fetchUser()
                userDataModel.getCurrentUser(uid: authViewModel.uid)
            }
            .padding(.bottom, 50)
        }
    }
    
    init(user: DBUser) {
        self.user = user
    }
}

#Preview {
    FriendProfileView(user: DBUser(email: "test@test.com", userId:"TestFullID", hastags:"TestHashtags", uid:"TestUID", profileImageURL:"", uploadedImagesURLs:[], friends: []))
}
