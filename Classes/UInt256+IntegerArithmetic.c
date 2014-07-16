//
//  UInt256+IntegerArithmetic.c
//  UInt256
//
//  Created by Sjors Provoost on 16-07-14.
//

//  C implementations for those functions that are too slow in their current
//  Swift form.

#include <stdio.h>
#include "UInt256-Bridging-Header.h"
#include <stdbool.h>

uint32_t * modulusWithOverflowC(uint32_t numerator[], uint32_t denominator[]) {
    static uint32_t remainder[8];
    int i;
    int word;
    int bit;
    uint32_t singleDigit[32];
    
    // remainder = 0
    for (i=0; i<8; i++) {
        remainder[i] = 0;
    }
    
    singleDigit[31] = 1;
    for (i=30; i>=0; i--) {
        singleDigit[i] =  singleDigit[i+1] << 1;
    }
    
    for (word = 0; word < 8; word++) {
        for(bit = 0; bit < 32; bit++) {
            // remainder <<= 1
            bool didOverflow = false;
            for (i=7; i >= 0; i--) {
                bool willOverflow = (remainder[i] & singleDigit[0]) == singleDigit[0];
                
                remainder[i] <<= 1;
                
                if (didOverflow) {
                    remainder[i]++;
                }
                
                didOverflow = willOverflow;
            }
            
            if (numerator[word] & singleDigit[bit]) {
                remainder[7] = remainder[7] | singleDigit[31]; // setBitAt(255)
            } else {
                remainder[7] = remainder[7] & ~singleDigit[31]; // unsetBitAt(255)
            }
            
            // if remainder >= denominator
            bool rgtd = false;
            
            for (i=0; i < 8; i++) {
                if (remainder[i] > denominator[i]) {
                    rgtd = true;
                    break;
                } else if (remainder[i] == denominator[i]) {
                    if (i==7) {
                        rgtd = true;
                    }
                } else {
                    break;
                }
            }
            
            if (rgtd) {
                // remainder = remainder - denominator
                uint32_t  overflow = 0;
                for (i=7; i >= 0; i--) {
                    bool willOverflow = (overflow == 1 && denominator[i] == ~0) || remainder[i] < denominator[i] + overflow;
                    
                    remainder[i] = remainder[i] -  denominator[i] - overflow;
                    
                    if (willOverflow) {
                        overflow = 1;
                    } else {
                        overflow = 0;
                    }
                }

                // To be implemented later:
                // quotient = quotient | UInt256.singleBitAt(255 - i)
            }

        
        }
    }

    return remainder;
}