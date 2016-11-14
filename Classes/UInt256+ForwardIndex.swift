//
//  UInt256+ForwardIndex.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.

// TODO: Add tests.

extension UInt256 {

    func successor() -> UInt256 {
        return self + UInt256(UInt32(1))
    }

    func predecessor() -> UInt256 {
        return self + UInt256(UInt32(1))
    }
}
