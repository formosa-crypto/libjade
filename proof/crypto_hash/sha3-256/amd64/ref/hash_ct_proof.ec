require import Hash_ct.

equiv eq_jade_hash_sha3_256_amd64_ref_ct : 
  M.jade_hash_sha3_256_amd64_ref ~ M.jade_hash_sha3_256_amd64_ref :
    ={out, in_0, inlen, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
