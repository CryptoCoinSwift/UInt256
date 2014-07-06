//
//  UInt256+Divide+Modulus.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

extension UInt256 : IntegerArithmetic {
    static func uncheckedAdd(lhs: UInt256, _ rhs: UInt256) -> (UInt256, Bool) {
        var previousDigitDidOverflow = false
        
        var sum = UInt256.allZeros
        
        for var i=7; i >= 0; i-- {
            
            
            sum[i] = sum[i] &+ lhs[i]
            
            if sum[i] < lhs[i] && i > 0 {
                sum[i-1] = 1
            }
            
            let sumBefore = sum[i]
            
            sum[i] = sumBefore &+ rhs[i]
            
            if sum[i] < sumBefore && i > 0 {
                sum[i-1] = sum[i-1] + 1 // Will either be 1 or 2
            }
        }
        
        return (sum, sum < lhs)
        
    }
    
    static func uncheckedSubtract(lhs: UInt256, _ rhs: UInt256) -> (UInt256, Bool) {
        var previousDigitDidOverflow = false
        var diff = UInt256.allZeros
        
        for var i=7; i >= 0; i-- {
            let modifier: UInt32 = (previousDigitDidOverflow ? 1 : 0)
            
            diff[i] = lhs[i] &- rhs[i] &- modifier
            
            if modifier == 1 && rhs[i] == UInt32.max {
                previousDigitDidOverflow = true
            } else {
                previousDigitDidOverflow = lhs[i] < rhs[i] + modifier
            }
        }
        
        return (diff, lhs > rhs)
        
    }
    
    static func uncheckedMultiply(lhs: UInt256, _ rhs: UInt256) -> (UInt256, Bool) {
        let (a,b) = lhs * rhs
        return (b, a != 0)
    }
    
    static func uncheckedDivide(numerator: UInt256, _ denomenator: UInt256) -> (UInt256, Bool) {
        assert(denomenator != 0, "Divide by zero")
        
        var quotient: UInt256 = 0
        var remainder: UInt256 = 0
        
        for var i=numerator.highestBit - 1; i >= 0; i--  {
            
            remainder <<= 1
            if UInt256.singleBitAt(255 - i) & numerator != 0 {
                remainder.setBitAt(255)
            } else {
                remainder.unsetBitAt(255)
            }
            
            if remainder >= denomenator {
                // println("R=\( remainder ) D=\( denomenator )")
                remainder = remainder - denomenator
                quotient = quotient | UInt256.singleBitAt(255 - i)
            }
        }
        
        return (quotient, false)
        
    }
    
    static func uncheckedModulus(numerator: UInt256, _ denomenator: UInt256) -> (UInt256, Bool) {
        assert(denomenator != 0, "Divide by zero")
        
        var remainder: UInt256 = 0
        
        for var i=numerator.highestBit - 1; i >= 0; i--  {
            
            remainder <<= 1
            if UInt256.singleBitAt(255 - i) & numerator != 0 {
                remainder.setBitAt(255)
            } else {
                remainder.unsetBitAt(255)
            }
            
            if remainder >= denomenator {
                remainder = remainder - denomenator
            }
        }
        
        return (remainder, false)
        
    }
    
    // I have no idea what this is supposed to do:
    func toIntMax() -> IntMax {
        return Int64(self[6]<<32 + self[7])
    }
    
    func modInverse(m: UInt256) -> UInt256 {
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
            let temp: UInt256 = q &* x0 // Should this really overflow?
            x0 = x1 &- temp
            x0positive = x1 >= x0
            x1 = t
        }
        
        if (!x0positive) {
            x1 = x1 &+ b0
        }
        
        return x1;
    }

}

func / (numerator: UInt256, denomenator: UInt256) -> (UInt256) {
    let (res, trouble) = UInt256.uncheckedDivide(numerator, denomenator)
    assert(!trouble, "Trouble")
    return res
}

func % (numerator: UInt256, denomenator: UInt256) -> UInt256 {
    let (res, trouble) = UInt256.uncheckedModulus(numerator, denomenator)
    assert(!trouble, "Trouble")
    return res
}

func % (lhs: (UInt256, UInt256), rhs: UInt256) -> UInt256 {
    // Source: http://www.hackersdelight.org/MontgomeryMultiplication.pdf (page 5)
    var (x,y) = lhs
    let z = rhs
    
    var t: UInt256
    
    assert(x < z, "Can't calculate modulo")
    
    for _ in 0..256 {
        // Avoid casting x to a signed integer and right shifting it all the way:
        if UInt256.singleBitAt(0) & x == 0 {
            t = UInt256.allZeros
        } else {
            t = UInt256.max
        }
        
        x = (x << 1) | (y >> 255)
        y = y << 1
        
        if((x | t) >= z) {
            x = x &- z
            y++
        }
    }
    
    return x
}

