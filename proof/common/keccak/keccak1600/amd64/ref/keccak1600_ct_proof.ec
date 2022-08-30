require import Keccak1600_ct.

equiv eq__keccak1600_ref_ct : 
  M._keccak1600_ref ~ M._keccak1600_ref :
    ={out, outlen, in_0, inlen, trail_byte, rate, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
