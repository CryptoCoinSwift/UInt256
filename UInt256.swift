//
//  UInt256.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 23-06-14.

import Foundation // Needed for a workaround in decimalStringValue's call to hexStringValue

// Avoid using NSNumber:
func raiseByPositivePower(radix: UInt32, power: UInt32) -> UInt32 {
    var res: UInt32 = 1;
    for _ in 1...power {
        res = res * radix;
    }
    return res;
}

operator infix ^^ { precedence 160 associativity left }
@infix func ^^ (radix: UInt32, power: UInt32) -> UInt32 {
    assert(power >= 0, "Power must be 0 or more")
    return raiseByPositivePower(radix, power)
}

struct UInt256 : Comparable, Printable, BitwiseOperations, Hashable, IntegerLiteralConvertible {
    // We should support the following protocols before honoring ourselves with the
    // UnsignedInteger protocol:
    
    // ArrayBound
    // _IntegerArithmetic
    // ForwardIndex  (_Incrementable, etc)
    // IntegerArithmetic
    
    let smallerIntegers: UInt32[] = [0,0,0,0,0,0,0,0] // Most significant first.
    
    static func convertFromIntegerLiteral(value: IntegerLiteralType) -> UInt256 {
       assert(value >= 0, "Unsigned integer should be 0 or larger")

        switch UInt64(Int.max) {
        case UInt64(Int32.max):
            return UInt256(mostSignificantOf8UInt32First: [0,0,0,0,0,0,0,UInt32(value)])
        case UInt64(Int64.max):
            let rightDigit: UInt32 = UInt32(value & Int(Int32.max));
            let leftDigit:  UInt32 = UInt32(value >> 32);

            return UInt256(mostSignificantOf8UInt32First: [0,0,0,0,0,0,leftDigit, rightDigit])
        default:
            assert(false, "Unknown bit size")
            return allZeros;
        }
        
    }
    
    var description: String { return self.toDecimalString }
    
    var toDecimalString: String {
        return BaseConverter.hexToDec(self.toHexString)
    }
    
    var toHexString: String {
        assert(countElements(self.smallerIntegers) == 8, "8 UInt32's needed")

        var result: String = ""
            
        for int in smallerIntegers {
            var paddedHexString = BaseConverter.decToHex(int.description)
            
            for _ in 1...(8 - countElements(paddedHexString)) {
                paddedHexString = "0" + paddedHexString;
            }
            
            result += paddedHexString
        }
            
        // Remove 0 padding
        var unpaddedResult = ""
        var didEncounterFirstNonZeroDigit = false
    
        for digit in result {
            if digit != "0" {
                didEncounterFirstNonZeroDigit = true
            }
            if didEncounterFirstNonZeroDigit {
                unpaddedResult += digit
            }
        }
            
        return unpaddedResult
    }
    
    init (mostSignificantOf8UInt32First: UInt32[]) {
        assert(mostSignificantOf8UInt32First.count == 8, "8 UInt32's needed")
        
        for i in 0..8 {
            self.smallerIntegers[i] = mostSignificantOf8UInt32First[i]
        }
        
        self.smallerIntegers.unshare()

    }
    
    init(var hexStringValue: String) {
        // First we perform some sanity checks on the string. Then we chop it in 8 pieces and convert each to a UInt32.
        
        assert(countElements(hexStringValue) > 0, "Can't be empty");
        
        // Assert if string isn't too long
        assert(countElements(hexStringValue) <= 64, "Too large");
        
        
        hexStringValue = hexStringValue.uppercaseString;
        
        // Assert if string has any characters that are not 0-9 or A-F
        for character in hexStringValue {
            switch character {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F":
                assert(true)
            default:
                assert(false, "Invalid character")
            }
            
        }
        
        
        // Pad zeros
        for _ in 1...(64 - countElements(hexStringValue)) {
            hexStringValue = "0" + hexStringValue;
        }
        
        var int1: UInt32 = 0
        var int2: UInt32 = 0
        var int3: UInt32 = 0
        var int4: UInt32 = 0
        var int5: UInt32 = 0
        var int6: UInt32 = 0
        var int7: UInt32 = 0
        var int8: UInt32 = 0
        
        var i = 0
        
        for char in hexStringValue {
            var increment: UInt32 = 0
            
            switch char {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                let stringChar: String = char + "";
                increment = UInt32(stringChar.toInt()!)
            case "A":
                increment = 10
            case "B":
                increment = 11
            case "C":
                increment = 12
            case "D":
                increment = 13
            case "E":
                increment = 14
            case "F":
                increment = 15
            default:
                assert(false, "Unexpected digit");
            }
            
            let incrementor: UInt32 = 16^^(7 - (UInt32(i) % 8))
            increment = increment * incrementor;
            
            switch i {
            case 0..8:
                int1 += UInt32(increment)
            case 8..16:
                int2 += increment
            case 16..24:
                int3 += increment
            case 24..32:
                int4 += increment
            case 32..40:
                int5 += increment
            case 40..48:
                int6 += increment
            case 48..56:
                int7 += increment
            case 56..64:
                int8 += increment
            default:
                break;
            }
            
            i++
        }
        
        self.init(mostSignificantOf8UInt32First: [int1, int2, int3, int4, int5, int6, int7, int8])
    }
    