func += (inout lhs: UInt256, rhs: UInt256) -> () {
    lhs = lhs + rhs
}

func -= (inout lhs: UInt256, rhs: UInt256) -> () {
    lhs = lhs - rhs
}

@postfix func ++ (inout lhs: UInt256) -> (UInt256) {
    let oldValue = lhs
    lhs += UInt256(0,0,0,0,0,0,0,1)
    
    return oldValue
}

@prefix func ++ (inout lhs: UInt256) -> (UInt256) {
    lhs += UInt256(0,0,0,0,0,0,0,1)
    
    return lhs
}

@postfix func -- (inout lhs: UInt256) -> (UInt256) {
    let oldValue = lhs
    lhs -= UInt256(0,0,0,0,0,0,0,1)
    
    return oldValue
}

@prefix func -- (inout lhs: UInt256) -> (UInt256) {
    lhs -= UInt256(0,0,0,0,0,0,0,1)
    
    return lhs
}


func &+ (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let (result, _) = UInt256.uncheckedAdd(lhs, rhs)
    return result
}

func + (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let (result, overflow) = UInt256.uncheckedAdd(lhs, rhs)
    assert(!overflow, "Overflow")
    return result
}

func &- (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let (result, _) = UInt256.uncheckedSubtract(lhs, rhs)
    return result
}

func - (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let (result, overflow) = UInt256.uncheckedSubtract(lhs, rhs)
    assert(!overflow, "Overflow")
    return result
}

func &* (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let (_,b) = lhs * rhs
    return b
}

func * (lhs: UInt256, rhs: UInt256) -> UInt256 {
    
    let zero = UInt256.allZeros
    
    if (lhs == zero) || (rhs == zero) {
        return 0 // Don't use lhs == 0, because it casts to a signed 32 bit integer
    }
    
    if lhs == UInt256.singleBitAt(255) {
        return rhs
    } else if rhs == UInt256.singleBitAt(255) {
        return lhs
    }
    
    // Karatsuba
    let sixteenBitMask = UInt256(0,0,0,0,0,0,0,UInt32.max >> 16)
    if lhs == lhs & sixteenBitMask && rhs == rhs & sixteenBitMask {
        return UInt256(0,0,0,0,0,0,0, lhs[7] * rhs[7])
    }
    
    let thirtyTwoBitMask = UInt256(0,0,0,0,0,0,0,UInt32.max)
    let sixtyFourBitMask = UInt256(0,0,0,0,0,0,UInt32.max,UInt32.max)
    let hundredTwentyEightBitMask = UInt256(0,0,0,0,UInt32.max,UInt32.max,UInt32.max,UInt32.max)
    
    var x₁: UInt256
    var x₀: UInt256
    var y₁: UInt256
    var y₀: UInt256
    
    var bitSize: Int
    
    if lhs == lhs & thirtyTwoBitMask && rhs == rhs & thirtyTwoBitMask {
        
        x₁ = UInt256(0,0,0,0,0,0,0,lhs[7] >> UInt32(16))
        x₀ = UInt256(0,0,0,0,0,0,0,lhs[7] & 0x0000FFFF)
        
        y₁ = UInt256(0,0,0,0,0,0,0, rhs[7] >> UInt32(16))
        y₀ = UInt256(0,0,0,0,0,0,0,rhs[7] & 0x0000FFFF)
        
        bitSize = 32
    } else if lhs == lhs & sixtyFourBitMask && rhs == rhs & sixtyFourBitMask {
        x₁ = UInt256(0,0,0,0,0,0,0,lhs[6])
        x₀ = UInt256(0,0,0,0,0,0,0,lhs[7])
        
        y₁ = UInt256(0,0,0,0,0,0,0,rhs[6])
        y₀ = UInt256(0,0,0,0,0,0,0,rhs[7])
        
        bitSize = 64
    } else if lhs == lhs & hundredTwentyEightBitMask && rhs == rhs &  hundredTwentyEightBitMask {
        x₁ = UInt256(0,0,0,0,0,0,lhs[4],lhs[5])
        x₀ = UInt256(0,0,0,0,0,0,lhs[6],lhs[7])
        
        y₁ = UInt256(0,0,0,0,0,0,rhs[4],rhs[5])
        y₀ = UInt256(0,0,0,0,0,0,rhs[6],rhs[7])
        
        bitSize = 128
    } else {
        assert(false, "Use a tuple when multiplying large values")
        x₁ = UInt256.allZeros
        x₀ = UInt256.allZeros
        y₁ = UInt256.allZeros
        y₀ = UInt256.allZeros
        //        x₁ = UInt256([0,0,0,0,lhs[0],lhs[1],lhs[2],lhs[3]])
        //        x₀ = UInt256([0,0,0,0,lhs[4],lhs[5],lhs[6],lhs[7]])
        //
        //        y₁ = UInt256([0,0,0,0,rhs[0],rhs[1],rhs[2],rhs[3]])
        //        y₀ = UInt256([0,0,0,0,rhs[4],rhs[5],rhs[6],rhs[7]])
        //
        bitSize = 256
    }
    
    // x₀, x₁, y₀ and y₁ are 64 bit max. They can be added or multiplied without carry,
    // resulting in 65 or 128 bit values respectively.
    // z₁ multiplies the result of an addition of 64 bit numbers, so it needs 65 * 2 = 130 bits
    
    if bitSize == 32 {
        // Part of the calculation can be done using UInt32's
        let z₂ = x₁[7] * y₁[7]
        let z₀ = x₀[7] * y₀[7]
        
        let x₁_plus_x₀ = UInt256(0,0,0,0,0,0,0, x₁[7] + x₀[7])
        let y₁_plus_y₀ = UInt256(0,0,0,0,0,0,0, y₁[7] + y₀[7])
        
        let z₁ = x₁_plus_x₀ * y₁_plus_y₀ - UInt256(0,0,0,0,0,0,0,z₂) - UInt256(0,0,0,0,0,0,0,z₀)
        
        return UInt256(0,0,0,0,0,0,z₂,z₀) + (z₁ << 16)
    } else {
        
        let z₂: UInt256 = x₁ * y₁
        let z₀: UInt256 = x₀ * y₀
        
        let z₁ = (x₁ + x₀) * (y₁ + y₀) - z₂ - z₀
        
        return z₂ << (bitSize) + z₀ + z₁  << (bitSize / 2)
    }
}

