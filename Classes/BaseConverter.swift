//
//  BaseConverter.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 24-06-14.
//

// Convert between strings in arbitrary base, ported from http://danvk.org/hex2dec.html
public struct BaseConverter {
    let base: Int
    
    // Adds two arrays for the given base (10 or 16)
    func add(x: [Int], y: [Int]) -> [Int] {
        var z: [Int] = []
        let n = max(countElements(x), countElements(y))
        
        var carry = 0;
        var i = 0;
        while (i < n || carry > 0) {
            let xi = i < countElements(x) ? x[i] : 0
            let yi = i < countElements(y) ? y[i] : 0
            let zi = carry + xi + yi;
            z.append(zi % self.base)
            carry = zi / base
            i++;
        }
        return z;
    }
    
    // Returns a * x, where x is an array of decimal digits and a is an ordinary
    // Int. The array should be in the base of the instance.
    func multiplyByNumber(num: Int, x: [Int]) -> [Int] {
        assert(num >= 0, "Positive numbers only")
        assert(num <= Int(Int32.max), "32 bit power max")
        
        var numU: UInt32  = UInt32(num);
        
        if (numU == 0) {
            return [];
        }
        
        var result: [Int] = [];
        var power = x;
        
        while (true) {
            if numU & 1 > 0 {
                result = add(result, y: power);
            }
            numU = numU >> 1;
            if (numU == 0) {
                break;
            }
            power = add(power, y: power);
        }
        
        return result;
    }
    
    func parseToDigitsArray(str: String) -> [Int] {
        var digits: [String] = []
        for char in str {
            digits.append(String(char))
        }
        
        var ary: [Int] = [];
        
        for (var i = digits.count - 1; i >= 0; i--) {
            var n = stringToInt(digits[i])
            
            if n? != nil {
                ary.append(n!)
            } else {
                assert(false, "Invalid digit")
            }
        }
        return ary;
    }
    
    public static  func convertBase(str: String, fromBase: Int, toBase: Int) -> String {
        let fromBaseConverter = self(base: fromBase)
        let   toBaseConverter = self(base:   toBase)
        
        
        var digits = fromBaseConverter.parseToDigitsArray(str);
        
        var outArray: [Int] = [];
        var power = [1];
        for digit in digits {
            // invariant: at this point, fromBase^i = power
            let digitsTimesPower: [Int] = toBaseConverter.multiplyByNumber(digit, x: power)
            outArray = toBaseConverter.add(outArray, y:digitsTimesPower);
            power =    toBaseConverter.multiplyByNumber(fromBase, x: power);
        }
        
        var out: String = ""
        
        for (var i = outArray.count - 1; i >= 0; i--) {
            out += toBaseConverter.intToString(outArray[i])
        }
        
        return out;
    }
    
    func stringToInt (digit: String) -> Int? {
        
        switch self.base {
        case 2, 3, 4, 5, 6, 7, 8, 9, 10:
            return digit.toInt()
        case 16:
            switch digit {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                return digit.toInt()
            case "A", "a":
                return 10
            case "B", "b":
                return 11
            case "C", "c":
                return 12
            case "D", "d":
                return 13
            case "E", "e":
                return 14
            case "F", "f":
                return 15
            default:
                assert(false, "Invalid hex digit")
                return nil
            }
            
        default:
            assert(false, "Only base 2-10 and 16 are supported")
            return nil
        }
        
    }
    
    func intToString (digit: Int) -> String {
        
        switch self.base {
        case 2, 3, 4, 5, 6, 7, 8, 9, 10:
            return digit.description
        case 16:
            switch digit {
            case 0...9:
                return digit.description
            case 10:
                return "A"
            case 11:
                return "B"
            case 12:
                return "C"
            case 13:
                return "D"
            case 14:
                return "E"
            case 15:
                return "F"
            default:
                assert(false, "Invalid hex digit")
                return ""
            }
        
        case 58: // This is a bitcoin specific variant!
            let alphabet: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
            
            return alphabet[digit]
            
        default:
            assert(false, "Only base 2-10, 16 and 58 are supported")
            return ""
        }
        
    }
    
    
    public static func decToHex(decStr: String) -> String {
        return convertBase(decStr, fromBase:10,toBase:16);
    }
    
    public static func hexToDec(var hexStr: String) -> String {
        return convertBase(hexStr, fromBase:16, toBase: 10);
    }
}
