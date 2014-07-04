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

struct UInt256 : Comparable, Printable, BitwiseOperations, Hashable, IntegerLiteralConvertible, ArrayBound, Sequence  {
    // All the above are combined in the illustruous UnsignedInteger protocol. 
    // The following is still needed (mostly things like *=, &&=, etc)
    
    // IntegerArithmetic (it complies, but Swift demands _IntegerArithmetic as well)
    // ForwardIndex  (_Incrementable, etc)
    
    var smallerIntegers: UInt256Store = UInt256Store(array: [0,0,0,0,0,0,0,0]) // Most significant first.
    
    subscript(index: Int) -> UInt32 {
        get {
            return smallerIntegers[index]
        }
        set(newValue) {
            smallerIntegers[index] = newValue
        }
    }
    
    static func convertFromIntegerLiteral(value: IntegerLiteralType) -> UInt256 {
       assert(value >= 0, "Unsigned integer should be 0 or larger")

        switch UInt64(Int.max) {
        case UInt64(Int32.max):
            return UInt256([0,0,0,0,0,0,0,UInt32(value)])
        case UInt64(Int64.max):
            let rightDigit: UInt32 = UInt32(value & Int(Int32.max));
            let leftDigit:  UInt32 = UInt32(value >> 32);

            return UInt256([0,0,0,0,0,0,leftDigit, rightDigit])
        default:
            assert(false, "Unknown bit size")
            return allZeros;
        }
    }
    
    var description: String { return self.toDecimalString }
    
    var toDecimalString: String {
        if self == 0 {
            return 0.description
        }
        return BaseConverter.hexToDec(self.toHexString)
    }
    
    var toHexString: String {

        var result: String = ""
            
        for int in self {
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
            
        if unpaddedResult == "" {
          unpaddedResult = "0"
        }
            
        return unpaddedResult
    }
    
    init (_ mostSignificantOf8UInt32First: UInt32[]) {
        assert(mostSignificantOf8UInt32First.count == 8, "8 UInt32's needed")
        
        for i in 0..8 {
            self[i] = mostSignificantOf8UInt32First[i]
        }

    }
    
    init(let _ int: Int) {
        self.init(decimalStringValue: int.description)
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
        
        self.init([int1, int2, int3, int4, int5, int6, int7, int8])
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
        
        self.init(hexStringValue: hexStringValue ) // This will cause EXC_BAD_ACCESS error
//        self.init(hexStringValue: NSString(format:"%@", hexStringValue))
        
    }
    
    var highestBit: Int {
        var bitLength: UInt32 = 256
        for int in self {
            if int == 0 {
                bitLength -= 32
            } else {
                for var i: UInt32 = 31; i > 0; i-- {
                    if (2^^i) & int != 0 {
                        break;
                    } else {
                        bitLength--;
                        
                    }
                }
                break;
            }
        }
            
        return Int(bitLength)
    }
    
    var hashValue: Int {
        return toHexString.hashValue
    }
    
    func getArrayBoundValue() -> UInt256 {
        return self
    }

    static var allZeros: UInt256 {
        let zeros: UInt32[] = [0,0,0,0,0,0,0,0]
        return UInt256(zeros)
    }
    
    static var max: UInt256 {
        return UInt256([UInt32.max, UInt32.max,UInt32.max,UInt32.max,UInt32.max,UInt32.max,UInt32.max,UInt32.max])
    }
    
    func toIntMax() -> IntMax {
        return Int64(self[6]<<32 + self[7])
    }
    
    func divideBy(denomenator: UInt256) -> (quotient: UInt256, remainder: UInt256) {
        assert(denomenator != UInt256.allZeros, "Divide by zero")
        let numerator = self
        
        var  quotient: UInt256 = 0
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
        
        
        return (quotient, remainder);
    }
    
    static func singleBitAt (position: Int) -> (UInt256) {
        var result: UInt256 = self.allZeros
        let index: Int = position / 32
        let bit: Int = 31 - (position % 32)
        
        result[index] =  2^^UInt32(bit)
        
        return result
    }
    
    mutating func setBitAt(position: Int) -> () {
        self = (self & ~UInt256.singleBitAt(position)) | UInt256.singleBitAt(position)
    }
    
    mutating func unsetBitAt(position: Int) -> () {
        self = self & ~UInt256.singleBitAt(position)
    }
    
    func modInverse(m: UInt256) -> UInt256 {
        // http://rosettacode.org/wiki/Modular_inverse#C
        var a = self
        var b = m
        let b0 = b
        var t: UInt256
        var q: UInt256
        var x0 = UInt256.allZeros
        var x1 = UInt256(1)
        
        if (m == 1) {
            return 1
        }
        
        while (a > 1) {
//            println("Divide...")
            q = a / b;
            t = b
//            println("Modulo...")
            b = a % b
            a = t
            t = x0
            //x0 = x1 &- q &* x0
//            println("Multiply..")
            let temp = q &* x0
//            println("Subtract...")
            x0 = x1 &- temp
            x1 = t
        }
        
        if (x1 < 0) {
            println("Add...")
            x1 += b0
        }
        
        return x1;
    }
}

extension UInt256 : Sequence {
    func generate() -> IndexingGenerator<UInt32[]> {
        return self.smallerIntegers.generate()
    }
}



