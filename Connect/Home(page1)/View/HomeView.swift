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
    @State private var imageUrls: [String] = []
    @State private var uiImage : UIImage?
    @State private var lastImageCaptureDate: Date?
    @State private var posts: [Post] = []
    @State private var lastDocumentSnapshot: DocumentSnapshot?
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
                    Spacer()
                    Text("Link life")
                        .font(.system(size: 28, weight:.black))
                    Spacer()
                    
                    Circle()
                        .foregroundColor(.clear)
                        .frame(width: 24, height: 24)
                }
                .padding(.horizontal,10)
                
                ScrollView {
                    LazyVStack(spacing :1){
                        ForEach(posts) { post in
                            PostRow(postData: post)
                        }
                    }
                    .padding(.bottom, 25)
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
        lastImageCaptureDateString = DateFormatter.localizedString(from: lastImageCaptureDate ?? Date(), dateStyle: .short, timeStyle: .none)
    }
    
    private func uploadImageToFirestore(image: UIImage) {
        guard let resizedImage = image.resized(toWidth : 393),
              let imageData = resizedImage.jpegData(compressionQuality : 1) else{
            print("Failed to convert image to data.")
            return
        }
        
        Task.init{
            do {
                try await self.authViewModel.fetchUser()
                
                guard let userId = authViewModel.user?.userId else {
                    print("No Full ID found")
                    return
                }
                
                let timestamp = Timestamp(date: Date())
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
                        
                        let postObject = Post(id: imageName,
                                              userId: userId,
                                              imageUrl: downloadURL.absoluteString,
                                              timestamp: timestamp,
                                              likeCount: 0)
                        
                        let postDict = postObject.asDictionary()
                        
                        Firestore.firestore().collection("posts").addDocument(data: postDict){ error in
                            if let err = error {
                                print(err.localizedDescription)
                            } else {
                                print("Document added successfully!")
                                
                                isUploaded = true
                                
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
        guard !isLoading else { return }
        
        isLoading = true
        
        let db = Firestore.firestore()
        
        let query: Query = db.collection("posts").order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { (querySnapshot, err) in
            defer { self.isLoading = false }
            
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
                    print("No posts found for user \(userId).")
                    completion(nil)
                    return
                } else {
                    if let document = querySnapshot?.documents.first,
                       let timestampData = document.data()["timestamp"] as? Timestamp {
                        completion(timestampData.dateValue())
                        return
                    }
                    
                    print("'timestamp' field is missing or not in expected format for user \(userId).")
                    completion(nil)
                }
            }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isShown: Bool
        @Binding var image: UIImage?
        
        init(isShown : Binding<Bool>, image : Binding<UIImage?>) {
            _isShown = isShown
            _image = image
            
            super.init()
            
            AVCaptureDevice.requestAccess(for:.video) { (granted) in
                if !granted { print("Error - AVCaptureDevice authorization status not authorized.") }
            }
            
            PHPhotoLibrary.requestAuthorization { (status) in
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
            
            if self.image == nil {
                self.image = selectedImage
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

#Preview {
    HomeView(imageUrl:"")
}
