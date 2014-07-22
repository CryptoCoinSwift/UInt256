//
//  UInt256Mac.h
//  UInt256Mac
//
//  Created by Sjors Provoost on 05-07-14.
//  Copyright (c) 2014 Crypto Coin Swift. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for UInt256Mac.
FOUNDATION_EXPORT double UInt256MacVersionNumber;

//! Project version string for UInt256Mac.
FOUNDATION_EXPORT const unsigned char UInt256MacVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <UInt256Mac/PublicHeader.h>

// Takes two arrays which 8 UInt32's each. They are exposed more for testing purposes than speed.
void subtract(uint32_t result[], uint32_t lhs[], uint32_t rhs[]);

// Takes two arrays which 8 UInt32's each and returns the result as an array.
uint32_t *  divideWithOverflowC(uint32_t numerator[], uint32_t denominator[]);
uint32_t * remainderWithOverflowC(uint32_t numerator[], uint32_t denominator[]);

void montgomery(uint32_t x[], uint32_t y[],  uint32_t z[]);
