require import Scalarmult_ct.

equiv jade_scalarmult_curve25519_amd64_mulx : 
  M.jade_scalarmult_curve25519_amd64_mulx ~ M.jade_scalarmult_curve25519_amd64_mulx :
    ={rp, kp, up, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

equiv jade_scalarmult_curve25519_amd64_mulx_base : 
  M.jade_scalarmult_curve25519_amd64_mulx_base ~ M.jade_scalarmult_curve25519_amd64_mulx_base :
    ={rp, kp, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.

