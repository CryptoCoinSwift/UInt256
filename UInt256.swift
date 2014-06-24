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
    
    let value: Int
    
    var description: String { return value.description }

    init(decimalStringValue: String) {
        if let numberFromString = decimalStringValue.toInt() {
            self.value = numberFromString
        } else {
            assert(0==1, "Invalid number");
            self.value = 0
        }
    }
    
}

func < (lhs: UInt256, rhs: UInt256) -> Bool {
    return lhs.value < rhs.value
}

func == (lhs: UInt256, rhs: UInt256) -> Bool {
    return lhs.value == rhs.value
}
