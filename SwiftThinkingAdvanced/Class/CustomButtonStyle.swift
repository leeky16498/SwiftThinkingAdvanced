//
//  CustomButtonStyle.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 21/03/2022.
//

import SwiftUI

struct PressableButtonStyle : ButtonStyle {
    
    let scaledAmount : CGFloat
    
    init(scaledAmount : CGFloat) {
        self.scaledAmount = scaledAmount
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label // configuration : 버튼의 레이블을 가르킨다.
//            .opacity(configuration.isPressed ? 0.3 : 1.0) 클릭될때의 밝기를 조정해줄 수 있다.
//            .brightness(configuration.isPressed ? 0.5 : 0)
        //클릭할 때 밝아지게 된다.
            .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
        //클릭해줄 때 스케일 이팩트가 적용되게 된다.
        //변수를 생성해주고 값을 받아서 모디파잉을 해줄수도 있다. 싱기방기
    }
}

extension View {
    
    func withPresssableStyle() -> some View {
        buttonStyle(PressableButtonStyle(scaledAmount: 0.5))
    }
}

struct CustomButtonStyle: View {
    var body: some View {
        Button(action: {
            
        }, label: {
            Text("Click me")
                .font(.headline)
                .frame(height : 55)
                .frame(maxWidth : .infinity)
                .background(.green)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
        })
//        .buttonStyle(.plain)
//        .buttonStyle(PressableButtonStyle(scaledAmount: 0.5))
        .withPresssableStyle()
        //익스텐션에 모디파이어를 생성해서 다음과 같이 그대로 붙여줄수도 있다. 위아래가 똑같다 지금.
        
    }
}

struct CustomButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        CustomButtonStyle()
    }
}
