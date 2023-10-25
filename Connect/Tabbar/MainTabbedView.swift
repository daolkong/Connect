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
                
                Time_sellectView()
                    .tag(1)
                    .environmentObject(AuthViewModel())
                    .environmentObject(UserDataModel())
                
                MainConnectView()
                    .tag(2)
                
                MyprofileView()
                    .tag(3)
            }
            ZStack{
                HStack(spacing: 0){ // spacing을 0으로 설정하여 아이콘 사이의 공간을 제거합니다.
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Spacer() // Spacer 추가
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, isActive: (selectedTab == item.rawValue))
                                .padding(.horizontal,10) // 버튼에 가로 방향 패딩 추가

                        }
                        Spacer() // Spacer 추가
                    }
                }
                .padding(.horizontal, 6) // 아이콘과 탭바의 가장자리 사이에 패딩 추가
            }
            .frame(height: 70)
            .background(Color.white)
        }
    }
}

struct MainTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabbedView()
    }
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
        .frame(maxWidth: .infinity)
        // width 값을 infinity로 설정하여 동일한 크기를 가지도록 합니다.
         //.cornerRadius(30)
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
