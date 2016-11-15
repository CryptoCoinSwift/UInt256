//
//  UInt256TestArithmetic.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

import XCTest
@testable import UInt256

class UInt256TestArithmetic: XCTestCase {

    let thousand = 1_000

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEquality() {
        let a = UInt256(decimalString: "115792089237316195423570985008687907852589419931798687112530834793049593217026")
        let b = UInt256(decimalString: "115792089237316195423570985008687907852589419932798687112530834793049593217026")

        var res = false

        self.measure() {
            for _ in 1 ... self.thousand {
                res = a != b
            }
        }

        XCTAssertTrue(res, "")
    }

    func testCompare() {
        let a = UInt256(decimalString: "115792089237316195423570985008687907852589419931798687112530834793049593217026")
        let b = UInt256(decimalString: "115792089237316195423570985008687907852589419932799687112530834793049593217026")

        var res = false

        self.measure() {
            for _ in 1 ... self.thousand {
                res = b > a
            }
        }

        XCTAssertTrue(res, "")
    }

    func testAdd() {
        let a = UInt256(decimalString: "14")
        let b = UInt256(decimalString: "26")
        let c = UInt256(decimalString: "40")

        XCTAssertEqual(a + b, c, "a + b = c")
    }

    func testAddHex() {
        let a = UInt256(hexString: "14")
        let b = UInt256(hexString: "26")
        let c = UInt256(hexString: "3A")

        XCTAssertEqual(a + b, c, "a + b = c")
    }

    func testAddBig() {
        let a = UInt256(decimalString: "14000000123400000001")
        let b = UInt256(decimalString: "26000000123400000001")
        let c = UInt256(decimalString: "40000000246800000002")

        XCTAssertEqual(a + b, c, "\(a) + \(b) = \(c)")
    }

