//
//  CustomShapeAnimation.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 21/03/2022.
//

import SwiftUI

struct CustomShapeAnimation: View {

    @State private var isAnimating : Bool = false
    
    var body: some View {
        VStack {
            
            Pacman(offsetAmount: isAnimating ? 20 : 0)
                .frame(width : 100, height : 100)
            
            RectanglewithSingleCornerAnimation(cornerRadius: isAnimating ? 30 : 0)
                .frame(width : 100, height : 100)
            
            RoundedRectangle(cornerRadius: isAnimating ? 60 : 0)
                .frame(width : 200, height : 200)
        }
        .onAppear{
            withAnimation(.easeInOut(duration: 0.3).repeatForever()) {
                isAnimating.toggle()
            }
        }
        //이건 이제 가장 기본이 되는 거다요
    }
}

struct CustomShapeAnimation_Previews: PreviewProvider {
    static var previews: some View {
        CustomShapeAnimation()
    }
}

struct RectanglewithSingleCornerAnimation : Shape {
    
    //스테이트 변수가 없어서 코너레디어스만 해둔 상태에서는 애니메이션이 작동하지 않는다.
    var animatableData: CGFloat {
        get {cornerRadius}
        set {cornerRadius = newValue} // 이렇게 감싸주니 애니메이션이 작동한다.
    }
    
    var cornerRadius : CGFloat
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))

            
            path.addArc(
                center: CGPoint(x: rect.maxX-cornerRadius, y: rect.maxY - cornerRadius),
                radius: cornerRadius,
                startAngle: .degrees(0),
                endAngle: .degrees(360),
                clockwise: false)
            
            path.addLine(to: CGPoint(x: rect.maxX-cornerRadius, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            //순서도 잘 지켜주어야 한다.
        }
    }
}

struct Pacman : Shape {
    
    var offsetAmount : CGFloat
    
    var animatableData: CGFloat {
        get{offsetAmount}
        set{offsetAmount = newValue}
    }
    
    
    func path(in rect: CGRect) -> Path {
        Path {path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.minY),
                radius: rect.height / 2,
                startAngle: .degrees(offsetAmount),
                endAngle: .degrees(360 - offsetAmount),
                clockwise: false)
        } // 선을 그어주고, 아크를 붙여주는 식으로 작동한다. 그래서 물결이나 원을 그려줄 수 있다.
    }
    
    

    
    
}
