//
//  AdvancedCombineClass.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 21/03/2022.
//

import SwiftUI
import Combine

class AdvancedCombineDataService {
    
//    @Published var basicPublisher : String = "first Publish"
    //가장 우리가 자주쓰는 퍼블리시 유형이다.
    //위 처럼 초기값을 설정하고 생산을 시작할수도 있다.
    let currentValuePublisher = CurrentValueSubject<Int, Error>(1000)
    // 퍼블리셔는 두가지가 있다 : currentValuePublisher, passthroughPublisher
    // 이거는 제네릭 타입이며 대신 퍼블리싱하는 타입과 에러의 형태를 정해주어야 한다.
    // 얘는 하나의 값을 홀딩하는 친구이다.
    // 위와 아래의 친구는 같은 말이다
    let passThroughPublisher = PassthroughSubject<Int, Error>()
    //다음 친구는 passthroughSubject이다.
    //이 친구는 값을 가지지 않는 파이프 라인이므로 메모리에 관리에 조금 더 좋다.
    let boolPublisher = PassthroughSubject<Bool, Error>()
    let intPublisher = PassthroughSubject<Int, Error>()
   
  
    
    static let dataService = AdvancedCombineDataService()
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        let items = Array(0..<11)
        for value in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(value)) {
//                self.basicPublisher = items[value] // 얘는 @Published로 선언했을 때,
//                self.currentValuePublisher.send(items[value]) // 얘는 currentValueSubject타입의 퍼블리셔일 때이다.
                self.passThroughPublisher.send(items[value])
                // 이렇게 초기값을 사용하지 않는 경우에는 지금처럼 사용해주면 된다. 초기값 설정없이 파이프라인만 설치해주는 것이다.
                if value > 4 && value < 8 {
                    self.boolPublisher.send(true)
                    self.intPublisher.send(999)
                } else {
                    self.boolPublisher.send(false)
                }
                
                if value == items.indices.last {
                    self.passThroughPublisher.send(completion: .finished)
                } //배열을 통해서 퍼블리싱을 전달할때는 마지막 값에 대해서 컴플리션을 반드시 전달해주어야 생산을 시작한다.
            }
        }
    }
}

class AdvancedCombineClassViewModel : ObservableObject {
    
    @Published var dataArray : [String] = []
    @Published var error : String = ""
    @Published var dataBools : [Bool] = []
    
    let dataService = AdvancedCombineDataService.dataService
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
//        dataService.$basicPublisher
//        dataService.currentValuePublisher // @published가 아니면 달러싸인을 써주지 않아도 된다.
      
        
        //Sequence Operators   시퀀스 오퍼레이터 정리
        /*
            .first() // 퍼블리셔에서 첫번째 값만 구독하고 끝낸다.
            .first(where: {$0 > 4}) // 이렇게 되면 5부터 첫 값을 출력해서 5하고 끝난다.
            .tryFirst(where: { int in
                if int == 3 {
                    throw URLError(.badServerResponse)
                }
                return int > 4
            }) // 에러를 리턴하는 first이다. 우리는 4보다 큰 첫 값을 출력할거지만 만약 3이 있는 경우 에러를 리턴할 것이다. 라고 했기 때문에 현재 에러가 나오지 않는 중이다. 이걸 하게되면 에러를 핸들링해줄 수 있다.
            .last() // 10초뒤에 마지막 아이템이 출력된다.
            .last(where: {$0 > 4}) // 4보다 큰 것들중에 마지막 값을 출력한다.
            .tryLast(where: { int in
                if int == 3 {
                    throw URLError(.badServerResponse)
                }
                return int > 4
            }) // 3을 생산하는 순간에 멈추고 에러를 리턴한다.
            .dropFirst() // 처음에 들어오는 값을 제외한다.
            .dropFirst(3) // 처음에 들어오는 3개의 값을 제외한다.
            .drop(while: {$0 < 5}) // 조건에 맞는 값 만큼을 제외하고 생산한다.
            .tryDrop(while: <#T##(Int) throws -> Bool#>) // 이 친구는 기존의 트라이와 똑같다. 비슷하니까는, 생략하고 넘어간다. 위처럼 조건에 따라서 에러를 리턴해 줄 수 있다.
            .prefix(10) // 처음부터 숫자만큼을 생산한다.
            .prefix(while: {$0 < 5}) // 조건을 만족할 때 끝난다.
            .tryPrefix(while: <#T##(Int) throws -> Bool#>) // try계열과 비슷하게 에러를 핸들링한다. 생략한다.
            .output(at: 1) 퍼블리셔의 인덱스에 해당하는 값을 퍼블리싱한다. 여기에서는 인덱스 1번이므로 1이 나온다, 2를 쓰면 2가 나옴
            .output(in: 1..<5) // 인덱스의 범위를 정해줄 수 있다
         
         */
        
