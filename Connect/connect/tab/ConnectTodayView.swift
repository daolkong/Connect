//
//  ConnectTodayView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI
import URLImage
import FirebaseFirestore
import FirebaseAuth
import Kingfisher

struct ConnectTodayView: View {
    @EnvironmentObject var sharedViewModel : SharedViewModel  // 추가된 부분
    @EnvironmentObject var notificationViewModel : NotificationViewModel
    
    @State var album1: String = "앨범명을 정해주세요"
    @State var album2: String = "앨범명을 정해주세요"
    @State var album3: String = "앨범명을 정해주세요"
    @State var album4: String = "앨범명을 정해주세요"
    
    
    var body: some View {
        VStack(spacing: 35) {
            ScrollView {
                VStack(spacing: 70) {
                    
                    //첫번째 게시물 묶음
                    HStack(spacing:20) {
                        VStack(spacing: 13) {
                            if sharedViewModel.tabSelection1 == 0 {
                                Image("non")
                                    .resizable()
                                    .frame(width: 159, height: 159)
                                
                                Text("서로의 추억을 만들어보세요!")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    .frame(width: 100)
                                
                            } else {
                                HStack(spacing: 17) {
                                    VStack {
                                        ZStack {
                                            TabView(selection: $sharedViewModel.tabSelection1) {
                                                ForEach((sharedViewModel.postsA1 + sharedViewModel.postsB1), id:\.tag) { post in
                                                    let url = URL(string: post.imageUrl)
                                                    KFImage(url)
                                                        .resizable()
                                                        .frame(width: 159, height: 159)
                                                        .cornerRadius(10)
                                                        .aspectRatio(contentMode: .fill)
                                                        .tag(post.tag)
                                                }
                                            }
                                            .frame(width: 159, height: 159)
                                            .tabViewStyle(PageTabViewStyle())
                                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                            
                                            if let profileImageUrlString = sharedViewModel.fromUserProfileImageUrls[0],
                                               let profileImageUrl = URL(string: profileImageUrlString) {
                                                KFImage(profileImageUrl)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,50)
                                                    .padding(.top,40)
                                            } else {
                                                Image("nonpro")
                                                    .resizable()
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,50)
                                                    .padding(.top,40)
                                            }
                                            
                                            if let currentUserProfileImageUrlString = sharedViewModel.currentUserProfileImageUrl,
                                               let currentUserProfileImageUrl = URL(string: currentUserProfileImageUrlString) {
                                                KFImage(currentUserProfileImageUrl)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,90)
                                                    .padding(.top,80)
                                            } else {
                                                Image("nonpro1")
                                                    .resizable()
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,90)
                                                    .padding(.top,80)
                                            }
                                            
                                        }
                                    }
                                }
                                TextField("", text: $album1)
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 0.33, green: 0.53, blue: 0.84))
                                    .frame(width:130)
                            }
                        }
                        VStack(spacing: 13) {
                            if sharedViewModel.tabSelection1 == 0 {
                                Image("non")
                                    .resizable()
                                    .frame(width: 159, height: 159)
                                
                                Text("서로의 추억을 만들어보세요!")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    .frame(width: 100)
                                
                            } else {
                                HStack(spacing: 17) {
                                    VStack {
                                        ZStack {
                                            TabView(selection: $sharedViewModel.tabSelection2) {
                                                ForEach((sharedViewModel.postsA2 + sharedViewModel.postsB2), id:\.tag) { post in
                                                    let url = URL(string: post.imageUrl)
                                                    KFImage(url)
                                                        .resizable()
                                                        .frame(width: 159, height: 159)
                                                        .cornerRadius(10)
                                                        .aspectRatio(contentMode: .fill)
                                                        .tag(post.tag)
                                                }
                                            }
                                            .frame(width: 159, height: 159)
                                            .tabViewStyle(PageTabViewStyle())
                                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                            
                                            if let profileImageUrlString = sharedViewModel.fromUserProfileImageUrls[1],
                                               let profileImageUrl = URL(string: profileImageUrlString) {
                                                KFImage(profileImageUrl)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,50)
                                                    .padding(.top,40)
                                            } else {
                                                Image("nonpro")
                                                    .resizable()
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,50)
                                                    .padding(.top,40)
                                            }
                                            
                                            if let currentUserProfileImageUrlString = sharedViewModel.currentUserProfileImageUrl,
                                               let currentUserProfileImageUrl = URL(string: currentUserProfileImageUrlString) {
                                                KFImage(currentUserProfileImageUrl)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,90)
                                                    .padding(.top,80)
                                            } else {
                                                Image("nonpro1")
                                                    .resizable()
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,90)
                                                    .padding(.top,80)
                                            }
                                            
                                        }
                                    }
                                }
                                TextField("", text: $album2)
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 0.33, green: 0.53, blue: 0.84))
                                    .frame(width:130)
                                
                            }
                        }
                    }
                    
                    //두번째 게시물 묶음
                    HStack(spacing:20) {
                        VStack(spacing: 13) {
                            if sharedViewModel.tabSelection1 == 0 {
                                Image("non")
                                    .resizable()
                                    .frame(width: 159, height: 159)
                                
                                Text("서로의 추억을 만들어보세요!")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    .frame(width: 100)
                                
                            } else {
                                HStack(spacing: 17) {
                                    VStack {
                                        ZStack {
                                            TabView(selection: $sharedViewModel.tabSelection3) {
                                                ForEach((sharedViewModel.postsA3 + sharedViewModel.postsB3), id:\.tag) { post in
                                                    let url = URL(string: post.imageUrl)
                                                    KFImage(url)
                                                        .resizable()
                                                        .frame(width: 159, height: 159)
                                                        .cornerRadius(10)
                                                        .tag(post.tag)
                                                }
                                                
                                            }
                                            .frame(width: 159, height: 159)
                                            .tabViewStyle(PageTabViewStyle())
                                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                            
                                            if let profileImageUrlString = sharedViewModel.fromUserProfileImageUrls[2],
                                               let profileImageUrl = URL(string: profileImageUrlString) {
                                                KFImage(profileImageUrl)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,50)
                                                    .padding(.top,40)
                                            } else {
                                                Image("nonpro")
                                                    .resizable()
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,50)
                                                    .padding(.top,40)
                                            }
                                            
                                            if let currentUserProfileImageUrlString = sharedViewModel.currentUserProfileImageUrl,
                                               let currentUserProfileImageUrl = URL(string: currentUserProfileImageUrlString) {
                                                KFImage(currentUserProfileImageUrl)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,90)
                                                    .padding(.top,80)
                                            } else {
                                                Image("nonpro1")
                                                    .resizable()
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,90)
                                                    .padding(.top,80)
                                            }
                                        }
                                    }
                                }
                                TextField("", text: $album3)
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 0.33, green: 0.53, blue: 0.84))
                                    .frame(width:130)
                            }
                        }
                        VStack(spacing: 13) {
                            if sharedViewModel.tabSelection1 == 0 {
                                Image("non")
                                    .resizable()
                                    .frame(width: 159, height: 159)
                                
                                Text("서로의 추억을 만들어보세요!")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    .frame(width: 100)
                                
                            } else {
                                HStack(spacing: 17) {
                                    VStack {
                                        ZStack {
                                            TabView(selection: $sharedViewModel.tabSelection4) {
                                                ForEach((sharedViewModel.postsA4 + sharedViewModel.postsB4), id:\.tag) { post in
                                                    let url = URL(string: post.imageUrl)
                                                    KFImage(url)
                                                        .resizable()
                                                        .frame(width: 159, height: 159)
                                                        .cornerRadius(10)
                                                        .tag(post.tag)
                                                }
                                            }
                                            .frame(width: 159, height: 159)
                                            .tabViewStyle(PageTabViewStyle())
                                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                            
                                            if let profileImageUrlString = sharedViewModel.fromUserProfileImageUrls[3],
                                               let profileImageUrl = URL(string: profileImageUrlString) {
                                                KFImage(profileImageUrl)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,50)
                                                    .padding(.top,40)
                                            } else {
                                                Image("nonpro")
                                                    .resizable()
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,50)
                                                    .padding(.top,40)
                                            }
                                            
                                            if let currentUserProfileImageUrlString = sharedViewModel.currentUserProfileImageUrl,
                                               let currentUserProfileImageUrl = URL(string: currentUserProfileImageUrlString) {
                                                KFImage(currentUserProfileImageUrl)
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,90)
                                                    .padding(.top,80)
                                            } else {
                                                Image("nonpro1")
                                                    .resizable()
                                                    .frame(width: 47, height: 47)
                                                    .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                                    .padding(.leading,90)
                                                    .padding(.top,80)
                                            }
                                        }
                                    }
                                }
                                
                                TextField("", text: $album4)
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 0.33, green: 0.53, blue: 0.84))
                                    .frame(width:130)
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            Task.init(priority : .high) { [weak sharedViewModel] in
                guard let viewModel = sharedViewModel else { return }
                
                guard let notification = notificationViewModel.notifications.first else {
                    print("No notifications found.")
                    return
                }
                let fromUserId = notification.fromUserId
                
                await viewModel.loadUserProfileImage(userId: fromUserId) // Use the sender's user id here.
                await viewModel.loadCurrentUserProfileImage()
                
            }
        }
        .onAppear(perform: {
            if sharedViewModel.tabSelection1 == 1 {
                sharedViewModel.tabSelection1 = 0
            }
            if sharedViewModel.tabSelection2 == 2 {
                sharedViewModel.tabSelection2 = 0
            }
            if sharedViewModel.tabSelection3 == 3 {
                sharedViewModel.tabSelection3 = 0
            }
            if sharedViewModel.tabSelection4 == 4 {
                sharedViewModel.tabSelection4 = 0
            }
        })
    }
}

struct ConnectTodayView_Previews : PreviewProvider {
    static var previews:some View {
        ConnectTodayView()
            .environmentObject(SharedViewModel()) // sharedViewModel 인스턴스 생성
    }
}

