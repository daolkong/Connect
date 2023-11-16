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
    @EnvironmentObject var sharedViewModel : SharedViewModel
    @EnvironmentObject var notificationViewModel : NotificationViewModel
    
    @State private var tabSelection = 1
    @State private var gotoalarm = false
    @State private var gotosetting = false
    
    var body: some View {
        
        VStack(spacing: 30) {
            
            //  커넥트 갤러리
            HStack {
                Image("align-left")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        gotosetting = true
                    }
                NavigationLink(destination: MypageView()
                    .navigationBarBackButtonHidden(true), isActive: $gotosetting) {
                        EmptyView()
                    }
                Spacer()
                
                Text("커넥트 갤러리")
                    .font(.system(size: 23, weight: .bold))
                    .frame(width: 190)
                
                Spacer()
                
                Image("alarm")
                    .resizable()
                    .frame(width: 18, height: 20)
                    .onTapGesture {
                        gotoalarm = true
                    }
                NavigationLink(destination: AlarmConnectView()
                    .navigationBarBackButtonHidden(true), isActive: $gotoalarm) {
                        EmptyView()
                    }
                
            }
            .frame(width: 345, height: 28)
            .padding(.horizontal,10)
            
            Spacer()
            ScrollView() {
                VStack(spacing: 80) {
                    //첫번째 게시물 묶음
                    HStack(spacing:20) {
                        VStack(spacing: 13) {
                            if sharedViewModel.isImageLoaded {
                                HStack(spacing: 17) {
                                    VStack {
                                        ZStack {
                                            TabView() {
                                                if let urlAString = sharedViewModel.userANImageUrls[0],
                                                   let urlA = URL(string: urlAString) {
                                                    KFImage(urlA)
                                                        .cacheOriginalImage()
                                                        .resizable()
                                                        .frame(width: 165, height: 165)
                                                        .cornerRadius(10)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(
                                                                    LinearGradient(
                                                                        gradient: Gradient(stops: [
                                                                            .init(color: Color(red: 0.55, green: 0.68, blue: 0.92), location: 0),
                                                                            .init(color: Color(red: 0.94, green: 0.71, blue: 0.7), location: 1)
                                                                        ]),
                                                                        startPoint: UnitPoint(x: 0.14, y: 0.08),
                                                                        endPoint: UnitPoint(x: 0.87, y: 0.91)
                                                                    ),
                                                                    lineWidth: 5
                                                                )
                                                        )
                                                        .aspectRatio(contentMode: .fill)
                                                        .tag("tag1")
                                                }
                                                
                                                if let urlBString = sharedViewModel.userBNImageUrls[0],
                                                   let urlB = URL(string: urlBString) {
                                                    KFImage(urlB)
                                                        .cacheOriginalImage()
                                                        .resizable()
                                                        .frame(width: 165, height: 165)
                                                        .cornerRadius(10)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(
                                                                    LinearGradient(
                                                                        gradient: Gradient(stops: [
                                                                            .init(color: Color(red: 0.55, green: 0.68, blue: 0.92), location: 0),
                                                                            .init(color: Color(red: 0.94, green: 0.71, blue: 0.7), location: 1)
                                                                        ]),
                                                                        startPoint: UnitPoint(x: 0.14, y: 0.08),
                                                                        endPoint: UnitPoint(x: 0.87, y: 0.91)
                                                                    ),
                                                                    lineWidth: 5
                                                                )
                                                        )
                                                        .aspectRatio(contentMode: .fill)
                                                        .tag("tag1")
                                                } else {
                                                    ProgressView("커넥트 대기중..")
                                                }
                                            }
                                            .shadow(color: .black.opacity(0.25), radius: 2, x: 3, y: 3)
                                            .frame(width: 170, height: 170)
                                            .tabViewStyle(PageTabViewStyle())
                                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                            
                                        }
                                    }
                                }
                                
                                if sharedViewModel.userAIds.count > 0 {
                                    let userAId = sharedViewModel.userAIds[0]
                                    VStack {
                                        Text("\(userAId)")
                                            .foregroundColor(Color(red: 0.33, green: 0.53, blue: 0.84))
                                            .font(.system(size: 17, weight:.bold))
                                        Text("님과 함께한 추억앨범")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 15, weight:.medium))
                                    }
                                    .frame(width: 130)
                                    .multilineTextAlignment(.center)
                                }
                                
                            } else {
                                Image("non")
                                    .resizable()
                                    .frame(width: 165, height: 165)
                                
                                Text("서로의 추억을 만들어보세요!")
                                    .font(.system(size: 15, weight:.bold))
                                    .foregroundColor(Color.black)
                                    .frame(width: 100)
                            }
                        }
                        VStack(spacing: 13) {
                            if sharedViewModel.isImageLoaded {
                                HStack(spacing: 17) {
                                    VStack {
                                        ZStack {
                                            TabView() {
                                                if let urlAString = sharedViewModel.userANImageUrls[1],
                                                   let urlA = URL(string: urlAString) {
                                                    KFImage(urlA)
                                                        .cacheOriginalImage()
                                                        .resizable()
                                                        .frame(width: 165, height: 165)
                                                        .cornerRadius(10)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(
                                                                    LinearGradient(
                                                                        stops: [
                                                                            Gradient.Stop(color: Color(red: 0.13, green: 0.14, blue: 0.14), location: 0.00),
                                                                            Gradient.Stop(color: Color(red: 0.89, green: 0.89, blue: 0.89), location: 1.00),
                                                                        ],
                                                                        startPoint: UnitPoint(x: 0.11, y: 0.1),
                                                                        endPoint: UnitPoint(x: 1, y: 1)
                                                                    ),
                                                                    lineWidth: 5
                                                                )
                                                        )
                                                        .aspectRatio(contentMode: .fill)
                                                        .tag("tag2")
                                                }
                                                
                                                if let urlBString = sharedViewModel.userBNImageUrls[1],
                                                   let urlB = URL(string: urlBString) {
                                                    KFImage(urlB)
                                                        .cacheOriginalImage()
                                                        .resizable()
                                                        .frame(width: 165, height: 165)
                                                        .cornerRadius(10)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(
                                                                    LinearGradient(
                                                                        stops: [
                                                                            Gradient.Stop(color: Color(red: 0.13, green: 0.14, blue: 0.14), location: 0.00),
                                                                            Gradient.Stop(color: Color(red: 0.89, green: 0.89, blue: 0.89), location: 1.00),
                                                                        ],
                                                                        startPoint: UnitPoint(x: 0.11, y: 0.1),
                                                                        endPoint: UnitPoint(x: 1, y: 1)
                                                                    ),
                                                                    lineWidth: 5
                                                                )
                                                        )
                                                        .aspectRatio(contentMode: .fill)
                                                        .tag("tag2")
                                                } else {
                                                    ProgressView("커넥트 대기중..")
                                                }
                                            }
                                            .shadow(color: .black.opacity(0.25), radius: 2, x: 3, y: 3)
                                            .frame(width: 170, height: 170)
                                            .tabViewStyle(PageTabViewStyle())
                                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                        }
                                    }
                                }
                                
                                if sharedViewModel.userAIds.count > 1 {
                                    let userAId = sharedViewModel.userAIds[1]
                                    VStack {
                                        Text("\(userAId)")
                                            .foregroundColor(Color(red: 0.45, green: 0.46, blue: 0.48))
                                            .font(.system(size: 17, weight:.bold))
                                        Text("님과 함께한 추억앨범")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 15, weight:.medium))
                                    }
                                    .frame(width:130)
                                    .multilineTextAlignment(.center)
                                    
                                }
                                
                            } else {
                                Image("non")
                                    .resizable()
                                    .frame(width: 165, height: 165)
                                
                                Text("서로의 추억을 만들어보세요!")
                                    .font(.system(size: 15, weight:.bold))
                                    .foregroundColor(Color.black)
                                    .frame(width: 100)
                            }
                        }
                    }
                    
                    //두번째 게시물 묶음
                    HStack(spacing:20) {
                        VStack(spacing: 13) {
                            if sharedViewModel.isImageLoaded {
                                HStack(spacing: 17) {
                                    VStack {
                                        ZStack {
                                            TabView() {
                                                if let urlAString = sharedViewModel.userANImageUrls[2],
                                                   let urlA = URL(string: urlAString) {
                                                    KFImage(urlA)
                                                        .cacheOriginalImage()
                                                        .resizable()
                                                        .frame(width: 165, height: 165)
                                                        .cornerRadius(10)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(
                                                                    LinearGradient(
                                                                        stops: [
                                                                            Gradient.Stop(color: Color(red: 0.68, green: 0.81, blue: 0.66), location: 0.00),
                                                                            Gradient.Stop(color: Color(red: 0.98, green: 0.86, blue: 0.66), location: 1.00),
                                                                        ],
                                                                        startPoint: UnitPoint(x: 0.13, y: 0.14),
                                                                        endPoint: UnitPoint(x: 1, y: 1)
                                                                    ),
                                                                    lineWidth: 5
                                                                )
                                                        )
                                                        .aspectRatio(contentMode: .fill)
                                                        .tag("tag3")
                                                }
                                                
                                                if let urlBString = sharedViewModel.userBNImageUrls[2],
                                                   let urlB = URL(string: urlBString) {
                                                    KFImage(urlB)
                                                        .cacheOriginalImage()
                                                        .resizable()
                                                        .frame(width: 165, height: 165)
                                                        .cornerRadius(10)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(
                                                                    LinearGradient(
                                                                        stops: [
                                                                            Gradient.Stop(color: Color(red: 0.68, green: 0.81, blue: 0.66), location: 0.00),
                                                                            Gradient.Stop(color: Color(red: 0.98, green: 0.86, blue: 0.66), location: 1.00),
                                                                        ],
                                                                        startPoint: UnitPoint(x: 0.13, y: 0.14),
                                                                        endPoint: UnitPoint(x: 1, y: 1)
                                                                    ),
                                                                    lineWidth: 5
                                                                )
                                                        )
                                                        .aspectRatio(contentMode: .fill)
                                                        .tag("tag3")
                                                } else {
                                                    ProgressView("커넥트 대기중..")
                                                }
                                                
                                            }
                                            .shadow(color: .black.opacity(0.25), radius: 2, x: 3, y: 3)
                                            .frame(width: 170, height: 180)
                                            .tabViewStyle(PageTabViewStyle())
                                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                        }
                                    }
                                }
                                
                                if sharedViewModel.userAIds.count > 2 {
                                    let userAId = sharedViewModel.userAIds[2]
                                    VStack {
                                        Text("\(userAId)")
                                            .foregroundColor(Color(red: 0.44, green: 0.68, blue: 0.44))
                                            .font(.system(size: 17, weight:.bold))
                                        Text("님과 함께한 추억앨범")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 15, weight:.medium))
                                    }
                                    .frame(width:130)
                                    .multilineTextAlignment(.center)
                                }
                                
                            } else {
                                Image("non")
                                    .resizable()
                                    .frame(width: 165, height: 165)
                                
                                Text("서로의 추억을 만들어보세요!")
                                    .font(.system(size: 15, weight:.bold))
                                    .foregroundColor(Color.black)
                                    .frame(width: 100)
                            }
                        }
                        VStack(spacing: 13) {
                            if sharedViewModel.isImageLoaded {
                                HStack(spacing: 17) {
                                    VStack {
                                        ZStack {
                                            TabView() {
                                                if let urlAString = sharedViewModel.userANImageUrls[3],
                                                   let urlA = URL(string: urlAString) {
                                                    KFImage(urlA)
                                                        .cacheOriginalImage()
                                                        .resizable()
                                                        .frame(width: 165, height: 165)
                                                        .cornerRadius(10)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(
                                                                    LinearGradient(
                                                                        stops: [
                                                                            Gradient.Stop(color: Color(red: 0.89, green: 0.78, blue: 0.65), location: 0.00),
                                                                            Gradient.Stop(color: Color(red: 0.21, green: 0.13, blue: 0.13), location: 1.00),
                                                                        ],
                                                                        startPoint: UnitPoint(x: 0.89, y: 0.89),
                                                                        endPoint: UnitPoint(x: 0.08, y: 0.09)
                                                                    ),
                                                                    lineWidth: 5
                                                                )
                                                        )
                                                        .aspectRatio(contentMode: .fill)
                                                        .tag("tag4")
                                                }
                                                if let urlBString = sharedViewModel.userBNImageUrls[3],
                                                   let urlB = URL(string: urlBString) {
                                                    KFImage(urlB)
                                                        .cacheOriginalImage()
                                                        .resizable()
                                                        .frame(width: 165, height: 165)
                                                        .cornerRadius(10)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(
                                                                    LinearGradient(
                                                                        stops: [
                                                                            Gradient.Stop(color: Color(red: 0.89, green: 0.78, blue: 0.65), location: 0.00),
                                                                            Gradient.Stop(color: Color(red: 0.21, green: 0.13, blue: 0.13), location: 1.00),
                                                                        ],
                                                                        startPoint: UnitPoint(x: 0.89, y: 0.89),
                                                                        endPoint: UnitPoint(x: 0.08, y: 0.09)
                                                                    ),
                                                                    lineWidth: 5
                                                                )
                                                        )
                                                        .aspectRatio(contentMode: .fill)
                                                        .tag("tag4")
                                                }  else {
                                                    ProgressView("커넥트 대기중..")
                                                }
                                            }
                                            .shadow(color: .black.opacity(0.25), radius: 2, x: 3, y: 3)
                                            .frame(width: 170, height: 170)
                                            .tabViewStyle(PageTabViewStyle())
                                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                            
                                        }
                                    }
                                }
                                
                                if sharedViewModel.userAIds.count > 3 {
                                    let userAId = sharedViewModel.userAIds[3]
                                    VStack {
                                        Text("\(userAId)")
                                            .foregroundColor(Color(red: 0.68, green: 0.5, blue: 0.49))
                                            .font(.system(size: 17, weight:.bold))
                                        Text("님과 함께한 추억앨범")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 15, weight:.medium))
                                    }
                                    .frame(width:130)
                                    .multilineTextAlignment(.center)
                                    
                                }
                                
                            } else {
                                Image("non")
                                    .resizable()
                                    .frame(width: 165, height: 165)
                                
                                Text("서로의 추억을 만들어보세요!")
                                    .font(.system(size: 15, weight:.bold))
                                    .foregroundColor(Color.black)
                                    .frame(width: 100)
                            }
                        }
                    }
                }
            }
            .onAppear {
                Task.init(priority: .high) {
                    guard let uid = Auth.auth().currentUser?.uid else {
                        print("User is not logged in")
                        return
                    }
                    
                    guard let document = try? await Firestore.firestore().collection("users").document(uid).getDocument(),
                          let dbUser = try? document.data(as: DBUser.self) else {
                        print("Failed to get user document or parse it into DBUser")
                        return
                    }
                    
                    let userId = dbUser.userId
                    
                    do {
                        try await sharedViewModel.loadImagesForToday(userId: userId)
                        sharedViewModel.isImageLoaded = true
                    } catch {
                        print("Failed to load images for today: \(error)")
                        sharedViewModel.isImageLoaded = false
                    }
                    
                    do {
                        sharedViewModel.userAIds = try await sharedViewModel.getFetchedUserAId(from: "ConnectDB", on: Date(), for: userId)
                    } catch {
                        print("Error fetching user A id:", error)
                    }
                }
            }
            
            Spacer()

        }
    }
}

#Preview {
    ConnectTodayView()
        .environmentObject(SharedViewModel())
}
