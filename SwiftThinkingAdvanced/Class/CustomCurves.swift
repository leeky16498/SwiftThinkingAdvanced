//
//  CustomCurves.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 21/03/2022.
//

import SwiftUI

struct CustomCurves: View {
    var body: some View {
        VStack {
            WaterShape()
                .ignoresSafeArea()
//                .frame(width : 100, height : 100)
            
            QuadSample()
                .frame(width : 100, height : 100)
            
            shapeWithArc()
                .frame(width : 300, height : 300)
            //물론 커스텀 모형에 대한 모든 모디파잉도 가능하다.
            
            ArcSample()
                .stroke()
                .frame(width : 200, height : 200)
        }
    }
}

struct CustomCurves_Previews: PreviewProvider {
    static var previews: some View {
        CustomCurves()
    }
}

struct ArcSample : Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.height / 2,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 360),
                clockwise: false)
        } // 이렇게 옵션을 주면 서클이 생기게 된다.
    }
}

struct shapeWithArc : Shape {
    func path(in rect: CGRect) -> Path {
        Path {path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            //top - left
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            //top - right
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            //mid - right
            
//            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            //bottom
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY - 100),
                radius: rect.height / 2,
                startAngle: .degrees(0),
                endAngle: .degrees(180),
                clockwise: false)
            //손톱형태의 아크를 추가해줄 수 있다링.
            //미드값을 조절해서도 커스텀이 가능하다.
            
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            //mid - left
        }
    }
}

struct QuadSample : Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.midY),
                control: CGPoint(x: rect.maxX, y: rect.minY))
        }
        //부채꼴을 그려주는 중이다.
        //부채꿀의 경우, control 포인트는 부채꼴의 중심이 된다.
        //to, 는 커브를 그려주는 방향이다.
    }
}

struct WaterShape : Shape {
    func path(in rect: CGRect) -> Path {
        Path {path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.midY),
                control: CGPoint(x: rect.width*0.25, y: rect.height*0.25))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.midY),
                control: CGPoint(x: rect.width*0.75, y: rect.height*0.75))
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            
        }
    }
    
    
        
    
}
