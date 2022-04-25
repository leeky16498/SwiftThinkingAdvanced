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

    func test_NewDataService_init_doesSetValuesCorrectly() {
        //given
        let items : [String]? = nil
        
        //when
        let dataService = newDataService(items: items)
        
        //then
        XCTAssertFalse(dataService.items?.isEmpty)
    }

}
