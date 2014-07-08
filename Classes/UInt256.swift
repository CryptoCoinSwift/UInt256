//
//  UInt256.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 23-06-14.

struct UInt256 { // : UnsignedInteger
    /* UnsignedInteger consists of a whole bunch of protocols. I implemented all that I could find, even if not always correctly. Unfortunately the compiler still complains that UInt256 doesn't comform to _UnsignedInteger. I can't find documentation for this protocol. */
   
    // Todo: use 4 parts on a 64 bit system
    var value: [UInt32] // Most significant first, should be 8 long
    
    subscript(index: Int) -> UInt32 {
        get {
          return value[index]
        }
        
        mutating set(newValue) {
            assert(index < 8, "Invalid index")
            value[index] = newValue
        }
    }
    
    init (_ part0: UInt32, _ part1: UInt32, _ part2: UInt32, _ part3: UInt32, _ part4: UInt32, _ part5: UInt32, _ part6: UInt32, _ part7: UInt32) {
        
        self.value = [part0, part1, part2, part3, part4, part5, part6,part7]
    }
    
    init() {
        self.value = [0,0,0,0,0,0,0,0]
    }
    
    init(let _ value: UInt32) {
        self.value = [0,0,0,0,0,0,0,UInt32(value)]
    }

    init(let _ value: UInt64) {
      let leftDigit:  UInt32 = UInt32(value >> 32);
      let rightDigit: UInt32 = UInt32((value << 32) >> 32);

      self.value = [0,0,0,0,0,0,leftDigit, rightDigit]

    }
    
    init(let _ value: Int) {
        self.value = [0,0,0,0,0,0,0,UInt32(value)]
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
            case 0..<8:
                int1 += UInt32(increment)
            case 8..<16:
                int2 += increment
            case 16..<24:
                int3 += increment
            case 24..<32:
                int4 += increment
            case 32..<40:
                int5 += increment
            case 40..<48:
                int6 += increment
            case 48..<56:
                int7 += increment
            case 56..<64:
                int8 += increment
            default:
                break;
            }
            
            i++
        }
        
        self.value = [int1, int2, int3, int4, int5, int6, int7, int8]
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





