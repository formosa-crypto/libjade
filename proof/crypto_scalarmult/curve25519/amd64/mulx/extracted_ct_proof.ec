require import Extracted_ct.

equiv jade_scalarmult_curve25519_amd64_mulx : 
  M.jade_scalarmult_curve25519_amd64_mulx ~ M.jade_scalarmult_curve25519_amd64_mulx :
    ={q, n, p, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

equiv jade_scalarmult_curve25519_amd64_mulx_base : 
  M.jade_scalarmult_curve25519_amd64_mulx_base ~ M.jade_scalarmult_curve25519_amd64_mulx_base :
    ={q, n, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

