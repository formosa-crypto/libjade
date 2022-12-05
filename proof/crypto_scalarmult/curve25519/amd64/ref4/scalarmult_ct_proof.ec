require import Scalarmult_ct.

equiv jade_scalarmult_curve25519_amd64_ref4 : 
  M.jade_scalarmult_curve25519_amd64_ref4 ~ M.jade_scalarmult_curve25519_amd64_ref4 :
    ={q, n, p, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

equiv jade_scalarmult_curve25519_amd64_ref4_base : 
  M.jade_scalarmult_curve25519_amd64_ref4_base ~ M.jade_scalarmult_curve25519_amd64_ref4_base :
    ={q, n, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

