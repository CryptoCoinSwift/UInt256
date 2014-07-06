//
//  UInt32 Helpers.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

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
