//
//  ConnectAllowView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct ConnectAllowView: View {
    @State private var tabSelection = 1
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 15) {
            
            //상위 탭바
            HStack(spacing: 28) {
                
                Button(action: {
                    // Dismiss the view when the button is tapped
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("back1")
                        .resizable()
                        .frame(width: 10, height: 16)
                }
               
                Text("Nontifications")
                    .font(.system(size: 23))
                    .fontWeight(.semibold)
                    
                Spacer()
            }
            .frame(width: 350, height: 50)
            
            VStack(spacing: 10) {
                AllowSelection(tabSelection: $tabSelection)
                
                ZStack() {
                    TabView(selection: $tabSelection) {
                        AlarmConnectView()
                            .tag(1)
                        AlarmLikeView()
                            .tag(2)
                        
                    }
                    .frame(width: 393, height: 800)
                    
                }
                
            }
            
 
        }
        .padding(.top,140)

    }
}

struct ConnectAllowView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectAllowView()
    }
}
