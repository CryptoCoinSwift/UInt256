//
//  UInt256_Sequence.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

extension UInt256 : Sequence {
    func generate() -> IndexingGenerator<[UInt32]> {
        return value.generate()
    }
}