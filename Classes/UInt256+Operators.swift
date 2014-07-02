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
    for i in 0..8 {
        if lhs[i] != rhs[i] {
            return false
        }
    }
    
    return true
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

@postfix func ++ (inout lhs: UInt256) -> (UInt256) {
    lhs += UInt256([0,0,0,0,0,0,0,1])
    
    return lhs
}


func &+ (lhs: UInt256, rhs: UInt256) -> UInt256 {
    var previousDigitDidOverflow = false
    
    var sum = UInt256.allZeros
    
    for var i=7; i >= 0; i-- {
        sum[i] = lhs[i] &+ rhs[i] &+ (previousDigitDidOverflow ? 1 : 0)

        previousDigitDidOverflow = sum[i] < lhs[i]
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
    assert(rhs == 1, "Only left-shift by 1 bit is supported")

    var result = lhs
    
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


    return result
}

func >> (lhs: UInt256, rhs: Int) -> UInt256 {
    assert(rhs == 1, "Only right-shift by 1 bit is supported")
    
    var result = lhs
    
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
    let (a,b) = lhs * rhs
    
    assert(a==0, "Overflow not allowed in multiplication")
    
    return b
}

func * (lhs: UInt256, rhs: UInt256) -> (UInt256, UInt256) {
    var rhsBitLength = rhs.highestBit
    var (productLeft,productRight)   = (UInt256.allZeros, UInt256.allZeros)
    var (lhsLeftShifterLeft, lhsLeftShifterRight) = (UInt256.allZeros, lhs)
    
    for var i = 0; i < rhsBitLength; i++ {
        // Bitwise AND RHS with a single bit at position 256 - i (split in chunks of 32)
        let relevantInt = rhs[Int((255 - i) / 32)]
        let position = (i) % 32
        
        if(2^^UInt32(position) & relevantInt != 0) {
            // Least significant UInt256:
            for var j=7; j >= 0; j-- {
                let add    = lhsLeftShifterRight[j]
                let before =        productRight[j]
                productRight[j] = before &+ add
                
                let addHex = UInt256(decimalStringValue: add.description).toHexString
                
//                println("i = \( i ); j = \( j ) ; add = \( addHex ); product = \( productRight.toHexString ) ")
                
                if before > productRight[j] {
                    var overflowProcessed = false
                    var k = j
                    
//                    println("Overflow: before product = \( productRight.toHexString ) ")

                    
                    while(!overflowProcessed) {
                        if k > 0 {

                            
                            productRight[k - 1]++ // Will not warn on overflow
                            
                            if productRight[k - 1] != 0 {
                                overflowProcessed = true
//                                println("Overflow: after product = \( productRight.toHexString ) ")

                            }
                            
                        } else {
                            productLeft[7 - k]++
                            
                            if productLeft[7 - k] != 0 {
                                overflowProcessed = true
                            }

                        }
                        
                        k--
                    }
                    
                    
                }
            }
            
            // Most significant UInt256:
            for var j=7; j >= 0; j-- {
                let add = lhsLeftShifterLeft[j]
                let before = productLeft[j]
                productLeft[j] = before &+ add
                if before > productLeft[j] {
                    assert(j > 0, "Overflow")
                    productLeft[j - 1]++
                }
            }
        }
        
        // Left shift
        let lhsLeftShifterRightBefore = lhsLeftShifterRight
        lhsLeftShifterRight <<= 1
        lhsLeftShifterLeft <<= 1
        
        if lhsLeftShifterRight < lhsLeftShifterRightBefore {
            lhsLeftShifterLeft += 1
        }

    }
    
    return (productLeft, productRight)
    
}

func / (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let (quotient, _) = lhs.divideBy(rhs)
    
    return quotient
}

func % (lhs: UInt256, rhs: UInt256) -> UInt256 {
    let (_, remainder) = lhs.divideBy(rhs)
    
    return remainder
    
}