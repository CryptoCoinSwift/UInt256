//
//  UInt256.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 23-06-14.

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

    static var allZeros: UInt256 {
        return UInt256(0,0,0,0,0,0,0,0)
    }
    
    static var max: UInt256 {
        return UInt256(UInt32.max, UInt32.max,UInt32.max,UInt32.max,UInt32.max,UInt32.max,UInt32.max,UInt32.max)
    }
    
    static var min: UInt256 {
        return UInt256.allZeros
    }
        
}





