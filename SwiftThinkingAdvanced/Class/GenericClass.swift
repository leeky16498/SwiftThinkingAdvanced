//
//  Generic.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 21/03/2022.
//

import SwiftUI

struct StringModel {
    let info : String?
    
    func removeInfo() -> StringModel {
        return StringModel(info: nil)
    }
}

struct BoolModel {
    let info : Bool?
    
    func removeInfo() -> BoolModel {
        return BoolModel(info: nil)
    }
}
// 보게되면 불모델이든 스트링모델이든 수행하는 값과 함수가 똑같다. 근데 타입이 다르기 때문에 구조체를 계속 분할해서 만들어줘야 하고, 이는 메모리를 잡아먹게 된다.

struct GenericModel<CustomType> {
    let info :CustomType?
    
    func removeInfo() -> GenericModel {
        return GenericModel(info: nil)
    }
}
//언제 제네릭을 써야할 까.? 틀을 정해두고 타입만 자유롭게 변경해가면서 사용한다면 제네릭을 통해서 사용하면 좋을 것 같다. 제네릭은 <여기 사이에 커스텀 타입의 명칭을 넣어주고 사용하면 된다. 얘는 모쿠진 타입이라 원하는 모든 타입을 대체할 수 있다.>

struct GenericModel1<T> {
    let info :T?
    
    func removeInfo() -> GenericModel1 {
        return GenericModel1(info: nil)
    }
}
//다음과 같은 코드를 보면서 당항활 필요가 없다. 이 구조체에는 모든 타입의 데이터를 생성하여 구조체를 사용할 수 있다는 의미이다. 저기. T라고 쓰여있는 것은 그냥 타입!이라고 대충 말해뒀다고 생각하면 좋다.


class GenericViewModel : ObservableObject {
    
    @Published var stringModel = StringModel(info: "Hello World")
    @Published var boolModel = BoolModel(info: true)
    @Published var genericStringModel = GenericModel(info: "Hello")
    @Published var genericBoolModel = GenericModel(info: true)
    
    func removeData() {
        stringModel = stringModel.removeInfo()
        boolModel = boolModel.removeInfo()
        genericStringModel = genericStringModel.removeInfo()
        genericBoolModel = GenericModel(info: true).removeInfo()
    }
//    @Published var dataArray : [Bool] = []
////    @Published var dataArray : [String] = []
//    //배열은 제네릭 타입이기 때문에 어떠한 자료형이든 모두 들어올 수 있다.
//
//    init() {
//        dataArray = [true, false, true]
//    }
//
//    func removeDataFromDataArray() {
//        dataArray.removeAll()
//    }
    
}

struct GenericClass: View {
    
    @StateObject var vm = GenericViewModel()
    
    var body: some View {
        VStack{
            
            GenericView(content: Text("customContent"), title: "new view")
            
            Text(vm.stringModel.info ?? "no data")
                .onTapGesture {
                    vm.removeData()
                }
            
            Text(vm.boolModel.info?.description ?? "no data")
                .onTapGesture {
                    vm.removeData()
                }
            Text(vm.genericBoolModel.info?.description ?? "generic bool optional")
                .onTapGesture {
                    vm.removeData()
                }
            Text(vm.genericStringModel.info ?? "generic String optional")
                .onTapGesture {
                    vm.removeData()
                }
        }
    }
}

struct GenericView<T:View> : View {
     // 제네릭으로 선언하고 뷰 프로토콜을 사용하면, 뷰에 해당하는 모든 타입을 사용할 수 있다.
    let content : T // 얘는 텍스트도 될 수 있고, 버튼도 될 수 있고, 뭐 아무거나 다 될 수 있다. 뷰에 해당하는 모든 것을 쓸 수 있다.
    let title : String
    
    var body: some View {
        VStack {
            Text(title)
            content
        }
    }
}


struct GenericClass_Previews: PreviewProvider {
    static var previews: some View {
        GenericClass()
    }
}
