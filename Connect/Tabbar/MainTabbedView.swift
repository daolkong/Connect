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
                HomeView(imageUrl:"")
                    .tag(0)
                
                Time_sellectView()
                    .tag(1)
                
                MainConnectView()
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
                            CustomTabItem(imageName: item.iconName, isActive: (selectedTab == item.rawValue))
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .frame(height: 40)
                .background(Color.white)
            }
        }
    }
}

struct MainTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabbedView()
    }
}

struct CustomTabItem : View {
    let imageName:String
    let isActive : Bool

    var body:some View {
        VStack { // Use VStack instead of HStack.
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? Color.black : (Color(red: 0.74, green: 0.74, blue: 0.74)))
                .frame(width: 20, height: 20)
                .padding(.top,20)
        }
    }
}


enum TabbedItems: Int, CaseIterable{
    case home = 0
    case search
    case connect
    case profile
    
    
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



