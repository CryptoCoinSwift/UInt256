//
//  UInt256+IntegerLiteralConvertible.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

extension UInt256: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: IntegerLiteralType) {
        assert(value >= 0, "Unsigned integer should be 0 or larger")
        assert(value <= 9223372036854775807, "Value too large. Use a decimal string isntead.")

        if value <= 4294967295 {
            self.init(UInt32(value))
        } else if value <= 9223372036854775807 {
            self.init(UInt64(value))
        } else {
            fatalError("Something went wrong while creating a UInt256 from \(value).")
        }
    }
}
