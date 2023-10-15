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
    @State private var tabSelection = 1
    @State private var postsA: [Post] = []  // Posts from user A
    @State private var postsB: [Post] = []  // Posts from user B
    @EnvironmentObject var sharedViewModel : SharedViewModel  // 추가된 부분
    
    var body: some View {
        VStack(spacing: 35) {
            ScrollView {
                VStack(spacing: 90) {
                    
                    //첫번째 게시물 묶음
                    HStack {
                        VStack(spacing: 13) {
                            HStack(spacing: 17) {
                                VStack {
                                    ZStack {
                                        TabView(selection: $tabSelection) {
                                            ForEach(postsA, id:\.id) { post in
                                                let url = URL(string: post.imageUrl)
                                                KFImage(url)
                                                    .setProcessor(RoundCornerImageProcessor(cornerRadius: 20)) // For rounded corners
                                                    .resizable()
                                                    .frame(width: 159, height: 159)
                                                    .cornerRadius(10)
                                                    .tag(1)
                                            }
                                            
                                            ForEach(postsB, id:\.id) { post in
                                                let url = URL(string: post.imageUrl)
                                                KFImage(url)
                                                    .resizable()
                                                    .frame(width: 159, height: 159)
                                                    .cornerRadius(10)
                                                    .tag(2)
                                            }
                                        }
                                        .tabViewStyle(PageTabViewStyle())
                                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                        
                                        Image("profile")
                                            .resizable()
                                            .frame(width: 47, height: 47)
                                            .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                            .padding(.leading,50)
                                            .padding(.top,50)
                                        
                                        Image("Mask group")
                                            .resizable()
                                            .frame(width: 47, height: 47)
                                            .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                            .padding(.leading,90)
                                            .padding(.top,90)
                                    }
                                }
                            }
                            Text("엘범명을 정해주세요")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.33, green: 0.53, blue: 0.84))
                        }
                        VStack(spacing: 13) {
                            HStack(spacing: 17) {
                                VStack {
                                    ZStack {
                                        TabView(selection: $tabSelection) {
                                            ForEach(postsA, id:\.id) { post in
                                                let url = URL(string: post.imageUrl)
                                                KFImage(url)
                                                    .resizable()
                                                    .frame(width: 159, height: 159)
                                                    .cornerRadius(10)
                                                    .tag(1)
                                            }
                                            
                                            ForEach(postsB, id:\.id) { post in
                                                let url = URL(string: post.imageUrl)
                                                KFImage(url)
                                                    .resizable()
                                                    .frame(width: 159, height: 159)
                                                    .cornerRadius(10)
                                                    .tag(2)
                                            }
                                        }
                                        .tabViewStyle(PageTabViewStyle())
                                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                        
                                        Image("profile")
                                            .resizable()
                                            .frame(width: 47, height: 47)
                                            .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                            .padding(.leading,50)
                                            .padding(.top,50)
                                        
                                        Image("Mask group")
                                            .resizable()
                                            .frame(width: 47, height: 47)
                                            .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                            .padding(.leading,90)
                                            .padding(.top,90)
                                    }
                                }
                            }
                            
                            Text("엘범명을 정해주세요")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.33, green: 0.53, blue: 0.84))
                        }
                    }
                    
                    //두번째 게시물 묶음
                    HStack {
                        VStack(spacing: 13) {
                            HStack(spacing: 17) {
                                VStack {
                                    ZStack {
                                        TabView(selection: $tabSelection) {
                                            ForEach(postsA, id:\.id) { post in
                                                let url = URL(string: post.imageUrl)
                                                KFImage(url)
                                                    .resizable()
                                                    .frame(width: 159, height: 159)
                                                    .cornerRadius(10)
                                                    .tag(1)
                                            }
                                            
                                            ForEach(postsB, id:\.id) { post in
                                                let url = URL(string: post.imageUrl)
                                                KFImage(url)
                                                    .resizable()
                                                    .frame(width: 159, height: 159)
                                                    .cornerRadius(10)
                                                    .tag(2)
                                            }
                                        }
                                        .tabViewStyle(PageTabViewStyle())
                                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                        
                                        Image("profile")
                                            .resizable()
                                            .frame(width: 47, height: 47)
                                            .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                            .padding(.leading,50)
                                            .padding(.top,50)
                                        
                                        Image("Mask group")
                                            .resizable()
                                            .frame(width: 47, height: 47)
                                            .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                            .padding(.leading,90)
                                            .padding(.top,90)
                                    }
                                }
                            }
                            Text("엘범명을 정해주세요")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.33, green: 0.53, blue: 0.84))
                        }
                        
                        VStack(spacing: 13) {
                            HStack(spacing: 17) {
                                VStack {
                                    ZStack {
                                        TabView(selection: $tabSelection) {
                                            ForEach(postsA, id:\.id) { post in
                                                let url = URL(string: post.imageUrl)
                                                KFImage(url)
                                                    .resizable()
                                                    .frame(width: 159, height: 159)
                                                    .cornerRadius(10)
                                                    .tag(1)
                                            }
                                            
                                            ForEach(postsB, id:\.id) { post in
                                                let url = URL(string: post.imageUrl)
                                                KFImage(url)
                                                    .resizable()
                                                    .frame(width: 159, height: 159)
                                                    .cornerRadius(10)
                                                    .tag(2)
                                            }
                                        }
                                        .tabViewStyle(PageTabViewStyle())
                                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                        
                                        Image("profile")
                                            .resizable()
                                            .frame(width: 47, height: 47)
                                            .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                            .padding(.leading,50)
                                            .padding(.top,50)
                                        
                                        Image("Mask group")
                                            .resizable()
                                            .frame(width: 47, height: 47)
                                            .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                            .padding(.leading,90)
                                            .padding(.top,90)
                                    }
                                }
                            }
                            
                            Text("엘범명을 정해주세요")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.33, green: 0.53, blue: 0.84))
                        }
                    }
                }
            }
        }.onAppear(perform : loadPosts)
        
    }
    
    func loadPosts() {
        
        let userAFullID = sharedViewModel.userAFullID // SharedViewModel로부터 사용자 이름 가져오기
        let userBFullID = sharedViewModel.userBFullID
        
        Firestore.firestore().collection("posts").whereField("userId", in: [userAFullID]).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.postsA = querySnapshot!.documents.compactMap({ document -> Post? in
                    let data = document.data()
                    let id = document.documentID
                    return Post(id: id, userId: data["userId"] as? String ?? "", imageUrl: data["imageUrl"] as? String ?? "", timestamp: data["timestamp"] as? Timestamp ?? Timestamp())
                })
            }
        }
        
        sharedViewModel.updateToUserInNotification(notificationId:"userBFullID")  // Update the user B Id before loading posts
        Firestore.firestore().collection("posts").whereField("userId", in:[sharedViewModel.userBFullID]).getDocuments() { (querySnapshot,error) in
            
            Firestore.firestore().collection("posts").whereField("userId", in: [userBFullID]).getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.postsB = querySnapshot!.documents.compactMap({ document -> Post? in
                        let data = document.data()
                        let id = document.documentID
                        return Post(id: id, userId: data["userId"] as? String ?? "", imageUrl: data["imageUrl"] as? String ?? "", timestamp: data["timestamp"] as? Timestamp ?? Timestamp())
                    })
                }
            }
            
        }
    }
}

struct ConnectTodayView_Previews : PreviewProvider {
    static var previews:some View {
        ConnectTodayView()
            .environmentObject(SharedViewModel()) // sharedViewModel 인스턴스 생성
    }
}
