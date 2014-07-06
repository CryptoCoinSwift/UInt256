//
//  UInt256.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 23-06-14.

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

struct UInt256 { // : UnsignedInteger
    /* UnsignedInteger consists of a whole bunch of protocols. I implemented all that I could find, even if not always correctly. Unfortunately the compiler still complains that UInt256 doesn't comform to _UnsignedInteger. I can't find documentation for this protocol. */
   
    // Use 8 vars, pending fixed size arrays in Swift and arrays that don't behave w̶e̶i̶r̶d̶
    // optimized when they get copied around with the struct they're in.
    // Todo: use 4 parts on a 64 bit system
    var part0: UInt32 // Most significant
    var part1: UInt32
    var part2: UInt32
    var part3: UInt32
    var part4: UInt32
    var part5: UInt32
    var part6: UInt32
    var part7: UInt32
    
    subscript(index: Int) -> UInt32 {
        get {
            switch index {
            case 0:
                return part0
            case 1:
                return part1
            case 2:
                return part2
            case 3:
                return part3
            case 4:
                return part4
            case 5:
                return part5
            case 6:
                return part6
            case 7:
                return part7
            default:
                assert(false, "Invalid index");
                return 0
            }
            
        }
        
        mutating set(newValue) {
            switch index {
            case 0:
                part0 = newValue
            case 1:
                part1 = newValue
            case 2:
                part2 = newValue
            case 3:
                part3 = newValue
            case 4:
                part4 = newValue
            case 5:
                part5 = newValue
            case 6:
                part6 = newValue
            case 7:
                part7 = newValue
            default:
                assert(false, "Invalid index");
                
            }
        }
    }
    
    init (_ part0: UInt32, _ part1: UInt32, _ part2: UInt32, _ part3: UInt32, _ part4: UInt32, _ part5: UInt32, _ part6: UInt32, _ part7: UInt32) {
        
        self.part0 = part0
        self.part1 = part1
        self.part2 = part2
        self.part3 = part3
        self.part4 = part4
        self.part5 = part5
        self.part6 = part6
        self.part7 = part7
    }
    
    init() {
        self.init(0,0,0,0,0,0,0,0)
    }
    
    init(let _ value: Int) {
        switch UInt64(Int.max) {
        case UInt64(Int32.max):
            self.init(0,0,0,0,0,0,0,UInt32(value))
        case UInt64(Int64.max):
            let rightDigit: UInt32 = UInt32(value & Int(Int32.max));
            let leftDigit:  UInt32 = UInt32(value >> 32);
            
            self.init(0,0,0,0,0,0,leftDigit, rightDigit)
        default:
            assert(false, "Unknown bit size")
            self.init(0,0,0,0,0,0,0,0)
        }
    }
    
    
    init(let _ value: UInt256) {
        self = value
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
        
        self.init(int1, int2, int3, int4, int5, int6, int7, int8)
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
        
        self.init(hexStringValue: hexStringValue )
    }
    
    var highestBit: Int {
        var bitLength: UInt32 = 256
        for int in self {
            if int == 0 { bitLength -= 32 } else {
                for var i: UInt32 = 31; i > 0; i-- {
                    if (2^^i) & int != 0 {  break;  } else {  bitLength--; }
                }
                break;
            }
        }
            
        return Int(bitLength)
    }

    static var allZeros: UInt256 {
        return UInt256(0,0,0,0,0,0,0,0)
    }
    
    static var max: UInt256 {
        return UInt256(UInt32.max, UInt32.max,UInt32.max,UInt32.max,UInt32.max,UInt32.max,UInt32.max,UInt32.max)
    }
    
    static var min: UInt256 {
        return UInt256.allZeros
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

extension UInt256 : Printable {
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
}

extension UInt256 : Sequence {
    func generate() -> IndexingGenerator<UInt32[]> {
        return [part0, part1, part2, part3, part4, part5, part6, part7].generate()
    }
}

extension UInt256 : ForwardIndex {
    func succ() -> UInt256 {
        return self + UInt256(1)
    }
    func pred() -> UInt256 {
        return self + UInt256(1)
    }
}

//extension UInt256 : RandomAccessIndex {
//    func distanceTo(other: UInt256) -> Int {
//        let distance = other - self
//        assert(distance <= UInt256(0,0,0,0, 0,0,0,UInt32.max), "Too far")
//        return Int(distance[7])
//    }
//    
//    func advancedBy(distance: Int) -> UInt256 {
//        return self + UInt256(distance)
//    }
//}

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
    
    
}

extension UInt256 : IntegerLiteralConvertible { // _BuiltinIntegerLiteralConvertible
    static func convertFromIntegerLiteral(value: IntegerLiteralType) -> UInt256 {
        assert(value >= 0, "Unsigned integer should be 0 or larger")
        
        return UInt256(value)
    }
    
//    This overrides convertFromIntegerLiteral!
//    static func _convertFromBuiltinIntegerLiteral(value: MaxBuiltinIntegerType) -> UInt256 {
//        assert(false, "Can't handle this") // Doesn't crash!
//        return UInt256(0,0,0,0,0,0,0,0)
//    }

}

extension UInt256 : Hashable {
    var hashValue: Int {
        return toHexString.hashValue
    }
}

extension UInt256 : ArrayBound {
    typealias ArrayBoundType = UInt256

    
    func getArrayBoundValue() -> UInt256 {
        return self
    }
}