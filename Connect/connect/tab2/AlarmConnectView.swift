//
//  AllowConnectView.swift
//  Connect
//
//  Created by Daol on 2023/09/16.
//

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
                                    .frame(width: 47, height: 45)
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


struct AlarmConnectView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmConnectView().environmentObject(ImageLoader())
    }
}
