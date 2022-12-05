require import Hash_ct.

equiv eq_jade_hash_sha3_224_amd64_avx2_ct : 
  M.jade_hash_sha3_224_amd64_avx2 ~ M.jade_hash_sha3_224_amd64_avx2 :
    ={hash, input, input_length, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
