//
//  ScrollViewPreferenceKey.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 22/03/2022.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey : PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ScrollViewPreferenceKey: View {
    
    let title : String = "new title String"
    @State var scrollViewOffset : CGFloat = 0

    var body: some View {
            ScrollView {
                VStack{
                    titleLayer
                        .opacity(Double(scrollViewOffset / 64.0))
                        .onScrollViewOffsetChange { offset in
                            self.scrollViewOffset = offset
                        }
                    
                    contentLayer
                }
                .padding()
            }
            .overlay(
                Text("\(scrollViewOffset)")
            )
            .overlay(
                navBarLayer
                    .opacity(scrollViewOffset < 40 ? 1.0 : 0)
                ,alignment: .top
            )
        }
    }

struct ScrollViewPreferenceKey_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewPreferenceKey()
    }
}

extension ScrollViewPreferenceKey {
    
    var titleLayer : some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth : .infinity, alignment: .leading)
    }
    
    var contentLayer : some View {
        ForEach(0..<100) { _ in
            RoundedRectangle(cornerRadius: 10)
                .fill(.red)
                .frame(width : 300, height : 200)
        }
    }
    
    var navBarLayer : some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth : .infinity)
            .frame(height : 55)
            .background(.blue)
    }
}

extension View {
    
    func onScrollViewOffsetChange(action: @escaping(_ offset : CGFloat) -> ()) -> some View {
        self
            .background(
                GeometryReader { geo in
                    Text("")
                        .preference(key: ScrollViewOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                }
            )
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self, perform: { value in
                action(value)
            })
    }
}
//결과적으로 부모 뷰에 넘기고 싶은 값을 프레퍼런스 키로 그대로 넘겨줘서 뷰의 변화를 연관지어줄 수 있는 장점이 있다.
