//
//  ProfileImageView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI
import PhotosUI


struct ProfileImageView: View {
    @State var isImageSelected: Bool = false
    @State var selectedItem: PhotosPickerItem? = nil
    @State var selectedImageData: Data? = nil
    @EnvironmentObject var authViewModel: AuthViewModel


    var body: some View {
        ZStack {
            Image("back")
                .resizable()
                .frame(width: 395, height: 877)
        
                VStack(spacing: 60) {
                    
                    Text("Connect")
                        .font(.system(size: 60))
                        .foregroundColor(Color.white)
                        .fontWeight(.black)
                    
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            if isImageSelected == false {
                                ZStack {
                                    Circle()
                                        .frame(width: 166, height: 166)
                                        .foregroundColor(Color(red: 0.5, green: 0.49, blue: 0.49))
                                    
                                    Image("whitechain")
                                        .resizable()
                                        .frame(width: 92, height: 92)
                                    
                                    Image("Plus")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .padding(.top,80)
                                        .padding(.leading,90)

                                }
                            } else {
                                if let urlStr = authViewModel.user?.profileImageURL,
                                   let url = URL(string: urlStr) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                    } placeholder:{
                                        ProgressView()  // 로딩 중일 때 보여줄 뷰
                                    }
                                }
                            }
                        }
                        .onChange(of: selectedItem, perform: { newValue in
                            Task {
                                if let newValue {
                                    do {
                                        if let data = try? await newValue.loadTransferable(type: Data.self) {
                                            selectedImageData = data
                                            isImageSelected = true
                                        }
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        })
              
// ---------------------------------------------------------------------------------------
                }
            
            .padding(.bottom,80)
        }
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView()
    }
}
