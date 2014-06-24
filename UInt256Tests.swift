//
//  UInt256Tests.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 24-06-14.
//

import XCTest
import CryptoCoin

class UInt256Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {
        let bi = UInt256(decimalStringValue: "123456")
        XCTAssertTrue(bi != nil, "Should exist")
    }

}
