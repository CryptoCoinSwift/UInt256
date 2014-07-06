//
//  UInt256Tests.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 24-06-14.
//

import XCTest
import UInt256Mac // Use UInt256 for iOs

class UInt256Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitWith16BitMaxHex() {
        // The largest value for an unsigned 16 bit integer is 2^16 - 1
        let bi = UInt256(hexStringValue: "FFFF")
        
        XCTAssertTrue(bi != nil, "Should exist");
        
    }
    
    func testToHexString() {
        let bi = UInt256(hexStringValue: "FFFF")
        XCTAssertEqual(bi.toHexString, "FFFF", "");

    }

    func testInitWith32BitHex() {
        let bi = UInt256(hexStringValue: "7FFFFFFF")
        
        XCTAssertTrue(bi != nil, "Should exist");
        
    }

    func testInitWithHalfMax32BitHex() {
        // The largest value for an unsigned 32 bit integer is 2^32 - 1
        let bi = UInt256(hexStringValue: "80000000")
        
        XCTAssertTrue(bi != nil, "Should exist");
        
    }
    
    func testInitWith32BitMaxHex() {
        // The largest value for an unsigned 32 bit integer is 2^32 - 1
        let bi = UInt256(hexStringValue: "FFFFFFFF")
        
        XCTAssertTrue(bi != nil, "Should exist");
        
    }

    func testInitWith64BitMaxHex() {
        // The largest value for an unsigned 64 bit integer is 2^64 - 1
        let bi = UInt256(hexStringValue: "FFFFFFFFFFFFFFFF")
        
        XCTAssertTrue(bi != nil, "Should exist");
        
    }

    
    func testInitWithIntHexLiterals() {
        let a = UInt256(hexStringValue: "FFFFFFFFFFFFFFFF")
        let b = UInt256(0,0,0,0,0,0,0xFFFFFFFF,0xFFFFFFFF)

        XCTAssertTrue(a == b, b.description);
        
    }
    
    func testInitWithIntLiteral() {
        let a = UInt256(decimalStringValue: "50245")
        let b = UInt256(UInt32(50245))
        let c: UInt256 = 50245
        
        // 32 bit values:
        let d: UInt256 = 3221225472
        
        XCTAssertTrue(d.toDecimalString == "3221225472", "")

        
        XCTAssertTrue(a == b, b.description);
        XCTAssertTrue(a == c, c.description);


    }
    
    func testInitWith128BitMaxHex() {
        // The largest value for an unsigned 128 bit integer is 2^128 - 1
        let bi = UInt256(hexStringValue: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
        
        XCTAssertTrue(bi != nil, "Should exist");
        
    }

    func testInitWithLargestHex() {
        // The largest value for an unsigned 256 bit integer is 2^256 - 1
        let bi = UInt256(hexStringValue: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
        
        XCTAssertTrue(bi != nil, "Should exist");
        
    }
    
    func testInitWithDecimal() {
        let dec = UInt256(decimalStringValue: "42")
        let hex = UInt256(hexStringValue: "2A")

        XCTAssertEqual(dec, hex, "Should exist and be the same");
    }
    
    func testToDecimalString() {
        let bi = UInt256(decimalStringValue: "42")
        XCTAssertEqual(bi.toDecimalString, "42", "");
        
    }
    
    
    func test9DigitNumber() {
        let bi = UInt256(decimalStringValue: "100000000")
        XCTAssertTrue(bi != nil, "Should exist");
    }

    func test12DigitNumber() {
        let bi = UInt256(decimalStringValue: "100000000000")
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
    func testEquality() {
        let a =  UInt256(decimalStringValue: "100000000000")
        let b =  UInt256(decimalStringValue: "100000000000")

        XCTAssertTrue(a == b, "Should be the same");
    }
    
    func testAllZeros() {
        let a = UInt256(decimalStringValue: "131069")
        let b = UInt256(decimalStringValue: "65534")
        let c = UInt256.allZeros
        
        if(a == c || b == c) {
            XCTAssertTrue(false ,"Not zero")
        }
        
         XCTAssertTrue(a != c && b != c, "")
        
    }

    func testComparison() {
        let smaller = UInt256(decimalStringValue: "100000000000")
        let bigger =  UInt256(decimalStringValue: "100000000001")

        XCTAssertTrue(smaller < bigger, "Should compare");
        XCTAssertFalse(smaller > bigger, "Should compare");

    }
    
    func testCompareBig() {
        var smaller = UInt256(decimalStringValue: "340282366920938463463374607431768211454")
        var bigger =  UInt256(decimalStringValue: "340282366920938463463374607431768211455")
        
        XCTAssertTrue(smaller < bigger, "Should compare");
        XCTAssertTrue(bigger > smaller, "Should compare");
        
        smaller =   UInt256(decimalStringValue: "64333151529")
        bigger =    UInt256(decimalStringValue: "158113883008")

        XCTAssertTrue(smaller < bigger, "Should compare");
        XCTAssertTrue(bigger > smaller, "Should compare");
        
        XCTAssertFalse(smaller > bigger, "Should compare");
        XCTAssertFalse(bigger < smaller, "Should compare");
    }
    
    func testGreaterOrEqual() {
        var smaller =   UInt256(decimalStringValue: "64333151529")
        var bigger =    UInt256(decimalStringValue: "158113883008")
        
        XCTAssertTrue(smaller <= bigger, "Should compare");
        XCTAssertTrue(bigger >= smaller, "Should compare");
        
        XCTAssertFalse(smaller >= bigger, "Should compare");
        XCTAssertFalse(bigger <= smaller, "Should compare");
    }



    func testAdd() {
        let a = UInt256(decimalStringValue: "14")
        let b = UInt256(decimalStringValue: "26")
        let c = UInt256(decimalStringValue: "40")
        
        XCTAssertEqual(a + b, c, "a + b = c");

    }
    
    func testAddHex() {
        let a = UInt256(hexStringValue: "14")
        let b = UInt256(hexStringValue: "26")
        let c = UInt256(hexStringValue: "3A")

        XCTAssertEqual(a + b, c, "a + b = c");

    }
    

    func testAddBig() {
        let a = UInt256(decimalStringValue: "14000000123400000001")
        let b = UInt256(decimalStringValue: "26000000123400000001")
        let c = UInt256(decimalStringValue: "40000000246800000002")
        
        XCTAssertEqual(a + b, c, "\(a) + \(b) = \( c )");
    }
    
    func testAddBigHex() {
        let a   = UInt256(hexStringValue:  "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF") // 128 bit
        let b   = UInt256(hexStringValue:  "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE") // 128 bit
        let sum = UInt256(hexStringValue: "1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD") // 129 bit
        let result = a + b
        
        XCTAssertEqual(result, sum, result.toHexString);

    }
    
    func testSubtract() {
        let a = UInt256(decimalStringValue: "40")
        let b = UInt256(decimalStringValue: "26")
        let c = UInt256(decimalStringValue: "14")
        
        XCTAssertEqual(a - b, c, "a - b = c");
        
    }

    func testSubtractHex() {
        let a = UInt256(hexStringValue: "3A")
        let b = UInt256(hexStringValue: "26")
        let c = UInt256(hexStringValue: "14")

        XCTAssertEqual(a - b, c, "a - b = c");
        
    }

    func testSubtractBig() {
        let a = UInt256(hexStringValue: "40000000000000000000")
        let b = UInt256(hexStringValue: "26000000000000000001")
        let c = UInt256(hexStringValue: "19FFFFFFFFFFFFFFFFFF")
        
        XCTAssertEqual(a - b, c, "a - b = c");
        
    }
    
    func testSubtractBigger() {
         let a = UInt256(decimalStringValue: "489155902448849041265494486330585906971")
         let b = UInt256(decimalStringValue: "340282366920938463463374607431768211297")

         let c = UInt256(decimalStringValue: "148873535527910577802119878898817695674")

        XCTAssertEqual(a - b, c, "a - b = c");
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

    func testMultiply() {
        let a = UInt256(decimalStringValue: "32")
        let b = UInt256(decimalStringValue: "2")
        let c = UInt256(decimalStringValue: "64")
        
        let res: UInt256 =  a * b
        
        XCTAssertEqual(res, c, "\(a) * \(b) = \( res ) != \( c )");
        
    }
    
    func testSquare131070() {
        let a = UInt256(decimalStringValue: "131070")
        let b = UInt256(decimalStringValue: "131070")
        let product = UInt256(decimalStringValue: "17179344900") // 33 bits
        
        let res: UInt256 =  a * b
        
        XCTAssertEqual(res, product, res.description);
        
    }
    
    func testMultiplyShouldNotMutate() {
        let a = UInt256(decimalStringValue: "32")
        let b = UInt256(decimalStringValue: "2")
        let c = UInt256(decimalStringValue: "64")
        
        var res: UInt256 =  a * b
        res = a * b
        
        XCTAssertEqual(res, c, "Res mutated to \( res)");
        
        
    }

    func testMultiplyBig() {
        let a = UInt256(decimalStringValue: "32000000000")
        let b = UInt256(decimalStringValue:  "2000000000")
        let c = UInt256(decimalStringValue: "64000000000000000000")
        
        let res: UInt256 = a * b
        
        XCTAssertEqual(res, c, "\(a) * \(b) = \( res) != \( c )");
        
    }
    
    func testSquareUInt32Max() {
        let a = UInt256(hexStringValue: "FFFFFFFF")
        let c = UInt256(hexStringValue: "FFFFFFFE00000001")
        
        let res: UInt256 = a * a
        
        XCTAssertEqual(res, c, res.description);
        
    }
    
    func testSquareUInt60Max() {
        let a = UInt256(hexStringValue: "FFFFFFF")
        let c = UInt256(hexStringValue: "FFFFFFE0000001")
        
        let res: UInt256 = a * a
        
        XCTAssertEqual(res, c, res.description);
        
    }
  
    func testMultiplyUInt64MaxWith3() {
        let a = UInt256(hexStringValue: "FFFFFFFFFFFFFFFF") // UInt64.max
        let b = UInt256(hexStringValue: "3") // 0b0011

        let c = UInt256(hexStringValue: "2FFFFFFFFFFFFFFFD")
        
        let res: UInt256 = a * b
        
        XCTAssertEqual(res, c, res.description);
        
    }
    
    func testSquareUInt64Max() {
        let a = UInt256(hexStringValue: "FFFFFFFFFFFFFFFF") // UInt64.max
        let c = UInt256(hexStringValue: "FFFFFFFFFFFFFFFE0000000000000001")
        
        let res: UInt256 = a * a
        
        XCTAssertEqual(res, c, res.description);

    }
    
    func testMultiplyMax() {
        let a = UInt256(decimalStringValue: "340282366920938463463374607431768211455")
        let c = UInt256(decimalStringValue: "115792089237316195423570985008687907852589419931798687112530834793049593217025") // 0.9999999...% of UInt256 max
        
        let res:UInt256 = a * a
        
        XCTAssertEqual(res, c, res.description);

    }


    
    func testMultiplyOverflow() {
        let a = UInt256(hexStringValue: "8888888888888888888888888888888888888888888888888888888888888888")
        let b = UInt256(hexStringValue: "0000000000000000000000000000000000000000000000000000000000000002")
        let c = UInt256(hexStringValue: "1111111111111111111111111111111111111111111111111111111111111110")
        
        // Should crash: let res = a * b
        
        let res = a &* b
        
        XCTAssertTrue(res == c, "");
    }
    
    func testMultiplyToTuple() {
        let a = UInt256(hexStringValue: "8888888888888888888888888888888888888888888888888888888888888888")
        let b = UInt256(hexStringValue: "0000000000000000000000000000000000000000000000000000000000000002")
        let c = (UInt256(hexStringValue: "0000000000000000000000000000000000000000000000000000000000000001"), UInt256(hexStringValue: "1111111111111111111111111111111111111111111111111111111111111110"))
        
        // Should crash: let res = a * b
        
        let (resLeft, resRight) = a * b
        let (cLeft, cRight) = c

        
        XCTAssertTrue(resLeft == cLeft && resRight == cRight, "( \(resLeft), \(resRight) )");
    }

    func testModuloFromTuple() {
        let tuple = (UInt256(hexStringValue: "33F23902074835C68CC1630F5EA81161C3720765CC78C137D6434422659760CC"),UInt256(hexStringValue: "493EF0F253A03B4AB649EA632C432258F7886805422976F65A3E63DE32D809D8"))
    
        let p = UInt256(hexStringValue: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F")
        
        let modulo = UInt256(hexStringValue: "8FF2B776AAF6D91942FD096D2F1F7FD9AA2F64BE71462131AA7F067E28FEF8AC")
        
        let result = tuple % p
        
        XCTAssertEqual(result, modulo, result.toHexString)
    }
    
    func testMultiplyPartOverflow() {
        let a = UInt256(hexStringValue: "0000000000000000000000008888888888888888888888888888888888888888")
        let b = UInt256(hexStringValue: "0000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000")
        
        // This should crash:
        //        let res = a * b
        
        let res = a &* b
                        
        XCTAssertTrue(true, ""); // Just make sure it doesn't crash
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
    
    func testDivide() {
        let a = UInt256(decimalStringValue: "640")
        let b = UInt256(decimalStringValue: "4")
        let c = UInt256(decimalStringValue: "160")
        
        let res =  a / b

        XCTAssertEqual(res, c, "\(a) / \(b) = \( res ) != \( c )");
        
    }
    
    func testModulo() {
        let a = UInt256(decimalStringValue: "23")
        let b = UInt256(decimalStringValue: "5")
        let c = UInt256(decimalStringValue: "3")
        
        let res =  a % b
        
        XCTAssertEqual(res, c, "\(a) % \(b) = \( res ) != \( c )");
        
    }
    
    
    func testModuloLarger() {
        let a = UInt256(decimalStringValue: "25000000000000000000000000000000000000000000000000000000000000000000000004")
        let b = UInt256(decimalStringValue: "5000000000000000000000000000000000000")
        let c = UInt256(decimalStringValue: "4")
        
        let res =  a % b
        
        XCTAssertEqual(res, c, "\(a) % \(b) = \( res ) != \( c )");
        
    }
    
    func testModuloMoreComplex() {
        let a = UInt256(decimalStringValue: "2145932040592314323128185")
        let b = UInt256(decimalStringValue: "897983433434")
        let c = UInt256(decimalStringValue: "3")
        
        let res =  a % b
        
        XCTAssertEqual(res, c, "\(a) % \(b) = \( res ) != \( c )");
        
    }

    func testDivideBig() {
        let a = UInt256(decimalStringValue: "115792089237316195423570985008687907852589419931798687112530834793049593217025")
        let b = UInt256(decimalStringValue: "340282366920938463463374607431768211455")
        let c = UInt256(decimalStringValue: "340282366920938463463374607431768211455")
        
        let res =  a / b
        
        XCTAssertEqual(res, c, "\(a) / \(b) = \( res ) != \( c )");
        
    }

    func testModuloLargest128bitPrime() {
        // According to http://primes.utm.edu/lists/2small/100bit.html, 2^128-159 is prime
        // According to Ruby that's: 340282366920938463463374607431768211297
        
        var a = UInt256(decimalStringValue: "340282366920938463463374607431768211298")
        var b = UInt256(decimalStringValue: "340282366920938463463374607431768211297")
        var c = UInt256(decimalStringValue: "1")
        
        var res =  a % b
        
        XCTAssertEqual(res, c, "\(a) % \(b) = \( res ) != \( c )");
        
        // (2**128 - 159) * 55 + 5 (according to Ruby)
        a = UInt256(decimalStringValue: "18715530180651615490485603408747251621340")
        b = UInt256(decimalStringValue: "340282366920938463463374607431768211297")
        c = UInt256(decimalStringValue: "5")
        
        res =  a % b
        
        // Fails:
        XCTAssertEqual(res, c, "\(a) % \(b) = \( res ) != \( c )");
        

    }
    
    func testModuloBig() {
        let a = UInt256(decimalStringValue: "115792089237316195423570985008687907852589419931798687112530834793049593217026")
        let b = UInt256(decimalStringValue: "340282366920938463463374607431768211455")
        let c = UInt256(decimalStringValue: "1")
        
        let res =  a % b
        
        XCTAssertEqual(res, c, "\(a) % \(b) = \( res ) != \( c )");
        
    }
    
    func testModularMultiplicativeInverse() {
        let a = UInt256(hexStringValue: "FFFFFF")
        let m = UInt256(hexStringValue:  "fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f")
        
        let aInverse = UInt256(hexStringValue: "6A94546A94546A94546A94546A94546A94546A94546A94546A94546A29C01493")
        
        let res = a.modInverse(m)
        
        XCTAssertEqual(res, aInverse, res.toHexString);

    }
    
    func testModularMultiplicativeInverseSmall() {
        let p: UInt256 = 11
        let a: UInt256 =  5
        
        let inverse: UInt256 = 9 // 9  * 5 = 45 -> 45 % 9 = 1
        
        let result = a.modInverse(p)
        
        XCTAssertEqual(inverse, result, result.toDecimalString);
    }
}
