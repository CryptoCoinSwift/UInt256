//
//  UInt256+Divide+Modulus.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

extension UInt256: IntegerArithmetic {

    public static func addWithOverflow(_ lhs: UInt256, _ rhs: UInt256) -> (UInt256, overflow: Bool) {
        var sum = UInt256.allZeros

        for i in (0 ... 7).reversed() {
            sum[i] = sum[i] &+ lhs[i]

            if sum[i] < lhs[i] && i > 0 {
                sum[i - 1] = 1
            }

            let sumBefore = sum[i]

            sum[i] = sumBefore &+ rhs[i]

            if sum[i] < sumBefore && i > 0 {
                sum[i - 1] = sum[i - 1] + 1 // Will either be 1 or 2
            }
        }

        return (sum, sum < lhs)
    }

    public static func subtractWithOverflow(_ lhs: UInt256, _ rhs: UInt256) -> (UInt256, overflow: Bool) {
        // Use C. Not so much for speed, but for debugging other C functions:

        var lhsC: [UInt32] = [0, 0, 0, 0, 0, 0, 0, 0]
        var rhsC: [UInt32] = [0, 0, 0, 0, 0, 0, 0, 0]
        var result: [UInt32] = [0, 0, 0, 0, 0, 0, 0, 0]

        for i in 0 ..< 8 { lhsC[i] = lhs[i]; rhsC[i] = rhs[i]; result[i] = 0 }

        subtract(&result, &lhsC, &rhsC)

        let diff = UInt256(result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7])

        return (diff, lhs < rhs)
    }

    public static func multiplyWithOverflow(_ lhs: UInt256, _ rhs: UInt256) -> (UInt256, overflow: Bool) {
        assert(false, "Unchecked multiplication is not supported. Multiply to a tuple instead.")
        let (a, b) = lhs * rhs
        return (b, a != UInt256.allZeros)
    }

    public static func divideWithOverflow(_ numerator: UInt256, _ denominator: UInt256) -> (UInt256, overflow: Bool) {
        assert(denominator != 0, "Divide by zero")

        var num: [UInt32] = [0, 0, 0, 0, 0, 0, 0, 0]
        var den: [UInt32] = [0, 0, 0, 0, 0, 0, 0, 0]

        for i in 0 ..< 8 { num[i] = numerator[i]; den[i] = denominator[i] }

        let result = divideWithOverflowC(&num, &den)

        return (UInt256(result![0], result![1], result![2], result![3], result![4], result![5], result![6], result![7]), false)
    }

    public static func remainderWithOverflow(_ numerator: UInt256, _ denominator: UInt256) -> (UInt256, overflow: Bool) {
        assert(denominator != 0, "Divide by zero")

        var num: [UInt32] = [0, 0, 0, 0, 0, 0, 0, 0]
        var den: [UInt32] = [0, 0, 0, 0, 0, 0, 0, 0]

        for i in 0 ..< 8 { num[i] = numerator[i]; den[i] = denominator[i] }

        let result = remainderWithOverflowC(&num, &den)

        return (UInt256(result![0], result![1], result![2], result![3], result![4], result![5], result![6], result![7]), false)
    }

    // I have no idea what this is supposed to do:
    public func toIntMax() -> IntMax {
        return Int64(self[6] << 32 + self[7])
    }

    public func modInverse(_ m: UInt256) -> UInt256 {
        assert(m > 0, "Modulo 0 makes no sense")
        // http://rosettacode.org/wiki/Modular_inverse#C
        var a = self
        var b = m

        let b0 = b
        var t: UInt256
        var q: UInt256
        var x0 = UInt256()
        var x0positive = true
        var x1: UInt256 = 1

        if (b == 1) {
            return 1
        }

        while (a > 1) {
            q = a / b
            t = b
            b = a % b
            a = t
            t = x0
            let (_, temp) = q * x0
            x0 = x1 &- temp
            x0positive = x1 >= x0
            x1 = t
        }

        if (!x0positive) {
            x1 = x1 &+ b0
        }

        return x1
    }
}

public func / (numerator: UInt256, denominator: UInt256) -> (UInt256) {
    let (res, trouble) = UInt256.divideWithOverflow(numerator, denominator)
    assert(!trouble, "Trouble")
    return res
}

public func % (numerator: UInt256, denominator: UInt256) -> UInt256 {
    let (res, trouble) = UInt256.remainderWithOverflow(numerator, denominator)
    assert(!trouble, "Trouble")
    return res
}

