require import Keccak1600_ct.

equiv eq__keccak1600_avx2_ct : 
  M._keccak1600_avx2 ~ M._keccak1600_avx2 :
    ={out, outlen, in_0, inlen, trail_byte, rate, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
