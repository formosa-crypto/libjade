require import Xof_ct.

equiv eq_jade_xof_shake256_amd64_ref1_ct : 
  M.jade_xof_shake256_amd64_ref1 ~ M.jade_xof_shake256_amd64_ref1 :
    ={output, output_length, input, input_length, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