public func % (lhs: (UInt256, UInt256), rhs: UInt256) -> UInt256 {
    // Source: http://www.hackersdelight.org/MontgomeryMultiplication.pdf (page 5)
    var(x, y) = lhs
    let z = rhs

    assert(x < z, "Can't calculate modulo")

    /* Takes 300 µs on a Macbook Pro */
    //    for _ in 0..<256 {
    //        // Avoid casting x to a signed integer and right shifting it all the way:
    //        if UInt256.singleBitAt(0) & x == 0 {
    //            t = UInt256.allZeros
    //        } else {
    //            t = UInt256.max
    //        }
    //
    //        x = (x << 1) | (y >> 255)
    //        y = y << 1
    //
    //        if((x | t) >= z) {
    //            x = x &- z
    //            y++
    //        }
    //    }

    //    let xC = UnsafeMutablePointer<UInt32>(8)
    //    let yC = UnsafeMutablePointer<UInt32>(8)
    //    let zC = UnsafeMutablePointer<UInt32>(8)

    var xC: [UInt32] = [0, 0, 0, 0, 0, 0, 0, 0]
    var yC: [UInt32] = [0, 0, 0, 0, 0, 0, 0, 0]
    var zC: [UInt32] = [0, 0, 0, 0, 0, 0, 0, 0]

    for i in 0 ..< 8 { xC[i] = x[i]; yC[i] = y[i]; zC[i] = z[i] }

    montgomery(&xC, &yC, &zC)

    //    return x
    return UInt256(xC[0], xC[1], xC[2], xC[3], xC[4], xC[5], xC[6], xC[7])
}

public func += (lhs: inout UInt256, rhs: UInt256) -> () {
    lhs = lhs + rhs
}

public func -= (lhs: inout UInt256, rhs: UInt256) -> () {
    lhs = lhs - rhs
}

// postfix public func ++ (lhs: inout UInt256) -> (UInt256) {
//    let oldValue = lhs
//    lhs += UInt256(0,0,0,0,0,0,0,1)
//
//    return oldValue
// }
//
// prefix public func ++ (lhs: inout UInt256) -> (UInt256) {
//    lhs += UInt256(0,0,0,0,0,0,0,1)
//
//    return lhs
// }
//
// postfix public func -- (lhs: inout UInt256) -> (UInt256) {
//    let oldValue = lhs
//    lhs -= UInt256(0,0,0,0,0,0,0,1)
//
//    return oldValue
// }
//
// prefix public func -- (lhs: inout UInt256) -> (UInt256) {
//    lhs -= UInt256(0,0,0,0,0,0,0,1)
//
//    return lhs
// }

public func &+ (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let (result, _) = UInt256.addWithOverflow(lhs, rhs)
    return result
}

public func + (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let (result, overflow) = UInt256.addWithOverflow(lhs, rhs)
    assert(!overflow, "Overflow")
    return result
}

public func &- (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let (result, _) = UInt256.subtractWithOverflow(lhs, rhs)
    return result
}

public func - (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let (result, overflow) = UInt256.subtractWithOverflow(lhs, rhs)
    assert(!overflow, "Overflow")
    return result
}

