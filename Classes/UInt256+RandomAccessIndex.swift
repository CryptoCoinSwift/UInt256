//
//  UInt256+RandomAccessIndex.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

// TODO: Add tests for this.

public extension UInt256 {

    public func distanceTo(_ other: UInt256) -> Int {
        let distance = other - self
        assert(distance <= UInt256(0, 0, 0, 0, 0, 0, 0, UInt32.max), "Too far")
        return Int(distance[7])
    }

    public func advanced(by distance: Int) -> UInt256 {
        return self + UInt256(distance)
    }
}
