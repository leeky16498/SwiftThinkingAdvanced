//
//  CustomNavbar.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 21/03/2022.
//

import SwiftUI

struct DefaultButtonViewModifier : ViewModifier {
    
    let background : Color
    //변화를 주고 싶은 항목에 대해 변수를 선언해서 다음과 같이 변화를 주는 것도 얼마든지 가능하다.
    
    func body(content: Content) -> some View {
        content // 여기에다가 모디파잉을 해서 아래에다가 리턴해준다.
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth : .infinity)
            .frame(height : 55)
            .background(background)
            .cornerRadius(30)
            .shadow(radius: 10)
            .padding()
        // 다음과 같이 많은 모디파이어들을 정의해서 한번에 간단하게 호출하고 사용이 가능하다.
        //모디파잉을 각각 해줘야하는 것들은 모디파이어에서 제거해주고 그냥 붙여서 선언해주어야 한다. 그래야 디자인이 편하다. 예를 들어 패딩값은 각 버튼마다 다를 수 있기 때문에 적용해주면 된다.
        //동일하게 적용해주고 싶은것들에 대해서만 선언해준다.
    }
    
}

struct CustomModifier: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .withDefaultButtonFormatting()
            //아래 보이는 것처럼 뷰에 익스텐션을 통해서 모디파이어 사용을 위한 함수를 추가해주게 되면 지금처럼 간단하게 호출하여 수정이 가능하다.

            Text("Hello, Everyone!")
                .modifier(DefaultButtonViewModifier(background: .blue))
            
            Text("Hello!!!!!")
                .modifier(DefaultButtonViewModifier(background: .red))
        }
    }
}

extension View {
    
    func withDefaultButtonFormatting() -> some View {
        self
            .modifier(DefaultButtonViewModifier(background: Color.green))
    }
}

struct CustomNavbar_Previews: PreviewProvider {
    static var previews: some View {
        CustomModifier()
    }
}
