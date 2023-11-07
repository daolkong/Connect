

///
//  AllowConnectView.swift
//  Connect
//
//  Created by Daol on 2023/09/16.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

struct AlarmConnectView: View {
    @State var buttonClickCount: Int = UserDefaults.standard.integer(forKey: "buttonClickCount")
    @State var lastClickDate: Date = UserDefaults.standard.object(forKey: "lastClickDate") as? Date ?? Date()
    @State private var showingAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var notificationViewModel : NotificationViewModel
    @EnvironmentObject var sharedViewModel : SharedViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            //상위 탭바
            HStack(spacing: 28) {
                
                Button(action: {
                    // Dismiss the view when the button is tapped
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("back1")
                        .resizable()
                        .frame(width: 10, height: 16)
                }
                
                Text("Nontifications")
                    .font(.system(size: 23, weight:.semibold))
                
                Spacer()
            }
            .frame(width: 350, height: 50)
            
            ScrollView {
                ForEach(notificationViewModel.notifications.removingDuplicates(), id: \.id) { notification in
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 369, height: 73)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269447327, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)), Color(#colorLiteral(red: 0.5176470875740051, green: 0.686274528503418, blue: 0.9372549057006836, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                        lineWidth : 2
                                    ))
                        HStack {
                            HStack {
                                if let profileImageUrl = URL(string: notification.fromUserProfileImageUrl ?? "") {
                                    KFImage(profileImageUrl)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 44, height: 44)
                                } else {
                                    Image("nonpro")
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                }
                                
                                VStack(alignment:.leading){
                                    Text("\(notification.fromUserId)님이 회원님과 일상을 connect 하고 싶어 합니다.")
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 15, weight:.medium))
                                }
                            }
                            .frame(width: 300)
                            .padding(.trailing,5)
                            
                            Button(action: {
                                Task {
                                    print("Button action started")
                                    if Calendar.current.isDateInToday(lastClickDate) {
                                        if buttonClickCount < 4 {
                                            buttonClickCount += 1
                                            UserDefaults.standard.set(buttonClickCount, forKey: "buttonClickCount")
                                            UserDefaults.standard.set(Date(), forKey: "lastClickDate")
                                        } else {
                                            showingAlert = true
                                        }
                                    } else {
                                        buttonClickCount = 1
                                        UserDefaults.standard.set(buttonClickCount, forKey: "buttonClickCount")
                                        UserDefaults.standard.set(Date(), forKey: "lastClickDate")
                                    }
                                    if buttonClickCount < 4 {
                                        let fromUserId = notification.fromUserId
                                        let toUserId = notification.toUserId
                                        let uid = Auth.auth().currentUser?.uid ?? ""
                                        
                                        guard let document = try? await Firestore.firestore().collection("users").document(uid).getDocument(), let dbUser = try? document.data(as: DBUser.self) else {
                                            print("Error getting userId for the current user")
                                            return
                                        }
                                        
                                        let currentUserId = dbUser.userId
                                        
                                        sharedViewModel.userAFullID = fromUserId
                                        sharedViewModel.userBFullID = toUserId
                                        
                                        var firstPostA: Post?
                                        var firstPostB: Post?
                                        
                                        do {
                                            await sharedViewModel.loadPostForUsers(["A"], tab: sharedViewModel.tabSelection1)
                                            let postsARecent = try await sharedViewModel.loadPosts(for: "A", tab: sharedViewModel.tabSelection1)
                                            firstPostA = postsARecent.first
                                        } catch {
                                            print("사용자 A의 게시물 로드 오류:", error)
                                            return
                                        }
                                        
                                        do {
                                            await sharedViewModel.loadPostForUsers(["B"], tab: sharedViewModel.tabSelection1)
                                            let postsBRecent = try await sharedViewModel.loadPosts(for: "B", tab: sharedViewModel.tabSelection1)
                                            firstPostB = postsBRecent.first
                                        } catch {
                                            print("사용자 B의 게시물 로드 오류:", error)
                                            return
                                        }
                                        
                                        do {
                                            try await sharedViewModel.increaseButtonClickCount(toUserId: notification.toUserId, fromUserId: notification.fromUserId)
                                        } catch {
                                            print("Error updating button click count:", error)
                                        }
                                        
                                        if let imageUrlStringA = firstPostA?.imageUrl, let imageUrlStringB = firstPostB?.imageUrl {
                                            if let urlImageA = URL(string: imageUrlStringA), let urlImageB = URL(string: imageUrlStringB) {
                                                
                                                async let imageDataATask: Data? = try? await sharedViewModel.fetchData(from: urlImageA)
                                                async let imageDataBTask: Data? = try? await sharedViewModel.fetchData(from: urlImageB)
                                                
                                                if let imageDataA = await imageDataATask, let imageDataB = await imageDataBTask {
                                                    
                                                    if let imageUserALatest = UIImage(data: imageDataA), let imageUserBLatest = UIImage(data: imageDataB) {
                                                        
                                                        if let imageUrlANew = await sharedViewModel.uploadImageToFirebaseStorage(image: imageUserALatest, imageName: "userAImage"),
                                                           let imageUrlBNew = await sharedViewModel.uploadImageToFirebaseStorage(image: imageUserBLatest, imageName: "userBImage") {
                                                            
                                                            do {
                                                                let dataToSave: [String: Any] = [
                                                                    "\(toUserId)": [
                                                                        "tag\(sharedViewModel.buttonClickCount + 1)": [
                                                                            "userANImageUrl": imageUrlANew,
                                                                            "userBNImageUrl": imageUrlBNew,
                                                                            "userAId": fromUserId,
                                                                            "userBId": toUserId
                                                                        ]
                                                                    ],
                                                                    "\(fromUserId)": [
                                                                        "tag\(sharedViewModel.buttonClickCount + 1)": [
                                                                            "userANImageUrl": imageUrlBNew,
                                                                            "userBNImageUrl": imageUrlANew,
                                                                            "userAId": toUserId,
                                                                            "userBId": fromUserId
                                                                        ]
                                                                    ]
                                                                ]
                                                                
                                                                let db = Firestore.firestore()
                                                                
                                                                let dateFormatter = DateFormatter()
                                                                dateFormatter.dateFormat = "yyyy_MM_dd"
                                                                let currentDate = dateFormatter.string(from: Date())
                                                                
                                                                // 오늘 날짜로 문서를 생성합니다.
                                                                let currentDateDocumentRef = db.collection("ConnectDB").document(currentDate)
                                                                
                                                                // fromUserId에 대한 데이터 저장
                                                                do {
                                                                    let dataToSaveForFromUser: [String: Any] = [
                                                                        "\(fromUserId)": [
                                                                            "tag\(sharedViewModel.buttonClickCount + 1)": [
                                                                                "userANImageUrl": imageUrlBNew,
                                                                                "userBNImageUrl": imageUrlANew,
                                                                                "userAId": toUserId,
                                                                                "userBId": fromUserId
                                                                            ]
                                                                        ]
                                                                    ]
                                                                    try await currentDateDocumentRef.setData(dataToSaveForFromUser, merge: true)
                                                                    print("fromUserId 데이터를 Firestore에 성공적으로 저장했습니다!")
                                                                    sharedViewModel.buttonClickCount += 1
                                                                } catch {
                                                                    print("Firestore에 fromUserId 데이터를 쓰는 중 오류 발생:", error)
                                                                    throw error
                                                                }
                                                                
                                                                // toUserId에 대한 데이터 저장
                                                                do {
                                                                    let dataToSaveForToUser: [String: Any] = [
                                                                        "\(toUserId)": [
                                                                            "tag\(sharedViewModel.buttonClickCount )": [
                                                                                "userANImageUrl": imageUrlANew,
                                                                                "userBNImageUrl": imageUrlBNew,
                                                                                "userAId": fromUserId,
                                                                                "userBId": toUserId
                                                                            ]
                                                                        ]
                                                                    ]
                                                                    try await currentDateDocumentRef.setData(dataToSaveForToUser, merge: true)
                                                                    print("toUserId 데이터를 Firestore에 성공적으로 저장했습니다!")
                                                                } catch {
                                                                    print("Firestore에 toUserId 데이터를 쓰는 중 오류 발생:", error)
                                                                    throw error
                                                                }
                                                            } catch {
                                                                print("Firebase Storage에 이미지를 업로드하는 중 오류 발생")
                                                                return
                                                            }
                                                        } else {
                                                            print("Firebase Storage에 이미지를 업로드하는 중 오류 발생")
                                                        }
                                                    } else {
                                                        print("UIImage를 생성하는 중 오류 발생")
                                                    }
                                                } else {
                                                    print("이미지 데이터를 가져오는 중 오류 발생")
                                                }
                                            } else {
                                                print("URL을 생성하는 중 오류 발생")
                                            }
                                        } else {
                                            print("이미지 URL을 가져오지 못했습니다.")
                                        }
                                    } else {
                                        showingAlert = true
                                    }
                                }
                            }) {
                                ZStack {
                                    if let imageUrlString = notification.latestPostImageUrl, let url = URL(string: imageUrlString) {
                                        KFImage(url)
                                            .resizable()
                                            .frame(width: 47, height: 47)
                                            .cornerRadius(6)
                                    } else {
                                        Rectangle()
                                            .foregroundColor(Color(red: 0.79, green: 0.78, blue: 0.78))
                                            .frame(width: 47, height: 45)
                                            .cornerRadius(6)
                                        
                                        Image("whitechain")
                                            .resizable()
                                            .frame(width: 29, height: 29)
                                    }
                                }
                            }
                            .onTapGesture {
                                if Calendar.current.isDateInToday(lastClickDate) {
                                    if buttonClickCount < 4 {
                                        buttonClickCount += 1
                                        UserDefaults.standard.set(buttonClickCount, forKey: "buttonClickCount")
                                        UserDefaults.standard.set(Date(), forKey: "lastClickDate")
                                    }
                                } else {
                                    buttonClickCount = 1
                                    UserDefaults.standard.set(buttonClickCount, forKey: "buttonClickCount")
                                    UserDefaults.standard.set(Date(), forKey: "lastClickDate")
                                }
                            }
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("알림"), message: Text("버튼이 오늘 최대 횟수로 클릭되었습니다."), dismissButton: .default(Text("확인")))
                            }
                        }
                        .padding(.trailing,20)
                    }
                }
            }
            .onAppear {
                Task {
                    await notificationViewModel.loadNotifications()
                    
                    let uid = Auth.auth().currentUser?.uid ?? ""
                    let db = Firestore.firestore()
                    let docRef = db.collection("Connect Numer").document(uid)
                    let doc = try? await docRef.getDocument()
                    if let doc = doc, doc.exists {
                        if let data = doc.data() {
                            sharedViewModel.buttonClickCount = data["buttonClickCount"] as? Int ?? 0
                        }
                    }
                }
                
                buttonClickCount = UserDefaults.standard.integer(forKey: "buttonClickCount")
                
                if let date = UserDefaults.standard.object(forKey: "lastClickDate") as? Date {
                    lastClickDate = date
                }
                
                if !Calendar.current.isDateInToday(lastClickDate) {
                    buttonClickCount = 0
                }
                
                UserDefaults.standard.set(buttonClickCount, forKey: "buttonClickCount")
            }
        }
    }
}
struct AlarmConnectView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmConnectView()
            .environmentObject(SharedViewModel())
    }
}
