//
//  UInt256_Sequence.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

extension UInt256: Sequence {
    public func makeIterator() -> IndexingIterator<[UInt32]> {
        return [part0, part1, part2, part3, part4, part5, part6, part7].makeIterator()
    }
}
