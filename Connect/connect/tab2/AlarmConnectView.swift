

//
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
    @EnvironmentObject var sharedViewModel : SharedViewModel  // 추가된 부분
    
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
                            if let profileImageUrl = URL(string: notification.fromUserProfileImageUrl ?? "") {
                                KFImage(profileImageUrl)
                                    .resizable()
                                    .clipShape(Circle()) // 프로필 사진을 원 모양으로 클리핑합니다.
                                    .frame(width: 44, height: 44)
                            } else {
                                Image("nonpro") // Replace this with your default image
                                    .resizable()
                                    .frame(width: 44, height: 44)
                            }
                            
                            VStack(alignment:.leading){
                                Text("\(notification.fromUserId)님이 회원님과 일상을 connect 하고 싶어 합니다.")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 15))
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(width: 300)
                        .padding(.trailing,5)
                        
                        Button(action: {
                            self.sharedViewModel.userAFullID = notification.fromUserId
                        }) {
                            ZStack {
                                if let imageUrlString = notification.latestPostImageUrl, let url = URL(string: imageUrlString) {
                                    KFImage(url)
                                        .resizable()
                                        .frame(width: 47, height: 45)
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
        .onAppear(perform: notificationViewModel.loadNotifications)
    }
}


struct AlarmConnectView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmConnectView()
            .environmentObject(SharedViewModel()) // sharedViewModel 인스턴스 생성
    }
}
