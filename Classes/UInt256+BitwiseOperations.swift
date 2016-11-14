//
//  UInt256+BitwiseOperations.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

extension UInt256: BitwiseOperations {
    var highestBit: Int {
        var bitLength: UInt32 = 256
        for int in self {
            if int == 0 { bitLength -= 32 } else {
                for i: UInt32 in ((0 + 1) ... 31).reversed() {
                    if (2 ^^ i) & int != 0 { break } else { bitLength -= 1 }
                }
                break
            }
        }

        return Int(bitLength)
    }

    static func singleBitAt(_ position: Int) -> (UInt256) {
        switch position {
        case 0:
            return UInt256(2147483648, 0, 0, 0, 0, 0, 0, 0)
        case 255:
            return UInt256(0, 0, 0, 0, 0, 0, 0, 1)
        default:
            var result: UInt256 = self.allZeros
            let index: Int = position / 32
            let bit: Int = 31 - (position % 32)

            result[index] = 2 ^^ UInt32(bit)

            return result
        }
    }

    public mutating func setBitAt(_ position: Int) -> () {
        self = (self & ~UInt256.singleBitAt(position)) | UInt256.singleBitAt(position)
    }

    mutating func unsetBitAt(_ position: Int) -> () {
        self = self & ~UInt256.singleBitAt(position)
    }
}

public func &(lhs: UInt256, rhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros

    for i in 0 ..< 8 {
        let and: UInt32 = lhs[i] & rhs[i]
        res[i] = and
    }

    return res
}

public func |(lhs: UInt256, rhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros

    for i in 0 ..< 8 {
        res[i] = lhs[i] | rhs[i]
    }

    return res
}

public func ^(lhs: UInt256, rhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros

    for i in 0 ..< 8 {
        res[i] = lhs[i] ^ rhs[i]
    }

    return res
}

public prefix func ~(lhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros

    for i in 0 ..< 8 {
        res[i] = ~lhs[i]
    }

    return res
}

public func <<= (lhs: inout UInt256, rhs: Int) -> () {
    lhs = lhs << rhs
}

public func << (lhs: UInt256, rhs: Int) -> UInt256 {
    switch rhs {
    case let x where x >= 256:
        return UInt256.allZeros
    case 255:
        return UInt256(0, 0, 0, 0, 0, 0, 0, lhs[7] & 1)
    case 128:
        return UInt256(lhs[4], lhs[5], lhs[6], lhs[7], 0, 0, 0, 0)
    case 64:
        return UInt256(lhs[2], lhs[3], lhs[4], lhs[5], lhs[6], lhs[7], 0, 0)
    case 32:
        return UInt256(lhs[1], lhs[2], lhs[3], lhs[4], lhs[5], lhs[6], lhs[7], 0)
    case let x where x < 32:
        return UInt256(
            (lhs[0] << UInt32(x)) + (lhs[1] >> UInt32(32 - x)),
            (lhs[1] << UInt32(x)) + (lhs[2] >> UInt32(32 - x)),
            (lhs[2] << UInt32(x)) + (lhs[3] >> UInt32(32 - x)),
            (lhs[3] << UInt32(x)) + (lhs[4] >> UInt32(32 - x)),
            (lhs[4] << UInt32(x)) + (lhs[5] >> UInt32(32 - x)),
            (lhs[5] << UInt32(x)) + (lhs[6] >> UInt32(32 - x)),
            (lhs[6] << UInt32(x)) + (lhs[7] >> UInt32(32 - x)),
            (lhs[7] << UInt32(x))
        )
    default:
        var result = lhs

        for _ in 0 ..< rhs {
            var overflow = false
            for i in (0 ... 7).reversed() {
                let leftMostBit: UInt32 = 0b1000_0000_0000_0000_0000_0000_0000_0000

                let willOverflow = result[i] & leftMostBit != 0

                result[i] = lhs[i] << 1

                if (overflow) {
                    result[i] = result[i] + 1
                }

                overflow = willOverflow
            }
        }

        return result
    }
}

public func >> (lhs: UInt256, rhs: Int) -> UInt256 {
    switch rhs {
    case let x where x >= 256:
        return UInt256.allZeros
    case 255:
        return UInt256(lhs[7] & 2147483648, 0, 0, 0, 0, 0, 0, 0)
    case 128:
        return UInt256(0, 0, 0, 0, lhs[0], lhs[1], lhs[2], lhs[3])
    case 64:
        return UInt256(0, 0, lhs[0], lhs[1], lhs[2], lhs[3], lhs[4], lhs[5])
    case 32:
        return UInt256(0, lhs[0], lhs[1], lhs[2], lhs[3], lhs[4], lhs[5], lhs[6])
    case let x where x < 32:
        return UInt256(
            (lhs[0] >> UInt32(x)),
            (lhs[1] >> UInt32(x)) + (lhs[0] << UInt32(32 - x)),
            (lhs[2] >> UInt32(x)) + (lhs[1] << UInt32(32 - x)),
            (lhs[3] >> UInt32(x)) + (lhs[2] << UInt32(32 - x)),
            (lhs[4] >> UInt32(x)) + (lhs[3] << UInt32(32 - x)),
            (lhs[5] >> UInt32(x)) + (lhs[4] << UInt32(32 - x)),
            (lhs[6] >> UInt32(x)) + (lhs[5] << UInt32(32 - x)),
            (lhs[7] >> UInt32(x)) + (lhs[6] << UInt32(32 - x))
        )
    default:
        var result = lhs

        for _ in 0 ..< rhs {
            var overflow = false
            for i in 0 ..< 8 {
                let rightMostBit: UInt32 = 0b0000_0000_0000_0000_0000_0000_0000_0001

                let willOverflow = result[i] & rightMostBit != 0
                
                result[i] = lhs[i] >> 1
                
                if (overflow) {
                    result[i] = result[i] + 0b1000_0000_0000_0000_0000_0000_0000_0000
                }
                
                overflow = willOverflow
            }
        }
        
        return result
    }
}

public func >>= (lhs: inout UInt256, rhs: Int) -> () {
    lhs = lhs >> rhs
}
