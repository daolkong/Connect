//
//  CustomTabBar.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/27.
//

import SwiftUI

struct MainTabbedView: View {
    @State var selectedTab = 0
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userDataModel: UserDataModel
    
    var body: some View {
        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
                HomeView(imageUrl:"")
                    .tag(0)
                
                FriendSearchView()
                    .tag(1)
                
                ConnectTodayView()
                    .tag(2)
                
                MyprofileView()
                    .tag(3)
            }
            ZStack{
                HStack(spacing: 0){
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Spacer()
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, isActive: (selectedTab == item.rawValue))
                                .padding(.horizontal,10)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 6)
            }
            .frame(height: 70)
            .background(Color.white)
        }
    }
}

#Preview {
        MainTabbedView()
}

extension MainTabbedView{
    func CustomTabItem(imageName:String, isActive :Bool)->some View{
        HStack(spacing :15){
            Image(imageName)
               .resizable()
               .renderingMode(.template)
               .foregroundColor(isActive ? Color.black : Color.gray )
               .frame(width :20,height :20)
        }
        .frame(height :60)
    }

}
enum TabbedItems:Int , CaseIterable{
    case home = 0
    case search
    case connect
    case profile
    
    var iconName:String{
        switch self {
        case.home:
            return "Home"
        case.search:
            return "searchh"
        case.connect:
            return "Connect"
        case.profile:
            return "Mypage"
   
        }
    }
}