    init(decimalStringValue: String) {
        // First we perform some sanity checks on the string. Then we convert it to a hex string.
        
        assert(countElements(decimalStringValue) > 0, "Can't be empty");
        
        // Assert if string longer than 78 characters
        assert(countElements(decimalStringValue) <= 78, "Too large");
        
        // Assert if string has any characters that are not 0-9
        for character in decimalStringValue {
            switch character {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                assert(true)
            default:
                assert(false, "Invalid character")
            }
            
        }
        
        // Pad zeros
        var paddedDecimalString = decimalStringValue
        
        for _ in 1...(78 - countElements(decimalStringValue)) {
            paddedDecimalString = "0" + paddedDecimalString;
        }
        
        
        assert(paddedDecimalString <= "115792089237316195423570985008687907853269984665640564039457584007913129639935", "Too large")
        
        var hexStringValue: String = BaseConverter.decToHex(decimalStringValue)
        
        if hexStringValue == "" {
            hexStringValue = "0"
        }
        
//        self.init(hexStringValue: hexStringValue ) // This will cause EXC_BAD_ACCESS error
        self.init(hexStringValue: NSString(format:"%@", hexStringValue))
        
    }
    
    var hashValue: Int {
        return toHexString.hashValue
    }

    static var allZeros: UInt256 {
        let zeros: UInt32[] = [0,0,0,0,0,0,0,0]
        return UInt256(mostSignificantOf8UInt32First: zeros)
    }

}

func &(lhs: UInt256, rhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros
    
    for i in 0..8 {
        res.smallerIntegers[i] = lhs.smallerIntegers[i] & rhs.smallerIntegers[i]
    }
    
    return res
}

func |(lhs: UInt256, rhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros
    
    for i in 0..8 {
        res.smallerIntegers[i] = lhs.smallerIntegers[i] | rhs.smallerIntegers[i]
    }
    
    return res
}

func ^(lhs: UInt256, rhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros
    
    for i in 0..8 {
        res.smallerIntegers[i] = lhs.smallerIntegers[i] ^ rhs.smallerIntegers[i]
    }
    
    return res
}

@prefix func ~(lhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros
    
    for i in 0..8 {
        res.smallerIntegers[i] = ~lhs.smallerIntegers[i]
    }
    
    return res
}

func < (lhs: UInt256, rhs: UInt256) -> Bool {
    for i in 0..8 {
        if lhs.smallerIntegers[i] < rhs.smallerIntegers[i] {
            return true
        }
    }
    
    return false
}

func == (lhs: UInt256, rhs: UInt256) -> Bool {
    for i in 0..8 {
        if lhs.smallerIntegers[i] != rhs.smallerIntegers[i] {
            return false
        }
    }
    
    return true
}

func + (lhs: UInt256, rhs: UInt256) -> UInt256 {
    assert(lhs.smallerIntegers.count == 8, "8 UInt32's needed")
    assert(rhs.smallerIntegers.count == 8, "8 UInt32's needed")

    
    var previousDigitDidOverflow = false
    var sum: UInt32[] = [0,0,0,0,0,0,0,0]

    for var i=7; i > 0; i-- {
        let lhsForIndex: UInt32  = lhs.smallerIntegers[i]
        let rhsForIndex: UInt32  = rhs.smallerIntegers[i]

        let sumForIndex = lhsForIndex &+ rhsForIndex &+ (previousDigitDidOverflow ? 1 : 0)
        
        sum[i] = sumForIndex
        
        previousDigitDidOverflow = sumForIndex < lhsForIndex
    }
    
    // Don't allow overflow for the most significant UInt32:
    sum[0] = lhs.smallerIntegers[0] + lhs.smallerIntegers[0]  + (previousDigitDidOverflow ? 1 : 0)
    
    return UInt256(mostSignificantOf8UInt32First: sum)
}

