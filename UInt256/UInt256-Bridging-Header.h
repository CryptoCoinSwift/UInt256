//
//  UInt256-Bridging-Header.h
//  UInt256
//
//  Created by Sjors Provoost on 16-07-14.
//

// Takes two arrays which 8 UInt32's each. They are exposed more for testing purposes than speed.
void subtract(uint32_t result[], uint32_t lhs[], uint32_t rhs[]);

// Takes two arrays which 8 UInt32's each and returns the result as an array.
uint32_t *  divideWithOverflowC(uint32_t numerator[], uint32_t denominator[]);
uint32_t * modulusWithOverflowC(uint32_t numerator[], uint32_t denominator[]);

void montgomery(uint32_t x[], uint32_t y[],  uint32_t z[]);

