

///
//  AlarmConnectView.swift
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
    @State private var alertTitle = ""
    @State private var alertMessage = ""
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

                                HStack {
                                    VStack(alignment:.leading){
                                        Text("\(notification.fromUserId)님이 회원님과 일상을 connect 하고 싶어 합니다.")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 15, weight:.medium))
                                    }
                                    Spacer()
                                }
                                .frame(width: 216)
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
                                            showingAlert = true
                                            alertTitle = "커넥트 성공(하루 4번 가능)"
                                            alertMessage = "이미지 업로드 중 입니다. 2,3초 후에 다른 뷰로 이동해주세요"
                                        } else {
                                            showingAlert = true
                                            alertTitle = "커넥트 4번 완료(하루 커넥트 횟수 달성 - 4회)"
                                            alertMessage = "이미지 업로드 중 입니다. 2,3초 후에 다른 뷰로 이동해주세요"
                                        }
                                    } else {
                                        buttonClickCount = 1
                                        UserDefaults.standard.set(buttonClickCount, forKey: "buttonClickCount")
                                        UserDefaults.standard.set(Date(), forKey: "lastClickDate")
                                        showingAlert = true
                                        alertTitle = "커넥트 성공(하루 4번 가능)"
                                        alertMessage = "이미지 업로드 중 입니다. 2,3초 후에 다른 뷰로 이동해주세요"
                                    }
                                    
                                    if buttonClickCount <= 4 {
                                        let fromUserId = notification.fromUserId
                                        let toUserId = notification.toUserId
                                        let uid = Auth.auth().currentUser?.uid ?? ""
                                        
                                        guard let document = try? await Firestore.firestore().collection("users").document(uid).getDocument(), let _ = try? document.data(as: DBUser.self) else {
                                            print("Error getting userId for the current user")
                                            return
                                        }

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
                                        
                                        if let imageUrlStringA = firstPostA?.imageUrl, let imageUrlStringB = firstPostB?.imageUrl {
                                                if let urlImageA = URL(string: imageUrlStringA), let urlImageB = URL(string: imageUrlStringB) {
                                                    
                                                    async let imageDataATask: Data? = try? await sharedViewModel.fetchData(from: urlImageA)
                                                    async let imageDataBTask: Data? = try? await sharedViewModel.fetchData(from: urlImageB)
                                                    
                                                    if let imageDataA = await imageDataATask, let imageDataB = await imageDataBTask {
                                                        
                                                        if let imageUserALatest = UIImage(data: imageDataA), let imageUserBLatest = UIImage(data: imageDataB) {
                                                            
                                                            if let imageUrlANew = await sharedViewModel.uploadImageToFirebaseStorage(image: imageUserALatest, imageName: "userAImage"),
                                                               let imageUrlBNew = await sharedViewModel.uploadImageToFirebaseStorage(image: imageUserBLatest, imageName: "userBImage") {
                                                                
                                                                do {
                                                                    let dateFormatter = DateFormatter()
                                                                    dateFormatter.dateFormat = "yyyy_MM_dd"
                                                                    let currentDate = dateFormatter.string(from: Date())
                                                                    
                                                                    let currentDateDocumentRef = Firestore.firestore().collection("ConnectDB").document(currentDate)
                                                                    
                                                                    let document = try await currentDateDocumentRef.getDocument()
                                                                    let data = document.data()
                                                                    
                                                                    let newTagKeyForFromUser: String
                                                                    if let existingTagsFromUser = data?[fromUserId] as? [String: Any] {
                                                                        let highestTagNumber = existingTagsFromUser.keys.compactMap { Int($0.replacingOccurrences(of: "tag", with: "")) }.max() ?? 0
                                                                        newTagKeyForFromUser = "tag\(highestTagNumber + 1)"
                                                                    } else {
                                                                        newTagKeyForFromUser = "tag1"
                                                                    }
                                                                    
                                                                    let newTagKeyForToUser: String
                                                                    if let existingTagsToUser = data?[toUserId] as? [String: Any] {
                                                                        let highestTagNumber = existingTagsToUser.keys.compactMap { Int($0.replacingOccurrences(of: "tag", with: "")) }.max() ?? 0
                                                                        newTagKeyForToUser = "tag\(highestTagNumber + 1)"
                                                                    } else {
                                                                        newTagKeyForToUser = "tag1"
                                                                    }
                                                                    
                                                                    let dataToSaveForFromUser: [String: Any] = [
                                                                        "\(fromUserId)": [
                                                                            newTagKeyForFromUser: [
                                                                                "userANImageUrl": imageUrlBNew,
                                                                                "userBNImageUrl": imageUrlANew,
                                                                                "userAId": toUserId,
                                                                                "userBId": fromUserId
                                                                            ]
                                                                        ]
                                                                    ]
                                                                    let dataToSaveForToUser: [String: Any] = [
                                                                        "\(toUserId)": [
                                                                            newTagKeyForToUser: [
                                                                                "userANImageUrl": imageUrlANew,
                                                                                "userBNImageUrl": imageUrlBNew,
                                                                                "userAId": fromUserId,
                                                                                "userBId": toUserId
                                                                            ]
                                                                        ]
                                                                    ]
                                                                    
                                                                    try await currentDateDocumentRef.setData(dataToSaveForFromUser, merge: true)
                                                                    try await currentDateDocumentRef.setData(dataToSaveForToUser, merge: true)
                                                                    
                                                                } catch {
                                                                    print("Firestore에 데이터를 쓰는 중 오류 발생:", error)
                                                                    throw error
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
                            .onDisappear {
                                UserDefaults.standard.set(sharedViewModel.buttonClickCount, forKey: "buttonClickCount")
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
                                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("확인")))
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
                    _ = try? await docRef.getDocument()
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

#Preview {
        AlarmConnectView()
            .environmentObject(SharedViewModel())
}
