//
//  UInt256Store.swift
//  Crypto Coin Swift
//
//  Created by Sjors Provoost on 30-06-14.
//
//  Pending fixed size arrays in Swift which don't behave w̶e̶i̶r̶d̶ optimized when
//  they get copied around with the struct they're in.

struct UInt256Store : Sequence {
    // Todo: use 4 parts on a 64 bit system
    
    var part0: UInt32 // Most significant
    var part1: UInt32
    var part2: UInt32
    var part3: UInt32
    var part4: UInt32
    var part5: UInt32
    var part6: UInt32
    var part7: UInt32

    subscript(index: Int) -> UInt32 {
        get {
            switch index {
            case 0:
                return part0
            case 1:
                return part1
            case 2:
                return part2
            case 3:
                return part3
            case 4:
                return part4
            case 5:
                return part5
            case 6:
                return part6
            case 7:
                return part7
            default:
                assert(false, "Invalid index");
                return 0
            }
            
        }
        
        mutating set(newValue) {
            switch index {
            case 0:
                part0 = newValue
            case 1:
                part1 = newValue
            case 2:
                part2 = newValue
            case 3:
                part3 = newValue
            case 4:
                part4 = newValue
            case 5:
                part5 = newValue
            case 6:
                part6 = newValue
            case 7:
                part7 = newValue
            default:
                assert(false, "Invalid index");
                
            }
        }
    }
    
    init(array: UInt32[]) {
        assert(countElements(array) == 8, "8 items required")
 
        part0 = array[0]
        part1 = array[1]
        part2 = array[2]
        part3 = array[3]
        part4 = array[4]
        part5 = array[5]
        part6 = array[6]
        part7 = array[7]

    }
    
    var array: UInt32[] {
        return [part0, part1, part2, part3, part4, part5, part6, part7]
    }
    
}

extension UInt256Store : Sequence {
    func generate() -> IndexingGenerator<UInt32[]> {
        return [part0, part1, part2, part3, part4, part5, part6, part7].generate()
    }
}

func == (lhs: UInt256Store, rhs: UInt256Store) -> Bool {
    return lhs.part0 == rhs.part0 && lhs.part1 == rhs.part1 && lhs.part2 == rhs.part2 && lhs.part3 == rhs.part3 && lhs.part4 == rhs.part4 && lhs.part5 == rhs.part5 && lhs.part6 == rhs.part6  && lhs.part7 == rhs.part7
    
}


