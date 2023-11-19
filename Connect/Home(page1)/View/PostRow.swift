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

    // ------------------------------------------------------------------------------------------------------------------
    
    var body: some View {
        
        VStack(spacing:0) {
            // 프로필 상단
            VStack(spacing:0) {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.3))
                        .frame(width: UIScreen.main.bounds.width == 430 ? 430 : UIScreen.main.bounds.width == 393 ? 393 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 375 : UIScreen.main.bounds.width == 320 ? 320 : 375,
                               height: 65)
                    HStack {
                        Spacer()
                            .frame(width: 8)
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
                    }
                }
                    Group {
                        if let imageUrl = URL(string: postData.imageUrl) {
                            KFImage(imageUrl)
                                .cacheOriginalImage()
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width == 430 ? 430 : UIScreen.main.bounds.width == 393 ? 393 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 375 : UIScreen.main.bounds.width == 320 ? 320 : 375,
                                       height: UIScreen.main.bounds.width == 430 ? 430 : UIScreen.main.bounds.width == 393 ? 393 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 375 : UIScreen.main.bounds.width == 320 ? 320 : 375)
                                .scaledToFill()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            Text("Invalid URL string.")
                                .font(.system(size: 20))
                                .foregroundColor(Color.black)
                        }
                    }
            }
            
            // 공감과 커넥트 칸
            ZStack {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: UIScreen.main.bounds.width == 430 ? 430 : UIScreen.main.bounds.width == 393 ? 393 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 375 : UIScreen.main.bounds.width == 320 ? 320 : 375,
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
            }
            .onAppear(perform:{
                loadProfileImageData(postData.userId)
            })
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
        
        let samplePost = TempPost(id: "1", userId: "TestUser", imageUrl:"https://example.com/image.jpg", timestamp: Date(), likeCount: 10)

        let post = Post(id: samplePost.id, userId: samplePost.userId, imageUrl: samplePost.imageUrl, timestamp: Timestamp(date: samplePost.timestamp), likeCount: samplePost.likeCount) 

        PostRow(postData: post)
    }
}
