require import Extracted_ct.

equiv eq_jade_hash_sha3_512_amd64_ref_ct : 
  M.jade_hash_sha3_512_amd64_ref ~ M.jade_hash_sha3_512_amd64_ref :
    ={hash, input, input_length, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
