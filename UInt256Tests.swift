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
        XCTAssertEqual(bi.description, "123456", "Should exist");
    }
    
    func testInitWithLargestDecimalNumber() {
        // The largest value for an unsigned 256 bit integer is 2^256 - 1
        let bi = UInt256(decimalStringValue: "115792089237316195423570985008687907853269984665640564039457584007913129639935")
        
        XCTAssertEqual(bi.description, "115792089237316195423570985008687907853269984665640564039457584007913129639935", "Should handle big number");

    }

}