        //Mathmatic operations 매스매틱 오퍼레이터
        /*
            .max() // 최대값을 생성한다.
            .tryMax(by: <#T##(Int, Int) throws -> Bool#>) // 조건에 따라서 에러를 핸들링한다
            .min() // 최소값을 뽑아낸다.
            .min(by: <#T##(Int, Int) -> Bool#>)
            .tryMin(by: <#T##(Publishers.Comparison<PassthroughSubject<Int, Error>>.Output, Publishers.Comparison<PassthroughSubject<Int, Error>>.Output) throws -> Bool#>) // 모두 최소값을 뽑아내는 것이다.
         */
        
        //filter, Reducing, Map Operations 고차함수 적용
        /*
            .tryMap( { int in
                if int == 5 {
                    throw URLError(.badServerResponse) // 매핑하는 중 조건에 대해서 에러를 던져준다. 예외항을 만들 수 있다.
                }
                return String(int)
            }) // 매핑하는 중 에러를 리턴해준다.
            .compactMap( { int in
                if Int == 5 {
                    return nil
                }
                return String(int)
            }) // 옵셔널을 포함하는 친구들에 대해서 nil을 포함한 친구를 제외하고 모두 깔끔하게 옵셔널을 벗겨준다.
            .tryCompactMap(<#T##transform: (Int) throws -> T?##(Int) throws -> T?#>) // 컴팩트맵에 대한 에러를 핸들링한다.
            .filter({$0 > 3}) // 괄호 안의 조건을 만족하는 퍼블리셔를 뱉어준다.
            .tryFilter(<#T##isIncluded: (Publishers.Filter<PassthroughSubject<Int, Error>>.Output) throws -> Bool##(Publishers.Filter<PassthroughSubject<Int, Error>>.Output) throws -> Bool#>) // 필터하는 중 발생하는 에러를 핸들링한다.
//            .removeDuplicates() // 반복되는 퍼블리셔를 삭제하고 전달해준다.(1, 1, 2, 3, 4) -> 1, 2, 3, 4 이렇게 하나를 스킵하고 전달해준다.
            .tryRemoveDuplicates(by: <#T##(Int, Int) throws -> Bool#>) // 에러 핸들링 생략
            .replaceNil(with: 5) // 저 with값은 제네릭이다. 따라서 모든 값을 넣어줄 수 있다. 문자열도 가능하다. nil값이 뱉어질 때 with 안의 값을 대체해서 넘겨준다.
            .replaceEmpty(with: []) // 배열이 비어있는 상태로 들어올 때  with 안의 배열을 뱉어준다.
            .replaceEmpty(with: "Default value") //에러가 발생하면  throw되는 에러를 with안의 값으로 바꿔서 던져준다.
            .scan(0, { existingValue, newValue in
                return existingValue + newValue
            }) // 이렇게 해주면, 0을 초기값으로 하는 existingValue에다가 퍼블리셔를 통해서 들어오는 newValue를 순차적으로 누적해서 새로운 퍼블리셔를 생성해준다.
        //scan(1로 시작하면 1+1 인 2에서부터 출력이 시작된다.
            .scan(0, {$0 + $1}) // 위에랑 같은 말이다. 깔끔하다.
            .scan(0, +) // 이렇게도 써줄 수 있다.
            .reduce(0, { existingValue, newValue in
                return existingValue + newValue
            }) // 위의 스캔 값과 똑같은 행위를 진행한다. 하지만 가장 최종값만을 뱉어내게 된다. 하나씩 더해주면서 그 값을 삭제하고 최종 55를 뱉어낸다.
            .reduce(0, +)
            .collect() // 이렇게 해주게 되면 1열의 배열로 매핑된 값들을 만들어줄 수 있다.
            .collect(3) // 이렇게 써주면 값들이 3개씩으로 구성된 배열을 뱉어낸다 [1, 2, 3], [4, 5, 6,]  이런색으로 뱉어내게 된다.
            .allSatisfy({$0 == 5}) // 모든 퍼블리셔의 값들이 조건을 만족 ? true, 아니다? false를 뱉어내게 된다.
            .tryAllSatisfy( )//하는 동안 에러 핸들링이 가능하다.
        */
        
