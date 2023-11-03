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
    @State private var lastDocumentSnapshot: DocumentSnapshot? // 마지막으로 가져온 DocumentSnapshot 저장
    @State private var isLoading = false
    @State private var isUploaded = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userDataModel: UserDataModel
    @EnvironmentObject var notificationViewModel : NotificationViewModel
    
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
                        .font(.system(size: 25, weight:.semibold))
                    
                    Spacer().frame(width: 105) // 여기에 Spacer 추가
                    
                    Image("users")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            isNavigatingToHomeGroup = true
                        }
                    
                    NavigationLink(destination: HomeGroupView()
                        .navigationBarBackButtonHidden(true), isActive: $isNavigatingToHomeGroup) {
                            EmptyView()
                        }
                }
                
                ScrollView {
                    LazyVStack(spacing :1){
                        // 아래 게시물
                        ForEach(posts) { post in
                            PostRow(postData: post)
                        }
                    }
                    .sheet(isPresented:$isCameraPresented){
                        CameraView(isShown:$isCameraPresented,image:$uiImage).environmentObject(authViewModel)
                    }
                }
            }
            .onAppear(perform:{
                fetchImages()
                
                guard let userId = authViewModel.user?.userId else {
                    self.isCameraPresented = true
                    return
                }
                
                fetchLatestPostTimestamp(forUser : userId) { date in
                    if let lastCaptureDate = date {
                        DispatchQueue.main.async {
                            let timeInterval = Date().timeIntervalSince(lastCaptureDate)
                            self.isCameraPresented = timeInterval < 24 * 60 * 60 ? false : true
                        }
                    } else {
                        DispatchQueue.main.async{
                            self.isCameraPresented = true
                        }
                    }
                }
            })
            
            .onDisappear(perform:{
                if let image = uiImage, isUploaded == false {
                    uploadImageToFirestore(image:image)
                    saveImageCaptureDate()
                }
                
                guard let userId = authViewModel.user?.userId else {
                    // Instead of 'return', set isCameraPresented to true and exit.
                    self.isCameraPresented = true
                    return
                }
                
                fetchLatestPostTimestamp(forUser : userId) { date in
                    if let lastCaptureDate = date {
                        DispatchQueue.main.async {
                            self.isCameraPresented =
                            !Calendar.current.isDate(lastCaptureDate,inSameDayAs : Date())
                        }
                    } else {
                        DispatchQueue.main.async{
                            self.isCameraPresented = true
                        }
                    }
                }
            })
            
        }
    }
    
    private func saveImageCaptureDate() {
        lastImageCaptureDate = Date()
        // 날짜를 문자열로 변환하여 UserDefaults에 저장합니다.
        lastImageCaptureDateString = DateFormatter.localizedString(from: lastImageCaptureDate ?? Date(), dateStyle: .short, timeStyle: .none)
    }
    
    private func uploadImageToFirestore(image: UIImage) {
        // Firestore에 업로드할 이미지 데이터
        guard let resizedImage = image.resized(toWidth : 500),
              let imageData = resizedImage.jpegData(compressionQuality : 1) else{
            print("Failed to convert image to data.")
            return
        }
        
        Task.init{
            do {
                try await self.authViewModel.fetchUser()
                
                guard let userId = authViewModel.user?.userId else { // Change from 'fullId' to 'userId'
                    print("No Full ID found")
                    return
                }
                
                let timestamp = Timestamp(date: Date()) // 현재 시간을 타임스탬프로 사용, 수정된 부분입니다.
                let imageName = UUID().uuidString
                
                if imageName.isEmpty {
                    print("Error generating imageName.")
                    return
                }
                
                let storageRef = Storage.storage().reference()
                let imagesRef = storageRef.child("images/\(imageName).jpg")
                
                imagesRef.putData(imageData, metadata: nil) { (metadata, error) in
                    guard let _ = metadata else {
                        // Uh-oh, an error occurred!
                        print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    guard metadata != nil else {
                        print("Metadata is nil.")
                        return
                    }
                    
                    imagesRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                            return
                        }
                        
                        // Firestore에 업로드할 데이터 구성 및 Post 객체 생성 후 사전 변환
                        let postObject = Post(id: imageName,
                                              userId: userId,
                                              imageUrl: downloadURL.absoluteString,
                                              timestamp: timestamp,
                                              likeCount: 0) // 'likeCount'를 추가했습니다.

                        // Post 객체를 사전으로 변환합니다.
                        let postDict = postObject.asDictionary()
                        
                        
                        // Firestore에 데이터 추가
    

                        Firestore.firestore().collection("posts").addDocument(data: postDict){ error in  // Removed [weak self]
                            if let err = error {
                                print(err.localizedDescription)
                            } else {
                                print("Document added successfully!")
                                
                                isUploaded = true   // <- 이곳으로 옮김.
                                
                                fetchLatestPostTimestamp(forUser : userId) { date in  // Fetch the latest timestamp after upload.
                                    if let lastCaptureDate = date {
                                        DispatchQueue.main.async {
                                            self.isCameraPresented =
                                            !Calendar.current.isDate(lastCaptureDate,inSameDayAs : Date())
                                        }
                                    } else {
                                        DispatchQueue.main.async{
                                            self.isCameraPresented = true  // If no posts are found for the user after upload.
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    func fetchImages() {
        guard !isLoading else { return }  // 이미 데이터를 불러오고 있다면 중복해서 불러오기 방지
        
        isLoading = true
        
        let db = Firestore.firestore()
        
        var query: Query = db.collection("posts").order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { (querySnapshot, err) in
            //        query.limit(to: 10).addSnapshotListener { (querySnapshot, err) in
            defer { self.isLoading = false }  // 데이터 로딩이 끝났음을 표시
            
            if let err = err {
                print("Error fetching documents:", err.localizedDescription)
                return
                
            } else if querySnapshot?.documents.isEmpty ?? true {
                
                print("No documents found in the posts collection.")
                return
                
            } else {
                
                DispatchQueue.main.async {
                    
                    self.posts = querySnapshot!.documents.compactMap { document in
                        if document.exists {
                            if let userId = document.data()["userId"] as? String,
                               let imageUrl = document.data()["imageUrl"] as? String,
                               let timestampData = document.data()["timestamp"] as? Timestamp {

                                return Post(id: document.documentID, userId: userId, imageUrl: imageUrl, timestamp: timestampData,likeCount: 0)
                            } else {
                                print("Failed to create a Post object from the data of Document ID \(document.documentID). Check whether all necessary fields are present and in correct format.")
                            }
                        } else {
                            print("Document does not exist for Document ID \(document.documentID)")
                        }

                        return nil
                    }

                }
            }
        }
    }
    
    private func fetchLatestPostTimestamp(forUser userId: String, completion: @escaping (Date?) -> Void) {
        let db = Firestore.firestore()

        db.collection("posts")
            .whereField("userId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .limit(to: 1)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print(err.localizedDescription)
                    completion(nil)
                    return
                } else if querySnapshot?.documents.isEmpty ?? true {
                    print("No posts found for user \(userId).")  // Print the user ID as well.
                    completion(nil)
                    return
                } else {
                    if let document = querySnapshot?.documents.first,
                       let timestampData = document.data()["timestamp"] as? Timestamp {
                        // Return the timestamp of the latest post.
                        completion(timestampData.dateValue())
                        return
                    }
                    
                    // If 'timestamp' field is not found or not in expected format,
                    // print an error message and complete with nil.
                    print("'timestamp' field is missing or not in expected format for user \(userId).")  // Print the user ID as well.
                    completion(nil)
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
        picker.sourceType = .camera // Use the photo library interface
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

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(imageUrl:"")
    }
}
