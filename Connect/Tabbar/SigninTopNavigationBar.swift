//
//  SigninTopNavigationBar.swift
//  Connect
//
//  Created by Daol on 2023/09/02.
//

import SwiftUI

struct SigninTopNavigationBar: View {
    var body: some View {
     
            
            HStack(spacing: 25) {
                Image("backk")
                    .resizable()
                    .frame(width: 10, height: 16)
                
                Text("로그인")
                    .font(.system(size: 20, weight:.heavy))
                    .foregroundColor(Color.white)
            }
            .padding(.trailing,250)
        
    }
}

struct SigninTopNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        SigninTopNavigationBar()
    }
}
