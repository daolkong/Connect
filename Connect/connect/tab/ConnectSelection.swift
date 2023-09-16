//
//  ConnectSelection.swift
//  Connect
//
//  Created by Daol on 2023/09/12.
//

import SwiftUI

struct ConnectSelection: View {
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    let tabItems: [String] = [
        "오늘",
        "보관함"
    ]
    
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 185, height: 64)
                .background(Color(red: 0.12, green: 0.14, blue: 0.14))
                .cornerRadius(35)
            
            HStack(spacing: 70) {
                Button(action: {
                    tabSelection = 1
                }) {
                    ZStack {
                        Text(tabItems[0])
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(tabSelection == 1 ? .white : .white)
                            .zIndex(1)
                        
                        if tabSelection == 1 {
                            Circle()
                                .frame(width: 46, height: 46)
                                .foregroundColor(Color(red: 0.52, green: 0.69, blue: 0.94))
                                .matchedGeometryEffect(id: "SelecedTabId", in: animationNamespace)
                        } else {
                            Circle()
                                .frame(width: 46, height: 46)
                                .foregroundColor(.clear)
                                .foregroundColor(.clear)
                        }
                    }
                }
                
                
                
                
                Button(action: {
                    tabSelection = 2
                }) {
                    ZStack {
                        Text(tabItems[1])
                            .font(.system(size: 14))
                            .frame(width: 46, height: 46)
                            .fontWeight(.bold)
                            .foregroundColor(tabSelection == 2 ? .white : .white)
                            .zIndex(1)
                        
                        if tabSelection == 2 {
                            Circle()
                                .frame(width: 46, height: 46)
                                .foregroundColor(Color(red: 0.52, green: 0.69, blue: 0.94))
                                .matchedGeometryEffect(id: "SelecedTabId", in: animationNamespace)
                        } else {
                            Circle()
                                .frame(width: 46, height: 46)
                                .foregroundColor(.clear)
                        }
                    }
                }
            }
            .frame(width: 364, height: 35)
            .padding(.horizontal, 20)
        }
    }
}

struct ConnectSelection_Previews: PreviewProvider {
    static var previews: some View {
        ConnectSelection(tabSelection: .constant(1))
    }
}
