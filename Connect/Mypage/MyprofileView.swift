//
//  MyprofileView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI
import Foundation
import PhotosUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MyprofileView: View {
    @StateObject var authViewModel = AuthViewModel()
    @State private var profileImage: UIImage? // This will hold the selected image.
    @State private var isShowingImagePicker = false // This will control the showing of the image picker.
    @State private var profileImageURL: String?
    
    @Environment(\.scenePhase) private var scenePhase

    
    // 현재 로그인한 사용자의 UID를 가져오는 computed property입니다. 만약 로그인한 사용자가 없다면 빈 문자열을 반환합니다.
    public var uid: String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 390, height: 844)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: .white, location: 0.00),
                            Gradient.Stop(color: Color(red: 0.7, green: 0.8, blue: 0.96), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.87, y: 0.98),
                        endPoint: UnitPoint(x: 0.21, y: 0.08)
                    )
                )
            
            VStack(spacing: 65) {
                // 프로필 이미지
                VStack(spacing: 25) {
                    Button(action: { isShowingImagePicker.toggle() }) {
                        if let urlStr = profileImageURL, let url = URL(string: urlStr) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .frame(width: 166, height: 166)
                                    .scaledToFill()
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        } else if let img = profileImage {
                            Image(uiImage: img)
                                .resizable()
                                .frame(width: 166, height: 166)
                                .scaledToFill()
                                .clipShape(Circle())
                        } else {
                            Image("profileplus")
                                .resizable()
                                .frame(width: 166, height: 166)
                        }
                    }
                    .sheet(isPresented: $isShowingImagePicker) {
                        PHPickerView(image: $profileImage)
                    }
                    
                    
                    // 사용자 아이디
                    VStack(spacing: 10) {
                        Text(authViewModel.user?.userId ?? "Loading...")
                            .font(.system(size: 45))
                            .fontWeight(.bold)
                        
                        // 해시태그 4개
                        HStack {
                            Text("# 논어")
                                .font(.system(size: 17))
                                .fontWeight(.regular)
                            
                            Text("# 재즈 사랑")
                                .font(.system(size: 17))
                                .fontWeight(.regular)
                            
                            Text("# 유튜버")
                                .font(.system(size: 17))
                                .fontWeight(.regular)
                            
                            Text("# 국어교사")
                                .font(.system(size: 17))
                                .fontWeight(.regular)
                        }
                    }
                }
                
                VStack {
                    // 친구 수
                    HStack(spacing: 20) {
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
                        
                        Text("18")
                            .font(.system(size: 30))
                            .fontWeight(.semibold)
                        
                    }
                    
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
                    
                }
                .padding(.bottom, 30)
            }
            
            // 총 커넥트 횟수(요청)
        }
        .onChange(of: profileImage) { newImage in
            if let newImage = newImage {
                Task.init {
                    do {
                        self.profileImageURL = try await authViewModel.saveProfileImage(newImage)
                    } catch {
                        print("Failed to save profile image:", error)
                    }
                }
            }
        }
        .onAppear(perform:{
            loadProfileImageData()
            Task.init {
                do {
                    try await authViewModel.fetchUser()
                } catch {
                    print("Failed to fetch user:", error)
                }
            }
        })
           

        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .active {
                loadProfileImageData()
            }
        }
        
    }
    
    func loadProfileImageData() {
        let db = Firestore.firestore()

        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No current user ID found")
            return
        }

        db.collection("users").document(currentUserId).getDocument { (userDocSnapshot, error) in
            if let error = error {
                print("Error fetching user document:", error.localizedDescription)
                return
            }
            
            guard let userData = userDocSnapshot?.data(),
                  let profileImageUrl = userData["profileImageURL"] as? String else {
                print("No profile image URL found for user \(currentUserId)")
                return
            }
            
            DispatchQueue.main.async{
                self.profileImageURL = profileImageUrl
            }
        }
    }
}

struct MyprofileView_Previews: PreviewProvider {
    static var previews: some View {
        MyprofileView()
    }
}
