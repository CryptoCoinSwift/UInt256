//
//  UInt256+IntegerArithmetic.c
//  UInt256
//
//  Created by Sjors Provoost on 16-07-14.
//

//  C implementations for those functions that are too slow in their current
//  Swift form.

#include <stdio.h>
#include <stdbool.h>

void singleBitArray(uint32_t result[]) {
    result[31] = 1;
    for (int i=30; i>=0; i--) {
        result[i] =  result[i+1] << 1;
    }
}

void leftShiftByOne(uint32_t result[], uint32_t lhs[]) {
    uint32_t singleDigit[32];
    singleBitArray(singleDigit);
    
    bool didOverflow = false;
    for (int i=7; i >= 0; i--) {
        bool willOverflow = lhs[i] & singleDigit[0];
        
        result[i] = lhs[i] << 1;
        
        if (didOverflow) {
            result[i]++;
        }
        
        didOverflow = willOverflow;
    }
    
}

void rightShiftBy255(uint32_t result[], uint32_t lhs[]) {
   for (int i=0; i < 7; i++) {
       result[i] = 0;
   }
    
    result[7] = lhs[0] >> 31;
}

void or(uint32_t result[], uint32_t lhs[], uint32_t rhs[]) {
    for (int i=0; i < 8; i++) {
        result[i] = lhs[i] | rhs[i];
    }
}

void subtract(uint32_t result[], uint32_t lhs[], uint32_t rhs[]) {
    int i;
    uint32_t tempResult[8];
    
    uint32_t  overflow = 0;
    for (i=7; i >= 0; i--) {
        bool willOverflow = (overflow == 1 && rhs[i] == ~0) || lhs[i] < rhs[i] + overflow;
        
        tempResult[i] = lhs[i] -  rhs[i] - overflow;
        
        if (willOverflow) {
            overflow = 1;
        } else {
            overflow = 0;
        }
    }
    
    for(i=0; i < 8; i++) {
        result[i] = tempResult[i];
    }
}

void addOne(uint32_t lhs[]) {
    bool overflow = false;
    
    for (int i = 7; i >= 0; i--) {
        lhs[i]++;
        overflow = lhs[i] == 0;
        if (!overflow) { break; }
    }
}

bool gte(uint32_t lhs[], uint32_t rhs[]) {
    bool result = false;
    
    for (int i=0; i < 8; i++) {
        if (lhs[i] > rhs[i]) {
            result = true;
            break;
        } else if (lhs[i] == rhs[i]) {
            if (i==7) {
                result = true;
            }
        } else {
            break;
        }
    }
    
    return result;
}

void divideWithModulus(uint32_t numerator[], uint32_t denominator[],  uint32_t quotient[], uint32_t remainder[]) {
    int word;
    int bit;
    int i;
    uint32_t singleDigit[32];
    singleBitArray(singleDigit);
    
    // remainder = 0
    for (i=0; i<8; i++) {
        remainder[i] = 0;
    }
    
    // quotient = 0
    for (i=0; i<8; i++) {
        quotient[i] = 0;
    }
    
    
    for (word = 0; word < 8; word++) {
        for(bit = 0; bit < 32; bit++) {
            // remainder <<= 1
            leftShiftByOne(remainder, remainder);
            
            if (numerator[word] & singleDigit[bit]) {
                remainder[7] = remainder[7] | singleDigit[31]; // setBitAt(255)
            } else {
                remainder[7] = remainder[7] & ~singleDigit[31]; // unsetBitAt(255)
            }
            
            if (gte(remainder, denominator)) {
                subtract(remainder, remainder, denominator);
                
                // quotient = quotient | UInt256.singleBitAt(255 - i)
                quotient[word] |= singleDigit[bit];
            }
        }
    }
}

uint32_t * divideWithOverflowC(uint32_t numerator[], uint32_t denominator[]) {
    static uint32_t theRemainder[8];
    static uint32_t theQuotient[8];

    
    divideWithModulus(numerator, denominator, theQuotient, theRemainder);
    
    return theQuotient;
    
}

