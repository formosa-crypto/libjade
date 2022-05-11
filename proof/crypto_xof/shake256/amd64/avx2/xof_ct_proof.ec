require import Xof_ct.

equiv eq_jade_xof_shake256_amd64_avx2_ct : 
  M.jade_xof_shake256_amd64_avx2 ~ M.jade_xof_shake256_amd64_avx2 :
    ={out, outlen, in_0, inlen, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
