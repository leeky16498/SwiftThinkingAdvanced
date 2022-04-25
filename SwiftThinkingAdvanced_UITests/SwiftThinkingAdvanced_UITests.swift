//
//  SwiftThinkingAdvanced_UITests.swift
//  SwiftThinkingAdvanced_UITests
//
//  Created by Kyungyun Lee on 25/04/2022.
//

import XCTest

class SwiftThinkingAdvanced_UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        // UI 테스트를 할때는 실제로 시뮬레이터가 가동되어야 한다.
        let app = XCUIApplication()
        app.launch() // 여기에서 실제로 앱을 런칭하게 된다.

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    } // 타임을 체크하는 퍼포먼스 테스트
}
