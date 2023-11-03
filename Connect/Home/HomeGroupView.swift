//
//  HomeGroupView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI


struct HomeGroupView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                
                HStack(spacing: 120) {
                    Button(action: {
                        // Dismiss the view when the button is tapped
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("back1")
                            .resizable()
                            .frame(width: 10, height: 16)
                    }
               
                    
                    Text("Connect")
                        .font(.system(size: 25, weight:.semibold))
                        .foregroundColor(Color.clear)
                }
                .padding(.trailing, 130)
                
                Spacer() // 화면 중앙 정렬을 위한 Spacer
                
                Text("준비중인 페이지입니다.")
                    .font(.system(size: 20, weight:.black))
                
                Spacer() // 화면 중앙 정렬을 위한 Spacer
            }
        }
    }
}

struct HomeGroupView_Previews: PreviewProvider {
    static var previews: some View {
        HomeGroupView()
    }
}

