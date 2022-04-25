//
//  UnitTestingClass.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 24/04/2022.
//

/*
 
1. unit tests
   - tests the business logic in your apps
 //말 그대로 로직에 대한 것, 구조체, 클래스 또는 열거형 등의 로직을 체크하는 것이다.
 
2. UI tests
  - tests the UI of your app
 //말 그대로 UI에 대한 것.
 */

import SwiftUI
import Foundation

struct UnitTestingClass: View {
    
    @StateObject private var vm : UnitTestingClassViewModel
    
    init(isPremium : Bool, dataService : newDataService) {
        _vm = StateObject(wrappedValue: UnitTestingClassViewModel(isPremium: isPremium, dataService: dataService))
    }
    
    var body: some View {
        Text(vm.isPremium.description)
    }
}

//struct UnitTestingClass_Previews: PreviewProvider {
//    static var previews: some View {
//        UnitTestingClass(isPremium: true)
//    }
//}
