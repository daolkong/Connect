//
//  imageupload.swift
//  Connect
//
//  Created by Daol on 2023/09/02.

//
import SwiftUI
import FirebaseFirestore // Add this line


struct imageupload: View {
    @State private var isCameraPresented = false
    @State private var image1: Image?
    @State private var image2: Image?

    @EnvironmentObject var authViewModel: AuthViewModel


    var body: some View {
        VStack {
            TabView {
                if let image = image1 {
                    image.resizable().frame(width: 430, height: 430)
                } else {
                    Rectangle().frame(width: 430, height: 430)
                }
                
                if let image = image2 {
                    image.resizable().frame(width: 430, height: 430)
                } else {
                    Rectangle().frame(width: 430, height: 430)
                }
            }.tabViewStyle(.page(indexDisplayMode:.always))
        }.onAppear() {
            self.isCameraPresented = true
        }.sheet(isPresented:$isCameraPresented){
            CameraView(isShown:$isCameraPresented,image1:$image1,image2:$image2)
                .environmentObject(authViewModel) // Pass the authViewModel to CameraView.

        }
    }
}

struct CameraView: UIViewControllerRepresentable {

    @Binding var isShown : Bool
    @Binding var image1 : Image?
    @Binding var image2 : Image?
    
    @EnvironmentObject var authViewModel: AuthViewModel


    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image1: $image1, image2: $image2, parent: self)
    }

    func makeUIViewController(context:UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator

        return picker

   }

   func updateUIViewController(_ uiViewController:UIImagePickerController,
                               context:UIViewControllerRepresentableContext<CameraView>) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

       @Binding var isCoordinatorShown : Bool
       @Binding var imagesInCoordinator1 : Image?
       @Binding var imagesInCoordinator2 : Image?
       
        let parent: CameraView // CameraView 인스턴스를 저장하는 프로퍼티

        init(isShown: Binding<Bool>, image1: Binding<Image?>, image2: Binding<Image?>, parent: CameraView) {
              _isCoordinatorShown = isShown
              _imagesInCoordinator1 = image1
              _imagesInCoordinator2 = image2
              self.parent = parent // CameraView 인스턴스를 초기화할 때 저장
          }

      // 이미지를 선택했을 때 호출되는 메서드. 선택한 이미지를 각 탭의 State 변수에 저장합니다.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {


           guard let unwrapImage =
                     info[UIImagePickerController.InfoKey.originalImage]
                     as? UIImage else { return }
           
            Task {
                      do {
                          // Save the image in the firebase storage and get the url.
                          if parent.image1 == nil { // parent를 통해 CameraView의 image1에 접근
                              parent.image1 = Image(uiImage: unwrapImage)
                              // Save the first image's url in firestore database.
                              let imageUrl1 = try await parent.authViewModel.saveImage(unwrapImage)
                              // ...
                          } else if parent.image2 == nil { // parent를 통해 CameraView의 image2에 접근
                              parent.image2 = Image(uiImage: unwrapImage)
                              // Save the second image's url in firestore database.
                              let imageUrl2 = try await parent.authViewModel.saveImage(unwrapImage)
                              // ...
                          }
                      } catch (let error){
                          print("Error saving the photo \(error)")
                      }
                  }

                  isCoordinatorShown = false
              }

     func imagePickerControllerDidCancel(_ picker:
                                         UIImagePickerController) {

         isCoordinatorShown =
         false

     }
  }
}

struct imageupload_Previews: PreviewProvider {
    static var previews: some View {
        imageupload()
    }
}
