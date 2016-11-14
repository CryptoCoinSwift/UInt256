//
//  UInt256TestBitwise.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

import XCTest
@testable import UInt256

class UInt256TestBitwise: XCTestCase {

    #if DEBUG
        let million: Int = 1_000_0
    #else
        let million: Int = 1_000_000
    #endif

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLeftShift() {
        let a = UInt256(decimalStringValue: "32")

        XCTAssertEqual((a << 1).toDecimalString, "64", "")
    }

    func testAssignLeftShift() {
        var a = UInt256(decimalStringValue: "32")

        a <<= 1

        XCTAssertEqual(a.toDecimalString, "64", "")
    }

    func testLeftShiftHex() {
        var a = UInt256(hexStringValue: "FFFFFFFF")
        a <<= 1

        XCTAssertEqual(a.toHexString, "1FFFFFFFE", "")
    }

    func testLeftShiftBigHex() {
        var a = UInt256(hexStringValue: "FFFFFFFFFFFFFFFFFFFF")
        a <<= 1

        XCTAssertEqual(a.toHexString, "1FFFFFFFFFFFFFFFFFFFE", "")
    }

    func testLeftShiftPerformance() {
        let a = UInt256(decimalStringValue: "57896044618658097711785492504343953926294709965899343556265417396524796608513")
        let b = UInt256(decimalStringValue: "115792089237316195423570985008687907852589419931798687112530834793049593217026")

        var res: UInt256 = 0

        self.measure() {
            for _: Int in Int(0) ..< Int(self.million) {
                res = a << 1
            }
        }

        XCTAssertEqual(res, b, "")
    }

    func testLeftShiftShouldNotMutate() {
        let a = UInt256(hexStringValue: "AAAAAAAAAAA")
        let b = a
        let _ = a << 1

        XCTAssertEqual(a, b, "")
    }

    func testRightShiftShouldNotMutate() {
        let a = UInt256(hexStringValue: "AAAAAAAAAAA")
        let b = a
        let _ = a >> 1

        XCTAssertEqual(a, b, "")
    }

    func testLeftOverflowHex() {
        var a = UInt256(hexStringValue: "1FFFFF")

        a <<= 1

        XCTAssertEqual(a.toHexString, "3FFFFE", "")
    }

    func testLeftShiftBig() {
        var a = UInt256(decimalStringValue: "32000000000000000000")
        a <<= 1

        XCTAssertEqual(a.toDecimalString, "64000000000000000000", "")
    }

    func testRightShift() {
        var a = UInt256(decimalStringValue: "64")
        a >>= 1

        XCTAssertEqual(a.toDecimalString, "32", "")
    }

    func testRightShiftBig() {
        var a = UInt256(decimalStringValue: "64000000000000000000")
        a >>= 1

        XCTAssertEqual(a.toDecimalString, "32000000000000000000", "")
    }

    func testFindHighestBit() {
        let a = UInt256(decimalStringValue: "6044618658097711785492504343953926294709965899343556265417396524796608513")

        var res = 0

        self.measure() {
            for _: Int in Int(0) ... Int(self.million / 100) {
                res = a.highestBit
            }
        }

        XCTAssertEqual(res, 242, "")
    }

    func testSingleBitAt() {
        var a = UInt256.singleBitAt(255)
        XCTAssertEqual(a.toHexString, "1", "")

        a = UInt256.singleBitAt(254)
        XCTAssertEqual(a.toHexString, "2", "")

        a = UInt256.singleBitAt(0)
        XCTAssertEqual(a.toHexString, "8000000000000000000000000000000000000000000000000000000000000000", "")
    }

    func testSetBitAt() {
        var a = UInt256.singleBitAt(255)
        a.setBitAt(255)

        XCTAssertEqual(a.toHexString, "1", "")

        self.measure() {
            for _: Int in Int(0) ... Int(self.million) {
                a.setBitAt(254)
            }
        }

        XCTAssertEqual(a.toHexString, "3", "")
    }
}
