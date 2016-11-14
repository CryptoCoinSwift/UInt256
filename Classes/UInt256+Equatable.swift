//
//  UInt256+Equatable+Comparable.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

// This results in a duplicate symbol error:
// extension UInt256 : Equatable {}

/// Two UInt256 are equal iff all of its 8 individual parts are equal.
public func == (lhs: UInt256, rhs: UInt256) -> Bool {
    return lhs.part0 == rhs.part0 && lhs.part1 == rhs.part1 && lhs.part2 == rhs.part2 && lhs.part3 == rhs.part3 && lhs.part4 == rhs.part4 && lhs.part5 == rhs.part5 && lhs.part6 == rhs.part6 && lhs.part7 == rhs.part7
}
