//
//  UInt256+Hashable.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

// Preliminary implementation to conform to UnsignedInteger. Unused and untested.

// Conforming to Hashable results in a duplicate symbol error.
extension UInt256 { // : Hashable {
    var hashValue: Int {
        return toHexString.hashValue
    }
}
