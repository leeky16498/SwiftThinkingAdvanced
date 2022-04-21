//
//  GeometryPreferenceKeyClass.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 22/03/2022.
//

import SwiftUI

struct GeometryPreferenceKeyClass: View {
    //이해가 간다. 뷰 간의 변수 전달은 기본적으로 바인딩을 통해서 하고 있다. 하지만 하위뷰와 상위뷰 간의 값 전달을 하게 될 때는 하위뷰에 있는 값을 프레퍼런스 키에 저장해서 상위뷰로 전달을 해주는 것이다. 그러면 이 값에 대해서 모두 일괄적인 적용이 가능해지게 된다.
    
    @State private var rectSize : CGSize = .zero
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Hello world!")
                    .background(.blue)
                    .frame(width : rectSize.width, height : rectSize.height)
            }
           
            Spacer()
            
            HStack {
                Rectangle()
                
                GeometryReader { geo in
                    Rectangle()
                        .updateRectangleGeoSize(geo.size) // 프리퍼런스 키로 지오싸이즈를 저장해주었다.
                }
                Rectangle()
            }
            .frame(height : 55)
        }
        .onPreferenceChange(RectangleGeometryPreferenceKey.self, perform: { value in
            self.rectSize = value
        })
    }
}

struct GeometryPreferenceKeyClass_Previews: PreviewProvider {
    static var previews: some View {
        GeometryPreferenceKeyClass()
    }
}

extension View {
    
    func updateRectangleGeoSize(_ size : CGSize) -> some View {
        preference(key: RectangleGeometryPreferenceKey.self, value: size)
    }
}


struct RectangleGeometryPreferenceKey : PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
    
}
