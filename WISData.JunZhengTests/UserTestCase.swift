//
//  UserTestCase.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 8/28/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import XCTest
import Alamofire
@testable import WISData_JunZheng

class UserTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testUserLogin() {
        // Given
        let userName = "admin"
        let password = "admin"
        let loginException = self.expectationWithDescription("Completion handler called!")
        
        // When
        let request = User.login(username: userName, password: password) {(response: WISValueResponse<String>) -> Void in
            loginException.fulfill()
            // Then
            XCTAssertTrue(response.success, response.message)
        }
        printURLRequestInfo(request: request)
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func printURLRequestInfo(request request: Request) {
        print("HTTP Header is: \n \(request.request?.allHTTPHeaderFields)\n")
        print("HTTP Method is: \n \(request.request?.HTTPMethod)\n")
        print("URL is: \n \(request.request?.URLString)\n")
    }
    
}
