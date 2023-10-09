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

struct ConnectTodayView: View {
    @State private var tabSelection = 1
    @EnvironmentObject var imageLoader: ImageLoader
    @State private var posts: [Post] = []
    
    var body: some View {
        VStack(spacing: 35) {
            ScrollView {
                VStack {
                    // 1번째줄
                    HStack(spacing: 17) {
                        // 갤러리 1
                        VStack {
                            ZStack {
                                switch imageLoader.requestStatus {
                                case "accepted":
                                    if let url = URL(string: imageLoader.imageUrlString ?? "") {
                                        URLImage(url) { image in
                                            image.resizable()
                                        }
                                        .frame(width: 159, height: 159)
                                        .cornerRadius(21)
                                        
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 159, height: 159)
                                            .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.3))
                                            .cornerRadius(21)
                                        
                                        Image("profile")
                                            .resizable()
                                            .frame(width: 47, height: 47)
                                            .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                            .padding(.leading,50)
                                            .padding(.top,50)
                                        
                                        
                                        Image("Mask group")
                                            .resizable()
                                            .frame(width: 47, height: 47)
                                            .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                                            .padding(.leading,90)
                                            .padding(.top,90)
                                        
                                        
                                        Text("커넥트 앨범의 이름을 정해주세요")
                                            .font(.system(size :17))
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.black)
                                    }
                                    
                                case "pending":
                                    
                                    Image("12")
                                        .resizable()
                                        .frame(width: 159, height: 159)
                                    
                                    Text("커넥트 대기중")
                                        .font(.system(size :17 ))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.black)

                                    
                                default:
                                    Image("non")
                                        .resizable()
                                        .frame(width: 159, height: 159)
                                    
                                    
                                    Text("서로의 추억을 만들어보세요!")
                                        .font(.system(size :17 ))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.black)
                                }
                            }
                        }
                    }
                }
            }
            
        }.onAppear() {
            self.imageLoader.loadImageUrl()
        }
    }
}

class ImageLoader : ObservableObject {
    @Published var imageUrlString : String?
    @Published var requestStatus: String?
    @Published var fromUserId : String?
    @Published var notifications = [Notification]()
    
    
    func loadImageUrl() {
        let db = Firestore.firestore()
        
        db.collection("users").document("<YourUserID>")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching documents:", error ?? "")
                    return
                }
                
                guard let data = document.data() else { return }
                
                self.requestStatus = data["status"] as? String
                
                self.fromUserId = data["from"] as? String
                
                if self.requestStatus == "accepted" && data["from"] as? String == "<TargetUserID>" {
                    
                    if let postId = data["postId"] as? String {
                        
                        db.collection("post").document(postId).getDocument { (docSnapshot, error) in
                            
                            if let docSnapshot = docSnapshot,
                               let postData = docSnapshot.data(),
                               let imageUrlString = postData["imageUrl"] as? String {
                                
                                self.imageUrlString = imageUrlString
                                
                            } else if let error = error{
                                print("Error fetching image url:", error.localizedDescription)
                            }
                        }
                        
                    } else {
                        
                        print("Image ID is nil")
                        
                    }
                    
                }
                
            }
        
    }
    
    func sendRequest(imageId: String) {
        let db = Firestore.firestore()

        db.collection("posts").document(imageId).getDocument { (documentSnapshot, error) in

            if let documentSnapshot = documentSnapshot,
               let data = documentSnapshot.data(),
               let fromUserId = Auth.auth().currentUser?.uid { // 버튼을 누른 사용자 ID

                // Fetch the name of the user who sent the request.
                db.collection("users").document(fromUserId).getDocument { (userDocSnapshot, error) in
                    if let userDocSnapshot = userDocSnapshot,
                       let userData = userDocSnapshot.data(),
                       let fromUserName = userData["fullid"] as? String {

                        if var toUserId = data["userId"] as? String { // 포스트 소유자 ID

                            // Notification 객체 생성 후 사전 변환
                            var notificationObject = Notification(id: UUID().uuidString,
                                                                  fromUserId: fromUserId,
                                                                  fromUserName: fromUserName,
                                                                  fromUserProfileImageUrl: nil)

                            var notificationDict:[String:Any] = [:]
                            notificationDict["from"]  = notificationObject.fromUserId
                            
                            // Add the sender's name to the dictionary.
                            notificationDict["fromUserName"]  = notificationObject.fromUserName
                            
                            // Add recipient's userId to the dictionary.
                            notificationDict["to"]  = toUserId

                            db.collection("notifications").document(notificationObject.id).setData(notificationDict){ error in

                                if error != nil {
                                    print(error!.localizedDescription)
                                } else {
                                    print("Notification sent successfully!")
                                }
                                
                            }
                        }
                    } else if let error = error{
                         print("Error fetching user:", error.localizedDescription)
                     }

                }

            } else if let error = error{
                 print("Error fetching post:", error.localizedDescription)
             }

        }

    }

    func loadNotifications() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("notifications").whereField("to", isEqualTo: currentUserId)
            .addSnapshotListener { querySnapshot, error in
                
                if let querySnapshot = querySnapshot {
                    self.notifications.removeAll()
                    
                    for document in querySnapshot.documents {
                        if let fromUserId = document.data()["from"] as? String,
                           let fromUserName = document.data()["fromUserName"] as? String {
                            let newNotification = Notification(id: document.documentID,
                                                              fromUserId: fromUserId,
                                                               fromUserName: fromUserName,
                                                               fromUserProfileImageUrl: nil)

                            self.notifications.append(newNotification)
                        }
                    }
                } else if let error = error {
                    print("Error fetching notifications:", error.localizedDescription)
                }
            }
    }
}

struct ConnectTodayView_Previews: PreviewProvider {
    static var previews:some View{
        ConnectTodayView().environmentObject(ImageLoader())
    }
}

