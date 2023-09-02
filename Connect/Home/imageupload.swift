//
//  imageupload.swift
//  Connect
//
//  Created by Daol on 2023/09/02.

//
import SwiftUI

struct imageupload: View {
    @State private var isCameraPresented = false
    @State private var image1: Image?
    @State private var image2: Image?
    
    var body: some View {
        VStack {
            TabView {
                // 첫 번째 탭. 이미지가 있는 경우 해당 이미지를 보여주고, 그렇지 않으면 Rectangle을 보여줍니다.
                if let image = image1 {
                    image
                        .resizable()
                        .frame(width: 393, height: 393)
                } else {
                    Rectangle()
                        .frame(width: 393, height: 393)
                }
                
                // 두 번째 탭. 이미지가 있는 경우 해당 이미지를 보여주고, 그렇지 않으면 Rectangle을 보여줍니다.
                if let image = image2 {
                    image
                        .resizable()
                        .frame(width: 393, height: 393)
                } else {
                    Rectangle()
                        .frame(width: 393, height: 393)
                }
            }
            // TabView 스타일 설정. 페이지 인디케이터가 항상 표시되도록 설정합니다.
            .tabViewStyle(.page(indexDisplayMode:.always))
            
            Button(action:{self.isCameraPresented = true}){
                Text("Take Photo")
            }
        }.sheet(isPresented:$isCameraPresented){
            CameraView(isShown:$isCameraPresented,image1:$image1,image2:$image2)
        }
        
    }
}

// 카메라 기능을 사용하기 위해 UIViewControllerRepresentable 프로토콜을 구현한 CameraView 구조체 정의
struct CameraView : UIViewControllerRepresentable {
    
    @Binding var isShown : Bool
    @Binding var image1 : Image?
    @Binding var image2 : Image?
    
    func makeCoordinator() -> Coordinator { return Coordinator(isShown:$isShown,image1:$image1,image2:$image2) }
    
    func makeUIViewController(context:UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        
        return picker
        
    }
    
    func updateUIViewController(_ uiViewController:UIImagePickerController,
                                context:UIViewControllerRepresentableContext<CameraView>) {}
    
    
    class Coordinator : NSObject,UINavigationControllerDelegate,
                        UIImagePickerControllerDelegate {
        
        @Binding var isCoordinatorShown : Bool
        @Binding var imagesInCoordinator1 : Image?
        @Binding var imagesInCoordinator2 : Image?
        
        init(isShown : Binding<Bool>,image1 :
             Binding<Image?>,image2 :
             Binding<Image?>) {
            
            _isCoordinatorShown = isShown
            _imagesInCoordinator1 = image1
            _imagesInCoordinator2=image2
            
        }
        
        func navigationController(_ navigationController:
                                  UINavigationController,didShow viewController:
                                  UIViewController,animated:
                                  Bool) {
            
            
        }
        
        func imagePickerControllerDidCancel(_ picker:
                                            UIImagePickerController) {
            
            self.isCoordinatorShown =
            false
            
            
        }
        
        
        func navigationController(_ navigationController:
                                  UINavigationController,willShow viewController:
                                  UIViewController,animated:
                                  Bool) {
            
        }
        
        
        // 이미지를 선택했을 때 호출되는 메서드. 선택한 이미지를 각 탭의 State 변수에 저장합니다.
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            self.imagesInCoordinator1 = Image(uiImage:unwrapImage)
            self.imagesInCoordinator2 = Image(uiImage:unwrapImage)
            self.isCoordinatorShown = false
        }
    }
}

// 프리뷰를 위한 구조체 정의
struct imageupload_Previews: PreviewProvider {
    static var previews: some View {
        imageupload()
    }
}
