//
//  TransltionClass.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 21/03/2022.
//

import SwiftUI

struct RotateViewModifier : ViewModifier {
    
    let rotation : Double
    
    func body(content: Content) -> some View {
//        content
//            .rotationEffect(Angle(degrees: rotation))
        
          content
            .rotationEffect(Angle(degrees: rotation))
            .offset(x: rotation != 0 ? UIScreen.main.bounds.width : 0, y: rotation != 0 ? UIScreen.main.bounds.height : 0)
    }
}

extension AnyTransition {
    static var rotating: AnyTransition {
//        return AnyTransition.modifier(active: RotateViewModifier(rotation: 180), identity: RotateViewModifier(rotation: 0))
        
        return modifier(active: RotateViewModifier(rotation: 180), identity: RotateViewModifier(rotation: 0))
        //이렇게 모디파이어라고 선언해주고 사용해도 된다. 클린코드를 위해서
    }
    
    static func rotating(amount: Double) -> AnyTransition {
        return AnyTransition.modifier(active: RotateViewModifier(rotation: amount), identity: RotateViewModifier(rotation: 0))
    }
    
    static var rotateOn : AnyTransition {
        return AnyTransition.asymmetric(insertion: .rotating, removal: .move(edge: .leading))
    } // 에이시스메트릭형으로 해서 로테이팅을 넘겨받아 들여보낼수도 있다.
}


struct CustomTransltionClass: View {
    
    @State private var showRectangle : Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if showRectangle {
                RoundedRectangle(cornerRadius: 24)
                    .frame(width : 250, height : 250)
                    .frame(maxWidth : .infinity, maxHeight: .infinity)
//                    .modifier(RotateViewModifier(rotation: 45))
                //로테이션 트랜지션을 줄수도 있다.
//                   .transition(AnyTransition.rotating.animation(.easeInOut))
//                    .transition(.rotating(amount: 1080))
                //다음과 같이 해주면 확대되면서 나왔다고 도로 들어간다.
//                    .transition(.move(edge: .leading))
                //이렇게 해주면, 왼쪽에서 나왔다가 왼쪽으로 들어간다.
                    .transition(.rotateOn)
                //이렇게 커스텀해줄 수 있다.
                
            }
            
            Spacer()
            
            Text("Click me!")
                .withDefaultButtonFormatting()
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showRectangle.toggle()
                    }
                }
            //이렇게 편하게 모디파이어 사용이 가능해집니다!!!
            
        }
    }
}

struct TransltionClass_Previews: PreviewProvider {
    static var previews: some View {
        CustomTransltionClass()
    }
}