func - (lhs: UInt256, rhs: UInt256) -> UInt256 {
    var previousDigitDidOverflow = false
    var diff: UInt32[] = [0,0,0,0,0,0,0,0]
    
    for var i=7; i > 0; i-- {
        let lhsForIndex: UInt32  = lhs.smallerIntegers[i]
        let rhsForIndex: UInt32  = rhs.smallerIntegers[i]
        
        let diffForIndex = lhsForIndex &- rhsForIndex &- (previousDigitDidOverflow ? 1 : 0)
        
        diff[i] = diffForIndex
        
        previousDigitDidOverflow = diffForIndex > lhsForIndex
    }
    
    // Don't allow overflow for the most significant UInt32:
    diff[0] = lhs.smallerIntegers[0] - lhs.smallerIntegers[0]  - (previousDigitDidOverflow ? 1 : 0)
    
    return UInt256(mostSignificantOf8UInt32First: diff)
}


func << (lhs: UInt256, rhs: Int) -> UInt256 {
    assert(rhs == 1, "Only left-shift by 1 bit is supported")
    
    var result = lhs
    
    var overflow = false
    for var i=7; i >= 0; i-- {
        let leftMostBit: UInt32 = 0b1000_0000_0000_0000_0000_0000_0000_0000
        
        let willOverflow = result.smallerIntegers[i] & leftMostBit != 0
        
        result.smallerIntegers[i] = lhs.smallerIntegers[i] << 1

        
        if(overflow) {
            result.smallerIntegers[i]++
        }
        
        
        overflow = willOverflow
    }
    
    return result
}

func <<= (var lhs: UInt256, rhs: Int) -> () {
    lhs = lhs << rhs
}

func >> (lhs: UInt256, rhs: Int) -> UInt256 {
    assert(rhs == 1, "Only right-shift by 1 bit is supported")
    
    var result = lhs
    
    var overflow = false
    for i in 0..8 {
        
        let rightMostBit: UInt32 = 0b0000_0000_0000_0000_0000_0000_0000_0001
        let  leftMostBit: UInt32 = 0b1000_0000_0000_0000_0000_0000_0000_0000

        
        let willOverflow = result.smallerIntegers[i] & rightMostBit != 0
        
        result.smallerIntegers[i] = lhs.smallerIntegers[i] >> 1
        
        
        if(overflow) {
            result.smallerIntegers[i] += leftMostBit
        }
        
        overflow = willOverflow
    }
    
    return result
}

func >>= (var lhs: UInt256, rhs: Int) -> () {
    lhs = lhs >> rhs
}

func * (lhs: UInt256, rhs: UInt256) -> UInt256 {
    assert(lhs.smallerIntegers.count == 8, "8 UInt32's needed")
    assert(rhs.smallerIntegers.count == 8, "8 UInt32's needed")
    

    
    var rhsBitLength: UInt32 = 256
    for int in rhs.smallerIntegers {
        if int == 0 {
            rhsBitLength -= 32
        } else {
            for var i: UInt32 = 31; i > 0; i-- {
                if (2^^i) & int != 0 {
                    break;
                } else {
                    rhsBitLength--;

                }
            }
            break;
        }
    }
    
    var product: UInt32[] = [0,0,0,0,0,0,0,0]
    
    // var leftShiftedLHS = lhs // This won't copy the array...
    var leftShiftedLHS = UInt256(mostSignificantOf8UInt32First: lhs.smallerIntegers)
    
    for var i: UInt32 = 0; i < rhsBitLength; i++ {
        // Bitwise AND RHS with a single bit at position 256 - i (split in chunks of 32)
        let relevantInt = rhs.smallerIntegers[Int((255 - i) / 32)]
        let position = (i) % 32
        
        if(2^^position & relevantInt != 0) {
            for j in 0..8 {
                let add: UInt32 = leftShiftedLHS.smallerIntegers[Int(j)]
                let before: UInt32 = product[Int(j)]
                product[Int(j)] = before &+ add
                if before > product[Int(j)] {
                    if(i > 0) {
                        product[Int(j) - 1]++
                    } else {
                        assert(false, "Overflow")
                    }
                }
            }
        }
        
        // Don't allow overflow on the most significant digit:
        let  leftMostBit: UInt32 = 0b1000_0000_0000_0000_0000_0000_0000_0000

        assert(leftShiftedLHS.smallerIntegers[0] & leftMostBit == 0, "Left shift overflow not allowed for UInt256")

        // Left shift
        leftShiftedLHS = leftShiftedLHS << 1
        
        
        

    }
    
    
    return UInt256(mostSignificantOf8UInt32First: product)
}