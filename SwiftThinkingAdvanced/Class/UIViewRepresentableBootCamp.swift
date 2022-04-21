//
//  UIViewRepresentable.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 21/04/2022.
//

import SwiftUI
import UIKit
import Foundation

//convert a UIView from UIKit to SwiftUI
struct UIViewRepresentableBootCamp: View {
    
    @State private var text : String = ""
    
    var body: some View {
        VStack{
            Text(text)
            HStack {
                Text("SwiftUI")
                TextField("Type here...", text: $text)
                    .frame(height : 55)
                .background(.gray)
            }
            //다음과 같이 UIKit으로 만들어준 뷰를 여기에 넣어줄 수 있다.
            HStack {
                Text("UIKit")
               UITextfieldViewRepresentable(text: $text)
                    .updatePlaceholder("hihi all!")
                    .frame(height : 55)
                .background(.gray)
            }
        }

    }
}

struct UIViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        UIViewRepresentableBootCamp()
    }
}

struct UITextfieldViewRepresentable : UIViewRepresentable {
    
    @Binding var text : String
    var placeholder : String
    let placeholderColor : UIColor
    
    init(text : Binding<String>, placeholder : String = "Default", placeholderColor : UIColor = .red) {
        self._text = text
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
    }
    
//    func makeUIView(context: Context) -> some UIView {
    //정확한 무엇을 반환할지 모르므로 UIView라고 언급해준다.
        func makeUIView(context: Context) -> UITextField {
        let textfield = getTextfield()
        textfield.delegate = context.coordinator
        return textfield
        //여기는 내가 사용할 뷰를 UIkit으로 그려주는 구간이다.
        //저기에서 텍스트필드에 해당하는 기능을 델리게잇 페턴을 통해서 가져오게 되는데 coordinator라는 프로퍼티로 접근할 것이다.
    }
    //from swiftUI to UIKit
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        //위에서 반환값을 변경했기 떄문에 파라미터 타입도 같이 변경해준다.
    }
    
    private func getTextfield() -> UITextField {
        let textfield = UITextField(frame: .zero)
        let placeholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor : placeholderColor
        ])
        textfield.attributedPlaceholder = placeholder
        return textfield
    }
    
    func updatePlaceholder(_ text : String) -> UITextfieldViewRepresentable {
        var viewRepresentable = self
        viewRepresentable.placeholder = text
        return viewRepresentable
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    } // 이 쿠디네이터가 바인딩 된 텍스트와 제작된 뷰 간의 데이터를 전달해준다.
    //쉽게 말하면 전달해야 할 데이터를 이것을 통해서 엮어주게 된다.
    
    class Coordinator : NSObject, UITextFieldDelegate {
        
        @Binding var text : String
        
        init(text : Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    //다음의 코디네이터 클래스를 통해서 전달해야 할 값을 델리게잇 패턴으로 연결한다.
}

struct BasicUIViewRepresentable : UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .red
        return view
        //여기는 뷰를 만들어 준다.
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
