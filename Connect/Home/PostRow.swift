//
//  PostRow.swift
//  Connect
//
//  Created by Daol on 10/4/23.
//


import SwiftUI
import Kingfisher

struct PostRow: View {
    @EnvironmentObject var notificationViewModel : NotificationViewModel
    
    var postData: Post
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    var body: some View {
        
        VStack(spacing: -19) {
            // 프로필 상단
            ZStack {
                Rectangle()
                    .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.3))
                    .frame(width: 390, height: 65)
                
                HStack {
                    Image("profile")
                        .resizable()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        
                        Text(postData.fullid)   // Use the fullId of the post directly
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                        
                        Text(dateFormatter.string(from :postData.timestamp))
                            .font(.system(size :12))
                            .fontWeight(.regular)
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
                
                Button(action:{}){
                    
                    HStack {
                        Image("heart button1")
                            .resizable()
                            .frame(width :33,height :33)
                        
                        Text("Like(31)")
                            .font(.system(size: 20))
                            .foregroundColor(Color.black)

                    }
                    
                }
                
                Button(action:{
                    notificationViewModel.sendRequest(imageId :postData.id)
                }){
                    HStack {
                        Image("Connect button")
                            .resizable()
                            .frame(width :33,height :33)
                        
                        
                        Text("Connect(31)")
                            .font(.system(size: 20))
                    }
                }
                
            }.padding(.top ,30)
            
        }
        .frame(maxWidth: .infinity) // 추가된 코드

    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        let samplePost = Post(id: "1", fullid: "TestUser", imageUrl:"https://example.com/image.jpg", timestamp: Date())
        PostRow(postData: samplePost)
    }
}
