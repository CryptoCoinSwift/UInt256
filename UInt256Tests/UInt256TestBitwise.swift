//
//  UInt256TestBitwise.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

import XCTest
import UInt256Mac

class UInt256TestBitwise: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLeftShift() {
        var a = UInt256(decimalStringValue: "32")
        
        XCTAssertEqual((a << 1).toDecimalString, "64", "");
    }
    
    func testAssignLeftShift() {
        var a = UInt256(decimalStringValue: "32")
        
        a <<= 1
        
        XCTAssertEqual(a.toDecimalString, "64", "");
        
    }
    
    func testLeftShiftHex() {
        var a = UInt256(hexStringValue: "FFFFFFFF")
        a <<= 1
        
        XCTAssertEqual(a.toHexString,  "1FFFFFFFE", "");
        
    }
    
    func testLeftShiftBigHex() {
        var a = UInt256(hexStringValue: "FFFFFFFFFFFFFFFFFFFF")
        a <<= 1
        
        XCTAssertEqual(a.toHexString,  "1FFFFFFFFFFFFFFFFFFFE", "");
        
    }
    
    func testLeftShiftShouldNotMutate() {
        var a = UInt256(hexStringValue: "AAAAAAAAAAA")
        var b=a
        a << 1
        
        XCTAssertEqual(a, b, "");
    }
    
    func testRightShiftShouldNotMutate() {
        var a = UInt256(hexStringValue: "AAAAAAAAAAA")
        var b=a
        a >> 1
        
        XCTAssertEqual(a, b, "");
    }
    
    func testLeftOverflowHex() {
        var a = UInt256(hexStringValue: "1FFFFF")
        
        a <<= 1
        
        XCTAssertEqual(a.toHexString,   "3FFFFE", "");
        
    }
    
    func testLeftShiftBig() {
        var a = UInt256(decimalStringValue: "32000000000000000000")
        a <<= 1
        
        XCTAssertEqual(a.toDecimalString,   "64000000000000000000", "");
        
    }
    
    func testRightShift() {
        var a = UInt256(decimalStringValue: "64")
        a >>= 1
        
        XCTAssertEqual(a.toDecimalString, "32", "");
        
    }
    
    func testRightShiftBig() {
        var a = UInt256(decimalStringValue: "64000000000000000000")
        a >>= 1
        
        XCTAssertEqual(a.toDecimalString, "32000000000000000000", "");
    }
    
    
    func testSingleBitAt() {
        var a = UInt256.singleBitAt(255)
        XCTAssertEqual(a.toHexString, "1", "");
        
        a = UInt256.singleBitAt(254)
        XCTAssertEqual(a.toHexString, "2", "");
        
        a = UInt256.singleBitAt(0)
        XCTAssertEqual(a.toHexString, "8000000000000000000000000000000000000000000000000000000000000000", "");
    }
    
    func testSetBitAt() {
        var a = UInt256.singleBitAt(255)
        a.setBitAt(255)
        
        XCTAssertEqual(a.toHexString, "1", "");
        
        a.setBitAt(254)
        XCTAssertEqual(a.toHexString, "3", "");
        
    }
}
