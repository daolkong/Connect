//
//  CustomTabBar.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/27.
//

import SwiftUI

struct MainTabbedView: View {
    @State var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                
                Time_sellectView()
                    .tag(1)
                
                ConnectTodayView()
                    .tag(2)
                
                MyprofileView()
                    .tag(3)
            }
            ZStack{
                HStack{
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(height: 70)
            .background(.white)
            .cornerRadius(35)
            .padding(.horizontal, 26)
        }
    }
}

struct MainTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabbedView()
    }
}

extension MainTabbedView{
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Spacer()
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .black : .gray)
                .frame(width: 20, height: 20)
            if isActive{
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isActive ? .black : .gray)
            }
            Spacer()
        }
        .frame(width: isActive ? .infinity : 60, height: 60)
        .background(isActive ? Color(red: 0.52, green: 0.69, blue: 0.93) : .clear)
        .cornerRadius(30)
    }
}




enum TabbedItems: Int, CaseIterable{
    case home = 0
    case search
    case connect
    case profile
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .search:
            return "search"
        case .connect:
            return "connect"
        case .profile:
            return "Profile"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "Home"
        case .search:
            return "searchh"
        case .connect:
            return "Connect"
        case .profile:
            return "Mypage"
        }
    }
}
