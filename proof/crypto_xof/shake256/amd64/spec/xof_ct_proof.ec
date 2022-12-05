require import Xof_ct.

equiv eq_jade_xof_shake256_amd64_spec_ct : 
  M.jade_xof_shake256_amd64_spec ~ M.jade_xof_shake256_amd64_spec :
    ={output, output_length, input, input_length, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
