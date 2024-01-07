//
//  PostRow.swift
//  Connect
//
//  Created by Daol on 10/4/23.
//

import SwiftUI
import Kingfisher
import FirebaseFirestore
import FirebaseAuth
import MessageUI


struct PostRow: View {
    @EnvironmentObject var notificationViewModel : NotificationViewModel
    @State private var profileImageURL: String? = nil
    @State private var likeCount: Int
    @State private var showAlert = false
    @State private var showingActionSheet = false
    @State private var showingAlert = false
    @State private var showingMailView = false
    @State private var isPostHidden = false
    @State private var confirmHidePost = false
    
    private var hiddenPostsKey = "HiddenPostsKey"

    @State private var hiddenPosts: Set<String> // Define the State property
    
    let postData: Post
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter
    }()
    
    init(postData: Post) {
          self.postData = postData
          _likeCount = State(initialValue: postData.likeCount)
          _hiddenPosts = State(initialValue: [])
          let loadedPosts = loadHiddenPosts()
          _hiddenPosts = State(initialValue: loadedPosts)
          isPostHidden = loadedPosts.contains(postData.id ?? "")
      }

    
    func loadProfileImageData(_ uid: String) {
        let db = Firestore.firestore()
        
        db.collection("users").whereField("userId", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching user document:", error.localizedDescription)
                return
            }
            
            guard let document = querySnapshot?.documents.first else {
                print("No documents found for user \(uid)")
                return
            }
            let userData = document.data()
            
            if userData.isEmpty {
                print("User document data is nil for user \(uid)")
                return
            }
            
            guard let profileImageUrl = userData["profileImageURL"] as? String else {
                print("No profile image URL found for user \(uid), full data: \(userData)")
                return
            }
            
            DispatchQueue.main.async {
                self.profileImageURL = profileImageUrl
            }
        }
    }
    
    func timeAgo(date: Date) -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day >= 1 {
            return "\(day)일 전 공유됨"
        } else if let hour = components.hour, hour >= 1 {
            return "\(hour)시간 전 공유됨"
        } else if let minute = components.minute {
            return "\(minute)분 전 공유됨"
        } else {
            return "방금"
        }
    }
    
   
    func hidePost() {
        isPostHidden.toggle()
        let postId = postData.id ?? ""
        if isPostHidden {
            hiddenPosts.insert(postId)
        } else {
            hiddenPosts.remove(postId)
        }
        saveHiddenPosts()
    }
    
    func loadHiddenPosts() -> Set<String> {
            if let decodedData = UserDefaults.standard.data(forKey: hiddenPostsKey),
               let loadedPosts = try? JSONDecoder().decode(Set<String>.self, from: decodedData) {
                return loadedPosts
            }
            return []
        }

        
    func saveHiddenPosts() {
        if let encodedData = try? JSONEncoder().encode(hiddenPosts) {
            UserDefaults.standard.set(encodedData, forKey: hiddenPostsKey)
        }
    }

    // ------------------------------------------------------------------------------------------------------------------
    
    var body: some View {
        if !isPostHidden {
            VStack(spacing:0) {
                // 프로필 상단
                VStack(spacing:0) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.3))
                            .frame(width: UIScreen.main.bounds.width == 430 ? 430 : UIScreen.main.bounds.width == 428 ? 428 : UIScreen.main.bounds.width == 414 ? 414 : UIScreen.main.bounds.width == 393 ? 393 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 375 : UIScreen.main.bounds.width == 320 ? 320 : UIScreen.main.bounds.width == 1024 ? 1024 : UIScreen.main.bounds.width == 1112 ? 1112 : UIScreen.main.bounds.width == 1194 ? 1194 : UIScreen.main.bounds.width == 1366 ? 1366 : 375,
                                   height: 65)

                        HStack {
                            Spacer()
                                .frame(width: 0)
                            if let urlStr = profileImageURL, let url = URL(string: urlStr) {
                                KFImage(url)
                                    .cacheOriginalImage()
                                    .resizable()
                                    .frame(width :44,height :44)
                                    .clipShape(Circle())
                            } else {
                                Image("nonpro")
                                    .resizable()
                                    .frame(width :44,height :44)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(postData.userId)
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text(timeAgo(date: postData.timestamp.dateValue()))
                                    .font(.system(size :12, weight: .regular))
                            }
                            Spacer()
                            
                            Button {
                                confirmHidePost = true
                            } label: {
                                Image("hide")
                                    .resizable()
                                    .frame(width: 21, height: 19)
                            }
                            .alert(isPresented: $confirmHidePost) {
                                Alert(
                                    title: Text("게시물 숨기기"),
                                    message: Text("게시물을 정말 숨기시겠습니까?"),
                                    primaryButton: .default(Text("확인")) {
                                        self.hidePost() // Call hidePost to update and save the changes
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                            
                            Button(action: {
                                self.showingActionSheet = true
                            }) {
                                Image("dot")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            .actionSheet(isPresented: $showingActionSheet) {
                                ActionSheet(title: Text("게시물 신고"), buttons: [
                                    .cancel(Text("취소")),
                                    .default(Text("🚨 이 게시물 신고하기 🚨")) {
                                        // '이 게시물 신고하기' 버튼을 누를 때만 메일 작성 뷰를 띄우도록 설정
                                        self.showingMailView = true
                                    }
                                ])
                            }
                            .sheet(isPresented: $showingMailView) {
                                MailView(isShowing: self.$showingMailView, imageUrl: postData.imageUrl)
                            }
                        }
                        .frame(width: 375)
                    }
                }
                if !isPostHidden {
                    Group {
                        if let imageUrl = URL(string: postData.imageUrl) {
                            KFImage(imageUrl)
                                .cacheOriginalImage()
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width == 430 ? 430 : UIScreen.main.bounds.width == 428 ? 428 : UIScreen.main.bounds.width == 414 ? 414 : UIScreen.main.bounds.width == 393 ? 393 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 375 : UIScreen.main.bounds.width == 320 ? 320 : UIScreen.main.bounds.width == 1024 ? 1024 : UIScreen.main.bounds.width == 1112 ? 1112 : UIScreen.main.bounds.width == 1194 ? 1194 : UIScreen.main.bounds.width == 1366 ? 1366 : 375,
                                       height: UIScreen.main.bounds.width == 430 ? 430 : UIScreen.main.bounds.width == 428 ? 428 : UIScreen.main.bounds.width == 414 ? 414 : UIScreen.main.bounds.width == 393 ? 393 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 375 : UIScreen.main.bounds.width == 320 ? 320 : UIScreen.main.bounds.width == 1024 ? 1024 : UIScreen.main.bounds.width == 1112 ? 1112 : UIScreen.main.bounds.width == 1194 ? 1194 : UIScreen.main.bounds.width == 1366 ? 1366 : 375)
                                .scaledToFill()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            Text("Invalid URL string.")
                                .font(.system(size: 20))
                                .foregroundColor(Color.black)
                        }
                    }
                }
            }
            .onAppear {
                      let loadedPosts = loadHiddenPosts()
                      hiddenPosts = loadedPosts
                      isPostHidden = loadedPosts.contains(postData.id ?? "")
                  }
            
            // 공감과 커넥트 칸
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: UIScreen.main.bounds.width == 430 ? 430 : UIScreen.main.bounds.width == 428 ? 428 : UIScreen.main.bounds.width == 414 ? 414 : UIScreen.main.bounds.width == 393 ? 393 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 375 : UIScreen.main.bounds.width == 320 ? 320 : 375,
                           height: 85)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.96, green: 0.75, blue: 0.74), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.6, green: 0.75, blue: 0.98), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.41, y: -0.95),
                            endPoint: UnitPoint(x: 0.94, y: 1.88)
                        )
                    )
                Button(action:{
                    if let postId = postData.id {
                        notificationViewModel.sendRequest(imageId: postId)
                        showAlert = true
                    } else {
                        print("Post ID is nil")
                    }
                }){
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 210, height: 50)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .inset(by: -1.25)
                                    .stroke(Color(red: 0.96, green: 0.96, blue: 0.96), lineWidth: 2.5)
                            )
                        
                        HStack(spacing: 30) {
                            Image("Connect button")
                                .resizable()
                                .frame(width :31,height :31)
                            
                            Text("커넥트")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color.white)
                        }
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("커넥트 요청이 전송되었습니다"),
                        message: Text("상대방이 요청을 수락하면 서로의 일상이 연결됩니다."),
                        dismissButton: .default(
                            Text("확인")
                                .foregroundColor(.pink)
                        )
                    )
                }
            }
            .onAppear(perform:{
                loadProfileImageData(postData.userId)
            })
        }
           
        
    }
}

