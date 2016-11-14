//
//  UInt256+Equatable+Comparable.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

// This results in a duplicate symbol error:
// extension UInt256 : Equatable {}

public func == (lhs: UInt256, rhs: UInt256) -> Bool {
    //    return lhs[0] == rhs[0] && lhs[1] == rhs[1] && lhs[2] == rhs[2] && lhs[3] == rhs[3] && lhs[4] == rhs[4] && lhs[5] == rhs[5] && lhs[6] == rhs[6] && lhs[7] == rhs[7]
    return lhs.part0 == rhs.part0 && lhs.part1 == rhs.part1 && lhs.part2 == rhs.part2 && lhs.part3 == rhs.part3 && lhs.part4 == rhs.part4 && lhs.part5 == rhs.part5 && lhs.part6 == rhs.part6 && lhs.part7 == rhs.part7
}