        //Timing operations 타이밍 오퍼레이션
        /*
            .debounce(for: 1, scheduler: DispatchQueue.main) // 퍼블리셔의 생산시간 차이가 1초이상 나야 실행이 된다. 예를 들자면 타이핑을 막 하다가 1초 이상 시간을 멈춰야지만 신호가 전해지게 된다.
            .delay(for: 2, scheduler: DispatchQueue.main) // 퍼블리셔의 생산이 2초 뒤부터 시작된다. 생산간격이 2초인 것이 아니다. 개념 확실히 잡기.
            .measureInterval(using: DispatchQueue.main) // 나노초 단위의 값이 출력된다. 각 퍼블리셔간의 시간 간격이 나노초 단위로 명시되게 된다.하지만 받아온 값을 매핑해서 문자열로 변경해줘야 한다.
            .map { stride in
                return "\(stride)"
            } //
            .throttle(for: 10, scheduler: DispatchQueue.main, latest: true)
        //위의 스로틀은 10초뒤에 10초에 해당하는 가장 최신값을 가져온다. 1이 출력되고 10초가 지난 후 10이 출력된다.
            .throttle(for: 10, scheduler: DispatchQueue.main, latest: false)
        //위의 스로틀은 10초 뒤에 그 다음 값이 출력된다. 1일 출력되고 10초 후 2가 출력된다.
            .throttle(for: 5, scheduler: DispatchQueue.main, latest: true)
        //스로틀을 5로 걸면 건너뛰고 출력한다.이렇게 된 상태라면 지금은 1을 출력 후 2초 뒤에 5를 출력한다.
            .retry(3) // 퍼블리싱을 재시도 하는 것이다. 3번 에러나면 에러를 출력한다.
            .timeout(0.75, scheduler: DispatchQueue.main) // 퍼블리싱에 0.75초 이상이 걸리면 퍼블리싱을 멈춘다.
            
        */
        
        //Mutiple Publisher, Subscribers 다수 퍼블리셔 및 섭스크라이버
        /*
//            .combineLatest(dataService.boolPublisher)
//            .compactMap({ int, bool in
//                if bool {
//                    return String(int)
//                }
//                return nil
//            }) // 퍼블리셔의 조건을 통해서 새로운 값을 뱉어줄 수 있다.
//            .compactMap($1 ? String($0) : nil) // 위 아래가 같다.
//            .removeDuplicates()
//            .merge(with: dataService.intPublisher) // 퍼블리셔를 하나로 합쳐서 동시에 생성되게 한다.
//            .zip(dataService.boolPublisher) // 위에서 선언한 기존 퍼블리셔와 함께 튜플값으로 묶여서 나오게 된다.
//            .map { tuple in
//                return tuple.0
//            } // 이런식으로 원하는 값을 전달 가능
//            .tryMap({ _ in
//                throw URLError(.badServerResponse)
//            })
//            .catch({ error in
//                return self.dataService.intPublisher // 에러가 발생하는 구건에서 에러를 잡아서 원하는 값으로 핸들링이 가능하다.
//            })
         */
        
        let sharedPublisher = dataService.passThroughPublisher
//            .dropFirst(3)
            .share()
            .multicast {
                PassthroughSubject<Int, Error>()
            }
        
       sharedPublisher // 이게 일단 가장 일반적인 퍼블리싱
        //여기에 sharedPublisher 이렇게 써주면 나눠지는 퍼블리셔로 생성하고 양쪽에 전달 가능하다.
//        dataService.passThroughPublisher
            .map {String($0)}
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            } receiveValue: { [weak self] returnedValue in
                self?.dataArray.append(returnedValue)
            } // 퍼블리셔에서 생산하는 것을 실시간으로 구독자가 주워담아준다.
            .store(in: &cancellables)
        
        sharedPublisher// 이게 일단 가장 일반적인 퍼블리싱
            .map {$0 > 5 ? true : false}
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            } receiveValue: { [weak self] returnedValue in
                self?.dataBools.append(returnedValue)
            } // 퍼블리셔에서 생산하는 것을 실시간으로 구독자가 주워담아준다.
            .store(in: &cancellables)
                   
//                   DispatchQueue.main.asyncAfter(deadline: .now()+5) {
//                sharedPublisher
//                    .connect()
//                    .store(in: &self.cancellables)
//            } // 이렇게 하게되면 4초가 지나고 난뒤에 퍼블리셔와 연결된다.
    }
    
}

struct AdvancedCombineClass: View {
    
    @StateObject private var vm = AdvancedCombineClassViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray, id: \.self) {
                    Text("\($0)")
                
                    //여기에서 작업이 끝나고도 각 클래스의 퍼블리셔는 모두 살아있는 상태이다.
                }
                
                if !vm.error.isEmpty {
                    Text(vm.error)
                }
            }
            
            VStack {
                ForEach(vm.dataBools, id: \.self) {
                    Text("\($0.description)")
                
                    //여기에서 작업이 끝나고도 각 클래스의 퍼블리셔는 모두 살아있는 상태이다.
                }
                
                if !vm.error.isEmpty {
                    Text(vm.error)
                }
            }
        }
    }
}

struct AdvancedCombineClass_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedCombineClass()
    }
}
