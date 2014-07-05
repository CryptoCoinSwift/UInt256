//
//  UInt256+More.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 01-07-14.
//

func &(lhs: UInt256, rhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros
    
    for i in 0..8 {
        let and: UInt32 = lhs[i] & rhs[i]
        res[i] = and
    }
    
    return res
}

func |(lhs: UInt256, rhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros
    
    for i in 0..8 {
        res[i] = lhs[i] | rhs[i]
    }
    
    return res
}

func ^(lhs: UInt256, rhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros
    
    for i in 0..8 {
        res[i] = lhs[i] ^ rhs[i]
    }
    
    return res
}

@prefix func ~(lhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros
    
    for i in 0..8 {
        res[i] = ~lhs[i]
    }
    
    return res
}

func < (lhs: UInt256, rhs: UInt256) -> Bool {
    for i in 0..8 {
        if lhs[i] < rhs[i] {
            return true
        } else if lhs[i] > rhs[i] {
            return false;
        }
    }
    
    return false
}

func == (lhs: UInt256, rhs: UInt256) -> Bool {
    return lhs.smallerIntegers == rhs.smallerIntegers
}


func >= (lhs: UInt256, rhs: UInt256) -> Bool {
    return lhs == rhs || lhs > rhs
}

func <= (lhs: UInt256, rhs: UInt256) -> Bool {
    return lhs == rhs || lhs < rhs
}

func <<= (inout lhs: UInt256, rhs: Int) -> () {
    lhs = lhs << rhs
}

func += (inout lhs: UInt256, rhs: UInt256) -> () {
    lhs = lhs + rhs
}

func -= (inout lhs: UInt256, rhs: UInt256) -> () {
    lhs = lhs - rhs
}

@postfix func ++ (inout lhs: UInt256) -> (UInt256) {
    let oldValue = lhs
    lhs += UInt256([0,0,0,0,0,0,0,1])
    
    return oldValue
}

@prefix func ++ (inout lhs: UInt256) -> (UInt256) {
    lhs += UInt256([0,0,0,0,0,0,0,1])
    
    return lhs
}

@postfix func -- (inout lhs: UInt256) -> (UInt256) {
    let oldValue = lhs
    lhs -= UInt256([0,0,0,0,0,0,0,1])
    
    return oldValue
}

@prefix func -- (inout lhs: UInt256) -> (UInt256) {
    lhs -= UInt256([0,0,0,0,0,0,0,1])
    
    return lhs
}


func &+ (lhs: UInt256, rhs: UInt256) -> UInt256 {
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
    
    return sum
}

func + (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let sum = lhs &+ rhs
    
    assert(sum >= lhs, "Overflow")
    return sum
}

func &- (lhs: UInt256, rhs: UInt256) -> UInt256 {
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
    
    return diff
}

func - (lhs: UInt256, rhs: UInt256) -> UInt256 {
    assert(lhs >= rhs, "Overflow")
    return lhs &- rhs
 }

func << (lhs: UInt256, rhs: Int) -> UInt256 {
    switch rhs {
    case let x where x >= 256:
        return UInt256.allZeros
    case 255:
        if lhs & UInt256.singleBitAt(255) == 0 {
            return 0
        } else {
            return UInt256.singleBitAt(0)
        }
    case 128:
        return UInt256([lhs[4],lhs[5],lhs[6], lhs[7], 0,0,0, 0])
    case 64:
        return UInt256([lhs[2],lhs[3], lhs[4],lhs[5],lhs[6], lhs[7],0, 0])
    case 32:
        return UInt256([lhs[1],lhs[2],lhs[3], lhs[4],lhs[5],lhs[6], lhs[7], 0])
    case let x where x < 32:
        return UInt256([
            (lhs[0] << UInt32(x)) + (lhs[1] >> UInt32(32-x)),
            (lhs[1] << UInt32(x)) + (lhs[2] >> UInt32(32-x)),
            (lhs[2] << UInt32(x)) + (lhs[3] >> UInt32(32-x)),
            (lhs[3] << UInt32(x)) + (lhs[4] >> UInt32(32-x)),
            (lhs[4] << UInt32(x)) + (lhs[5] >> UInt32(32-x)),
            (lhs[5] << UInt32(x)) + (lhs[6] >> UInt32(32-x)),
            (lhs[6] << UInt32(x)) + (lhs[7] >> UInt32(32-x)),
            (lhs[7] << UInt32(x))
        ])
    default:
        var result = lhs
        
        for _ in 0..rhs {
            var overflow = false
            for var i=7; i >= 0; i-- {
                let leftMostBit: UInt32 = 0b1000_0000_0000_0000_0000_0000_0000_0000
                
                let willOverflow = result[i] & leftMostBit != 0
                
                result[i] = lhs[i] << 1
                
                if(overflow) {
                    result[i] = result[i] + 1
                }
                
                overflow = willOverflow
            }
        }
        
        return result
    }
}

