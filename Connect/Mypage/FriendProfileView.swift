//
//  FriendProfileView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct FriendProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userDataModel: UserDataModel
    @Environment(\.presentationMode) var presentationMode
    
    let user : User
    var uid: String? // 'uid'의 접근 제어 수준을 변경
    
    func addFriend(_ friendUser: User) {
        guard let currentUser = authViewModel.currentUser else {
            print("Error: No current user found")
            return
        }
        
        // Add friendUser's uid to currentUser's friends list
        userDataModel.addFriend(currentUser.uid , friendUser.uid) { result in
            switch result {
            case .success():
                print("Successfully added friend to current user's friends list")
            case .failure(let error):
                print("Error adding friend to current user's friends list: \(error)")
            }
        }
        
        // Add currentUser's uid to friendUser's friends list
        userDataModel.addFriend(friendUser.uid, authViewModel.uid) { result in  // <-- Here
            switch result {
            case .success():
                print("Successfully added current user to friend's friends list")
            case .failure(let error):
                print("Error adding current user to friend's friends list: \(error)")
            }
        }
    }
    
    var body: some View {
        ZStack {
            Image("Rectangle 19")
                .resizable()
                .frame(width: 394, height: 844)
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
                    // Dismiss the view when the button is tapped
                    presentationMode.wrappedValue.dismiss()
                }) {
                    ProfileTopNavigationBar(TextLogo: "back1")
                }
                
                
                Image("profile")
                    .resizable()
                    .frame(width: 195, height: 195)
                    .shadow(color: .black.opacity(0.25), radius: 3.5, x: 0, y: 0)
                VStack(spacing: 10) {
                    Text(user.fullid ?? "No Full ID")
                        .font(.system(size: 45))
                        .fontWeight(.bold)
                    
                    Text(user.hastags ?? "No Full ID")
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
                        
                        Text("\(user.friends.count)") // Show the number of friends of the user.
                            .font(.system(size: 30))
                            .fontWeight(.semibold)
                        
                    }
                    
                    // 총 커넥트 횟수(요청)
                    HStack(spacing: 20) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 65, height: 59)
                                .background(Color(red: 0.13, green: 0.14, blue: 0.14))
                                .cornerRadius(20)
                            
                            Image("ccc")
                                .resizable()
                                .frame(width: 35, height: 35)
                        }
                        
                        Image("lline")
                            .resizable()
                            .frame(width: 34, height: 4)
                        
                        Text("21")
                            .font(.system(size: 30))
                            .fontWeight(.semibold)
                        
                    }
                    
                    // 정보수정 버튼
                    Button(action: {
                        // Add your action here when the button is tapped
                        addFriend(user)
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
                                .font(.system(size: 20))
                                .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.14))
                                .fontWeight(.bold)
                                .padding(.leading,30)
                            
                        }
                    }
                    
                    
                    
                    .padding(.top, 30)
                    
                }
                .padding(.top,30)
            }
            .padding(.bottom,30)

            
        }
        .onAppear() {
            userDataModel.fetchUser()
            userDataModel.getCurrentUser(uid: authViewModel.uid)
        }
    }
        
        init(user: User) {
            self.user = user
        }
}

struct FriendProfileView_Previews: PreviewProvider {
    static var previews: some View {
        FriendProfileView(user: User(email: "test@test.com", fullid:"TestFullID", hastags:"TestHashtags", uid:"TestUID", profileImageURL:"", uploadedImagesURLs:[], friends: []))
            .environmentObject(AuthViewModel())
            .environmentObject(UserDataModel())
    }
}