struct MailView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    let imageUrl: String // 메일에 첨부할 이미지 URL
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(["daolkong06@gmail.com"]) // 개발자 이메일 주소
        vc.setSubject("부적절한 게시물을 신고합니다")
        vc.setMessageBody("신고할 내용을 작성해주세요", isHTML: false)
        
        // 게시물 이미지를 NSData로 변환하여 첨부
        if let imageData = NSData(contentsOf: URL(string: imageUrl)!) {
            vc.addAttachmentData(imageData as Data, mimeType: "image/jpeg", fileName: "post_image.jpeg")
        }
        
        vc.mailComposeDelegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isShowing: $isShowing, imageUrl: imageUrl)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        
        init(isShowing: Binding<Bool>, imageUrl: String) {
            _isShowing = isShowing
            super.init()
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            if result == .sent {
                isShowing = false
            }
            
            controller.dismiss(animated: true)
        }
    }
    
    
    func showAlert() -> Alert {
        Alert(
            title: Text("Mail Sent"),
            message: Text("Your mail has been sent successfully!"),
            dismissButton: .default(Text("OK"))
        )
    }
}



struct TempPost: Identifiable {
    var id: String?
    let userId: String
    let imageUrl: String
    let timestamp: Date
    var likeCount: Int
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        
        let samplePost = TempPost(id: "1", userId: "TestUser", imageUrl:"https://example.com/image.jpg", timestamp: Date(), likeCount: 10)
        
        let post = Post(id: samplePost.id, userId: samplePost.userId, imageUrl: samplePost.imageUrl, timestamp: Timestamp(date: samplePost.timestamp), likeCount: samplePost.likeCount)
        
        PostRow(postData: post)
    }
}