func >> (lhs: UInt256, rhs: Int) -> UInt256 {
    if rhs >= 256 {
        return UInt256.allZeros
    }
    
    if rhs == 255 {
        if lhs & UInt256.singleBitAt(0) == 0 {
            return 0
        } else {
            return UInt256.singleBitAt(255)
        }
    }
    
    if rhs == 128 {
        return UInt256([0,0,0,0, lhs[0],lhs[1],lhs[2], lhs[3]])
    }
    
    var result = lhs
    
    for _ in 0..rhs {
        var overflow = false
        for i in 0..8 {
            
            let rightMostBit: UInt32 = 0b0000_0000_0000_0000_0000_0000_0000_0001
            let  leftMostBit: UInt32 = 0b1000_0000_0000_0000_0000_0000_0000_0000
            
            
            let willOverflow = result[i] & rightMostBit != 0
            
            result[i] = lhs[i] >> 1
            
            
            if(overflow) {
                result[i] += leftMostBit
            }
            
            overflow = willOverflow
        }
    }
    
    return result
}

func >>= (inout lhs: UInt256, rhs: Int) -> () {
    lhs = lhs >> rhs
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
    let sixteenBitMask = UInt256([0,0,0,0,0,0,0,UInt32.max >> 16])
    if lhs == lhs & sixteenBitMask && rhs == rhs & sixteenBitMask {
        return UInt256([0,0,0,0,0,0,0, lhs[7] * rhs[7]].copy())
    }
    
    let thirtyTwoBitMask = UInt256([0,0,0,0,0,0,0,UInt32.max].copy())
    let sixtyFourBitMask = UInt256([0,0,0,0,0,0,UInt32.max,UInt32.max].copy())
    let hundredTwentyEightBitMask = UInt256([0,0,0,0,UInt32.max,UInt32.max,UInt32.max,UInt32.max].copy())

    var x₁: UInt256
    var x₀: UInt256
    var y₁: UInt256
    var y₀: UInt256
    
    var bitSize: Int
    
    if lhs == lhs & thirtyTwoBitMask && rhs == rhs & thirtyTwoBitMask {

        x₁ = UInt256([0,0,0,0,0,0,0,lhs[7] >> UInt32(16)])
        x₀ = UInt256([0,0,0,0,0,0,0,lhs[7] & 0x0000FFFF].copy())
    
        y₁ = UInt256([0,0,0,0,0,0,0, rhs[7] >> UInt32(16)])
        y₀ = UInt256([0,0,0,0,0,0,0,rhs[7] & 0x0000FFFF].copy())
        
        bitSize = 32
    } else if lhs == lhs & sixtyFourBitMask && rhs == rhs & sixtyFourBitMask {
        x₁ = UInt256([0,0,0,0,0,0,0,lhs[6]].copy())
        x₀ = UInt256([0,0,0,0,0,0,0,lhs[7]].copy())
        
        y₁ = UInt256([0,0,0,0,0,0,0,rhs[6]].copy())
        y₀ = UInt256([0,0,0,0,0,0,0,rhs[7]].copy())
        
        bitSize = 64
    } else if lhs == lhs & hundredTwentyEightBitMask && rhs == rhs &  hundredTwentyEightBitMask {
        x₁ = UInt256([0,0,0,0,0,0,lhs[4],lhs[5]].copy())
        x₀ = UInt256([0,0,0,0,0,0,lhs[6],lhs[7]].copy())
        
        y₁ = UInt256([0,0,0,0,0,0,rhs[4],rhs[5]].copy())
        y₀ = UInt256([0,0,0,0,0,0,rhs[6],rhs[7]].copy())
        
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
        
        let x₁_plus_x₀ = UInt256([0,0,0,0,0,0,0, x₁[7] + x₀[7]])
        let y₁_plus_y₀ = UInt256([0,0,0,0,0,0,0, y₁[7] + y₀[7]])

        let z₁ = x₁_plus_x₀ * y₁_plus_y₀ - UInt256([0,0,0,0,0,0,0,z₂]) - UInt256([0,0,0,0,0,0,0,z₀])
        
        return UInt256([0,0,0,0,0,0,z₂,z₀]) + (z₁ << 16)
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

func / (numerator: UInt256, denomenator: UInt256) -> (UInt256) {
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
    
    
    return quotient

}

func % (numerator: UInt256, denomenator: UInt256) -> UInt256 {
  
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
    
    return remainder

    
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