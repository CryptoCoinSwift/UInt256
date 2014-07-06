//
//  UInt256+IntegerLiteralConvertible.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

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