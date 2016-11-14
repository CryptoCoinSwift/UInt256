//
//  UInt256+Equatable+Comparable.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

/// As soon as one of its parts, ordered by significance, is smaller then the other's corresponding part, we can return.
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
