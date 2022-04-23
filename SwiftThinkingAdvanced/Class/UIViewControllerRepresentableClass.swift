//
//  UIViewControllerRepresentableClass.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 23/04/2022.
//

import SwiftUI
import UIKit

struct UIViewControllerRepresentableClass: View {
    
    @State private var showScreen : Bool = false
    @State private var image : UIImage?
    
    var body: some View {
        VStack {
            Text("hi")
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width : 200, height : 200)
            }
            
            Button(action: {
                showScreen.toggle()
            }, label: {
                Text("Click here")
            })
            .sheet(isPresented: $showScreen) {
                UIImagePickerControllerRepresentable(image: $image, showScreen: $showScreen)
            }
        }
    }
}

struct UIViewControllerRepresentableClass_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerRepresentableClass()
    }
}

struct BasicUIViewControllerRepresentable : UIViewControllerRepresentable {

    let labelText : String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = MyFirstViewController()
        vc.labelText = labelText
        return vc
        //다음과 같이 스유와 유킷 간의 데이터 연결도 가능하다.
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct UIImagePickerControllerRepresentable : UIViewControllerRepresentable {
    
    @Binding var image : UIImage?
    @Binding var showScreen : Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.allowsEditing = false
        vc.delegate = context.coordinator
        return vc
    }
    
    //from SU to Ukit
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    //from Ukit to SU
    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, showScreen: $showScreen)
    }
    //다음을 통해서 유킷에서 스유로 데이터 전달이 가능하다.
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        @Binding var image : UIImage?
        @Binding var showScreen : Bool
        
        init(image : Binding<UIImage?>, showScreen : Binding<Bool>) {
            self._image = image
            self._showScreen = showScreen
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let newImage = info[.originalImage] as? UIImage else {return}
            image = newImage
            showScreen = false
        }
    }
    
}

class MyFirstViewController : UIViewController {
    
    var labelText : String = "Starting Value"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        let label = UILabel()
        label.text = labelText
        label.textColor = UIColor.white
        
        view.addSubview(label)
        label.frame = view.frame
    }
}
//다음과 같이 아예 뷰컨을 디자인해 버린 후에 전달해주는 방법도 있다.