uint32_t * remainderWithOverflowC(uint32_t numerator[], uint32_t denominator[]) {
    static uint32_t theRemainder[8];
    static uint32_t theQuotient[8];
    
    divideWithModulus(numerator, denominator, theQuotient, theRemainder);
    
    return theRemainder;
    
}

void montgomery(uint32_t x[], uint32_t y[],  uint32_t z[]) {
    uint32_t t[8];
    int i, bit, word;
    
    for (word = 0; word<8; word++) {
        for (bit = 0; bit<32; bit++) {

        // if UInt256.singleBitAt(0) & x == 0 {
        if(x[0] >> 31) {
            for (i=0; i<8; i++) {
                t[i] = 4294967295; // UInt32.max
            }
        } else {
            for (i=0; i<8; i++) {
                t[i] = 0;
            }
        }
            
        // x = (x << 1) | (y >> 255)
        uint32_t lhs[8];
        leftShiftByOne(lhs, x);
        uint32_t rhs[8];
        rightShiftBy255(rhs, y);
        or(x,lhs,rhs);

        // y = y << 1
        leftShiftByOne(y, y);
            
        //    if((x | t) >= z) {
        uint32_t x_or_t[8];
        or(x_or_t, x, t);
        if(gte(x_or_t, z)) {
            //        x = x &- z
            subtract(x, x, z);
            
            //        y++
            addOne(y);
        }
            

        //    }
        }
    }
}

void multiply(uint32_t lhs[], uint32_t rhs[],  uint32_t res[]) {
    // Assuming lhs and rhs are 2 words, res is 4 words. To be expanded later.
    uint64_t x0 = lhs[1]; // 32 bit max
    uint64_t x1 = lhs[0]; // 32 bit max
    uint64_t y0 = rhs[1]; // 32 bit max
    uint64_t y1 = rhs[0]; // 32 bit max
    
    uint64_t z0 = x0 * y0; // 64 bit max
    uint64_t z2 = x1 * y1; // 64 bit max

    uint64_t x1_plus_x0 = x1 + x0; // 33 bit max
    uint64_t y1_plus_y0 = y1 + y0; // 33 bit max
    
    
    res[0] = z2 >> 32;
    res[1] = z2 & 0xffffffff;
    res[2] = z0 >> 32;
    res[3] = z0 & 0xffffffff;

    uint32_t overflow = 0;
    uint64_t z1;
    
    // if x1_plus_x0 and y1_plus_y0 are 32 bits or less each
    if(((x1_plus_x0 >> 32) | (y1_plus_y0 >> 32)) == 0 ) {
        z1 = x1_plus_x0 * y1_plus_y0 - z2 - z0;
    } else {


        // Use recursion to find overflow value
        uint32_t lhsR[2]; // 33 bit max
        uint32_t rhsR[2]; // 33 bit max
        uint32_t z1_precursor[4];   // 66 bit max, so z1[0] = 0
        
        lhsR[0] = x1_plus_x0 >> 32;
        lhsR[1] = x1_plus_x0 & 0xffffffff;

        rhsR[0] = y1_plus_y0 >> 32;
        rhsR[1] = y1_plus_y0 & 0xffffffff;
        
        multiply(lhsR, rhsR, z1_precursor);
        
        uint64_t z1_precursor_lhs = z1_precursor[2];
        uint64_t z1_precursor_rhs = z1_precursor[3];

        uint64_t z1_precursor_64 = (z1_precursor_lhs << 32)  + z1_precursor_rhs; // Ignoring overflow
        
        overflow = z1_precursor[1];
        
        if(z1_precursor_64 < z2) {
            overflow--;
        }
        
        z1_precursor_64 -= z2;
        
        if(z1_precursor_64 < z0) {
            overflow--;
        }
        
        z1 = z1_precursor_64 - z0;
                
    }
    
    uint32_t before = res[2];
    res[2]+= z1 & 0xffffffff;
    if (res[2] < before) {
        res[1]++;
        if (res[1]==0) {
            res[0]++; // This will never overflow. No test reaches this code.
        }
    }
    
    before = res[1];
    res[1]+= z1 >> 32;
    if (res[1] < before) {
        res[0]++; // This will never overflow
    }
    
    res[0]+= overflow;

}
