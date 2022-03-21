//
//  ViewBuilderClass.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 21/03/2022.
//

import SwiftUI

struct HeaderViewRegular : View {
    
    let title : String
    let description : String?
    let iconName : String?
    
    var body: some View {
        VStack(alignment : .leading) {
            Text(title)
                .font(.largeTitle.bold())
                .fontWeight(.semibold)
            if let description = description {
                Text(description)
            }
            
            if let iconName = iconName {
                Image(systemName: iconName)
            }
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height :2)
            Spacer()
        }
        .frame(maxWidth : .infinity, alignment: .leading)
        .padding()
    }
}

struct CustomHStack<Content : View> : View {
    
    let content : Content
    
    init(@ViewBuilder content : () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            content
        }
    }
    
}

struct HeaderViewGeneric<T: View> : View {
    
    let title : String
    let content : T
    
    init(title : String, @ViewBuilder content : () -> T) {
        self.title = title
        self.content = content()
        //이건 클로저이다. 그래서
    }
    
    var body: some View {
        VStack(alignment : .leading) {
            Text(title)
                .font(.largeTitle.bold())
                .fontWeight(.semibold)
            
            content
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height :2)
            Spacer()
        }
        .frame(maxWidth : .infinity, alignment: .leading)
        .padding()
    }
}

struct ViewBuilderClass: View {
    var body: some View {
        VStack {
            HeaderViewRegular(title: "New title", description: "Hello", iconName: "checkmark.circle")
            HeaderViewRegular(title: "another title", description: nil, iconName: nil)
            HeaderViewGeneric(title: "Generic Title") {
                VStack{
                    Text("hi")
                    Text("hi")
                    Text("hi")
                    Text("hi")
                }
            }
            
            CustomHStack {
                Text("hi")
                Text("hi")
                Text("hi")
            }
            //제네릭 타입의 뷰를 선언해주면 지금처럼 자리에 버튼도 들어가고 텍스트도 들어가고 그냥 뷰에 해당되는 것들은 모두 다 때려박아 줄 수 있다.
            
        } // 이렇게 선언을 해주는게 가장 일반적인 상태이다.
    }
}

struct LocalViewBuilder : View {
    
    enum ViewType {
        case one, two, three
    }
    
    let type : ViewType
    
    private var viewOne: some View {
        Text("One!")
    }
    
    private var viewTwo: some View {
        VStack{
            Text("Two!")
            Image(systemName: "heart.fill")
        }
    }
    
    private var viewThree: some View {
        Image(systemName: "heart.fill")
    }
    
    @ViewBuilder private var headerSection : some View {
            if type == .one {
                viewOne
            } else if type == .two {
                viewTwo
            } else {
                viewThree
            }
    } // 뷰빌더로 감싸지 않으면, 오류가 난다. 뷰빌더로 위와같이 감싸주게 되면 뷰빌더가 클로저의 역할을 해줘서 뷰의 사용이 가능해지게 된다.
    
    var body: some View {
        VStack {
            headerSection
        }
    }
}

struct ViewBuilderClass_Previews: PreviewProvider {
    static var previews: some View {
        LocalViewBuilder(type: .two)
    }
}