func * (lhs: UInt256, rhs: UInt256) -> (UInt256, UInt256) {
    // Apply 1 iteration of Karatsuba
    // x₀, x₁, y₀ and y₁ are 128 bit max. They can be added or multiplied without carry,
    // resulting in 129 or 256 bit values respectively.
    // z₁ multiplies the result of an addition of 128 bit numbers, so it needs 129 * 2 = 258 bits
    //
    
    if lhs == 0 || rhs == 0 {
        return (UInt256.allZeros, UInt256.allZeros)
    }
    
    let x₁ = lhs >> 128
    let x₀ = lhs & UInt256(hexStringValue: "00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
    
    let y₁ = rhs >> 128
    let y₀ = rhs & UInt256(hexStringValue: "00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
    
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
    
    if x₁_plus_x₀ & UInt256.singleBitAt(127) != 0 || y₁_plus_y₀ & UInt256.singleBitAt(127) != 0  {
        let z₁subtotal: (UInt256, UInt256) = x₁_plus_x₀ * y₁_plus_y₀
        
        let (left, right) = z₁subtotal
        
        // Check if z₁subtotal is <= or > 256 bit (either 257 or 258)
        if left == 0 { // right represents the full value of z₁subtotal, so this will not overflow:
            z₁ = right - z₂ - z₀
        } else {
            var willOverflow = false
            let addSafe = z₂ &+ z₀
            if addSafe >= z₂ { // z₂ + z₀ doesn't overflow
                if right >= addSafe { // subtraction won't overflow
                    z₁tuple = (left, right - z₂ - z₀)
                } else {
                    z₁tuple = (left - 1, right &- addSafe)
                }
            } else { // z₂ + z₀ overflows
                if right >= addSafe { // subtraction won't overflow again
                    z₁tuple = (left - 1, right - addSafe)
                } else { // subtraction will overflow again
                    z₁tuple = (left - 2, right &- addSafe)
                }
            }
            
            
        }
        
        
    } else { // Both sums are 128 bit or less, so their product is 256 bit or less
        let z₁subtotal: UInt256 = x₁_plus_x₀ * y₁_plus_y₀
        
        z₁ = z₁subtotal - z₂ - z₀
    }
    
    // product = z₂ · 2²⁵⁶ + z₁ · 2¹²⁸ + z₀
    
    var productLeft  = z₂
    var productRight = z₀
    
    if let (z₁left, z₁right) = z₁tuple {
        let productRightBefore = productRight
        
        productRight = productRight &+ (z₁right << 128)
        
        if productRight < productRightBefore {
            productLeft++
        }
        
        productLeft = productLeft + z₁left
        
        
        productLeft = productLeft + (z₁right >> 128)
        
    } else {
        let productRightBefore = productRight
        productRight = productRight &+ (z₁! << 128)
        
        if productRight < productRightBefore {
            productLeft++
        }
        
        productLeft = productLeft + (z₁! >> 128)
    }
    
    return (productLeft, productRight)
    
}