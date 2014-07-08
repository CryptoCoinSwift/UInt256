//
//  UInt256+BitwiseOperations.swift
//  UInt256
//
//  Created by Sjors Provoost on 06-07-14.
//

extension UInt256 : BitwiseOperations {
    var highestBit: Int {
    var bitLength: UInt32 = 256
        for int in self {
            if int == 0 { bitLength -= 32 } else {
                for var i: UInt32 = 31; i > 0; i-- {
                    if (2^^i) & int != 0 {  break;  } else {  bitLength--; }
                }
                break;
            }
        }
        
        return Int(bitLength)
    }
    
    static func singleBitAt (position: Int) -> (UInt256) {
        var result: UInt256 = self.allZeros
        let index: Int = position / 32
        let bit: Int = 31 - (position % 32)
        
        result[index] =  2^^UInt32(bit)
        
        return result
    }
    
    mutating func setBitAt(position: Int) -> () {
        self = (self & ~UInt256.singleBitAt(position)) | UInt256.singleBitAt(position)
    }
    
    mutating func unsetBitAt(position: Int) -> () {
        self = self & ~UInt256.singleBitAt(position)
    }
    
}

func &(lhs: UInt256, rhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros
    
    for i in 0..<8 {
        let and: UInt32 = lhs[i] & rhs[i]
        res[i] = and
    }
    
    return res
}

func |(lhs: UInt256, rhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros
    
    for i in 0..<8 {
        res[i] = lhs[i] | rhs[i]
    }
    
    return res
}

func ^(lhs: UInt256, rhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros
    
    for i in 0..<8 {
        res[i] = lhs[i] ^ rhs[i]
    }
    
    return res
}

@prefix func ~(lhs: UInt256) -> UInt256 {
    var res: UInt256 = UInt256.allZeros
    
    for i in 0..<8 {
        res[i] = ~lhs[i]
    }
    
    return res
}

func <<= (inout lhs: UInt256, rhs: Int) -> () {
    lhs = lhs << rhs
}



func << (lhs: UInt256, rhs: Int) -> UInt256 {
    switch rhs {
    case let x where x >= 256:
        return UInt256.allZeros
    case 255:
        if lhs & UInt256.singleBitAt(255) == 0 {
            return 0
        } else {
            return UInt256.singleBitAt(0)
        }
    case 128:
        return UInt256(lhs[4],lhs[5],lhs[6], lhs[7], 0,0,0, 0)
    case 64:
        return UInt256(lhs[2],lhs[3], lhs[4],lhs[5],lhs[6], lhs[7],0, 0)
    case 32:
        return UInt256(lhs[1],lhs[2],lhs[3], lhs[4],lhs[5],lhs[6], lhs[7], 0)
    case let x where x < 32:
        return UInt256(
            (lhs[0] << UInt32(x)) + (lhs[1] >> UInt32(32-x)),
            (lhs[1] << UInt32(x)) + (lhs[2] >> UInt32(32-x)),
            (lhs[2] << UInt32(x)) + (lhs[3] >> UInt32(32-x)),
            (lhs[3] << UInt32(x)) + (lhs[4] >> UInt32(32-x)),
            (lhs[4] << UInt32(x)) + (lhs[5] >> UInt32(32-x)),
            (lhs[5] << UInt32(x)) + (lhs[6] >> UInt32(32-x)),
            (lhs[6] << UInt32(x)) + (lhs[7] >> UInt32(32-x)),
            (lhs[7] << UInt32(x))
        )
    default:
        var result = lhs
        
        for _ in 0..<rhs {
            var overflow = false
            for var i=7; i >= 0; i-- {
                let leftMostBit: UInt32 = 0b1000_0000_0000_0000_0000_0000_0000_0000
                
                let willOverflow = result[i] & leftMostBit != 0
                
                result[i] = lhs[i] << 1
                
                if(overflow) {
                    result[i] = result[i] + 1
                }
                
                overflow = willOverflow
            }
        }
        
        return result
    }
}

func >> (lhs: UInt256, rhs: Int) -> UInt256 {
    if rhs >= 256 {
        return UInt256.allZeros
    }
    
    if rhs == 255 {
        if lhs & UInt256.singleBitAt(0) == 0 {
            return 0
        } else {
            return UInt256.singleBitAt(255)
        }
    }
    
    if rhs == 128 {
        return UInt256(0,0,0,0, lhs[0],lhs[1],lhs[2], lhs[3])
    }
    
    var result = lhs
    
    for _ in 0..<rhs {
        var overflow = false
        for i in 0..<8 {
            
            let rightMostBit: UInt32 = 0b0000_0000_0000_0000_0000_0000_0000_0001
            let  leftMostBit: UInt32 = 0b1000_0000_0000_0000_0000_0000_0000_0000
            
            
            let willOverflow = result[i] & rightMostBit != 0
            
            result[i] = lhs[i] >> 1
            
            
            if(overflow) {
                result[i] += leftMostBit
            }
            
            overflow = willOverflow
        }
    }
    
    return result
}

func >>= (inout lhs: UInt256, rhs: Int) -> () {
    lhs = lhs >> rhs
}