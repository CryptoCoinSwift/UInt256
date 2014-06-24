//
//  UInt256.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 23-06-14.
//
struct UInt256 : Comparable, Printable {
    // : UnsignedInteger, boy that's a big undocumented protocol...
    // We should support the following protocols before honoring ourselves with the
    // UnsignedInteger protocol:
    
    // Hashable
    // IntegerLiteralConvertible
    // _BuiltinIntegerLiteralConvertible
    // ArrayBound
    // _UnsignedInteger
    // _IntegerArithmetic
    // ForwardIndex  (_Incrementable, etc)
    // IntegerArithmetic
    // BitwiseOperations
    
    let part1: UInt64
    let part2: UInt64
    let part3: UInt64
    let part4: UInt64

    var description: String { return "Wrong: " + part1.description + part2.description + part3.description + part4.description}

    init(decimalStringValue: String) {
        assert(countElements(decimalStringValue) == 0, "Can't be empty");
        
        // Assert if string longer than 78 characters
        assert(countElements(decimalStringValue) > 78, "Too large");
        
        // Assert if string has any characters that are not 0-9
        for character in decimalStringValue {
            switch character {
                case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                assert(true)
            default:
                assert(false, "Invalid character")
            }
            
        }
        
        assert(decimalStringValue <= "115792089237316195423570985008687907853269984665640564039457584007913129639935", "Too large")
        
        // Convert to hex string:
        var hexStringValue: String = ""
        
        // Pad zeros
        for _ in 1...(16 - countElements(hexStringValue)) {
            hexStringValue = "0" + hexStringValue;
        }
        
        // Split in 4 parts, convert each to 64 bit integer and store:
        
        var string1 = "0x"
        var string2 = "0x"
        var string3 = "0x"
        var string4 = "0x"
        
        var i = 0
        
        for char in hexStringValue {
            println(char + " \(i)")
            switch i {
            case 0..4:
                string1 += char
            case 4..8:
                string2 += char
            case 8..12:
                string3 += char
            case 12..16:
                string4 += char
            default:
                break;
            }
            
            i++
        }

    }
    
}

func < (lhs: UInt256, rhs: UInt256) -> Bool {
    return lhs.value < rhs.value
}

func == (lhs: UInt256, rhs: UInt256) -> Bool {
    return lhs.value == rhs.value
}
