

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
    @EnvironmentObject var notificationViewModel : NotificationViewModel
    @EnvironmentObject var sharedViewModel : SharedViewModel
    var body: some View {
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
                                print("Button action started") // 버튼 액션 시작
                                if sharedViewModel.buttonClickCount < 4 {
                                    let fromUserId = notification.fromUserId
                                    let toUserId = notification.toUserId  // 알림에서 'toUserId' 사용
                                    let uid = Auth.auth().currentUser?.uid ?? "" // 현재 로그인한 사용자의 uid
                                    
                                    guard let document = try? await Firestore.firestore().collection("users").document(uid).getDocument(), let dbUser = try? document.data(as: DBUser.self) else {
                                        print("Error getting userId for the current user")
                                        return
                                    }
                                    
                                    let currentUserId = dbUser.userId
                                    
                                    sharedViewModel.userAFullID = fromUserId
                                    sharedViewModel.userBFullID = toUserId
                                    
                                    var firstPostA: Post?
                                    var firstPostB: Post?
                                    
                                    // 데이터 불러오기
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
                                        try await sharedViewModel.increaseButtonClickCount(userId: currentUserId, fromUserId: notification.fromUserId)
                                    } catch {
                                        print("Error updating button click count:", error)
                                    }
                                    
                                    // 이미지 URL 가져오기
                                    if let imageUrlStringA = firstPostA?.imageUrl, let imageUrlStringB = firstPostB?.imageUrl {
                                        if let urlImageA = URL(string: imageUrlStringA), let urlImageB = URL(string: imageUrlStringB) {
                                            
                                            // 이미지 데이터 가져오기
                                            async let imageDataATask: Data? = try? await sharedViewModel.fetchData(from: urlImageA)
                                            async let imageDataBTask: Data? = try? await sharedViewModel.fetchData(from: urlImageB)
                                            
                                            if let imageDataA = await imageDataATask, let imageDataB = await imageDataBTask {
                                                
                                                if let imageUserALatest = UIImage(data: imageDataA), let imageUserBLatest = UIImage(data: imageDataB) {
                                                    
                                                    if let imageUrlANew = await sharedViewModel.uploadImageToFirebaseStorage(image: imageUserALatest, imageName: "userAImage"),
                                                       let imageUrlBNew = await sharedViewModel.uploadImageToFirebaseStorage(image: imageUserBLatest, imageName: "userBImage") {
                                                        
                                                        do {
                                                            let dataToSave: [String: Any] = [
                                                                "tag\(sharedViewModel.buttonClickCount + 1)": [
                                                                    "userANImageUrl": imageUrlANew,
                                                                    "userBNImageUrl": imageUrlBNew,
                                                                    "userAId": fromUserId,
                                                                    "userBId": toUserId
                                                                ]
                                                            ]
                                                            
                                                            let db = Firestore.firestore()
                                                            
                                                            let dateFormatter = DateFormatter()
                                                            dateFormatter.dateFormat = "yyyy.MM.dd"
                                                            let documentId = dateFormatter.string(from: Date())
                                                            let documentRef = db.collection("ConnectDB").document(documentId)
                                                            try await documentRef.setData([currentUserId: dataToSave], merge: true)
                                                            
                                                            print("데이터를 Firestore에 성공적으로 저장했습니다!")
                                                            
                                                            sharedViewModel.buttonClickCount += 1 // 버튼 클릭 횟수 증가
                                                        } catch {
                                                            print("Firestore에 데이터를 쓰는 중 오류 발생:", error)
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
                                    print("버튼이 오늘 최대 횟수로 클릭되었습니다.")
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
                    }
                    .padding(.trailing,20)
                    
                }
            }
        }
        .onAppear {
            Task {
                await notificationViewModel.loadNotifications()
            }
        }
    }
}
struct AlarmConnectView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmConnectView()
            .environmentObject(SharedViewModel()) // sharedViewModel 인스턴스 생성
    }
}
