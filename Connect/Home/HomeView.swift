//
//  HomeView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI
import UIKit
import FirebaseFirestore
import PhotosUI
import FirebaseStorage
import FirebaseAuth

struct HomeView: View {
    @State private var isCameraPresented = true
    @State private var isNavigatingToMyPage = false
    @State private var isNavigatingToHomeGroup = false
    @State private var imageUrls: [String] = [] // 이미지 URL 배열 추가
    @State private var uiImage : UIImage?
    @State private var lastImageCaptureDate: Date?
    @State private var posts: [Post] = []
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userDataModel: UserDataModel
    @EnvironmentObject var imageLoader: ImageLoader
    
    @AppStorage("lastImageCaptureDate") var lastImageCaptureDateString: String = ""
    
    let imageUrl: String
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 10) {
                
                // 상단 탭뷰
                HStack {
                    Image("align-left")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            isNavigatingToMyPage = true
                        }
                    NavigationLink(destination: MypageView()
                        .navigationBarBackButtonHidden(true), isActive: $isNavigatingToMyPage) {
                            EmptyView()
                        }
                    
                    Spacer().frame(width: 105) // 여기에 Spacer 추가
                    
                    Text("Connect")
                        .font(.system(size: 25))
                        .fontWeight(.semibold)
                    
                    Spacer().frame(width: 105) // 여기에 Spacer 추가
                    
                    Image("users")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            isNavigatingToHomeGroup = true
                        }
                    
                    NavigationLink(destination: HomeGroupView()   .navigationBarBackButtonHidden(true), isActive: $isNavigatingToHomeGroup) {
                        EmptyView()
                    }
                }
                
                ScrollView {
                    VStack(spacing: 1) {
                        // 아래 게시물
                        ForEach(posts, id: \.id) { post in // id 파라미터 추가
                            VStack(spacing: -19) {
                                // 프로필 상단
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.3))
                                        .frame(width: 390, height: 65)
                                    
                                    HStack {
                                        Image("profile")
                                            .resizable()
                                            .frame(width: 44, height: 44)
                                        
                                        VStack(alignment: .leading) {
                                            
                                            Text(post.fullid)   // Use the fullId of the post directly
                                                .font(.system(size: 20))
                                                .fontWeight(.semibold)
                                            
                                            Text(dateFormatter.string(from: post.timestamp))
                                                .font(.system(size: 12))
                                                .fontWeight(.regular)
                                            
                                        }
                                        .onAppear(){
                                            userDataModel.fetchUser()
                                        }
                                        
                                        Spacer()
                                    }
                                }
                                .padding()
                                
                                // 사진 넘기는 영역
                                if let imageUrl = URL(string: post.imageUrl) {
                                    AsyncImage(url: imageUrl) { phase in
                                        if let image = phase.image {
                                            image.resizable()
                                        } else if phase.error != nil {
                                            Text("An error occurred")
                                        } else {
                                            Rectangle().frame(width :390,height :390)
                                        }
                                    }
                                    .frame(width :390,height :390)
                                }
                   
                                // 공감과 커넥트 칸
                                HStack(spacing: 36) {
                                    HStack {
                                        Button(action: {
                                            // 버튼이 클릭되었을 때 실행될 액션
                                        }) {
                                            Image("heart button1")
                                                .resizable()
                                                .frame(width: 33, height: 33)
                                        }
                                        
                                        Text("Like")
                                            .font(.system(size:20))
                                            .fontWeight(.semibold)
                                    }
                                    HStack {
                                        Button(action: {
                                            self.imageLoader.sendRequest(imageId: post.id) 
                                        }) {
                                            Image("Connect button")
                                                .resizable()
                                                .frame(width: 33, height: 33)
                                        }
                                        Text("Connect (15)")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.black)
                                        
                                    }
                                }
                                .padding(.top,30)
                            }
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            fetchImages()
                            self.isCameraPresented = true
                            
                            Task.init {
                                do {
                                    try await self.authViewModel.fetchUser()
                                } catch {
                                    print("Error fetching user: \(error)")
                                    
                                }
                            }
                        }
                    }
                    .sheet(isPresented:$isCameraPresented){
                        CameraView(isShown: $isCameraPresented, image: $uiImage)
                            .environmentObject(authViewModel)
                            .onDisappear {
                                // CameraView 가 사라질 때 (사용자가 사진을 찍고 닫았을 때) 이미지 업로드 및 저장
                                if let image = uiImage {
                                    uploadImageToFirestore(image: image)
                                    saveImageCaptureDate()
                                }
                                
                                
                                // 사진이 성공적으로 업로드되고 저장된 후에는 isCameraPresented 를 false 로 설정하여 모달 닫기
                                self.isCameraPresented = false
                                
                                // 다음날 카메라를 다시 표시하기 위해 이미지 캡처 날짜 저장
                                if shouldShowCamera() {
                                    self.isCameraPresented = true
                                }
                            }
                    }
                }
               
                
            }
        }
    }
    
    private func shouldShowCamera() -> Bool {
        
        let todayDate = Calendar.current.startOfDay(for: Date())
        
        if let lastCaptureDate = lastImageCaptureDate {
            return !Calendar.current.isDate(lastCaptureDate, inSameDayAs: todayDate)
            // 이미지를 마지막으로 찍은 날짜와 오늘 날짜를 비교하여 같으면 false를 반환하여 카메라를 열지 않습니다.
        }
        // 날짜를 비교할 수 없으면 true를 반환하여 카메라를 엽니다.
        return true
    }
    
    private func saveImageCaptureDate() {
        lastImageCaptureDate = Date()
        // 날짜를 문자열로 변환하여 UserDefaults에 저장합니다.
        lastImageCaptureDateString = DateFormatter.localizedString(from: lastImageCaptureDate ?? Date(), dateStyle: .short, timeStyle: .none)
    }
    
    private func uploadImageToFirestore(image: UIImage) {
        // Firestore에 업로드할 이미지 데이터
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        Task.init{
            do {
                try await self.authViewModel.fetchUser()
                
                guard let fullId = self.authViewModel.user?.fullid else {
                    print("No Full ID found")
                    return
                }
                                
                let timestamp = Date() // 현재 시간을 타임스탬프로 사용
                let imageName = UUID().uuidString
                
                if imageName.isEmpty {
                             print("Error generating imageName.")
                             return
                         }
                         
                let storageRef = Storage.storage().reference()
                let imagesRef = storageRef.child("images/\(imageName).jpg")
                
                _ = imagesRef.putData(imageData, metadata: nil) { (metadata, error) in
                    guard metadata != nil else {
                        print("Error uploading image.")
                        return
                    }
                    
                    imagesRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            print("Error getting download URL.")
                            return
                        }
                        
                        // Firestore에 업로드할 데이터 구성 및 Post 객체 생성 후 사전 변환
                        let postObject = Post(id: imageName, fullid: fullId , imageUrl:downloadURL.absoluteString , timestamp :timestamp)

                        // Post 객체를 사전으로 변환합니다.
                        let postDict = postObject.asDictionary()
                        
                        // Firestore에 데이터 추가
                        
                         Firestore.firestore().collection("posts").addDocument(data: postDict){ error in
                             if error != nil {
                                 print(error!.localizedDescription)
                             } else {
                                 print("Document added successfully!")
                             }
                         }

                    }
                    
                 }

            } catch {
                 print(error.localizedDescription)
             }

         }

    }

    private func fetchImages() {
        let db = Firestore.firestore()

        db.collection("posts").order(by: "timestamp", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            } else if querySnapshot?.documents.isEmpty ?? true {
                print("No documents found in the posts collection.")
                return
            } else {
                DispatchQueue.main.async { // 메인 스레드에서 UI 업데이트 수행
                    self.posts = querySnapshot!.documents.compactMap { document in
                        // Document exists check 추가
                        guard document.exists else {
                            print("Document does not exist")
                            return nil
                        }
                        
                        if let fullid = document.data()["fullid"] as? String,
                           let url = document.data()["imageUrl"] as? String,
                           let timestampData = document.data()["timestamp"] as? Timestamp {

                            // Create a new post and add it to the array.
                            return Post(id: document.documentID, fullid: fullid, imageUrl:url, timestamp: timestampData.dateValue())
                        } else {
                            return nil

                        }
                    }
                }
            }
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    
    @EnvironmentObject var authViewModel: AuthViewModel  // Add this line
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary // Use the photo library interface
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isShown: Bool
        @Binding var image: UIImage?
        
        init(isShown : Binding<Bool>, image : Binding<UIImage?>) {  // Add 'image1' binding here.
            _isShown = isShown
            _image = image
            
            super.init()
            
            AVCaptureDevice.requestAccess(for:.video) { (granted) in // Request authorization for camera access.
                if !granted { print("Error - AVCaptureDevice authorization status not authorized.") }
            }
            
            PHPhotoLibrary.requestAuthorization { (status) in // Request authorization for photo library access.
                switch status {
                case .authorized:
                    break
                    
                default:
                    print("Error - PHPhotoLibrary authorization status not authorized.")
                    break
                    
                }
                
            }
            
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                return
            }
            
            // 선택한 이미지를 처리합니다.
            if self.image == nil {
                self.image = selectedImage
                
                // 두 장의 사진 모두 선택되었으므로 isShown 상태 변수를 false로 설정하여 카메라 뷰(모달)를 닫습니다.
                self.isShown = false
            }
        }
        
    }
    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(imageUrl:"").environmentObject(ImageLoader())
    }
}
