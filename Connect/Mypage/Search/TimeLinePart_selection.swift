//
//  TimeLinePart_selection.swift
//  Connect
//
//  Created by Daol on 2023/09/08.
//

import SwiftUI

struct TimeLinePart_selection: View {
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    let tabItems: [String] = [
        "친구 ",
        "그룹"
    ]
    
    var body: some View {
        
        HStack(spacing: 15) {
            Button(action: {
                tabSelection = 1
            }) {
                
                if tabSelection == 1 {
                    Text(tabItems[0])
                        .foregroundColor(Color(red: 0.32, green: 0.53, blue: 0.84))                        .fontWeight(.black)
                        .matchedGeometryEffect(id: "SelectedTabId_\(tabItems[0])", in: animationNamespace)
                } else {
                    Text(tabItems[0])
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.78, green: 0.77, blue: 0.77))
                }
                
            }
            
            
            Button(action: {
                tabSelection = 2
            }) {
                
                if tabSelection == 2 {
                    Text(tabItems[1])
                        .foregroundColor(Color(red: 0.32, green: 0.53, blue: 0.84))                        .fontWeight(.black)
                        .matchedGeometryEffect(id: "SelecedTabId", in: animationNamespace)
                } else {
                    Text(tabItems[1])
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.78, green: 0.77, blue: 0.77))
                }
                
            }
        }
    }
}

struct TimeLinePart_selection_Previews: PreviewProvider {
    static var previews: some View {
        TimeLinePart_selection(tabSelection: .constant(1))
    }
}

