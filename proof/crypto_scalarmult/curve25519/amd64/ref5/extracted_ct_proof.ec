require import Extracted_ct.

equiv jade_scalarmult_curve25519_amd64_ref5 : 
  M.jade_scalarmult_curve25519_amd64_ref5 ~ M.jade_scalarmult_curve25519_amd64_ref5 :
    ={q, n, p, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

equiv jade_scalarmult_curve25519_amd64_ref5_base : 
  M.jade_scalarmult_curve25519_amd64_ref5_base ~ M.jade_scalarmult_curve25519_amd64_ref5_base :
    ={q, n, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

