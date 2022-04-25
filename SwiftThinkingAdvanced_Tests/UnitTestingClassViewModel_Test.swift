//
//  UnitTestingClassViewModel_Test.swift
//  SwiftThinkingAdvanced_Tests
//
//  Created by Kyungyun Lee on 24/04/2022.
//

import XCTest
import Combine
@testable import SwiftThinkingAdvanced

    var viewModel : UnitTestingClassViewModel?
    var cancellables = Set<AnyCancellable>()

//naming structure : test_UnitOfWork_StateUnderText_ExpectedBehavior
//naming structure : test_[struct or class]_[variable or function]_[expected result]

//testing structure : Given, When, Then

class UnitTestingClassViewModel_Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = UnitTestingClassViewModel(isPremium: Bool.random())
        //이렇게 처음에 인스턴스를 생성해서 모든 테스트에 전부 전달해줘도 가능하다.
    }

    override func tearDownWithError() throws {
        viewModel = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_UnitTestingClassViewModel_isPremium_shouldBeTrue() {
        //given
        let userIsPremium : Bool = true
        //when
        let vm = UnitTestingClassViewModel(isPremium: userIsPremium)
        //then
        XCTAssertTrue(vm.isPremium)
    }
    
//    func test_UnitTestingClassViewModel_isPremium_shouldBeFalse() {
//        //given
//        let userIsPremium : Bool = false
//        //when
//        let vm = UnitTestingClassViewModel(isPremium: userIsPremium)
//        //then
//        XCTAssertFalse(vm.isPremium)
//    }
    
    func test_UnitTestingClassViewModel_isPremium_shouldBeInjectedValue() {
        //given
        let userIsPremium : Bool = Bool.random()
        let dataService = newMockDataService(items: nil)
        //when
        let vm = UnitTestingClassViewModel(isPremium: userIsPremium, dataService: dataService)
        //then
        XCTAssertEqual(vm.isPremium, userIsPremium)
    }
    
    func test_UnitTestingClassViewModel_isPremium_shouldBeBlankString2() {
        //given
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        //when
        vm.addItem(item: "")
        //then
        XCTAssertTrue(vm.dataArray.isEmpty)
        //이렇게 뷰모델을 심플하게 처리해줘도 정상적으로 작동이 잘 된다.
    }
    
    func test_UnitTestingClassViewModel_isPremium_shouldBeInjectedValue_stress() {
        for x in 0..<100 {
            func test_UnitTestingClassViewModel_isPremium_shouldBeInjectedValue() {
                //given
                let userIsPremium : Bool = Bool.random()
                //when
                let vm = UnitTestingClassViewModel(isPremium: userIsPremium)
                //then
                XCTAssertEqual(vm.isPremium, userIsPremium)
            }
        }
        //불리언 값의 값 처리에 대해서 100회를 돌려서 확인이 가능하다.
    }
    
    func test_UnitTestingClassViewModel_dataArray_ShouldBeEmpty() {
        //given
            
        //when
        let vm = UnitTestingClassViewModel(isPremium: Bool.random())
        //then
        XCTAssertTrue(vm.dataArray.isEmpty) // 안에 완전 비어있으므로 테스트 성공
        XCTAssertEqual(vm.dataArray.count, 0) // 디음과 같이해도 작동한다.
    }
    
    func test_UnitTestingClassViewModel_dataArray_ShouldAddItems() {
        //given
        let vm = UnitTestingClassViewModel(isPremium: Bool.random())
        //when
        let loopCount : Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
//        vm.addItem(item: UUID().uuidString) // guard를 벗어나지 못하므로 테스트를 실패한다.
        //then
        XCTAssertTrue(!vm.dataArray.isEmpty) // 안에 완전 비어있으므로 테스트 성공
        XCTAssertFalse(vm.dataArray.isEmpty)
        XCTAssertNotEqual(vm.dataArray.count, 0)// 다음과 같이해도 작동한다.
        XCTAssertEqual(vm.dataArray.count, loopCount) //같은 의미를 제공한다.
        XCTAssertGreaterThan(vm.dataArray.count, 0) // 같은의미이다. 모든 것에 대해서 참을 리턴한다.
    }
    //테스트 케이스에 랜덤 케이스를 집어 넣어서 모든 테스트 상황에 대한 결과를 얻을 수 있다.
    
    func test_UnitTestingClassViewModel_dataArray_ShouldNotBlankString() {
        //given
        let vm = UnitTestingClassViewModel(isPremium: Bool.random())
        //when
        vm.addItem(item: "") // guard를 벗어나지 못하므로 테스트를 실패한다.
        //then
        XCTAssertTrue(vm.dataArray.isEmpty) // 안에 완전 비어있으므로 테스트 성공
    }
    
    func test_UnitTestingClassViewModel_SelectedItem_shouldStartAsNil() {
        //given

        //when
        let vm = UnitTestingClassViewModel(isPremium: Bool.random())
        //then
        XCTAssertTrue(vm.selectedItem == nil) // 안에 완전 비어있으므로 테스트 성공
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_UnitTestingClassViewModel_SelectedItem_shouldStartAsNotNil() {
        //given
        let vm = UnitTestingClassViewModel(isPremium: Bool.random())
        //when
        let loopCount : Int = Int.random(in: 1..<100)
        var itemsArray : [String] = []
        
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        
        let randomItem = itemsArray.randomElement() ?? ""
        vm.selectedItem(item: randomItem)
        //then
//        XCTAssertFalse(vm.selectedItem == nil) // 안에 완전 비어있으므로 테스트 성공
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, randomItem) // 프로퍼티값을 비교할 수도 있다.
    }
    //지금과 같이 하는 테스트가 훨씬 로직의 복잡성을 확실하게 체크할 수 있는 테스트이다. 표본을 늘리고 랜덤한 경우의 수를 늘리는 것이다.
    
    func test_UnitTestingClassViewModel_saveItem_shouldThrowError_noData() {
        //given
        let vm = UnitTestingClassViewModel(isPremium: Bool.random())
        //when
        let loopCount : Int = Int.random(in: 1..<100)
        var itemsArray : [String] = []
        
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        let randomItem = itemsArray.randomElement() ?? ""
        //then
        
        do {
            try vm.saveItem(item: "")
        } catch let error{
            let returnedError = error as? UnitTestingClassViewModel.dataError
            XCTAssertEqual(returnedError, UnitTestingClassViewModel.dataError.noData)
        }
         // 두캐치를 써서 깔끔하게 에러에 대한 핸들링도 가능하다. 열거형의 연관된 값을 통해서 처리해주었다.
//        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString))
//        //에러를 잘 던지는지에 대해서 체크하는 부분이다.
//        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should throw item not found error") { error in
//            let returnedError = error as? UnitTestingClassViewModel.dataError
//            XCTAssertEqual(returnedError, UnitTestingClassViewModel.dataError.itemNotFound)
//        }
        //클로저를 열어서 에러를 받아다가 타입캐스팅 이후, 해당 타입에 대한 최종적인 테스트를 기입 가능하다.
        //위보다 아래의 에러테스트가 훨씬 더 정교하다.
        //다양한 상황에 대한 정교한 테스트가 가능해진다.
    }
    
    func test_UnitTestingClassViewModel_downloadWithEscaping_shouldReturnItems() {
        //given
        let vm = UnitTestingClassViewModel(isPremium: Bool.random())
        //when
        let expectation = XCTestExpectation(description: "should return items after 3 secounds")

        vm.$dataArray
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.downloadWithEscaping()
        
        //then
        wait(for: [expectation], timeout: 5) // 5초간 대기 시간을 부여한다.
        XCTAssertGreaterThan(vm.dataArray.count, 0)
        //에러가 나게 되는데 이유는 시간이 걸리는 비동기 함수이기 때문이다.
        //asnycronised code에 대한 테스트 방법이다.
    }
    
    func test_UnitTestingClassViewModel_downloadWithCombine_shouldReturnItems() {
        //given
        let vm = UnitTestingClassViewModel(isPremium: Bool.random())
        //when
        let expectation = XCTestExpectation(description: "should return items after 3 secounds")

        vm.$dataArray
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        vm.downloadWithCombine()
        
        //then
        wait(for: [expectation], timeout: 5) // 5초간 대기 시간을 부여한다.
        XCTAssertGreaterThan(vm.dataArray.count, 0)
        //에러가 나게 되는데 이유는 시간이 걸리는 비동기 함수이기 때문이다.
        //asnycronised code에 대한 테스트 방법이다.
    }
    
    
    
    
}
