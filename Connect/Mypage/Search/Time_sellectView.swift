//
//  Time_sellectView.swift
//  Connect
//
//  Created by Daol on 2023/09/08.
//

import SwiftUI

struct Time_sellectView: View {
    @State private var tabSelection = 1
    @State private var searchText: String = "" // $text를 정의
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userDataModel: UserDataModel
    
    var body: some View {
        VStack {
            
            VStack {
                HStack {
                    Text("Friend Search")
                        .font(.system(size: 23))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    TimeLinePart_selection(tabSelection: $tabSelection)
                    
                }
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 355, height: 47)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .inset(by: 1)
                                .stroke(Color(red: 0.52, green: 0.69, blue: 0.94), lineWidth: 2)
                        )
                    
                    HStack(spacing: 15) {
                        Image("search")
                            .resizable()
                            .frame(width: 17, height: 17)
                        
                        Image("Vector 27")
                            .resizable()
                            .frame(width: 1, height: 14)
                        
                        TextField("Search...", text: $searchText) // 여기서 searchText는 문자열 바인딩 변수여야 합니다.
                            .font(.system(size: 17))
                            .fontWeight(.regular)
                            .foregroundColor(Color(red: 0.52, green: 0.69, blue: 0.94))
                    }
                    .padding(.leading, 40)
                }

            }
            .padding()
            .padding(.top,220)
        
            ZStack() {
                TabView(selection: $tabSelection) {
                    FriendSearchView()
                        .tag(1)
                        .environmentObject(AuthViewModel())
                        .environmentObject(UserDataModel())
                    GroupSearchView()
                        .tag(2)
                        .environmentObject(AuthViewModel())
                        .environmentObject(UserDataModel())
                    
                }
                .frame(width: 393, height: 800)
            }
        }
        
    }
}

struct Time_sellectView_Previews: PreviewProvider {
    static var previews: some View {
        Time_sellectView()
    }
}
