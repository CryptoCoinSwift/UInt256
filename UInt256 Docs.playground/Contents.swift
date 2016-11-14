//// To use this Playground select UInt256Mac - My Mac as the target and build.
//import UInt256
//
//// You can initialize using a decimal or hexadecimal string:
//let a = UInt256(decimalStringValue: "10000000000000000001234")
//a.description
//UInt256(hexStringValue: "A").description
//
//// It's faster when you initialize it using 8 32-bit integers:
//UInt256(1,0,0,0,0,0,0,2).toHexString
//
//// You can compare them:
//a > 5
//
//// Addition, multiplication, division, modulus:
//(a + a).description
//
//(a * a).description
//
//(a / 2).description
//
//(a % 5).description
//
//// Multiply two large 256-bit numbers in a 512-bit number represented as a tuple:
//let (lhs, rhs) = UInt256(1,0,0,0,0,0,0,2) * UInt256(1,0,0,0,0,0,0,2)
//lhs.toHexString + rhs.toHexString
//
//// Get the modulo of a 512-bit number::
//let p = UInt256(0xffffffff, 0xffffffff, 0xffffffff,0xffffffff, 0xffffffff,0xffffffff, 0xfffffffe,0xfffffc2f)
//
//var (left, right) = (UInt256(0x8cfa2912, 0x94cc8c2c, 0x827a9ef6, 0x977f6b69, 0x1d24b810, 0xf085c437, 0xabd13f27, 0x942da0b5), UInt256(0xede973cf, 0x7a14db61, 0x0dfe857e, 0x382bc650, 0x71af459e, 0x27425f0c, 0x36b67051, 0x0a55b86e))
//
//
//((left, right) % p).toHexString
//
//// You can also perform bitwise operations:
//let b = UInt256(1)
//(b << 5).description
//(~b).toHexString
