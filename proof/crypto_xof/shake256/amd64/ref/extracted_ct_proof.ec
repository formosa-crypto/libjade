require import Extracted_ct.

equiv eq_jade_xof_shake256_amd64_ref_ct : 
  M.jade_xof_shake256_amd64_ref ~ M.jade_xof_shake256_amd64_ref :
    ={output, output_length, input, input_length, M.leakages} ==> ={M.leakages}.
proof.
proc; inline *; sim => />.
qed.