public func * (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let zero = UInt256.allZeros

    if (lhs == zero) || (rhs == zero) {
        return 0 // Don't use lhs == 0, because it casts to a signed 32 bit integer
    }

    if lhs == UInt256.singleBitAt(255) {
        return rhs
    } else if rhs == UInt256.singleBitAt(255) {
        return lhs
    }

    // Check if we're on a 64 bit system:
    if CGFLOAT_IS_DOUBLE == 1 {
        let thirtyTwoBitMask = UInt256(0, 0, 0, 0, 0, 0, 0, UInt32.max)

        if lhs == lhs & thirtyTwoBitMask && rhs == rhs & thirtyTwoBitMask {

            let product: UInt64 = UInt64(lhs[7]) * UInt64(rhs[7])
            let productLhs: UInt64 = product >> 32
            let productRhs: UInt64 = product & 0b0000_0000_0000_0000_0000_0000_0000_0000_1111_1111_1111_1111_1111_1111_1111_1111
            return UInt256(UInt32(0), 0, 0, 0, 0, 0, UInt32(productLhs), UInt32(productRhs))
        }

        let sixtyFourBitMask = UInt256(0, 0, 0, 0, 0, 0, UInt32.max, UInt32.max)

        if lhs == lhs & sixtyFourBitMask && rhs == rhs & sixtyFourBitMask {

            var lhsC: [UInt32] = [0, 0, 0, 0, 0, 0, 0, 0]
            var rhsC: [UInt32] = [0, 0, 0, 0, 0, 0, 0, 0]
            var res: [UInt32] = [0, 0, 0, 0, 0, 0, 0, 0]

            lhsC[0] = lhs[6]
            lhsC[1] = lhs[7]

            rhsC[0] = rhs[6]
            rhsC[1] = rhs[7]

            multiply(&lhsC, &rhsC, &res)

            return UInt256(0, 0, 0, 0, res[0], res[1], res[2], res[3])
        }
    } else {
        // We're on a 32 bit system, check if it's a 16 bit number

        let sixteenBitMask = UInt256(0, 0, 0, 0, 0, 0, 0, 65535)

        if lhs == lhs & sixteenBitMask && rhs == rhs & sixteenBitMask {
            return UInt256(0, 0, 0, 0, 0, 0, 0, lhs[7] * rhs[7])
        }

        // We're on a 32 bit system, check if it's a 32 bit bit number
        let thirtyTwoBitMask = UInt256(0, 0, 0, 0, 0, 0, 0, UInt32.max)

        if lhs == lhs & thirtyTwoBitMask && rhs == rhs & thirtyTwoBitMask {

            // Karatsuba

            var x₁: UInt256
            var x₀: UInt256
            var y₁: UInt256
            var y₀: UInt256

            x₁ = UInt256(0, 0, 0, 0, 0, 0, 0, lhs[7] >> 16)
            x₀ = UInt256(0, 0, 0, 0, 0, 0, 0, lhs[7] & 0x0000FFFF)

            y₁ = UInt256(0, 0, 0, 0, 0, 0, 0, rhs[7] >> 16)
            y₀ = UInt256(0, 0, 0, 0, 0, 0, 0, rhs[7] & 0x0000FFFF)

            // Part of the calculation can be done using UInt32's
            let z₂ = x₁[7] * y₁[7]
            let z₀ = x₀[7] * y₀[7]

            let x₁_plus_x₀ = UInt256(0, 0, 0, 0, 0, 0, 0, x₁[7] + x₀[7])
            let y₁_plus_y₀ = UInt256(0, 0, 0, 0, 0, 0, 0, y₁[7] + y₀[7])

            let z₁ = x₁_plus_x₀ * y₁_plus_y₀ - UInt256(0, 0, 0, 0, 0, 0, 0, z₂) - UInt256(0, 0, 0, 0, 0, 0, 0, z₀)

            return UInt256(0, 0, 0, 0, 0, 0, z₂, z₀) + (z₁ << 16)
        }
    }

    var x₁: UInt256
    var x₀: UInt256
    var y₁: UInt256
    var y₀: UInt256

    var bitSize: Int

    // We're on a 32 bit machine or it's a 32+ bit number

    let sixtyFourBitMask = UInt256(0, 0, 0, 0, 0, 0, UInt32.max, UInt32.max)

    let hundredTwentyEightBitMask = UInt256(0, 0, 0, 0, UInt32.max, UInt32.max, UInt32.max, UInt32.max)

    if lhs == lhs & sixtyFourBitMask && rhs == rhs & sixtyFourBitMask {
        x₁ = UInt256(0, 0, 0, 0, 0, 0, 0, lhs[6])
        x₀ = UInt256(0, 0, 0, 0, 0, 0, 0, lhs[7])

        y₁ = UInt256(0, 0, 0, 0, 0, 0, 0, rhs[6])
        y₀ = UInt256(0, 0, 0, 0, 0, 0, 0, rhs[7])

        bitSize = 64
    } else if lhs == lhs & hundredTwentyEightBitMask && rhs == rhs & hundredTwentyEightBitMask {
        x₁ = UInt256(0, 0, 0, 0, 0, 0, lhs[4], lhs[5])
        x₀ = UInt256(0, 0, 0, 0, 0, 0, lhs[6], lhs[7])

        y₁ = UInt256(0, 0, 0, 0, 0, 0, rhs[4], rhs[5])
        y₀ = UInt256(0, 0, 0, 0, 0, 0, rhs[6], rhs[7])

        bitSize = 128
    } else {
        assert(false, "Use a tuple when multiplying large values")
        x₁ = UInt256.allZeros
        x₀ = UInt256.allZeros
        y₁ = UInt256.allZeros
        y₀ = UInt256.allZeros

        bitSize = 256
    }

    // x₀, x₁, y₀ and y₁ are 64 bit max. They can be added or multiplied without carry,
    // resulting in 65 or 128 bit values respectively.
    // z₁ multiplies the result of an addition of 64 bit numbers, so it needs 65 * 2 = 130 bits

    let z₂: UInt256 = x₁ * y₁
    let z₀: UInt256 = x₀ * y₀

    let z₁ = (x₁ + x₀) * (y₁ + y₀) - z₂ - z₀

    //    println(z₀)
    //    println(z₁)
    //    println(z₂)

    return z₂ << (bitSize) + z₀ + z₁ << (bitSize / 2)
}

