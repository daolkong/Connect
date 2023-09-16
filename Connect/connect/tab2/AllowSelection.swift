//
//  AllowSelection.swift
//  Connect
//
//  Created by Daol on 2023/09/16.
//

import SwiftUI

struct AllowSelection: View {
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    let tabItems: [String] = [
        "Connect",
        "Like"
    ]
    
    var body: some View {
        HStack(spacing:14) {
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
                        Rectangle()
                            .foregroundColor(Color(red: 0.52, green: 0.69, blue: 0.94))
                            .frame(width: 86, height: 34)
                            .cornerRadius(30)
                            .matchedGeometryEffect(id: "SelecedTabId", in: animationNamespace)
                    } else {
                        Rectangle()
                          .foregroundColor(Color(red: 0.12, green: 0.14, blue: 0.14).opacity(0.2))
                          .frame(width: 86, height: 34)
                          .cornerRadius(30)
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
                        Rectangle()
                            .foregroundColor(Color(red: 0.18, green: 0.19, blue: 0.19))
                            .frame(width: 64, height: 34)
                            .cornerRadius(30)
                            .matchedGeometryEffect(id: "SelecedTabId", in: animationNamespace)
                    } else {
                        Rectangle()
                          .foregroundColor(Color(red: 0.12, green: 0.14, blue: 0.14).opacity(0.2))
                          .frame(width: 64, height: 34)
                          .cornerRadius(30)
                    }
                }
            }
            
            Spacer()
        }
        .frame(width: 364, height: 35)
        
            }
}

struct AllowSelection_Previews: PreviewProvider {
    static var previews: some View {
        AllowSelection(tabSelection: .constant(1))
    }
}