    func testAddBigHex() {
        let a = UInt256(hexString: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF") // 128 bit
        let b = UInt256(hexString: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE") // 128 bit
        let sum = UInt256(hexString: "1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD") // 129 bit

        var result: UInt256 = 0

        self.measure() {
            for _ in 1 ... self.thousand {
                result = a + b
            }
        }

        XCTAssertEqual(result, sum, result.toHexString)
    }

    func testSubtract() {
        let a = UInt256(decimalString: "40")
        let b = UInt256(decimalString: "26")
        let c = UInt256(decimalString: "14")

        XCTAssertEqual(a - b, c, "a - b = c")
    }

    func testSubtractHex() {
        let a = UInt256(hexString: "3A")
        let b = UInt256(hexString: "26")
        let c = UInt256(hexString: "14")

        XCTAssertEqual(a - b, c, "a - b = c")
    }

    func testSubtractBig() {
        let a = UInt256(hexString: "40000000000000000000")
        let b = UInt256(hexString: "26000000000000000001")
        let c = UInt256(hexString: "19FFFFFFFFFFFFFFFFFF")

        XCTAssertEqual(a - b, c, "a - b = c")
    }

    func testSubtractBigger() {
        let a = UInt256(decimalString: "489155902448849041265494486330585906971")
        let b = UInt256(decimalString: "340282366920938463463374607431768211297")

        let c = UInt256(decimalString: "148873535527910577802119878898817695674")

        self.measure() {
            for _ in 1 ... self.thousand / 100 {
                let _ = a - b
            }
        }

        XCTAssertEqual(a - b, c, "a - b = c")
    }

    func testSquare131070() {
        let a = UInt256(decimalString: "131070")
        let b = UInt256(decimalString: "131070")
        let product = UInt256(decimalString: "17179344900") // 33 bits

        let res: UInt256 = a * b

        XCTAssertEqual(res, product, res.description)
    }

    func testMultiplyShouldNotMutate() {
        let a = UInt256(decimalString: "32")
        let b = UInt256(decimalString: "2")
        let c = UInt256(decimalString: "64")

        var res: UInt256 = a * b
        res = a * b

        XCTAssertEqual(res, c, "Res mutated to \(res)")
    }

    func testSquareUInt60Max() {
        let a = UInt256(hexString: "FFFFFFF")
        let c = UInt256(hexString: "FFFFFFE0000001")

        let res: UInt256 = a * a

        XCTAssertEqual(res, c, res.description)
    }

    func testMultiplyUInt64MaxWith3() {
        let a = UInt256(hexString: "FFFFFFFFFFFFFFFF") // UInt64.max
        let b = UInt256(hexString: "3") // 0b0011

        let c = UInt256(hexString: "2FFFFFFFFFFFFFFFD")

        let res: UInt256 = a * b

        XCTAssertEqual(res, c, res.description)
    }

    func testSquareUInt64Max() {
        let a = UInt256(hexString: "FFFFFFFFFFFFFFFF") // UInt64.max
        let c = UInt256(hexString: "FFFFFFFFFFFFFFFE0000000000000001")

        let res: UInt256 = a * a

        XCTAssertEqual(res, c, res.description)
    }

    //    func testMultiplyOverflow() {
    //        let a = UInt256(hexString: "8888888888888888888888888888888888888888888888888888888888888888")
    //        let b = UInt256(hexString: "0000000000000000000000000000000000000000000000000000000000000002")
    //        let c = UInt256(hexString: "1111111111111111111111111111111111111111111111111111111111111110")
    //
    //        // Should crash:
    //        let res = a * b
    //
    //        // Unsafe multiply is not supported, so this will crash as well:
    //        let res = a &* b
    //
    //        XCTAssertTrue(res == c, "")
    //    }

    func testMultiplyToTuple() {

        let a = UInt256(hexString: "8888888888888888888888888888888888888888888888888888888888888888")
        let b = UInt256(hexString: "0000000000000000000000000000000000000000000000000000000000000002")
        let c = (UInt256(hexString: "0000000000000000000000000000000000000000000000000000000000000001"), UInt256(hexString: "1111111111111111111111111111111111111111111111111111111111111110"))

        // Should crash: let res = a * b

        let (resLeft, resRight) = a * b
        let (cLeft, cRight) = c

        XCTAssertTrue(resLeft == cLeft && resRight == cRight, "( \(resLeft), \(resRight) )")
    }

    func testModuloFromTuple() {
        let tuple = (UInt256(hexString: "33F23902074835C68CC1630F5EA81161C3720765CC78C137D6434422659760CC"), UInt256(hexString: "493EF0F253A03B4AB649EA632C432258F7886805422976F65A3E63DE32D809D8"))

        let p = UInt256(hexString: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F")

        let modulo = UInt256(hexString: "8FF2B776AAF6D91942FD096D2F1F7FD9AA2F64BE71462131AA7F067E28FEF8AC")

        let result = tuple % p

        XCTAssertEqual(result, modulo, result.toHexString)
    }

    func testDivide() {
        let a = UInt256(decimalString: "640")
        let b = UInt256(decimalString: "4")
        let c = UInt256(decimalString: "160")

        let res = a / b

        XCTAssertEqual(res, c, "\(a) / \(b) = \(res) != \(c)")
    }

    func testModulo() {
        let a = UInt256(decimalString: "23")
        let b = UInt256(decimalString: "5")
        let c = UInt256(decimalString: "3")

        let res = a % b

        XCTAssertEqual(res, c, res.description)
    }

    func testModuloLarger() {
        let a = UInt256(decimalString: "25000000000000000000000000000000000000000000000000000000000000000000000004")
        let b = UInt256(decimalString: "5000000000000000000000000000000000000")
        let c = UInt256(decimalString: "4")

        let res = a % b

        XCTAssertEqual(res, c, "\(a) % \(b) = \(res) != \(c)")
    }

    func testModuloMoreComplex() {
        let a = UInt256(decimalString: "2145932040592314323128185")
        let b = UInt256(decimalString: "897983433434")
        let c = UInt256(decimalString: "3")

        let res = a % b

        XCTAssertEqual(res, c, "\(a) % \(b) = \(res) != \(c)")
    }

    func testDivideBig() {
        let a = UInt256(decimalString: "115792089237316195423570985008687907852589419931798687112530834793049593217025")
        let b = UInt256(decimalString: "340282366920938463463374607431768211455")
        let c = UInt256(decimalString: "340282366920938463463374607431768211455")

        var res: UInt256 = 0

        self.measure() {
            for _ in 1 ... self.thousand / 100 {
                res = a / b
            }
        }

        XCTAssertEqual(res, c, "\(a) / \(b) = \(res) != \(c)")
    }

    func testDivideBigLiteral() {
        let a = UInt256(decimalString: "106030040005000600070")

        if CGFLOAT_IS_DOUBLE == 1 {
        let result = "\(a / 1000000000000000000)"
        let c = "106"
        XCTAssertEqual(result, c, "\(a) / \(1000000000000000000) = \(result) != \(c)")
        } else {
            let b = UInt256(decimalString: "1000000000000000000")
            let result = "\(a / b)"
            let c = "106"
            XCTAssertEqual(result, c, "\(a) / \(b) = \(result) != \(c)")
        }
    }

    func testModuloLargest128bitPrime() {
        // According to http://primes.utm.edu/lists/2small/100bit.html, 2^128-159 is prime
        // According to Ruby that's: 340282366920938463463374607431768211297

        var a = UInt256(decimalString: "340282366920938463463374607431768211298")
        var b = UInt256(decimalString: "340282366920938463463374607431768211297")
        var c = UInt256(decimalString: "1")

        var res = a % b

        XCTAssertEqual(res, c, "\(a) % \(b) = \(res) != \(c)")

        // (2**128 - 159) * 55 + 5 (according to Ruby)
        a = UInt256(decimalString: "18715530180651615490485603408747251621340")
        b = UInt256(decimalString: "340282366920938463463374607431768211297")
        c = UInt256(decimalString: "5")

        res = a % b

        // Fails:
        XCTAssertEqual(res, c, "\(a) % \(b) = \(res) != \(c)")
    }

    func testModuloBig() {
        let a = UInt256(decimalString: "115792089237316195423570985008687907852589419931798687112530834793049593217026")
        let b = UInt256(decimalString: "340282366920938463463374607431768211455")

        var res: UInt256 = 0

        self.measure() {
            for _ in 1 ... self.thousand / 100 {
                res = a % b
            }
        }

        let c = UInt256(decimalString: "1")

        XCTAssertEqual(res, c, "")
    }

    func testModularMultiplicativeInverse() {
        let a = UInt256(hexString: "2b80697edf28a916d822b9b89a8f770fb70d49f48b5c184f2f47f652db960baa")
        let m = UInt256(hexString: "fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f")

        let aInverse = UInt256(hexString: "7ae012558f0053523a39cfe291c0fea21d2c23f41a3805c1c487c93aa83fdac1")

        var res: UInt256 = 0

        self.measure() {
            for _: UInt16 in UInt16(0) ... UInt16(self.thousand / 1_000_00) {

                res = a.modInverse(m)
            }
        }

        XCTAssertEqual(res, aInverse, res.toHexString)
    }

    func testModularMultiplicativeInverseSmall() {
        let p: UInt256 = 11
        let a: UInt256 = 5

        let inverse: UInt256 = 9 // 9  * 5 = 45 -> 45 % 9 = 1

        let result = a.modInverse(p)

        XCTAssertEqual(inverse, result, result.toDecimalString)
    }

    func testMultiplyToMax32Bit() {
        let a = UInt256(decimalString: "65535")
        let c = UInt256(decimalString: "4294836225")

        var res: UInt256 = 0

        self.measure() {

            for _ in 1 ... self.thousand {

                res = a * a // 0.9999...% of 32 bit max
            }
        }

        XCTAssertEqual(res, c, res.description)
    }

    func testMultiplyToMax64Bit() {
        let a = UInt256(decimalString: "4294967295")
        let c = UInt256(decimalString: "18446744065119617025")

        var res: UInt256 = 0

        #if DEBUG
            res = a * a // 0.9999999...% of 64 bit max
        #else
            self.measure() {
                for _ in 1 ... self.thousand {
                    res = a * a
                }
            }
        #endif

        XCTAssertEqual(res, c, res.description)
    }

    func testMultiplyToMax128BitNoKaratsubaOverflow() {
        var a = UInt256(hexString: "1000200030004000")
        var c = UInt256(hexString: "10004000a0014001900180010000000")

        var res: UInt256 = 0

        res = a * a

        XCTAssertEqual(res, c, res.toHexString)

        res = 0

        a = UInt256(decimalString: "8373049358093547092")
        c = UInt256(decimalString: "70107955553070761001235484930421656464")

        res = a * a

        XCTAssertEqual(res, c, res.toHexString)

        res = 0

        a = UInt256(decimalString: "4514341311903373517")
        c = UInt256(decimalString: "20379277480357471495929005285216949289")

        res = a * a

        XCTAssertEqual(res, c, res.toHexString)

        res = 0

        a = UInt256(decimalString: "8324499029011133232")
        c = UInt256(decimalString: "69297284084007299998947387404854765824")

        self.measure() {
            for _ in 1 ... self.thousand / 100 {
                res = a * a
            }
        }

        XCTAssertEqual(res, c, res.toHexString)
    }

    func testMultiplyToMax128BitWithKaratsubaOverflow() {
        var a = UInt256(decimalString: "6907831480921755401") // Also overflows res[1]+= z1 >> 32
        var c = UInt256(hexString: "23e62dbc72dfd1301d69c1b13fb60e51")

        var res: UInt256 = 0

        res = a * a // result[0] is 1 to high

        XCTAssertEqual(res, c, res.toHexString)

        a = UInt256(decimalString: "8865396608531244567")
        c = UInt256(hexString: "3b20e559aa2e5076fa2b512bdeb0d611")

        res = a * a // result[0] is 1 to high

        XCTAssertEqual(res, c, res.toHexString)

        a = UInt256(decimalString: "9654263533683468436")
        c = UInt256(decimalString: "93204804377810410884729817879008286096")

        res = a * a

        XCTAssertEqual(res, c, res.toHexString)

        a = UInt256(decimalString: "18446744073709551614") // 0.9999999...% of 128 bit max
        c = UInt256(decimalString: "340282366920938463389587631136930004996")

        self.measure() {

            for _ in 1 ... self.thousand / 100 {
                res = a * a // 0.9999999...% of 128 bit max
            }
        }

        XCTAssertEqual(res, c, res.toHexString)
    }

    func testMultiplyToMax128BitWithKaratsubaOverflowPart2() {
        var a: UInt256 = UInt256(decimalString: "9654263533683468436")
        var c: UInt256 = UInt256(hexString: "461e97a5a38a54c61541d2cd28949590")

        var res: UInt256 = a * a // Overflow 1 to high

        XCTAssertEqual(res, c, res.toHexString)

        a = UInt256(decimalString: "18446744073709551614") // 0.9999999...% of 128 bit max
        c = UInt256(decimalString: "340282366920938463389587631136930004996")

        res = a * a

        XCTAssertEqual(res, c, res.toHexString)
    }

    func testMultiplyToMax256Bit() {
        let a = UInt256(decimalString: "340282366920938463463374607431768211455")
        let c = UInt256(decimalString: "115792089237316195423570985008687907852589419931798687112530834793049593217025")

        var res: UInt256 = 0

        self.measure() {

            for _ in 1 ... self.thousand / 100 {

                res = a * a // 0.9999999...% of UInt256 max
            }
        }

        XCTAssertEqual(res, c, res.description)
    }

    func testMultiplicationToTupleWithoutRecursion() {
        // a and b chosen such that x₁ + x₀ and y₁_plus_y₀ don't overflow
        let a = UInt256(0x502b5092, 0x9d7b11ed, 0x52d00e63, 0x11cd10ff, 0x92956188, 0xdd566bc4, 0x52d0ebaa, 0x95f8234c)

        let b = UInt256(0x17c10759, 0xf6e128f2, 0x0704c711, 0x914fa8bf, 0xaa514b51, 0xa371522d, 0xfc5bd655, 0x162050ce)

        let (left, right) = (UInt256(0x07705732, 0x4641effd, 0x378f46bc, 0x92edec71, 0x75c31faf, 0xc2e21a5d, 0x69bfbb9f, 0x07abd941), UInt256(0x98baaae0, 0xf56e67d7, 0x455c1ce2, 0x8617a3a9, 0xc9cd081a, 0x1afb578a, 0xa0e2446b, 0x2a342728))

        var resLeft: UInt256 = 0
        var resRight: UInt256 = 0

        self.measure() {
            for _ in 1 ... self.thousand / 1000 {
                (resLeft, resRight) = a * b
            }
        }

        XCTAssertTrue(resLeft == left, resLeft.description)
        XCTAssertTrue(resRight == right, resRight.description)
    }

    func testMultiplicationInSecp256k1() {
        let a = UInt256(0x9b992796, 0x19237faf, 0x0c13c344, 0x614c46a9, 0xe7357341, 0xc6e4e042, 0xa9b1311a, 0x8622deaa)

        let b = UInt256(0xe7f1caa6, 0x36baa277, 0x9cfd6cf9, 0x696cf826, 0xf013db03, 0x7aa08f3d, 0x5c2dfaf9, 0xdb5d255b)

        let(left, right) = (UInt256(0x8cfa2912, 0x94cc8c2c, 0x827a9ef6, 0x977f6b69, 0x1d24b810, 0xf085c437, 0xabd13f27, 0x942da0b5), UInt256(0xede973cf, 0x7a14db61, 0x0dfe857e, 0x382bc650, 0x71af459e, 0x27425f0c, 0x36b67051, 0x0a55b86e))

        var resLeft: UInt256 = 0
        var resRight: UInt256 = 0

        self.measure() {
            for _ in 0 ... self.thousand / 1000 {
                (resLeft, resRight) = a * b
            }
        }

        XCTAssertTrue(resLeft == left, resLeft.description)
        XCTAssertTrue(resRight == right, resRight.description)
    }

    func testModTupleInSecp256k1() {

        let p = UInt256(0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff, 0xfffffffe, 0xfffffc2f)

        let(left, right) = (UInt256(0x8cfa2912, 0x94cc8c2c, 0x827a9ef6, 0x977f6b69, 0x1d24b810, 0xf085c437, 0xabd13f27, 0x942da0b5), UInt256(0xede973cf, 0x7a14db61, 0x0dfe857e, 0x382bc650, 0x71af459e, 0x27425f0c, 0x36b67051, 0x0a55b86e))

        let mod = UInt256(0x896cbfe5, 0xdd327035, 0x9b769bff, 0x82996a89, 0x9b57827b, 0xc19576ab, 0x11704459, 0x9336d1f0)

        var result: UInt256 = 0

        self.measure() {
            for _ in 1 ... (self.thousand / 1_00) {
                result = (left, right) % p
            }
        }

        XCTAssertTrue(result == mod, result.description)
    }
}
