//
//  NewMockDataService_Test.swift
//  SwiftThinkingAdvanced_Tests
//
//  Created by Kyungyun Lee on 25/04/2022.
//

import XCTest
import Combine
@testable import SwiftThinkingAdvanced

class NewMockDataService_Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_NewMockDataService_downloadItemsWithDataService_doesReturnValues() {
        //given
        let items : [String]? = nil
        let items2 : [String]? = []
        let items3 : [String]? = [UUID().uuidString, UUID().uuidString, UUID().uuidString]
        
        //when
        let dataService = newMockDataService(items: items)
        let dataService2 = newMockDataService(items: items2)
        let dataService3 = newMockDataService(items: items3)
        
        //then
        XCTAssertFalse(dataService.items.isEmpty)
        XCTAssertTrue(dataService2.items.isEmpty)
        XCTAssertEqual(dataService3.items.count, items3?.count)
        //테스트가 성공한다.
        //각 단계별에 대한 상태를 지정가능하다.
    }
    
    func test_NewMockDataService_downloadItemsWithEscaping_doesReturnValues() {
        //given
        let dataService = newMockDataService(items: nil)
        
        //when
        var items : [String] = []
        let expectation = XCTestExpectation(description: "should data be returned")
        
        dataService.downloadItemsWithEscaping { returnedItems in
            items = returnedItems
            expectation.fulfill()
        }

        //then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
    //비동기 작업에 대한 테스팅을 다음과 같이 처리해서 테스팅이 가능하다.
    //주요한 것들은 여기에 주어진 키워드들임.
    
    
    func test_NewMockDataService_downloadItemsWithCombine_doesReturnValues() {
        //given
        let dataService = newMockDataService(items: nil)
        
        //when
        var items : [String] = []
        let expectation = XCTestExpectation(description: "should data be returned")
        
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    break
                }
            } receiveValue: { returnedItems in
                items = returnedItems
                expectation.fulfill()
            }

        //then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }

}
