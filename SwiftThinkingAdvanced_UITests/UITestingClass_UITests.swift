//
//  UITestingClass_UITests.swift
//  SwiftThinkingAdvanced_UITests
//
//  Created by Kyungyun Lee on 25/04/2022.
//

import XCTest

//naming structure : test_UnitOfWork_StateUnderTest_ExpectedBehavior
//naming structure : test_[struct]_[uicomponents]_[expected result]
//testing structure : Given, When, Then

class UITestingClass_UITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
       
    }
    
    func test_UITestingClassView_signUpButton_shouldNotSignIn() {
        let textfield = app.textFields["Add your name.."]
        //when
        textfield.tap()
        
        let returnedButton = app.buttons["Return"]
        returnedButton.tap()
        
        let navButton = app.buttons["SignUpButton"]
        navButton.tap()
        
        let navBar = app.navigationBars["Welcome"]
        
        //then
        XCTAssertFalse(navButton.exists)
    }
    
    func test_UITestingClassView_signUpButton_shouldSignIn() {
        //여기 빈 공간에 커서를 두고 아래의 REC버튼을 누른다. 누르는 순서에 따라서 버튼의 탭 여부가 찍힌다.
        //다룬 순서에 따라서 그대로 나오게 된다.
        //실제 클릭했던 것들이 그대로 찍혀 나온다.
        
        //given
        let textfield = app.textFields["Add your name.."]
        //when
        textfield.tap()
        
        let keyA = app.keys["A"]
        keyA.tap()
        let keya = app.keys["a"]
        keya.tap()
        keya.tap()
        
        let returnedButton = app.buttons["Return"]
        returnedButton.tap()
        
        let signUpButton = app.buttons["SignUpButton"]
        signUpButton.tap()
        
        let navButton = app.buttons["Navigate"]
        navButton.tap()
        
        let navBar = app.navigationBars["Welcome"]
        
        //then
        XCTAssertTrue(navBar.exists)
    }
    
    func text_SignedInHomeView_showAlertButton_shoudDisplayAlert() {
        
        //given
        let textfield = app.textFields["Add your name.."]
        //when
        textfield.tap()
        
        let keyA = app.keys["A"]
        keyA.tap()
        let keya = app.keys["a"]
        keya.tap()
        keya.tap()
        
        let returnedButton = app.buttons["Return"]
        returnedButton.tap()
        
        let signUpButton = app.buttons["SignUpButton"]
        signUpButton.tap()
        
        let navButton = app.buttons["Navigate"]
        navButton.tap()
        
        let navBar = app.navigationBars["Welcome"]
        
        let alertButton = app.buttons["Show welcome alert!"]
        alertButton.tap()
        
        let alert = app.alerts["Welcome to the app!"]
        XCTAssertTrue(alert.exists)
//        sleep(1)
        let alertOkButton = alert.buttons["OK"]
        let exists = alertOkButton.waitForExistence(timeout: 5) // 얼럿 버튼의 생성시간을 조건으로 준다./
//        XCTAssertTrue(alertOkButton.exists)
        XCTAssertTrue(exists)
        //트루 값에 대해서 불리언을 프로퍼티로 넣어줘도 되고 지금처럼 상수에 담아서 리턴해줘도 문제 없다.
        
        alertOkButton.tap()
//        sleep(1) // 시간 차를 줘서 최종 UI의 상태를 추적 가능하다.
        //then
        XCTAssertFalse(alert.exists)
    }
    
    func tapAlertButton() {
        let showAlertButton = app.buttons["show Alert"]
        showAlertButton.tap()
    }
    
    func text_SignedInHomeView_showAlertButton_shoudNotDisplayAlert() {
        
        //given
        let textfield = app.textFields["Add your name.."]
        //when
        textfield.tap()
        
        let keyA = app.keys["A"]
        keyA.tap()
        let keya = app.keys["a"]
        keya.tap()
        keya.tap()
        
        let returnedButton = app.buttons["Return"]
        returnedButton.tap()
        
        let signUpButton = app.buttons["SignUpButton"]
        signUpButton.tap()
        
        let navButton = app.buttons["Navigate"]
        navButton.tap()
        
        let navBar = app.navigationBars["Welcome"]
        
       tapAlertButton() // 다음과 같이 함수로 각 과정을 집합시켜서 직접 선언해줘도 작동을 잘 한다.
        
        let alert = app.alerts["Welcome to the app!"]
        XCTAssertTrue(alert.exists)
        sleep(1)
        let alertOkButton = alert.buttons["OK"]
        alertOkButton.tap()
        sleep(1) // 시간 차를 줘서 최종 UI의 상태를 추적 가능하다.
        //then
        XCTAssertFalse(alert.exists)
        //다음과 같이 모든 버튼을 눌렀을 때 정상적으로 얼럿이 뜨는가? 라는 마무리로 테스트는 끝난다.
    }
}
