//
//  UInt256+IntegerLiteralConvertible.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

extension UInt256: ExpressibleByIntegerLiteral { // _BuiltinIntegerLiteralConvertible

    public init(integerLiteral value: IntegerLiteralType) {
        assert(value >= 0, "Unsigned integer should be 0 or larger")
        assert(value < 2147483647, "Too large - use decimal string assignment")

        self.part0 = 0
        self.part1 = 0
        self.part2 = 0
        self.part3 = 0
        self.part4 = 0
        self.part5 = 0
        self.part6 = 0
        self.part7 = UInt32(value)
    }
}
