//
//  UInt256+RandomAccessIndex.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

// Preliminary implementation to conform to UnsignedInteger. Unused and untested.

// Conforming to RandomAccessIndex results in a duplicate symbol error.

extension UInt256 { // : RandomAccessIndex {
    func distanceTo(other: UInt256) -> Int {
        let distance = other - self
        assert(distance <= UInt256(0,0,0,0, 0,0,0,UInt32.max), "Too far")
        return Int(distance[7])
    }

//    func advancedBy(distance: Int) -> UInt256 {
//        return self + UInt256(distance)
//    }
}