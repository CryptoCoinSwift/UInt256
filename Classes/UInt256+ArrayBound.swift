//
//  UInt256+Arraybound.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

// Preliminary implementation to conform to UnsignedInteger. Unused and untested.

extension UInt256 : ArrayBound {
    typealias ArrayBoundType = UInt256
    
    
    func getArrayBoundValue() -> UInt256 {
        return self
    }
}