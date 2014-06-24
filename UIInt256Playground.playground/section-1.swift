import Cocoa

// Goal: chop up a large decimal number into 8 chunks of 32 bits (8 hex characters) each.

var decimalStringValue = "115792089237316195423570985008687907853269984665640564039457584007913129639935" // Max value, will crash playground


decimalStringValue =   "1000000000000000000"  // Too much for Wolfram Alpha and Google to handle, or bug in this code...

decimalStringValue   = "100000000000000000" // The most Wolfram Alpha can handle

decimalStringValue = "100000000000"

// For reference, 2^64: 18446744073709551616

//operator infix ^^ { }
//@infix func ^^ (radix: Int, power: Int) -> Int {
//    return Int(pow(Double(radix), Double(power)))
//}

func raiseByPositivePower(radix: Int, power: Int) -> Int {
    var res = 1;
    for _ in 1...power {
        res *= radix;
    }
    return res;
}

operator infix ^^ { }
@infix func ^^ (radix: Int, power: Int) -> Int {
    assert(power >= 0, "Power must be 0 or more")
    return raiseByPositivePower(radix, power)
}

var reverseDecimalString = ""
var base16: Int[] = []

for char in decimalStringValue {
    reverseDecimalString = char + reverseDecimalString
    base16 += 0
}

reverseDecimalString

var hexStringValue: String = ""




var i = 0
for digitChar in reverseDecimalString {
    digitChar
    let digitString: String = digitChar + ""
    var carryover = digitString.toInt()! * (10^^i)

    for var j = countElements(base16) - 1; j >= 0; j-- {
        base16[j] = base16[j] + carryover
        let remainder: Int = base16[j] % 16
        carryover = base16[j] / 16
        base16[j] = remainder
        base16
        
        if carryover == 0 {
            break;
        }
    }
    
    i++
}

base16

// Convert to hex and drop leading zeros
var firstNonZeroDigitParsed = false
for digit in base16 {
    switch digit {
    case 0:
        if(firstNonZeroDigitParsed) {
            hexStringValue += "0"
        }
    case 1...9:
        firstNonZeroDigitParsed = true
         hexStringValue += digit.description
    case 10:
        hexStringValue += "A"
    case 11:
        hexStringValue += "B"
    case 12:
        hexStringValue += "C"
    case 13:
        hexStringValue += "D"
    case 14:
        hexStringValue += "E"
    case 15:
        hexStringValue += "F"
    default:
        println(digit)
        assert(false, "Digit too large")
    }
}


// Pad zeros
for _ in 1...(64 - countElements(hexStringValue)) {
    hexStringValue = "0" + hexStringValue;
}

hexStringValue


var string1 = "0x"
var string2 = "0x"
var string3 = "0x"
var string4 = "0x"
var string5 = "0x"
var string6 = "0x"
var string7 = "0x"
var string8 = "0x"
i = 0

for char in hexStringValue {
    switch i {
    case 0..8:
        string1 += char
    case 8..16:
        string2 += char
    case 16..24:
        string3 += char
    case 24..32:
        string4 += char
    case 32..40:
        string5 += char
    case 40..48:
        string6 += char
    case 48..56:
        string7 += char
    case 56..64:
        string8 += char
    default:
        break;
    }
    
    i++
}

string1
string2
string3
string4
string5
string6
string7
string8

string1.toInt()
"0".toInt()
"1".toInt()
"0x1".toInt()

var int1: Int = 0
var int2: Int = 0
var int3: Int = 0
var int4: Int = 0
var int5: Int = 0
var int6: Int = 0
var int7: Int = 0
var int8: Int = 0

i = 0

for char in hexStringValue {
    var increment: Int = 0
    
    switch char {
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            let stringChar: String = char + "";
            increment = stringChar.toInt()!
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
    7 - (i % 8)
    increment
    increment *= 16^^(7 - (i % 8))
    
    switch i {
    case 0..8:
        int1 += increment
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


let uint1: UInt32 = UInt32(int1)
let uint2: UInt32 = UInt32(int2)
let uint3: UInt32 = UInt32(int3)
let uint4: UInt32 = UInt32(int4)
let uint5: UInt32 = UInt32(int5)
let uint6: UInt32 = UInt32(int6)
let uint7: UInt32 = UInt32(int7)
let uint8: UInt32 = UInt32(int8) // Least significant

// Check with Wolfram Alpha: uint7 * 2^32 + uint8 = original number  (remove the dots!)
