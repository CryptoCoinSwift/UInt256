//
//  UInt256+Equatable+Comparable.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

// This results in a duplicate symbol error:
// extension UInt256 : Comparable {}

public func < (lhs: UInt256, rhs: UInt256) -> Bool {
    for i in 0 ..< 8 {
        if lhs[i] < rhs[i] {
            return true
        } else if lhs[i] > rhs[i] {
            return false
        }
    }

    return false
}

public func >= (lhs: UInt256, rhs: UInt256) -> Bool {
    return lhs == rhs || lhs > rhs
}

public func <= (lhs: UInt256, rhs: UInt256) -> Bool {
    return lhs == rhs || lhs < rhs
}
