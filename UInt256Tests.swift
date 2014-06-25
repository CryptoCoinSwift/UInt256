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
    
    func test12DigitNumber() {
        let bi = UInt256(decimalStringValue: "100000000000")
        XCTAssertTrue(bi != nil, "Should exist");
    }
    
    func testEquality() {
        let a =  UInt256(decimalStringValue: "100000000000")
        let b =  UInt256(decimalStringValue: "100000000000")

        XCTAssertTrue(a == b, "Should be the same");
    }
    
    func testComparison() {
        let smaller = UInt256(decimalStringValue: "100000000000")
        let bigger =  UInt256(decimalStringValue: "100000000001")
        
        XCTAssertTrue(smaller < bigger, "Should compare");
    }

    func testInitWith16BitMaxHexNumber() {
        // The largest value for an unsigned 16 bit integer is 2^16 - 1
        let bi = UInt256(hexStringValue: "FFFF")
        
        XCTAssertTrue(bi != nil, "Should exist");
        
    }


    func testInitWith32BitHexNumber() {
        // The largest value for an unsigned 32 bit integer is 2^32 - 1
        let bi = UInt256(hexStringValue: "7FFFFFFF")
        
        XCTAssertTrue(bi != nil, "Should exist");
        
    }
    
    func testInitWithHalfMax32BitHexNumber() {
        // The largest value for an unsigned 32 bit integer is 2^32 - 1
        let bi = UInt256(hexStringValue: "80000000")
        
        XCTAssertTrue(bi != nil, "Should exist");
        
    }
    
    func testInitWith32BitMaxHexNumber() {
        // The largest value for an unsigned 32 bit integer is 2^32 - 1
        let bi = UInt256(hexStringValue: "FFFFFFFF")
        
        XCTAssertTrue(bi != nil, "Should exist");
        
    }
    
    func testInitWith64BitMaxHexNumber() {
        // The largest value for an unsigned 64 bit integer is 2^64 - 1
        let bi = UInt256(hexStringValue: "FFFFFFFFFFFFFFFF")
        
        XCTAssertTrue(bi != nil, "Should exist");
        
    }

    
    func testInitWith128BitMaxHexNumber() {
        // The largest value for an unsigned 128 bit integer is 2^128 - 1
        let bi = UInt256(hexStringValue: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
        
        XCTAssertTrue(bi != nil, "Should exist");
        
    }

    func testInitWithLargestHexNumber() {
        // The largest value for an unsigned 256 bit integer is 2^256 - 1
        let bi = UInt256(hexStringValue: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
        
        XCTAssertTrue(bi != nil, "Should exist");
        
    }

    func testInitWithLargestDecimalNumber() {
        // The largest value for an unsigned 256 bit integer is 2^256 - 1
        let a = UInt256(decimalStringValue: "115792089237316195423570985008687907853269984665640564039457584007913129639935")
        let b = UInt256(hexStringValue: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
        
        XCTAssertEqual(a, b, "Should be the same as max hex");

    }
    
    func testInitWithExampleDecimalNumber() {
        let a = UInt256(decimalStringValue: "29048849665247")
        let b = UInt256(hexStringValue: "1A6B765D8CDF")
        
        XCTAssertEqual(a, b, "Should be the same as max hex");

    }
    
    func testAdd() {
        let a = UInt256(decimalStringValue: "14")
        let b = UInt256(decimalStringValue: "26")
        let c = UInt256(decimalStringValue: "40")
        
        XCTAssertEqual(a + b, c, "a + b = c");

    }
    
    func testAddBig() {
        let a = UInt256(decimalStringValue: "14000000123400000001")
        let b = UInt256(decimalStringValue: "26000000123400000001")
        let c = UInt256(decimalStringValue: "40000000246800000002")
        
        XCTAssertEqual(a + b, c, "\(a) + \(b) = \( c )");
    }
    
    func testSubtract() {
        let a = UInt256(decimalStringValue: "40")
        let b = UInt256(decimalStringValue: "26")
        let c = UInt256(decimalStringValue: "14")
        
        XCTAssertEqual(a - b, c, "a - b = c");
        
    }
    
    func testSubtractBig() {
        let a = UInt256(decimalStringValue: "40000000000000000000")
        let b = UInt256(decimalStringValue: "26000000000000000000")
        let c = UInt256(decimalStringValue: "14000000000000000000")
        
        XCTAssertEqual(a - b, c, "a - b = c");
        
    }
    



}
