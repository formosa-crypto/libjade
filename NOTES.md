# Research Retreat 2021 Notes


**What do we want?** A formally verified cryptography library that can be used by real-world applications.

**What did we discuss?**

* **What cryptographic primitives should it provide?**
  For most cases, what is needed in real applications is algorithms that integrate into TLS and those used for data encryption at rest. These include:
  * Post-quantum KEMs
  * Post-quantum Signatures
  * Hashes
  * MAC
  * Block/Stream ciphers
  * HKDF (*)

* **In what format should code be shipped (assembly (GAS or MASM), jasmin)?**
  We will start by focusing on Jasmin and GAS. There could be applications that need MASM, but they seem to be smaller.
   
  [TODO]: figure out how much MASM is used in practice.

* **What kind of API should we use?**
  We should follow what libsodium does. And it should include testing.
  
  [TODO]: Create an extensive documentation for the API.
 
* **How should proofs be connected to code?**
  They should be easily replicated in the recent versions, and anyone should quickly run them locally. There should also be a public statement where the passing of the proofs is stated. Proofs should run, as much as possible, over the CI. We also want a human-readable explanation of the proofs (it could be in the form of comments): it should state that the specification is what is implemented. Proofs should be abstract enough so they can be reused by different algorithms (for example, an IND-CPA proof can be reused by instantiations of algorithms).

* **What calling languages should be supported?**
C, Rust and Golang. But they should easily wrapped to another language. 

[TODO]: how costly is this warpping?

* **What should CI for such a library look like?**
It should execute the proofs. We want cross-CI: execute the CI of other projects to see that all builds correctly. Potentially, it should have benchmarking. 

[TODO]:

* How are we going to handle calling conventions?
* How will be handling releases?
* How will be handling contributions?
* How often will be updating EasyCrypt and Jasmin libraries?
* Which architecture should it support?
* Should we use hacspec?
