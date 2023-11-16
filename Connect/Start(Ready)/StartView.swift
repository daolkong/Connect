//
//  StartView.swift
//  Connect
//
//  Created by Daol on 2023/09/02.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        VStack(spacing: 80) {
            Image("Connect(1)")
                .resizable()
                .frame(width: 420, height: 130)
                .padding(.bottom,20)
            
            
            Image("chain")
                .resizable()
                .frame(width: 222, height: 222)
            
            Image("Connect(2)")
                .resizable()
                .frame(width: 420, height: 150)
        }
    }
}

#Preview {
    StartView()
}
