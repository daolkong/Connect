//
//  imageupload.swift
//  Connect
//
//  Created by Daol on 2023/09/02.


import SwiftUI
import UIKit
import FirebaseFirestore

struct ImageUpload: View {
    @State private var isCameraPresented = false
    @State private var uiImage : UIImage?
    @State private var uiImage1 : UIImage?
    @EnvironmentObject var authViewModel: AuthViewModel
    
    let imageUrl: String
    
    var body: some View {
        VStack {
        
        }
    }
    
}


    

struct ImageUpload_Previews : PreviewProvider {
    static var previews:some View{
        ImageUpload(imageUrl:"")
    }
}


