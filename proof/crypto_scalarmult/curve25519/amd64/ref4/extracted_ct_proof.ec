require import Extracted_ct.

equiv jade_scalarmult_curve25519_amd64_ref4 : 
  M.jade_scalarmult_curve25519_amd64_ref4 ~ M.jade_scalarmult_curve25519_amd64_ref4 :
    ={qp, np, pp, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

equiv jade_scalarmult_curve25519_amd64_ref4_base : 
  M.jade_scalarmult_curve25519_amd64_ref4_base ~ M.jade_scalarmult_curve25519_amd64_ref4_base :
    ={qp, np, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

