#!/usr/bin/env ruby
require 'benchmark'

def extended_gcd(a, b)
  last_remainder, remainder = a.abs, b.abs
  x, last_x, y, last_y = 0, 1, 1, 0
  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient*x, x
    y, last_y = last_y - quotient*y, y
  end
 
  return last_remainder, last_x * (a < 0 ? -1 : 1)
end
 
def invmod(e, et)
  g, x = extended_gcd(e, et)
  if g != 1
    raise 'Teh maths are broken!'
  end
  x % et
end

subtract =  Benchmark.measure { 1000000.times do; 489155902448849041265494486330585906971 - 340282366920938463463374607431768211297; end}.to_s
add =       Benchmark.measure { 1000000.times do; 489155902448849041265494486330585906971 + 340282366920938463463374607431768211297; end}.to_s
multiply =  Benchmark.measure { 1000000.times do; 340282366920938463463374607431768211455 * 340282366920938463463374607431768211455; end}.to_s
div =  Benchmark.measure { 1000000.times do; 115792089237316195423570985008687907852589419931798687112530834793049593217026 / 340282366920938463463374607431768211455; end}.to_s
mod =  Benchmark.measure { 1000000.times do; 115792089237316195423570985008687907852589419931798687112530834793049593217026 % 340282366920938463463374607431768211455; end}.to_s
multiply_big =  Benchmark.measure { 1000000.times do; 0x9b99279619237faf0c13c344614c46a9e7357341c6e4e042a9b1311a8622deaa * 0xe7f1caa636baa2779cfd6cf9696cf826f013db037aa08f3d5c2dfaf9db5d255b ; end}.to_s
mod_big =  Benchmark.measure { 1000000.times do; 0x8cfa291294cc8c2c827a9ef6977f6b691d24b810f085c437abd13f27942da0b5ede973cf7a14db610dfe857e382bc65071af459e27425f0c36b670510a55b86e % 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f; end}.to_s
mod_inverse = Benchmark.measure { 1000000.times do; invmod(0x2b80697edf28a916d822b9b89a8f770fb70d49f48b5c184f2f47f652db960baa, 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f); end}.to_s

puts "Numbers of seconds for 1 million iterations (first column = user CPU time):"
puts "Subtraction : #{ subtract.to_s }"
puts "Addition    : #{ subtract.to_s }"
puts "/           : #{ div.to_s }"
puts "*           : #{ multiply.to_s }"
puts "%           : #{ mod.to_s }"
puts "Big *       : #{ multiply_big.to_s }"
puts "Big %       : #{ mod_big.to_s }"
puts "Mod inverse : #{ mod_inverse.to_s }"