public func * (lhs: UInt256, rhs: UInt256) -> (UInt256, UInt256) {
    // Apply 1 iteration of Karatsuba
    // x₀, x₁, y₀ and y₁ are 128 bit max. They can be added or multiplied without carry,
    // resulting in 129 or 256 bit values respectively.
    // z₁ multiplies the result of an addition of 128 bit numbers, so it needs 129 * 2 = 258 bits
    //

    if lhs == 0 || rhs == 0 {
        return (UInt256.allZeros, UInt256.allZeros)
    }

    let x₁ = lhs >> 128
    let x₀ = lhs & UInt256(0, 0, 0, 0, UInt32.max, UInt32.max, UInt32.max, UInt32.max)

    let y₁ = rhs >> 128
    let y₀ = rhs & UInt256(0, 0, 0, 0, UInt32.max, UInt32.max, UInt32.max, UInt32.max)

    let z₂: UInt256 = x₁ * y₁
    let z₀: UInt256 = x₀ * y₀

    // z₁ = (x₁ + x₀) * (y₁ + y₀) - z₂ - z₀
    // Call Karatsuba recursively if the additions result in a 129 bit value or
    // multiplication results in a 257 or 258 bit value.
    // Alternatively deal with carries...

    let x₁_plus_x₀ = x₁ + x₀

    let y₁_plus_y₀ = y₁ + y₀

    var z₁: UInt256?
    var z₁tuple: (UInt256, UInt256)?

    if x₁_plus_x₀ & UInt256.singleBitAt(127) != 0 || y₁_plus_y₀ & UInt256.singleBitAt(127) != 0 {
        let z₁subtotal: (UInt256, UInt256) = x₁_plus_x₀ * y₁_plus_y₀

        let (left, right) = z₁subtotal
        // Check if z₁subtotal is <= or > 256 bit (either 257 or 258)
        if left == 0 { // right represents the full value of z₁subtotal, so this will not overflow:
            z₁ = right - z₂ - z₀
        } else {

            let addSafe = z₂ &+ z₀
            if addSafe >= z₂ { // z₂ + z₀ doesn't overflow
                if right >= addSafe { // subtraction won't overflow
                    // Code path not covered by any test!
                    // Add and double big point do not encounter this.
                    z₁tuple = (left, right - z₂ - z₀)
                } else {
                    z₁tuple = (left - 1, right &- addSafe)
                }
            } else { // z₂ + z₀ overflows
                if right >= addSafe { // subtraction won't overflow again
                    z₁tuple = (left - 1, right - addSafe)
                } else { // subtraction will overflow again
                    // Code path not covered by any test!
                    // Double big point encounters this, add big doesn't:
                    z₁tuple = (left - 2, right &- addSafe)
                }
            }
        }

    } else { // Both sums are 128 bit or less, so their product is 256 bit or less
        let z₁subtotal: UInt256 = x₁_plus_x₀ * y₁_plus_y₀

        z₁ = z₁subtotal - z₂ - z₀
    }

    // product = z₂ · 2²⁵⁶ + z₁ · 2¹²⁸ + z₀
    var productLeft = z₂
    var productRight = z₀

    if let (z₁left, z₁right) = z₁tuple {
        let productRightBefore = productRight

        productRight = productRight &+ (z₁right << 128)

        if productRight < productRightBefore {
            productLeft += 1
        }
        
        productLeft = productLeft + (z₁right >> 128)
        productLeft = productLeft + (z₁left << 128)
        
    } else {
        let productRightBefore = productRight
        productRight = productRight &+ (z₁! << 128)
        
        if productRight < productRightBefore {
            // Leaving this line out will not be detected by any test (but will cause addBig in
            // ECurve test to hit an overflow.
            productLeft += 1
        }
        
        productLeft = productLeft + (z₁! >> 128)
    }
    
    return (productLeft, productRight)
}
