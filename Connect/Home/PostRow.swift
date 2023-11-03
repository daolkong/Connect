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

struct PostRow: View {
    @EnvironmentObject var notificationViewModel : NotificationViewModel
    @State private var profileImageURL: String? = nil
    @State private var likeCount: Int
    
    
    let postData: Post  
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter
    }()
    
    init(postData: Post) {
        self.postData = postData
        _likeCount = State(initialValue: postData.likeCount)
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
    
    var body: some View {
        
        VStack(spacing: -19) {
            // 프로필 상단
            ZStack {
                Rectangle()
                    .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.3))
                    .frame(width: 390, height: 65)
                
                HStack {
                    if let urlStr = profileImageURL, let url = URL(string: urlStr) {
                        KFImage(url)
                            .resizable()
                            .frame(width :44,height :44)
                            .clipShape(Circle()) // 프로필 사진을 원 모양으로 클리핑합니다.
                    } else {
                        Image("nonpro")
                            .resizable()
                            .frame(width :44,height :44)
                    }
                    
                    VStack(alignment: .leading) {
                        
                        Text(postData.userId)   // Use the fullId of the post directly
                            .font(.system(size: 20, weight: .semibold))
                        
                        Text("\(postData.timestamp.dateValue())") // Use the timestamp of the post directly.
                            .font(.system(size :12, weight: .regular))
                    }
                    
                    Spacer()
                }
            }
            .padding()
            
            // 사진 넘기는 영역
            Group {
                if let imageUrl = URL(string: postData.imageUrl) {
                    KFImage(imageUrl)
                        .resizable()
                        .frame(width: 390, height: 390) // 사진 크기 설정
                        .scaledToFill() // 추가된 코드
                        .aspectRatio(contentMode: .fit)
                } else {
                    Text("Invalid URL string.")
                        .font(.system(size: 20))
                        .foregroundColor(Color.black)
                }
            }
            
            // 공감과 커넥트 칸
            HStack(spacing :36){
                
                Button(action:{
                    guard let currentUser = Auth.auth().currentUser else {
                        print("No user is currently logged in.")
                        return
                    }
                    
                    let userID = currentUser.uid
                    let db = Firestore.firestore()
                    let likeDocRef = db.collection("likes").document(self.postData.id ?? "")
                    
                    likeDocRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            var likedUsers = document.data()?["users"] as? [String] ?? []
                            if let index = likedUsers.firstIndex(of: userID) {
                                likedUsers.remove(at: index)
                                self.likeCount -= 1  // Modify this line.
                            } else {
                                likedUsers.append(userID)
                                self.likeCount += 1  // Modify this line.
                            }
                            
                            likeDocRef.setData(["users": likedUsers], merge: true)
                            db.collection("posts").document(self.postData.id ?? "").updateData([
                                "likeCount": self.likeCount  // Modify this line.
                            ])
                        } else {
                            likeDocRef.setData(["users": [userID]], merge: true)
                            db.collection("posts").document(self.postData.id ?? "").updateData([
                                "likeCount": self.likeCount  // Modify this line.
                            ])
                        }
                    }
                }){
                    HStack {
                        Image("heart button1")
                            .resizable()
                            .frame(width :33,height :33)
                        
                        Text("Like(\(self.likeCount))")  // Modify this line.
                            .font(.system(size: 20))
                            .foregroundColor(Color.black)
                    }
                }
                
                Button(action:{
                    if let postId = postData.id {
                        notificationViewModel.sendRequest(imageId: postId)
                    } else {
                        print("Post ID is nil")
                    }
                }){
                    HStack {
                        Image("Connect button")
                            .resizable()
                            .frame(width :33,height :33)
                        
                        Text("Connect(31)")
                            .font(.system(size: 20))
                            .foregroundColor(Color.black)
                    }
                }
            }
            .onAppear(perform:{
                loadProfileImageData(postData.userId)
            })
            
            .padding(.top ,30)
        }
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
        
        let samplePost = TempPost(id: "1", userId: "TestUser", imageUrl:"https://example.com/image.jpg", timestamp: Date(), likeCount: 10) // likeCount를 추가했습니다.

        // Convert the TempPost object to a Post object.
        let post = Post(id: samplePost.id, userId: samplePost.userId, imageUrl: samplePost.imageUrl, timestamp: Timestamp(date: samplePost.timestamp), likeCount: samplePost.likeCount) // likeCount를 추가했습니다.

        PostRow(postData: post)
    }
}
