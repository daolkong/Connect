//
//  MainConnectView.swift
//  Connect
//
//  Created by Daol on 2023/09/12.
//

import SwiftUI

struct MainConnectView: View {
    @State private var tabSelection = 1
    @State private var gotoalarm = false
    @State private var gotosetting = false

    var body: some View {
        VStack(spacing: 30) {
            
                HStack {
                    Image("align-left")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            gotosetting = true
                        }
                    NavigationLink(destination: MypageView()
                        .navigationBarBackButtonHidden(true), isActive: $gotosetting) {
                            EmptyView()
                        }
                    Spacer()
                    
                    Text("Connect Gallery")
                        .font(.system(size: 25))
                        .frame(width: 187)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image("alarm")
                        .resizable()
                        .frame(width: 18, height: 20)
                        .onTapGesture {
                            gotoalarm = true
                        }
                    NavigationLink(destination: ConnectAllowView()
                        .navigationBarBackButtonHidden(true), isActive: $gotoalarm) {
                            EmptyView()
                        }
                    
                }
                .frame(width: 345, height: 28)
            
                .padding(.horizontal,10)
            // 스위치
            
            VStack(spacing: 30) {
                ConnectSelection(tabSelection: $tabSelection)
                
                ZStack() {
                    TabView(selection: $tabSelection) {
                        ConnectTodayView()
                            .tag(1)
                        ConnectSaveView()
                            .tag(2)
                        
                    }
                    .frame(width: 393, height: 800)
                    
                }
                
            }
        }
        .padding(.top,270)
    }
}

struct MainConnectView_Previews: PreviewProvider {
    static var previews: some View {
        MainConnectView()
    }
}
