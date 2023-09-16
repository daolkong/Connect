//
//  zsf.swift
//  Connect
//
//  Created by Daol on 2023/09/14.
//

//SwiftUI를 사용하여 앱을 개발하면서 Firebase를 백엔드로 사용하는 경우, 두 사용자 간에 이미지 공유 기능을 구현하려면 다음과 같은 과정이 필요합니다:
//
//버튼 클릭 시 Firestore에 요청을 보내어 상대방에게 알림을 전송합니다.
//상대방이 알림을 수락하면, 해당 이미지의 URL 정보를 Firestore에서 가져와 ConnectTodayView에 표시합니다.
//그러나 이런 과정은 복잡한 로직과 백엔드 구성이 필요하므로, 간단한 예제 코드만 제공할 수 있습니다.
//
//우선, 버튼 클릭 시 Firestore에 요청을 보내는 메소드를 추가해보겠습니다:
//
//swift
class ImageLoader : ObservableObject {
    // ...
    func sendRequest() {
        let db = Firestore.firestore()
        // Assuming 'users' collection and 'requests' document exists
        db.collection("users").document("requests").setData([
            "from": "<YourUserID>",
            "to": "<TargetUserID>",
            "imageURL": self.imageUrlString,
            "status": "pending"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
그리고 버튼 클릭 이벤트에서 sendRequest 메소드를 호출합니다:

swift
Button(action: {
    self.imageLoader.sendRequest()
}) {
    Image("Connect button")
        .resizable()
        .frame(width: 33, height: 33)
}
다음으로는 상대방이 수락했을 때 이미지가 ConnectTodayView에 표시되도록 합니다. 이를 위해서는 Firestore에서 알림의 상태가 변경되었는지 확인하는 리스너가 필요합니다.

swift
class ImageLoader : ObservableObject{
    
    @Published var imageUrlString : String?
    
    func listenForRequests() {
        let db = Firestore.firestore()

        db.collection("users").document("<YourUserID>")
          .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                  print("Error fetching documents: \(error!)")
                  return
              }
              guard let data = document.data() else { return }

              if data["status"] as? String == "accepted" &&
                 data["from"] as? String == "<TargetUserID>" {

                  self.imageUrlString = data["imageURL"] as? String

              }
          }
     }

     // ... Other methods ...
}
위 코드에서 <YourUserID>와 <TargetUserID>는 실제 사용자 ID로 대체해야 합니다. 또한, Firestore의 데이터 구조가 예시와 동일해야 합니다.

이렇게 하면 상대방이 알림을 수락하면 이미지 URL이 업데이트되고 ConnectTodayView에 표시됩니다. listenForRequests 메소드는 앱 시작 시점에 호출되어야 합니다.

하지만 이 코드는 매우 기본적인 예시로, 실제 앱에서는 보안 및 에러 처리 등 추가적인 고려사항이 있습니다. Firebase의 Cloud Functions를 사용하여 서버리스 함수를 작성하여 요청 및 수락 과정을 관리하는 것이 좋습니다. 또한, 이미지를 직접 Firebase Storage에 저장하고 URL만 Firestore에 저장하는 방식도 고려해볼 만합니다.
