//
//  AllowConnectView.swift
//  Connect
//
//  Created by Daol on 2023/09/16.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AlarmConnectView: View {
    
    @EnvironmentObject var notificationViewModel : NotificationViewModel
    @State private var isButtonPressed = false
    
    var body: some View {
        ScrollView {
            ForEach(notificationViewModel.notifications, id: \.id) { notification in
                // 알림창 1
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 369, height: 73)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269447327, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)), Color(#colorLiteral(red: 0.5176470875740051, green: 0.686274528503418, blue: 0.9372549057006836, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                    lineWidth : 2 // Specify your desired line width here
                                ))
                    
                    HStack {
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            
                            Text("\(notification.fromUserName)님이 회원님과 일상을 connect 하고 싶어 합니다.")
                                .foregroundColor(Color.black)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .frame(width: 300)
                        
                        .padding(.trailing,5)
                        
                        Button(action: {
                            self.isButtonPressed.toggle()
                        }) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color(red: 0.79, green: 0.78, blue: 0.78))
                                    .frame(width: 45, height: 45)
                                    .cornerRadius(6)
                                
                                if isButtonPressed {
                                    Image("ccheck")
                                        .resizable()
                                        .frame(width: 29, height: 29)
                                } else {
                                    Image("whitechain")
                                        .resizable()
                                        .frame(width: 29, height: 29)
                                }
                            }
                        }
                        
                        
                    }
                    .padding(.trailing,20)
                    
                }
            }
        }
        .onAppear(perform: notificationViewModel.loadNotifications)
        
    }
}


class NotificationViewModel: ObservableObject {
    
    @Published var notifications: [Notification] = []
    
    func sendRequest(imageId: String) {
        let db = Firestore.firestore()
        
        print("sendRequest called with imageId: \(imageId)") // 로그 메시지 추가
        
        db.collection("posts").document(imageId).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            guard let documentSnapshot = documentSnapshot else {
                print("Failed to retrieve document")
                return
            }
            
            guard let data = documentSnapshot.data() else {
                print("Document data is empty")
                return
            }
            
            if let fromUserId = Auth.auth().currentUser?.uid { // 버튼을 누른 사용자 ID
                
                // Fetch the name of the user who sent the request.
                db.collection("users").document(fromUserId).getDocument { (userDocSnapshot, error) in
                    if let userDocSnapshot = userDocSnapshot,
                       let userData = userDocSnapshot.data(),
                       let fromUserName = userData["fullid"] as? String {
                        
                        if let toUserId = data["fullid"] as? String { // Use 'fullid' instead of 'userId'
                            
                            // Notification 객체 생성 후 사전 변환
                            var notificationObject = Notification(id: UUID().uuidString,
                                                                  fromUserId: fromUserId,
                                                                  fromUserName: fromUserName)
                            
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
                
            }
            else if let error = error{
                print("Error fetching post:", error.localizedDescription)
            }
            
        }
        
    }
    
    func loadNotifications() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

        // Fetch the user document from Firestore
        let db = Firestore.firestore()
        db.collection("users").document(currentUserId).getDocument { (documentSnapshot, error) in
            if let documentSnapshot = documentSnapshot,
               let data = documentSnapshot.data(),
               let currentUserFullName = data["fullid"] as? String {

                // Now we have the full name of the current user.
                // We can use it to filter notifications.
                db.collection("notifications").whereField("to", isEqualTo: currentUserFullName).addSnapshotListener{ (querySnapShot,error) in

                    if let error = error {
                        print("Error loading notifications: \(error.localizedDescription)")
                        return
                    }

                    guard let querySnapShot = querySnapShot else{
                        print("No QuerySnapshot returned from listener")
                        return
                    }
                
                    self.notifications.removeAll()
                    
                    var addedUserIds: [String] = []  // Keep track of added userIds
                    
                    for document in querySnapShot.documents{
                        if document.exists ,
                           let fromUserId = document.data()["from"] as? String ,
                           let fromUserName = document.data()["fromUserName"] as? String {

                            // Check if this userId has already been added.
                            if !addedUserIds.contains(fromUserId) {
                                self.notifications.append(Notification(id:document.documentID , fromUserId:fromUserId, fromUserName:fromUserName))
                                addedUserIds.append(fromUserId)
                            }
                            
                        }
                    }
                }

            } else if let error = error {
                print("Error fetching user:", error.localizedDescription)
            }
        }
    }

}



struct AlarmConnectView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmConnectView().environmentObject(NotificationViewModel())
        
    }
}
