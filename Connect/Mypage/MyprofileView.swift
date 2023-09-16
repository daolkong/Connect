//
//  MyprofileView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI
import PhotosUI

struct MyprofileView: View {
    @StateObject var authViewModel = AuthViewModel() // 'private' 제거
    @StateObject var userDataModel = UserDataModel() // 'private' 제거
    @State var isImageSelected: Bool = false
    @State var selectedItem: PhotosPickerItem? = nil
    @State var selectedImageData: Data? = nil
    
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
           
            
            VStack(spacing: 25) {
                ZStack {
                    Circle()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.white.opacity(0.6))
                    
                    Image("pen")
                        .resizable()
                        .frame(width: 17, height: 17)
                }
                .padding(.leading, 280)
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        if isImageSelected == false {
                            ZStack {
                                Circle()
                                    .frame(width: 180, height: 180)
                                    .foregroundColor(Color(red: 0.5, green: 0.49, blue: 0.49))
                                
                                Image("whitechain")
                                    .resizable()
                                    .frame(width: 96, height: 96)
                                
                                Image("Plus")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(.top, 80)
                                    .padding(.leading, 90)
                            }
                        } else {
                            if selectedImageData != nil,
                               let uiImage = UIImage(data: selectedImageData!) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 180, height: 180)
                                    .background {
                                        Circle().fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.yellow, .orange]),
                                                startPoint: .top,
                                                endPoint: .bottom))
                                    }
                                    .task {
                                        do {
                                            _ = try await authViewModel.saveProfileImage(uiImage)
                                        } catch {
                                            print("Failed to save profile image: \(error)")
                                        }
                                    }
                            }
                        }
                    }
                    .onChange(of: selectedItem) { newValue in
                        Task {
                            if newValue != nil {
                                do {
                                    selectedImageData = try await newValue!.loadTransferable(type: Data.self)
                                    isImageSelected = true
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                
                VStack(spacing: 10) {
                    Text("susun_hit")
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
                }
                .padding(.top, 60)
            }
            .padding(.bottom, 80)
        }
    }
}

struct MyprofileView_Previews: PreviewProvider {
    static var previews: some View {
        MyprofileView()
    }
}
