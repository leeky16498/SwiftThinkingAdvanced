//
//  CustomShapes.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 21/03/2022.
//

import SwiftUI

struct Triangle : Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
    
}

struct Diamond : Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY)) // 시작점을 정하고
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            // 변을 그려나간다
            
        }
    }
}

struct Trapezoid : Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let horizontalOffset: CGFloat = rect.width*0.2
            path.move(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
        }
    }
    
    
    
}

struct CustomShapes: View {
    var body: some View {
        VStack{
            
            Trapezoid()
                .frame(width : 100, height : 100)
            
            Diamond()
                .frame(width : 100, height : 100)
            
            Image("Blur01")
                .resizable()
                .scaledToFit()
                .clipShape(Triangle())
            //다음처럼 커스텀이 된다.
                .frame(width : 100, height : 200)
            //이미지도 클립으로 잘라낼 수 있다.
            
            Triangle()
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, dash: [10]))
                .foregroundColor(.blue)
            //다음과 같이 점선으로 된 도형도 생성 가능하다.
//                .trim(from: 0, to: 0.5) // 대각 반절로 잘라버린다
//                .fill(
//                    LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .bottom, endPoint: .top)
//                )
            //일반적인 도형으로 선언하고 이리저리 커스텀이 가능하다.
                .frame(width : 300, height : 300)
            
            
        }
    }
}

struct CustomShapes_Previews: PreviewProvider {
    static var previews: some View {
        CustomShapes()
    }
}
