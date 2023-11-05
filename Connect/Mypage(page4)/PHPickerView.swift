//
//  PHPickerView.swift
//  Connect
//
//  Created by Daol on 10/7/23.
//

import PhotosUI
import SwiftUI

struct PHPickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        private let parent: PHPickerView
        
        init(_ parent: PHPickerView) {
            self.parent = parent
            
            super.init()
            
            PHPhotoLibrary.requestAuthorization { status in }
            
         }
        
         func picker(_ picker:PHPickerViewController,didFinishPicking results:[PHPickerResult]){
             if !results.isEmpty{
                 results.first?.itemProvider.loadObject(ofClass:UIImage.self){ object,error in
                     if let image=object as? UIImage{
                         DispatchQueue.main.async{
                             self.parent.image=image
                         }
                     } else if let error = error {
                         print("Error occurred while picking photo from library:",error)
                     }
                 }
             }else{
                 print("No photo is selected")
             }

             DispatchQueue.main.async{
                self.parent.presentationMode.wrappedValue.dismiss()
             }
         }
   }

}
