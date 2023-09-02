//
//  CustomTabBar.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/27.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var TabSelection: Int
    @Binding var selectedTab : String
    
    var body: some View {
        HStack(spacing: 0) {
            
            TabBarButton(TabSelection: $TabSelection, image: "TabBarLogoHouse", clickSelection: 1, text: "홈", selectedTab: $selectedTab )
            
            TabBarButton(TabSelection: $TabSelection, image: "TabBarLogoClock", clickSelection: 2, text: "시간표", selectedTab: $selectedTab )
            
            TabBarButton(TabSelection: $TabSelection, image: "TabBarLogoPerson", clickSelection: 3, text: "급식", selectedTab: $selectedTab )
        }
        .padding(.horizontal)
        .background(
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 65)
                .background(Color.white)
                .cornerRadius(40)
                .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0, y: 0)
        )
    }
}

struct TabBarButton: View {
    @Binding var TabSelection: Int
    var image : String = ""
    var clickSelection : Int
    var text : String
    @Binding var selectedTab: String
    
    var body: some View {
        
        GeometryReader { reader in
            Button(action: {
                TabSelection = clickSelection
                withAnimation{
                    selectedTab = image
                }
                
            }, label: {
                VStack(spacing: 0) {
                    Image("\(image)\(TabSelection == clickSelection ? "-fill" : "")")
                    Spacer()
                        .frame(maxHeight: 12)
                    if TabSelection == clickSelection {
                        Text(text)
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(Color.blue)
                    } else {
                        Text(text)
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(Color.gray)
                    }
                   
                }
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 90)
    }
}
