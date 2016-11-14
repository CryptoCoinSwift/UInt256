//
//  BaseConverterTests.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 24-06-14.
//

import XCTest
import UInt256

class BaseConverterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConvertDecimalToHex() {
        let decimal: String = "42"
        let hex: String = "2A"
        XCTAssertEqual(BaseConverter.decToHex(decimal), hex, "Converts")
    }

    func testWithLargestDecimalNumberForUInt256() {
        // The largest value for an unsigned 256 bit integer is 2^256 - 1
        let decimal: String = "115792089237316195423570985008687907853269984665640564039457584007913129639935"

        let hex: String = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
        XCTAssertEqual(BaseConverter.decToHex(decimal), hex, "Converts huge")
    }
}
