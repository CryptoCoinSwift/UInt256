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
        XCTAssertTrue(bi != nil, "Should exist");
    }
    
    func test9DigitNumber() {
        let bi = UInt256(decimalStringValue: "100000000")
        XCTAssertTrue(bi != nil, "Should exist");
    }
    
    func test10DigitNumber() {
        let bi = UInt256(decimalStringValue: "1000000000")
        XCTAssertTrue(bi != nil, "Should exist");
    }
    
    func test11DigitNumber() {
        let bi = UInt256(decimalStringValue: "10000000000")
        XCTAssertTrue(bi != nil, "Should exist");
    }
    
//    func test12DigitNumber() {
//        let bi = UInt256(decimalStringValue: "100000000000")
//        XCTAssertTrue(bi != nil, "Should exist");
//    }
    
//    func testEquality() {
//        let a =  UInt256(decimalStringValue: "100000000000")
//        let b =  UInt256(decimalStringValue: "100000000000")
//
//        XCTAssertTrue(a == b, "Should be the same");
//    }
//    
//    func testComparison() {
//        let smaller = UInt256(decimalStringValue: "100000000000")
//        let bigger =  UInt256(decimalStringValue: "100000000001")
//        
//        XCTAssertTrue(smaller < bigger, "Should compare");
//    }
//    
//    func testInitWithLargestDecimalNumber() {
//        // The largest value for an unsigned 256 bit integer is 2^256 - 1
//        let bi = UInt256(decimalStringValue: "115792089237316195423570985008687907853269984665640564039457584007913129639935")
//        
//        XCTAssertEqual(bi.description, "115792089237316195423570985008687907853269984665640564039457584007913129639935", "Should handle big number");
//
//    }

}
