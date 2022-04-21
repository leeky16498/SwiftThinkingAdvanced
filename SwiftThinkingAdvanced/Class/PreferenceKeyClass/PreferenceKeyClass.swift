//
//  PreferenceKeyClass.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 22/03/2022.
//

import SwiftUI

struct PreferenceKeyClass: View {
    
    @State private var text : String = "Hello, World!"
    
    var body: some View {
        NavigationView {
            VStack {
                SecondaryScreen(text: text) // 얘는 차일드 레벨
                    .navigationTitle("Title")
//                    .customTitle("new Value!!")
            }
        }
        .onPreferenceChange(CustomTitlePreferenceKey.self) { value in
            self.text = value
        }
    }
}

extension View {
    
    func customTitle(_ text : String) -> some View {
        self
            .preference(key: CustomTitlePreferenceKey.self, value: text)
    }
    
}

struct PreferenceKeyClass_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceKeyClass()
    }
}

//그래 그래서 프레퍼런스 키를 언제 쓰는가??


struct SecondaryScreen : View {
    
    let text : String
    @State var newValue : String = ""
    
    var body: some View {
        Text(text)
            .onAppear {
                getDataBase()
                    
            }
            .customTitle(newValue)
    }
    
    func getDataBase() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.newValue = "New Value from Database"
        }
    }
}

struct CustomTitlePreferenceKey : PreferenceKey {
    
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value  = nextValue()
    }
    
}
