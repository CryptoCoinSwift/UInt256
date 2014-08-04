//
//  UInt256_Sequence.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

extension UInt256 : SequenceType {
    public func generate() -> IndexingGenerator<[UInt32]> {
        // return value.generate()      
        return [part0, part1, part2, part3, part4, part5, part6, part7].generate()
    }
}