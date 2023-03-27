	.att_syntax
	.text
	.p2align	5
	.globl	_jade_aead_chacha20poly1305_amd64_avx_open
	.globl	jade_aead_chacha20poly1305_amd64_avx_open
	.globl	_jade_aead_chacha20poly1305_amd64_avx
	.globl	jade_aead_chacha20poly1305_amd64_avx
_jade_aead_chacha20poly1305_amd64_avx_open:
jade_aead_chacha20poly1305_amd64_avx_open:
	movq	%rsp, %rax
	leaq	-712(%rsp), %rsp
	andq	$-16, %rsp
	movq	%rax, 704(%rsp)
	movq	%rbx, 656(%rsp)
	movq	%rbp, 664(%rsp)
	movq	%r12, 672(%rsp)
	movq	%r13, 680(%rsp)
	movq	%r14, 688(%rsp)
	movq	%r15, 696(%rsp)
	movq	%rsi, %r10
	addq	%rdx, %r10
	movq	$-1, %rax
	cmpq	$16, %rcx
	jb  	Ljade_aead_chacha20poly1305_amd64_avx_open$1
	movq	%rdi, 544(%rsp)
	movq	%rsi, 552(%rsp)
	movq	%rdx, 560(%rsp)
	movq	%r10, 568(%rsp)
	leaq	16(%r10), %rax
	movq	%rax, 576(%rsp)
	leaq	-16(%rcx), %rax
	movq	%rax, 584(%rsp)
	movq	%r8, 592(%rsp)
	movq	%r9, 600(%rsp)
	xorl	%eax, %eax
	movl	$1634760805, 32(%rsp)
	movl	$857760878, 36(%rsp)
	movl	$2036477234, 40(%rsp)
	movl	$1797285236, 44(%rsp)
	movl	(%r9), %ecx
	movl	%ecx, 48(%rsp)
	movl	4(%r9), %ecx
	movl	%ecx, 52(%rsp)
	movl	8(%r9), %ecx
	movl	%ecx, 56(%rsp)
	movl	12(%r9), %ecx
	movl	%ecx, 60(%rsp)
	movl	16(%r9), %ecx
	movl	%ecx, 64(%rsp)
	movl	20(%r9), %ecx
	movl	%ecx, 68(%rsp)
	movl	24(%r9), %ecx
	movl	%ecx, 72(%rsp)
	movl	28(%r9), %ecx
	movl	%ecx, 76(%rsp)
	movl	%eax, 80(%rsp)
	movl	(%r8), %eax
	movl	%eax, 84(%rsp)
	movl	4(%r8), %eax
	movl	%eax, 88(%rsp)
	movl	8(%r8), %eax
	movl	%eax, 92(%rsp)
	movl	92(%rsp), %eax
	movl	%eax, 640(%rsp)
	movl	32(%rsp), %eax
	movl	36(%rsp), %ecx
	movl	40(%rsp), %edx
	movl	44(%rsp), %esi
	movl	48(%rsp), %edi
	movl	52(%rsp), %r8d
	movl	56(%rsp), %r9d
	movl	60(%rsp), %r10d
	movl	64(%rsp), %r11d
	movl	68(%rsp), %ebx
	movl	72(%rsp), %ebp
	movl	76(%rsp), %r12d
	movl	80(%rsp), %r13d
	movl	84(%rsp), %r14d
	movl	88(%rsp), %r15d
	movl	%r15d, 644(%rsp)
	movl	$10, %r15d
Ljade_aead_chacha20poly1305_amd64_avx_open$20:
	movl	%r15d, 648(%rsp)
	movl	644(%rsp), %r15d
	addl	%edi, %eax
	addl	%r9d, %edx
	xorl	%eax, %r13d
	xorl	%edx, %r15d
	roll	$16, %r13d
	roll	$16, %r15d
	addl	%r13d, %r11d
	addl	%r15d, %ebp
	xorl	%r11d, %edi
	xorl	%ebp, %r9d
	roll	$12, %edi
	roll	$12, %r9d
	addl	%edi, %eax
	addl	%r9d, %edx
	xorl	%eax, %r13d
	xorl	%edx, %r15d
	roll	$8, %r13d
	roll	$8, %r15d
	addl	%r13d, %r11d
	addl	%r15d, %ebp
	xorl	%r11d, %edi
	xorl	%ebp, %r9d
	roll	$7, %edi
	roll	$7, %r9d
	movl	%r15d, 652(%rsp)
	movl	640(%rsp), %r15d
	addl	%r8d, %ecx
	addl	%r10d, %esi
	xorl	%ecx, %r14d
	xorl	%esi, %r15d
	roll	$16, %r14d
	roll	$16, %r15d
	addl	%r14d, %ebx
	addl	%r15d, %r12d
	xorl	%ebx, %r8d
	xorl	%r12d, %r10d
	roll	$12, %r8d
	roll	$12, %r10d
	addl	%r8d, %ecx
	addl	%r10d, %esi
	xorl	%ecx, %r14d
	xorl	%esi, %r15d
	roll	$8, %r14d
	roll	$8, %r15d
	addl	%r14d, %ebx
	addl	%r15d, %r12d
	xorl	%ebx, %r8d
	xorl	%r12d, %r10d
	roll	$7, %r8d
	roll	$7, %r10d
	addl	%r9d, %ecx
	addl	%r8d, %eax
	xorl	%ecx, %r13d
	xorl	%eax, %r15d
	roll	$16, %r13d
	roll	$16, %r15d
	addl	%r13d, %r12d
	addl	%r15d, %ebp
	xorl	%r12d, %r9d
	xorl	%ebp, %r8d
	roll	$12, %r9d
	roll	$12, %r8d
	addl	%r9d, %ecx
	addl	%r8d, %eax
	xorl	%ecx, %r13d
	xorl	%eax, %r15d
	roll	$8, %r13d
	roll	$8, %r15d
	addl	%r13d, %r12d
	addl	%r15d, %ebp
	xorl	%r12d, %r9d
	xorl	%ebp, %r8d
	roll	$7, %r9d
	roll	$7, %r8d
	movl	%r15d, 640(%rsp)
	movl	652(%rsp), %r15d
	addl	%r10d, %edx
	addl	%edi, %esi
	xorl	%edx, %r14d
	xorl	%esi, %r15d
	roll	$16, %r14d
	roll	$16, %r15d
	addl	%r14d, %r11d
	addl	%r15d, %ebx
	xorl	%r11d, %r10d
	xorl	%ebx, %edi
	roll	$12, %r10d
	roll	$12, %edi
	addl	%r10d, %edx
	addl	%edi, %esi
	xorl	%edx, %r14d
	xorl	%esi, %r15d
	roll	$8, %r14d
	roll	$8, %r15d
	addl	%r14d, %r11d
	addl	%r15d, %ebx
	xorl	%r11d, %r10d
	xorl	%ebx, %edi
	roll	$7, %r10d
	roll	$7, %edi
	movl	%r15d, 644(%rsp)
	movl	648(%rsp), %r15d
	decl	%r15d
	cmpl	$0, %r15d
	jnbe	Ljade_aead_chacha20poly1305_amd64_avx_open$20
	addl	32(%rsp), %eax
	addl	36(%rsp), %ecx
	addl	40(%rsp), %edx
	addl	44(%rsp), %esi
	addl	48(%rsp), %edi
	addl	52(%rsp), %r8d
	addl	56(%rsp), %r9d
	addl	60(%rsp), %r10d
	movl	%eax, 608(%rsp)
	movl	%ecx, 612(%rsp)
	movl	%edx, 616(%rsp)
	movl	%esi, 620(%rsp)
	movl	%edi, 624(%rsp)
	movl	%r8d, 628(%rsp)
	movl	%r9d, 632(%rsp)
	movl	%r10d, 636(%rsp)
	movq	568(%rsp), %rax
	movq	552(%rsp), %rcx
	movq	560(%rsp), %rsi
	movq	576(%rsp), %rdi
	movq	584(%rsp), %r8
	movq	%rax, 560(%rsp)
	movq	$0, %r9
	movq	$0, %r10
	movq	$0, %r15
	movq	608(%rsp), %r11
	movq	616(%rsp), %rbx
	movq	$1152921487695413247, %rax
	andq	%rax, %r11
	movq	$1152921487695413244, %rax
	andq	%rax, %rbx
	movq	%rbx, %rbp
	shrq	$2, %rbp
	addq	%rbx, %rbp
	movq	%rsi, 552(%rsp)
	movq	%r8, 568(%rsp)
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx_open$18
Ljade_aead_chacha20poly1305_amd64_avx_open$19:
	addq	(%rcx), %r9
	adcq	8(%rcx), %r10
	adcq	$1, %r15
	movq	%rbp, %r12
	imulq	%r15, %r12
	imulq	%r11, %r15
	movq	%r11, %rax
	mulq	%r9
	movq	%rax, %r13
	movq	%rdx, %r14
	movq	%r11, %rax
	mulq	%r10
	addq	%rax, %r14
	adcq	%rdx, %r15
	movq	%rbp, %rax
	mulq	%r10
	movq	%rdx, %r10
	addq	%r12, %r10
	movq	%rax, %r12
	movq	%rbx, %rax
	mulq	%r9
	addq	%r12, %r13
	adcq	%rax, %r14
	adcq	%rdx, %r15
	movq	$-4, %r9
	movq	%r15, %rax
	shrq	$2, %rax
	andq	%r15, %r9
	addq	%rax, %r9
	andq	$3, %r15
	addq	%r13, %r9
	adcq	%r14, %r10
	adcq	$0, %r15
	addq	$16, %rcx
	addq	$-16, %rsi
Ljade_aead_chacha20poly1305_amd64_avx_open$18:
	cmpq	$16, %rsi
	jnb 	Ljade_aead_chacha20poly1305_amd64_avx_open$19
	cmpq	$0, %rsi
	jbe 	Ljade_aead_chacha20poly1305_amd64_avx_open$15
	movq	$0, (%rsp)
	movq	$0, 8(%rsp)
	movq	$0, %rax
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx_open$16
Ljade_aead_chacha20poly1305_amd64_avx_open$17:
	movb	(%rcx,%rax), %dl
	movb	%dl, (%rsp,%rax)
	incq	%rax
Ljade_aead_chacha20poly1305_amd64_avx_open$16:
	cmpq	%rsi, %rax
	jb  	Ljade_aead_chacha20poly1305_amd64_avx_open$17
	addq	(%rsp), %r9
	adcq	8(%rsp), %r10
	adcq	$1, %r15
	movq	%rbp, %rcx
	imulq	%r15, %rcx
	imulq	%r11, %r15
	movq	%r11, %rax
	mulq	%r9
	movq	%rax, %rsi
	movq	%rdx, %r12
	movq	%r11, %rax
	mulq	%r10
	addq	%rax, %r12
	adcq	%rdx, %r15
	movq	%rbp, %rax
	mulq	%r10
	movq	%rdx, %r10
	addq	%rcx, %r10
	movq	%rax, %rcx
	movq	%rbx, %rax
	mulq	%r9
	addq	%rcx, %rsi
	adcq	%rax, %r12
	adcq	%rdx, %r15
	movq	$-4, %r9
	movq	%r15, %rax
	shrq	$2, %rax
	andq	%r15, %r9
	addq	%rax, %r9
	andq	$3, %r15
	addq	%rsi, %r9
	adcq	%r12, %r10
	adcq	$0, %r15
Ljade_aead_chacha20poly1305_amd64_avx_open$15:
	cmpq	$1024, %r8
	jb  	Ljade_aead_chacha20poly1305_amd64_avx_open$12
	movq	%r11, %rcx
	movq	%rbx, %rsi
	movq	$0, %r9
	movq	%rcx, %rax
	andq	$67108863, %rax
	movq	%rax, 232(%rsp)
	movq	%rcx, %rax
	shrq	$26, %rax
	andq	$67108863, %rax
	movq	%rax, 248(%rsp)
	movq	%rcx, %rax
	shrdq	$52, %rsi, %rax
	movq	%rax, %rdx
	andq	$67108863, %rax
	movq	%rax, 264(%rsp)
	shrq	$26, %rdx
	andq	$67108863, %rdx
	movq	%rdx, 280(%rsp)
	movq	%rsi, %rax
	shrdq	$40, %r9, %rax
	movq	%rax, 296(%rsp)
	movq	%rbp, %r10
	imulq	%r9, %r10
	imulq	%r11, %r9
	movq	%r11, %rax
	mulq	%rcx
	movq	%rax, %r12
	movq	%rdx, %r13
	movq	%r11, %rax
	mulq	%rsi
	addq	%rax, %r13
	adcq	%rdx, %r9
	movq	%rbp, %rax
	mulq	%rsi
	movq	%rdx, %rsi
	addq	%r10, %rsi
	movq	%rax, %r10
	movq	%rbx, %rax
	mulq	%rcx
	addq	%r10, %r12
	adcq	%rax, %r13
	adcq	%rdx, %r9
	movq	$-4, %rcx
	movq	%r9, %rax
	shrq	$2, %rax
	andq	%r9, %rcx
	addq	%rax, %rcx
	andq	$3, %r9
	addq	%r12, %rcx
	adcq	%r13, %rsi
	adcq	$0, %r9
	movq	%rcx, %rax
	andq	$67108863, %rax
	movq	%rax, 224(%rsp)
	movq	%rcx, %rax
	shrq	$26, %rax
	andq	$67108863, %rax
	movq	%rax, 240(%rsp)
	movq	%rcx, %rax
	shrdq	$52, %rsi, %rax
	movq	%rax, %rdx
	andq	$67108863, %rax
	movq	%rax, 256(%rsp)
	shrq	$26, %rdx
	andq	$67108863, %rdx
	movq	%rdx, 272(%rsp)
	movq	%rsi, %rax
	shrdq	$40, %r9, %rax
	movq	%rax, 288(%rsp)
	vpbroadcastq	glob_data + 240(%rip), %xmm0
	vpmuludq	240(%rsp), %xmm0, %xmm1
	vmovdqu	%xmm1, 32(%rsp)
	vpmuludq	256(%rsp), %xmm0, %xmm1
	vmovdqu	%xmm1, 48(%rsp)
	vpmuludq	272(%rsp), %xmm0, %xmm1
	vmovdqu	%xmm1, 64(%rsp)
	vpmuludq	288(%rsp), %xmm0, %xmm0
	vmovdqu	%xmm0, 80(%rsp)
	vpbroadcastq	224(%rsp), %xmm0
	vmovdqu	%xmm0, 304(%rsp)
	vpbroadcastq	240(%rsp), %xmm0
	vmovdqu	%xmm0, 320(%rsp)
	vpbroadcastq	256(%rsp), %xmm0
	vmovdqu	%xmm0, 336(%rsp)
	vpbroadcastq	272(%rsp), %xmm0
	vmovdqu	%xmm0, 352(%rsp)
	vpbroadcastq	288(%rsp), %xmm0
	vmovdqu	%xmm0, 368(%rsp)
	vpbroadcastq	32(%rsp), %xmm0
	vmovdqu	%xmm0, 96(%rsp)
	vpbroadcastq	48(%rsp), %xmm0
	vmovdqu	%xmm0, 112(%rsp)
	vpbroadcastq	64(%rsp), %xmm0
	vmovdqu	%xmm0, 128(%rsp)
	vpbroadcastq	80(%rsp), %xmm0
	vmovdqu	%xmm0, 144(%rsp)
	movq	%rbp, %r10
	imulq	%r9, %r10
	imulq	%r11, %r9
	movq	%r11, %rax
	mulq	%rcx
	movq	%rax, %r12
	movq	%rdx, %r13
	movq	%r11, %rax
	mulq	%rsi
	addq	%rax, %r13
	adcq	%rdx, %r9
	movq	%rbp, %rax
	mulq	%rsi
	movq	%rdx, %rsi
	addq	%r10, %rsi
	movq	%rax, %r10
	movq	%rbx, %rax
	mulq	%rcx
	addq	%r10, %r12
	adcq	%rax, %r13
	adcq	%rdx, %r9
	movq	$-4, %rcx
	movq	%r9, %rax
	shrq	$2, %rax
	andq	%r9, %rcx
	addq	%rax, %rcx
	andq	$3, %r9
	addq	%r12, %rcx
	adcq	%r13, %rsi
	adcq	$0, %r9
	movq	%rbp, %r10
	imulq	%r9, %r10
	imulq	%r11, %r9
	movq	%r11, %rax
	mulq	%rcx
	movq	%rax, %r12
	movq	%rdx, %r13
	movq	%r11, %rax
	mulq	%rsi
	addq	%rax, %r13
	adcq	%rdx, %r9
	movq	%rbp, %rax
	mulq	%rsi
	movq	%rdx, %rsi
	addq	%r10, %rsi
	movq	%rax, %r10
	movq	%rbx, %rax
	mulq	%rcx
	addq	%r10, %r12
	adcq	%rax, %r13
	adcq	%rdx, %r9
	movq	$-4, %rax
	movq	%r9, %rcx
	shrq	$2, %rcx
	andq	%r9, %rax
	addq	%rcx, %rax
	andq	$3, %r9
	addq	%r12, %rax
	adcq	%r13, %rsi
	adcq	$0, %r9
	movq	%rax, %rcx
	andq	$67108863, %rcx
	movq	%rcx, 384(%rsp)
	movq	%rax, %rcx
	shrq	$26, %rcx
	andq	$67108863, %rcx
	movq	%rcx, 400(%rsp)
	shrdq	$52, %rsi, %rax
	movq	%rax, %rcx
	andq	$67108863, %rax
	movq	%rax, 416(%rsp)
	shrq	$26, %rcx
	andq	$67108863, %rcx
	movq	%rcx, 432(%rsp)
	shrdq	$40, %r9, %rsi
	movq	%rsi, 448(%rsp)
	movq	384(%rsp), %rax
	movq	%rax, 392(%rsp)
	movq	400(%rsp), %rax
	movq	%rax, 408(%rsp)
	movq	416(%rsp), %rax
	movq	%rax, 424(%rsp)
	movq	432(%rsp), %rax
	movq	%rax, 440(%rsp)
	movq	448(%rsp), %rax
	movq	%rax, 456(%rsp)
	vpbroadcastq	glob_data + 240(%rip), %xmm0
	vpmuludq	400(%rsp), %xmm0, %xmm1
	vmovdqu	%xmm1, 160(%rsp)
	vpmuludq	416(%rsp), %xmm0, %xmm1
	vmovdqu	%xmm1, 176(%rsp)
	vpmuludq	432(%rsp), %xmm0, %xmm1
	vmovdqu	%xmm1, 192(%rsp)
	vpmuludq	448(%rsp), %xmm0, %xmm0
	vmovdqu	%xmm0, 208(%rsp)
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpbroadcastq	glob_data + 232(%rip), %xmm5
	vmovdqu	%xmm5, (%rsp)
	vpbroadcastq	glob_data + 224(%rip), %xmm5
	vmovdqu	%xmm5, 16(%rsp)
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx_open$13
Ljade_aead_chacha20poly1305_amd64_avx_open$14:
	vmovdqu	384(%rsp), %xmm5
	vmovdqu	400(%rsp), %xmm6
	vmovdqu	208(%rsp), %xmm7
	vpmuludq	%xmm5, %xmm0, %xmm8
	vpmuludq	%xmm6, %xmm0, %xmm9
	vpmuludq	%xmm5, %xmm1, %xmm10
	vpmuludq	%xmm6, %xmm1, %xmm11
	vpmuludq	%xmm5, %xmm2, %xmm12
	vpmuludq	%xmm6, %xmm2, %xmm13
	vpmuludq	%xmm5, %xmm3, %xmm14
	vpaddq	%xmm9, %xmm10, %xmm9
	vpmuludq	%xmm6, %xmm3, %xmm6
	vpaddq	%xmm11, %xmm12, %xmm10
	vpmuludq	%xmm5, %xmm4, %xmm5
	vpaddq	%xmm13, %xmm14, %xmm11
	vpaddq	%xmm6, %xmm5, %xmm5
	vpmuludq	%xmm7, %xmm1, %xmm6
	vmovdqu	(%rdi), %xmm12
	vpmuludq	%xmm7, %xmm2, %xmm13
	vmovdqu	416(%rsp), %xmm14
	vpmuludq	%xmm7, %xmm3, %xmm15
	vpmuludq	%xmm7, %xmm4, %xmm7
	vpaddq	%xmm6, %xmm8, %xmm6
	vmovdqu	16(%rdi), %xmm8
	vpaddq	%xmm13, %xmm9, %xmm9
	vpaddq	%xmm15, %xmm10, %xmm10
	vpaddq	%xmm7, %xmm11, %xmm7
	vpmuludq	%xmm14, %xmm0, %xmm11
	vpunpcklqdq	%xmm8, %xmm12, %xmm13
	vpmuludq	%xmm14, %xmm1, %xmm15
	vpunpckhqdq	%xmm8, %xmm12, %xmm8
	vpmuludq	%xmm14, %xmm2, %xmm12
	vpaddq	%xmm11, %xmm10, %xmm10
	vmovdqu	192(%rsp), %xmm11
	vpaddq	%xmm15, %xmm7, %xmm7
	vpaddq	%xmm12, %xmm5, %xmm5
	vpmuludq	%xmm11, %xmm2, %xmm2
	vpmuludq	%xmm11, %xmm3, %xmm12
	vmovdqu	%xmm13, %xmm14
	vpmuludq	%xmm11, %xmm4, %xmm11
	vpsrlq	$26, %xmm14, %xmm14
	vpand	(%rsp), %xmm14, %xmm14
	vmovdqu	432(%rsp), %xmm15
	vpaddq	%xmm2, %xmm6, %xmm2
	vpaddq	%xmm12, %xmm9, %xmm6
	vpaddq	%xmm10, %xmm11, %xmm9
	vpmuludq	%xmm15, %xmm0, %xmm10
	vmovdqu	%xmm8, %xmm11
	vmovdqu	%xmm9, 496(%rsp)
	vpmuludq	%xmm15, %xmm1, %xmm1
	vpsrlq	$40, %xmm11, %xmm9
	vpor	16(%rsp), %xmm9, %xmm9
	vmovdqu	176(%rsp), %xmm11
	vpaddq	%xmm10, %xmm7, %xmm7
	vpaddq	%xmm1, %xmm5, %xmm1
	vpmuludq	%xmm11, %xmm3, %xmm3
	vmovdqu	%xmm13, %xmm5
	vmovdqu	%xmm7, 512(%rsp)
	vpmuludq	%xmm11, %xmm4, %xmm7
	vpsrlq	$52, %xmm5, %xmm5
	vpaddq	%xmm3, %xmm2, %xmm2
	vpaddq	%xmm6, %xmm7, %xmm3
	vpmuludq	160(%rsp), %xmm4, %xmm4
	vpsllq	$12, %xmm8, %xmm6
	vmovdqu	%xmm3, 480(%rsp)
	vpmuludq	448(%rsp), %xmm0, %xmm0
	vpor	%xmm6, %xmm5, %xmm3
	vmovdqu	(%rsp), %xmm5
	vpaddq	%xmm4, %xmm2, %xmm2
	vpaddq	%xmm0, %xmm1, %xmm0
	vmovdqu	%xmm2, 464(%rsp)
	vmovdqu	%xmm0, 528(%rsp)
	vpand	%xmm5, %xmm13, %xmm0
	vpand	%xmm5, %xmm3, %xmm1
	vpsrlq	$14, %xmm8, %xmm2
	vpand	%xmm5, %xmm2, %xmm2
	vmovdqu	304(%rsp), %xmm3
	vmovdqu	320(%rsp), %xmm4
	vmovdqu	144(%rsp), %xmm5
	vpmuludq	%xmm3, %xmm0, %xmm6
	vpmuludq	%xmm4, %xmm0, %xmm7
	vpmuludq	%xmm3, %xmm14, %xmm8
	vpmuludq	%xmm4, %xmm14, %xmm10
	vpmuludq	%xmm3, %xmm1, %xmm11
	vpmuludq	%xmm4, %xmm1, %xmm12
	vpaddq	464(%rsp), %xmm6, %xmm6
	vpmuludq	%xmm3, %xmm2, %xmm13
	vpaddq	480(%rsp), %xmm8, %xmm8
	vpaddq	%xmm7, %xmm8, %xmm7
	vpmuludq	%xmm4, %xmm2, %xmm4
	vpaddq	496(%rsp), %xmm11, %xmm8
	vpaddq	%xmm10, %xmm8, %xmm8
	vpmuludq	%xmm3, %xmm9, %xmm3
	vpaddq	512(%rsp), %xmm13, %xmm10
	vpaddq	%xmm12, %xmm10, %xmm10
	vpaddq	528(%rsp), %xmm3, %xmm3
	vpaddq	%xmm4, %xmm3, %xmm3
	vpmuludq	%xmm5, %xmm14, %xmm4
	vmovdqu	32(%rdi), %xmm11
	vpmuludq	%xmm5, %xmm1, %xmm12
	vmovdqu	336(%rsp), %xmm13
	vpmuludq	%xmm5, %xmm2, %xmm15
	vpmuludq	%xmm5, %xmm9, %xmm5
	vpaddq	%xmm4, %xmm6, %xmm4
	vmovdqu	48(%rdi), %xmm6
	vpaddq	%xmm12, %xmm7, %xmm7
	vpaddq	%xmm15, %xmm8, %xmm8
	vpaddq	%xmm5, %xmm10, %xmm5
	vpmuludq	%xmm13, %xmm0, %xmm10
	vpunpcklqdq	%xmm6, %xmm11, %xmm12
	vpmuludq	%xmm13, %xmm14, %xmm15
	vpunpckhqdq	%xmm6, %xmm11, %xmm6
	vpmuludq	%xmm13, %xmm1, %xmm11
	vpaddq	%xmm10, %xmm8, %xmm8
	vmovdqu	128(%rsp), %xmm10
	vpaddq	%xmm15, %xmm5, %xmm5
	vpaddq	%xmm11, %xmm3, %xmm3
	vpmuludq	%xmm10, %xmm1, %xmm1
	vpmuludq	%xmm10, %xmm2, %xmm11
	vmovdqu	%xmm12, %xmm13
	vpmuludq	%xmm10, %xmm9, %xmm10
	vpsrlq	$26, %xmm13, %xmm13
	vpand	(%rsp), %xmm13, %xmm13
	vmovdqu	352(%rsp), %xmm15
	vpaddq	%xmm1, %xmm4, %xmm1
	vpaddq	%xmm11, %xmm7, %xmm4
	vpaddq	%xmm8, %xmm10, %xmm7
	vpmuludq	%xmm15, %xmm0, %xmm8
	vmovdqu	%xmm6, %xmm10
	vpmuludq	%xmm15, %xmm14, %xmm11
	vpsrlq	$40, %xmm10, %xmm10
	vpor	16(%rsp), %xmm10, %xmm10
	vmovdqu	112(%rsp), %xmm14
	vpaddq	%xmm8, %xmm5, %xmm5
	vpaddq	%xmm11, %xmm3, %xmm3
	vpmuludq	%xmm14, %xmm2, %xmm2
	vmovdqu	%xmm12, %xmm8
	vpmuludq	%xmm14, %xmm9, %xmm11
	vpsrlq	$52, %xmm8, %xmm8
	vpaddq	%xmm2, %xmm1, %xmm1
	vpaddq	%xmm4, %xmm11, %xmm2
	vpmuludq	96(%rsp), %xmm9, %xmm4
	vpsllq	$12, %xmm6, %xmm9
	vpmuludq	368(%rsp), %xmm0, %xmm0
	vpor	%xmm9, %xmm8, %xmm8
	vmovdqu	(%rsp), %xmm9
	vpaddq	%xmm4, %xmm1, %xmm1
	vpaddq	%xmm0, %xmm3, %xmm0
	vpand	%xmm9, %xmm12, %xmm3
	vpaddq	%xmm1, %xmm3, %xmm1
	vpand	%xmm9, %xmm8, %xmm3
	vpaddq	%xmm7, %xmm3, %xmm3
	vpsrlq	$14, %xmm6, %xmm4
	vpand	%xmm9, %xmm4, %xmm4
	vpaddq	%xmm5, %xmm4, %xmm4
	addq	$64, %rdi
	vpaddq	%xmm2, %xmm13, %xmm2
	vpaddq	%xmm0, %xmm10, %xmm0
	vpsrlq	$26, %xmm1, %xmm5
	vpsrlq	$26, %xmm4, %xmm6
	vpand	%xmm9, %xmm1, %xmm1
	vpand	%xmm9, %xmm4, %xmm4
	vpaddq	%xmm5, %xmm2, %xmm2
	vpaddq	%xmm6, %xmm0, %xmm0
	vpsrlq	$26, %xmm2, %xmm5
	vpsrlq	$26, %xmm0, %xmm6
	vpsllq	$2, %xmm6, %xmm7
	vpaddq	%xmm7, %xmm6, %xmm6
	vpand	%xmm9, %xmm2, %xmm7
	vpand	%xmm9, %xmm0, %xmm8
	vpaddq	%xmm5, %xmm3, %xmm0
	vpaddq	%xmm6, %xmm1, %xmm1
	vpsrlq	$26, %xmm0, %xmm3
	vpsrlq	$26, %xmm1, %xmm5
	vpand	%xmm9, %xmm0, %xmm2
	vpand	%xmm9, %xmm1, %xmm0
	vpaddq	%xmm3, %xmm4, %xmm3
	vpaddq	%xmm5, %xmm7, %xmm1
	vpsrlq	$26, %xmm3, %xmm4
	vpand	%xmm9, %xmm3, %xmm3
	vpaddq	%xmm4, %xmm8, %xmm4
	addq	$-64, %r8
Ljade_aead_chacha20poly1305_amd64_avx_open$13:
	cmpq	$64, %r8
	jnb 	Ljade_aead_chacha20poly1305_amd64_avx_open$14
	vmovdqu	224(%rsp), %xmm5
	vmovdqu	240(%rsp), %xmm6
	vmovdqu	80(%rsp), %xmm7
	vpmuludq	%xmm5, %xmm0, %xmm8
	vpmuludq	%xmm5, %xmm1, %xmm9
	vpmuludq	%xmm5, %xmm2, %xmm10
	vpmuludq	%xmm5, %xmm3, %xmm11
	vpmuludq	%xmm5, %xmm4, %xmm5
	vpmuludq	%xmm6, %xmm0, %xmm12
	vpmuludq	%xmm6, %xmm1, %xmm13
	vpmuludq	%xmm6, %xmm2, %xmm14
	vpmuludq	%xmm6, %xmm3, %xmm6
	vmovdqu	256(%rsp), %xmm15
	vpaddq	%xmm12, %xmm9, %xmm9
	vpaddq	%xmm13, %xmm10, %xmm10
	vpaddq	%xmm14, %xmm11, %xmm11
	vpaddq	%xmm6, %xmm5, %xmm5
	vpmuludq	%xmm7, %xmm1, %xmm6
	vpmuludq	%xmm7, %xmm2, %xmm12
	vpmuludq	%xmm7, %xmm3, %xmm13
	vpmuludq	%xmm7, %xmm4, %xmm7
	vmovdqu	64(%rsp), %xmm14
	vpaddq	%xmm6, %xmm8, %xmm6
	vpaddq	%xmm12, %xmm9, %xmm8
	vpaddq	%xmm13, %xmm10, %xmm9
	vpaddq	%xmm7, %xmm11, %xmm7
	vpmuludq	%xmm15, %xmm0, %xmm10
	vpmuludq	%xmm15, %xmm1, %xmm11
	vpmuludq	%xmm15, %xmm2, %xmm12
	vmovdqu	272(%rsp), %xmm13
	vpaddq	%xmm10, %xmm9, %xmm9
	vpaddq	%xmm11, %xmm7, %xmm7
	vpaddq	%xmm12, %xmm5, %xmm5
	vpmuludq	%xmm14, %xmm2, %xmm2
	vpmuludq	%xmm14, %xmm3, %xmm10
	vpmuludq	%xmm14, %xmm4, %xmm11
	vmovdqu	48(%rsp), %xmm12
	vpaddq	%xmm2, %xmm6, %xmm2
	vpaddq	%xmm10, %xmm8, %xmm6
	vpaddq	%xmm9, %xmm11, %xmm8
	vpmuludq	%xmm13, %xmm0, %xmm9
	vpmuludq	%xmm13, %xmm1, %xmm1
	vpaddq	%xmm9, %xmm7, %xmm7
	vpaddq	%xmm1, %xmm5, %xmm1
	vpmuludq	%xmm12, %xmm3, %xmm3
	vpmuludq	%xmm12, %xmm4, %xmm5
	vpaddq	%xmm3, %xmm2, %xmm2
	vpaddq	%xmm6, %xmm5, %xmm3
	vpmuludq	32(%rsp), %xmm4, %xmm4
	vpmuludq	288(%rsp), %xmm0, %xmm0
	vpaddq	%xmm4, %xmm2, %xmm2
	vpaddq	%xmm0, %xmm1, %xmm0
	vmovdqu	(%rsp), %xmm1
	vpsrlq	$26, %xmm2, %xmm4
	vpsrlq	$26, %xmm7, %xmm5
	vpand	%xmm1, %xmm2, %xmm2
	vpand	%xmm1, %xmm7, %xmm6
	vpaddq	%xmm4, %xmm3, %xmm3
	vpaddq	%xmm5, %xmm0, %xmm0
	vpsrlq	$26, %xmm3, %xmm4
	vpsrlq	$26, %xmm0, %xmm5
	vpsllq	$2, %xmm5, %xmm7
	vpaddq	%xmm7, %xmm5, %xmm5
	vpand	%xmm1, %xmm3, %xmm3
	vpand	%xmm1, %xmm0, %xmm0
	vpaddq	%xmm4, %xmm8, %xmm4
	vpaddq	%xmm5, %xmm2, %xmm2
	vpsrlq	$26, %xmm4, %xmm5
	vpsrlq	$26, %xmm2, %xmm7
	vpand	%xmm1, %xmm4, %xmm4
	vpand	%xmm1, %xmm2, %xmm2
	vpaddq	%xmm5, %xmm6, %xmm5
	vpaddq	%xmm7, %xmm3, %xmm3
	vpsrlq	$26, %xmm5, %xmm6
	vpand	%xmm1, %xmm5, %xmm1
	vpaddq	%xmm6, %xmm0, %xmm0
	vpsllq	$26, %xmm3, %xmm3
	vpaddq	%xmm2, %xmm3, %xmm2
	vpsllq	$26, %xmm1, %xmm1
	vpaddq	%xmm4, %xmm1, %xmm1
	vpsrldq	$8, %xmm0, %xmm3
	vpaddq	%xmm0, %xmm3, %xmm0
	vpunpcklqdq	%xmm1, %xmm2, %xmm3
	vpunpckhqdq	%xmm1, %xmm2, %xmm1
	vpaddq	%xmm1, %xmm3, %xmm1
	vpextrq	$0, %xmm1, %rax
	vpextrq	$1, %xmm1, %r10
	vpextrq	$0, %xmm0, %rcx
	movq	%r10, %r9
	shlq	$52, %r9
	shrq	$12, %r10
	movq	%rcx, %r15
	shrq	$24, %r15
	shlq	$40, %rcx
	addq	%rax, %r9
	adcq	%rcx, %r10
	adcq	$0, %r15
	movq	%r15, %rax
	movq	%r15, %rcx
	andq	$3, %r15
	shrq	$2, %rax
	andq	$-4, %rcx
	addq	%rcx, %rax
	addq	%rax, %r9
	adcq	$0, %r10
	adcq	$0, %r15
Ljade_aead_chacha20poly1305_amd64_avx_open$12:
	movq	568(%rsp), %rcx
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx_open$10
Ljade_aead_chacha20poly1305_amd64_avx_open$11:
	addq	(%rdi), %r9
	adcq	8(%rdi), %r10
	adcq	$1, %r15
	movq	%rbp, %rsi
	imulq	%r15, %rsi
	imulq	%r11, %r15
	movq	%r11, %rax
	mulq	%r9
	movq	%rax, %r8
	movq	%rdx, %r12
	movq	%r11, %rax
	mulq	%r10
	addq	%rax, %r12
	adcq	%rdx, %r15
	movq	%rbp, %rax
	mulq	%r10
	movq	%rdx, %r10
	addq	%rsi, %r10
	movq	%rax, %rsi
	movq	%rbx, %rax
	mulq	%r9
	addq	%rsi, %r8
	adcq	%rax, %r12
	adcq	%rdx, %r15
	movq	$-4, %r9
	movq	%r15, %rax
	shrq	$2, %rax
	andq	%r15, %r9
	addq	%rax, %r9
	andq	$3, %r15
	addq	%r8, %r9
	adcq	%r12, %r10
	adcq	$0, %r15
	addq	$16, %rdi
	addq	$-16, %rcx
Ljade_aead_chacha20poly1305_amd64_avx_open$10:
	cmpq	$16, %rcx
	jnb 	Ljade_aead_chacha20poly1305_amd64_avx_open$11
	cmpq	$0, %rcx
	jbe 	Ljade_aead_chacha20poly1305_amd64_avx_open$7
	movq	$0, (%rsp)
	movq	$0, 8(%rsp)
	movq	$0, %rax
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx_open$8
Ljade_aead_chacha20poly1305_amd64_avx_open$9:
	movb	(%rdi,%rax), %dl
	movb	%dl, (%rsp,%rax)
	incq	%rax
Ljade_aead_chacha20poly1305_amd64_avx_open$8:
	cmpq	%rcx, %rax
	jb  	Ljade_aead_chacha20poly1305_amd64_avx_open$9
	addq	(%rsp), %r9
	adcq	8(%rsp), %r10
	adcq	$1, %r15
	movq	%rbp, %rcx
	imulq	%r15, %rcx
	imulq	%r11, %r15
	movq	%r11, %rax
	mulq	%r9
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%r11, %rax
	mulq	%r10
	addq	%rax, %rdi
	adcq	%rdx, %r15
	movq	%rbp, %rax
	mulq	%r10
	movq	%rdx, %r10
	addq	%rcx, %r10
	movq	%rax, %rcx
	movq	%rbx, %rax
	mulq	%r9
	addq	%rcx, %rsi
	adcq	%rax, %rdi
	adcq	%rdx, %r15
	movq	$-4, %r9
	movq	%r15, %rax
	shrq	$2, %rax
	andq	%r15, %r9
	addq	%rax, %r9
	andq	$3, %r15
	addq	%rsi, %r9
	adcq	%rdi, %r10
	adcq	$0, %r15
Ljade_aead_chacha20poly1305_amd64_avx_open$7:
	movq	552(%rsp), %rax
	movq	568(%rsp), %rcx
	addq	%rax, %r9
	adcq	%rcx, %r10
	adcq	$1, %r15
	movq	%rbp, %rcx
	imulq	%r15, %rcx
	imulq	%r11, %r15
	movq	%r11, %rax
	mulq	%r9
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%r11, %rax
	mulq	%r10
	addq	%rax, %rdi
	adcq	%rdx, %r15
	movq	%rbp, %rax
	mulq	%r10
	movq	%rdx, %r8
	addq	%rcx, %r8
	movq	%rax, %rcx
	movq	%rbx, %rax
	mulq	%r9
	addq	%rcx, %rsi
	adcq	%rax, %rdi
	adcq	%rdx, %r15
	movq	$-4, %rax
	movq	%r15, %rcx
	shrq	$2, %rcx
	andq	%r15, %rax
	addq	%rcx, %rax
	andq	$3, %r15
	addq	%rsi, %rax
	adcq	%rdi, %r8
	adcq	$0, %r15
	movq	%rax, %rcx
	movq	%r8, %rdx
	addq	$5, %rcx
	adcq	$0, %rdx
	adcq	$0, %r15
	shrq	$2, %r15
	negq	%r15
	xorq	%rax, %rcx
	xorq	%r8, %rdx
	andq	%r15, %rcx
	andq	%r15, %rdx
	xorq	%rax, %rcx
	xorq	%r8, %rdx
	movq	624(%rsp), %rax
	movq	632(%rsp), %rsi
	addq	%rax, %rcx
	adcq	%rsi, %rdx
	movq	560(%rsp), %rax
	xorq	(%rax), %rcx
	xorq	8(%rax), %rdx
	orq 	%rdx, %rcx
	xorq	%rax, %rax
	subq	$1, %rcx
	adcq	$0, %rax
	addq	$-1, %rax
	cmpq	$0, %rax
	jne 	Ljade_aead_chacha20poly1305_amd64_avx_open$1
	movq	544(%rsp), %rax
	movq	576(%rsp), %rcx
	movq	584(%rsp), %rdx
	movq	592(%rsp), %rsi
	movq	600(%rsp), %rdi
	movl	$1, %r8d
	cmpq	$129, %rdx
	jb  	Ljade_aead_chacha20poly1305_amd64_avx_open$3
	movq	%rax, %r11
	movq	%rcx, %r10
	movq	%rdx, %rcx
	movq	%rsi, %rax
	movl	%r8d, %edx
	movq	%rdi, %r9
	leaq	-616(%rsp), %rsp
	call	L_chacha_xor_v_avx_ic$1
Ljade_aead_chacha20poly1305_amd64_avx_open$6:
	leaq	616(%rsp), %rsp
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx_open$4
Ljade_aead_chacha20poly1305_amd64_avx_open$3:
	movq	%rax, %r11
	movq	%rcx, %r10
	movq	%rdx, %rcx
	movq	%rsi, %rax
	movl	%r8d, %edx
	movq	%rdi, %r9
	call	L_chacha_xor_h_x2_avx_ic$1
Ljade_aead_chacha20poly1305_amd64_avx_open$5:
Ljade_aead_chacha20poly1305_amd64_avx_open$4:
	movq	$0, %rax
Ljade_aead_chacha20poly1305_amd64_avx_open$2:
Ljade_aead_chacha20poly1305_amd64_avx_open$1:
	movq	656(%rsp), %rbx
	movq	664(%rsp), %rbp
	movq	672(%rsp), %r12
	movq	680(%rsp), %r13
	movq	688(%rsp), %r14
	movq	696(%rsp), %r15
	movq	704(%rsp), %rsp
	ret 
_jade_aead_chacha20poly1305_amd64_avx:
jade_aead_chacha20poly1305_amd64_avx:
	movq	%rsp, %rax
	leaq	-240(%rsp), %rsp
	andq	$-16, %rsp
	movq	%rax, 232(%rsp)
	movq	%rbx, 184(%rsp)
	movq	%rbp, 192(%rsp)
	movq	%r12, 200(%rsp)
	movq	%r13, 208(%rsp)
	movq	%r14, 216(%rsp)
	movq	%r15, 224(%rsp)
	movq	%rsi, %rax
	addq	%rdx, %rax
	movq	%rdi, (%rsp)
	leaq	16(%rdi), %rdi
	movq	%rdi, 8(%rsp)
	movq	%rsi, 16(%rsp)
	movq	%rdx, 24(%rsp)
	movq	%rcx, 32(%rsp)
	movq	%r8, 40(%rsp)
	movq	%r9, 48(%rsp)
	movl	$1, %edx
	cmpq	$129, %rcx
	jb  	Ljade_aead_chacha20poly1305_amd64_avx$12
	movq	%rdi, %r11
	movq	%rax, %r10
	movq	%r8, %rax
	leaq	-616(%rsp), %rsp
	call	L_chacha_xor_v_avx_ic$1
Ljade_aead_chacha20poly1305_amd64_avx$15:
	leaq	616(%rsp), %rsp
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx$13
Ljade_aead_chacha20poly1305_amd64_avx$12:
	movq	%rdi, %r11
	movq	%rax, %r10
	movq	%r8, %rax
	call	L_chacha_xor_h_x2_avx_ic$1
Ljade_aead_chacha20poly1305_amd64_avx$14:
Ljade_aead_chacha20poly1305_amd64_avx$13:
	movq	40(%rsp), %rax
	movq	48(%rsp), %rcx
	xorl	%edx, %edx
	movl	$1634760805, 120(%rsp)
	movl	$857760878, 124(%rsp)
	movl	$2036477234, 128(%rsp)
	movl	$1797285236, 132(%rsp)
	movl	(%rcx), %esi
	movl	%esi, 136(%rsp)
	movl	4(%rcx), %esi
	movl	%esi, 140(%rsp)
	movl	8(%rcx), %esi
	movl	%esi, 144(%rsp)
	movl	12(%rcx), %esi
	movl	%esi, 148(%rsp)
	movl	16(%rcx), %esi
	movl	%esi, 152(%rsp)
	movl	20(%rcx), %esi
	movl	%esi, 156(%rsp)
	movl	24(%rcx), %esi
	movl	%esi, 160(%rsp)
	movl	28(%rcx), %ecx
	movl	%ecx, 164(%rsp)
	movl	%edx, 168(%rsp)
	movl	(%rax), %ecx
	movl	%ecx, 172(%rsp)
	movl	4(%rax), %ecx
	movl	%ecx, 176(%rsp)
	movl	8(%rax), %eax
	movl	%eax, 180(%rsp)
	movl	180(%rsp), %eax
	movl	%eax, 104(%rsp)
	movl	120(%rsp), %eax
	movl	124(%rsp), %ecx
	movl	128(%rsp), %edx
	movl	132(%rsp), %esi
	movl	136(%rsp), %edi
	movl	140(%rsp), %r8d
	movl	144(%rsp), %r9d
	movl	148(%rsp), %r10d
	movl	152(%rsp), %r11d
	movl	156(%rsp), %ebx
	movl	160(%rsp), %ebp
	movl	164(%rsp), %r12d
	movl	168(%rsp), %r13d
	movl	172(%rsp), %r14d
	movl	176(%rsp), %r15d
	movl	%r15d, 108(%rsp)
	movl	$10, %r15d
Ljade_aead_chacha20poly1305_amd64_avx$11:
	movl	%r15d, 112(%rsp)
	movl	108(%rsp), %r15d
	addl	%edi, %eax
	addl	%r9d, %edx
	xorl	%eax, %r13d
	xorl	%edx, %r15d
	roll	$16, %r13d
	roll	$16, %r15d
	addl	%r13d, %r11d
	addl	%r15d, %ebp
	xorl	%r11d, %edi
	xorl	%ebp, %r9d
	roll	$12, %edi
	roll	$12, %r9d
	addl	%edi, %eax
	addl	%r9d, %edx
	xorl	%eax, %r13d
	xorl	%edx, %r15d
	roll	$8, %r13d
	roll	$8, %r15d
	addl	%r13d, %r11d
	addl	%r15d, %ebp
	xorl	%r11d, %edi
	xorl	%ebp, %r9d
	roll	$7, %edi
	roll	$7, %r9d
	movl	%r15d, 116(%rsp)
	movl	104(%rsp), %r15d
	addl	%r8d, %ecx
	addl	%r10d, %esi
	xorl	%ecx, %r14d
	xorl	%esi, %r15d
	roll	$16, %r14d
	roll	$16, %r15d
	addl	%r14d, %ebx
	addl	%r15d, %r12d
	xorl	%ebx, %r8d
	xorl	%r12d, %r10d
	roll	$12, %r8d
	roll	$12, %r10d
	addl	%r8d, %ecx
	addl	%r10d, %esi
	xorl	%ecx, %r14d
	xorl	%esi, %r15d
	roll	$8, %r14d
	roll	$8, %r15d
	addl	%r14d, %ebx
	addl	%r15d, %r12d
	xorl	%ebx, %r8d
	xorl	%r12d, %r10d
	roll	$7, %r8d
	roll	$7, %r10d
	addl	%r9d, %ecx
	addl	%r8d, %eax
	xorl	%ecx, %r13d
	xorl	%eax, %r15d
	roll	$16, %r13d
	roll	$16, %r15d
	addl	%r13d, %r12d
	addl	%r15d, %ebp
	xorl	%r12d, %r9d
	xorl	%ebp, %r8d
	roll	$12, %r9d
	roll	$12, %r8d
	addl	%r9d, %ecx
	addl	%r8d, %eax
	xorl	%ecx, %r13d
	xorl	%eax, %r15d
	roll	$8, %r13d
	roll	$8, %r15d
	addl	%r13d, %r12d
	addl	%r15d, %ebp
	xorl	%r12d, %r9d
	xorl	%ebp, %r8d
	roll	$7, %r9d
	roll	$7, %r8d
	movl	%r15d, 104(%rsp)
	movl	116(%rsp), %r15d
	addl	%r10d, %edx
	addl	%edi, %esi
	xorl	%edx, %r14d
	xorl	%esi, %r15d
	roll	$16, %r14d
	roll	$16, %r15d
	addl	%r14d, %r11d
	addl	%r15d, %ebx
	xorl	%r11d, %r10d
	xorl	%ebx, %edi
	roll	$12, %r10d
	roll	$12, %edi
	addl	%r10d, %edx
	addl	%edi, %esi
	xorl	%edx, %r14d
	xorl	%esi, %r15d
	roll	$8, %r14d
	roll	$8, %r15d
	addl	%r14d, %r11d
	addl	%r15d, %ebx
	xorl	%r11d, %r10d
	xorl	%ebx, %edi
	roll	$7, %r10d
	roll	$7, %edi
	movl	%r15d, 108(%rsp)
	movl	112(%rsp), %r15d
	decl	%r15d
	cmpl	$0, %r15d
	jnbe	Ljade_aead_chacha20poly1305_amd64_avx$11
	addl	120(%rsp), %eax
	addl	124(%rsp), %ecx
	addl	128(%rsp), %edx
	addl	132(%rsp), %esi
	addl	136(%rsp), %edi
	addl	140(%rsp), %r8d
	addl	144(%rsp), %r9d
	addl	148(%rsp), %r10d
	movl	%eax, 72(%rsp)
	movl	%ecx, 76(%rsp)
	movl	%edx, 80(%rsp)
	movl	%esi, 84(%rsp)
	movl	%edi, 88(%rsp)
	movl	%r8d, 92(%rsp)
	movl	%r9d, 96(%rsp)
	movl	%r10d, 100(%rsp)
	movq	(%rsp), %rax
	movq	8(%rsp), %rcx
	movq	16(%rsp), %rsi
	movq	24(%rsp), %rdi
	movq	32(%rsp), %rdx
	movq	%rax, 32(%rsp)
	movq	$0, %r8
	movq	$0, %r9
	movq	$0, %r10
	movq	72(%rsp), %r11
	movq	80(%rsp), %rbx
	movq	$1152921487695413247, %rax
	andq	%rax, %r11
	movq	$1152921487695413244, %rax
	andq	%rax, %rbx
	movq	%rbx, %rbp
	shrq	$2, %rbp
	addq	%rbx, %rbp
	movq	%rdi, 24(%rsp)
	movq	%rdx, 16(%rsp)
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx$9
Ljade_aead_chacha20poly1305_amd64_avx$10:
	addq	(%rsi), %r8
	adcq	8(%rsi), %r9
	adcq	$1, %r10
	movq	%rbp, %r12
	imulq	%r10, %r12
	imulq	%r11, %r10
	movq	%r11, %rax
	mulq	%r8
	movq	%rax, %r13
	movq	%rdx, %r14
	movq	%r11, %rax
	mulq	%r9
	addq	%rax, %r14
	adcq	%rdx, %r10
	movq	%rbp, %rax
	mulq	%r9
	movq	%rdx, %r9
	addq	%r12, %r9
	movq	%rax, %r12
	movq	%rbx, %rax
	mulq	%r8
	addq	%r12, %r13
	adcq	%rax, %r14
	adcq	%rdx, %r10
	movq	$-4, %r8
	movq	%r10, %rax
	shrq	$2, %rax
	andq	%r10, %r8
	addq	%rax, %r8
	andq	$3, %r10
	addq	%r13, %r8
	adcq	%r14, %r9
	adcq	$0, %r10
	addq	$16, %rsi
	addq	$-16, %rdi
Ljade_aead_chacha20poly1305_amd64_avx$9:
	cmpq	$16, %rdi
	jnb 	Ljade_aead_chacha20poly1305_amd64_avx$10
	cmpq	$0, %rdi
	jbe 	Ljade_aead_chacha20poly1305_amd64_avx$6
	movq	$0, 56(%rsp)
	movq	$0, 64(%rsp)
	movq	$0, %rax
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx$7
Ljade_aead_chacha20poly1305_amd64_avx$8:
	movb	(%rsi,%rax), %dl
	movb	%dl, 56(%rsp,%rax)
	incq	%rax
Ljade_aead_chacha20poly1305_amd64_avx$7:
	cmpq	%rdi, %rax
	jb  	Ljade_aead_chacha20poly1305_amd64_avx$8
	addq	56(%rsp), %r8
	adcq	64(%rsp), %r9
	adcq	$1, %r10
	movq	%rbp, %rsi
	imulq	%r10, %rsi
	imulq	%r11, %r10
	movq	%r11, %rax
	mulq	%r8
	movq	%rax, %rdi
	movq	%rdx, %r12
	movq	%r11, %rax
	mulq	%r9
	addq	%rax, %r12
	adcq	%rdx, %r10
	movq	%rbp, %rax
	mulq	%r9
	movq	%rdx, %r9
	addq	%rsi, %r9
	movq	%rax, %rsi
	movq	%rbx, %rax
	mulq	%r8
	addq	%rsi, %rdi
	adcq	%rax, %r12
	adcq	%rdx, %r10
	movq	$-4, %r8
	movq	%r10, %rax
	shrq	$2, %rax
	andq	%r10, %r8
	addq	%rax, %r8
	andq	$3, %r10
	addq	%rdi, %r8
	adcq	%r12, %r9
	adcq	$0, %r10
Ljade_aead_chacha20poly1305_amd64_avx$6:
	movq	16(%rsp), %rsi
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx$4
Ljade_aead_chacha20poly1305_amd64_avx$5:
	addq	(%rcx), %r8
	adcq	8(%rcx), %r9
	adcq	$1, %r10
	movq	%rbp, %rdi
	imulq	%r10, %rdi
	imulq	%r11, %r10
	movq	%r11, %rax
	mulq	%r8
	movq	%rax, %r12
	movq	%rdx, %r13
	movq	%r11, %rax
	mulq	%r9
	addq	%rax, %r13
	adcq	%rdx, %r10
	movq	%rbp, %rax
	mulq	%r9
	movq	%rdx, %r9
	addq	%rdi, %r9
	movq	%rax, %rdi
	movq	%rbx, %rax
	mulq	%r8
	addq	%rdi, %r12
	adcq	%rax, %r13
	adcq	%rdx, %r10
	movq	$-4, %r8
	movq	%r10, %rax
	shrq	$2, %rax
	andq	%r10, %r8
	addq	%rax, %r8
	andq	$3, %r10
	addq	%r12, %r8
	adcq	%r13, %r9
	adcq	$0, %r10
	addq	$16, %rcx
	addq	$-16, %rsi
Ljade_aead_chacha20poly1305_amd64_avx$4:
	cmpq	$16, %rsi
	jnb 	Ljade_aead_chacha20poly1305_amd64_avx$5
	cmpq	$0, %rsi
	jbe 	Ljade_aead_chacha20poly1305_amd64_avx$1
	movq	$0, 56(%rsp)
	movq	$0, 64(%rsp)
	movq	$0, %rax
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx$2
Ljade_aead_chacha20poly1305_amd64_avx$3:
	movb	(%rcx,%rax), %dl
	movb	%dl, 56(%rsp,%rax)
	incq	%rax
Ljade_aead_chacha20poly1305_amd64_avx$2:
	cmpq	%rsi, %rax
	jb  	Ljade_aead_chacha20poly1305_amd64_avx$3
	addq	56(%rsp), %r8
	adcq	64(%rsp), %r9
	adcq	$1, %r10
	movq	%rbp, %rcx
	imulq	%r10, %rcx
	imulq	%r11, %r10
	movq	%r11, %rax
	mulq	%r8
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%r11, %rax
	mulq	%r9
	addq	%rax, %rdi
	adcq	%rdx, %r10
	movq	%rbp, %rax
	mulq	%r9
	movq	%rdx, %r9
	addq	%rcx, %r9
	movq	%rax, %rcx
	movq	%rbx, %rax
	mulq	%r8
	addq	%rcx, %rsi
	adcq	%rax, %rdi
	adcq	%rdx, %r10
	movq	$-4, %r8
	movq	%r10, %rax
	shrq	$2, %rax
	andq	%r10, %r8
	addq	%rax, %r8
	andq	$3, %r10
	addq	%rsi, %r8
	adcq	%rdi, %r9
	adcq	$0, %r10
Ljade_aead_chacha20poly1305_amd64_avx$1:
	movq	24(%rsp), %rax
	movq	16(%rsp), %rcx
	addq	%rax, %r8
	adcq	%rcx, %r9
	adcq	$1, %r10
	movq	%rbp, %rcx
	imulq	%r10, %rcx
	imulq	%r11, %r10
	movq	%r11, %rax
	mulq	%r8
	movq	%rax, %rsi
	movq	%rdx, %rdi
	movq	%r11, %rax
	mulq	%r9
	addq	%rax, %rdi
	adcq	%rdx, %r10
	movq	%rbp, %rax
	mulq	%r9
	movq	%rdx, %r9
	addq	%rcx, %r9
	movq	%rax, %rcx
	movq	%rbx, %rax
	mulq	%r8
	addq	%rcx, %rsi
	adcq	%rax, %rdi
	adcq	%rdx, %r10
	movq	$-4, %rax
	movq	%r10, %rcx
	shrq	$2, %rcx
	andq	%r10, %rax
	addq	%rcx, %rax
	andq	$3, %r10
	addq	%rsi, %rax
	adcq	%rdi, %r9
	adcq	$0, %r10
	movq	%rax, %rcx
	movq	%r9, %rdx
	addq	$5, %rcx
	adcq	$0, %rdx
	adcq	$0, %r10
	shrq	$2, %r10
	negq	%r10
	xorq	%rax, %rcx
	xorq	%r9, %rdx
	andq	%r10, %rcx
	andq	%r10, %rdx
	xorq	%rax, %rcx
	xorq	%r9, %rdx
	movq	88(%rsp), %rax
	movq	96(%rsp), %rsi
	addq	%rax, %rcx
	adcq	%rsi, %rdx
	movq	32(%rsp), %rax
	movq	%rcx, (%rax)
	movq	%rdx, 8(%rax)
	movq	$0, %rax
	movq	184(%rsp), %rbx
	movq	192(%rsp), %rbp
	movq	200(%rsp), %r12
	movq	208(%rsp), %r13
	movq	216(%rsp), %r14
	movq	224(%rsp), %r15
	movq	232(%rsp), %rsp
	ret 
L_chacha_v_avx_ic$1:
	vmovdqu	glob_data + 64(%rip), %xmm0
	vmovdqu	glob_data + 48(%rip), %xmm1
	vmovdqu	%xmm0, 16(%rsp)
	vmovdqu	%xmm1, 32(%rsp)
	movl	%eax, 608(%rsp)
	vmovdqu	glob_data + 112(%rip), %xmm0
	vmovdqu	glob_data + 128(%rip), %xmm1
	vmovdqu	glob_data + 144(%rip), %xmm2
	vmovdqu	glob_data + 160(%rip), %xmm3
	vpbroadcastd	(%rcx), %xmm4
	vpbroadcastd	4(%rcx), %xmm5
	vpbroadcastd	8(%rcx), %xmm6
	vpbroadcastd	12(%rcx), %xmm7
	vpbroadcastd	16(%rcx), %xmm8
	vpbroadcastd	20(%rcx), %xmm9
	vpbroadcastd	24(%rcx), %xmm10
	vpbroadcastd	28(%rcx), %xmm11
	vpbroadcastd	608(%rsp), %xmm12
	vpaddd	glob_data + 96(%rip), %xmm12, %xmm12
	vpbroadcastd	(%rdx), %xmm13
	vpbroadcastd	4(%rdx), %xmm14
	vpbroadcastd	8(%rdx), %xmm15
	vmovdqu	%xmm0, 352(%rsp)
	vmovdqu	%xmm1, 368(%rsp)
	vmovdqu	%xmm2, 384(%rsp)
	vmovdqu	%xmm3, 400(%rsp)
	vmovdqu	%xmm4, 416(%rsp)
	vmovdqu	%xmm5, 432(%rsp)
	vmovdqu	%xmm6, 448(%rsp)
	vmovdqu	%xmm7, 464(%rsp)
	vmovdqu	%xmm8, 480(%rsp)
	vmovdqu	%xmm9, 496(%rsp)
	vmovdqu	%xmm10, 512(%rsp)
	vmovdqu	%xmm11, 528(%rsp)
	vmovdqu	%xmm12, 544(%rsp)
	vmovdqu	%xmm13, 560(%rsp)
	vmovdqu	%xmm14, 576(%rsp)
	vmovdqu	%xmm15, 592(%rsp)
	jmp 	L_chacha_v_avx_ic$11
L_chacha_v_avx_ic$12:
	vmovdqu	352(%rsp), %xmm0
	vmovdqu	368(%rsp), %xmm1
	vmovdqu	384(%rsp), %xmm2
	vmovdqu	400(%rsp), %xmm3
	vmovdqu	416(%rsp), %xmm4
	vmovdqu	432(%rsp), %xmm5
	vmovdqu	448(%rsp), %xmm6
	vmovdqu	464(%rsp), %xmm7
	vmovdqu	480(%rsp), %xmm8
	vmovdqu	496(%rsp), %xmm9
	vmovdqu	512(%rsp), %xmm10
	vmovdqu	528(%rsp), %xmm11
	vmovdqu	544(%rsp), %xmm12
	vmovdqu	560(%rsp), %xmm13
	vmovdqu	576(%rsp), %xmm14
	vmovdqu	592(%rsp), %xmm15
	vmovdqu	%xmm15, 48(%rsp)
	movl	$10, %eax
L_chacha_v_avx_ic$13:
	vpaddd	%xmm4, %xmm0, %xmm0
	vpxor	%xmm0, %xmm12, %xmm12
	vpshufb	16(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm8, %xmm8
	vpxor	%xmm8, %xmm4, %xmm4
	vpslld	$12, %xmm4, %xmm15
	vpsrld	$20, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	vpaddd	%xmm4, %xmm0, %xmm0
	vpxor	%xmm0, %xmm12, %xmm12
	vpshufb	32(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm8, %xmm8
	vpxor	%xmm8, %xmm4, %xmm4
	vpslld	$7, %xmm4, %xmm15
	vpsrld	$25, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	vpaddd	%xmm5, %xmm1, %xmm1
	vpxor	%xmm1, %xmm13, %xmm13
	vpshufb	16(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm9, %xmm9
	vpxor	%xmm9, %xmm5, %xmm5
	vpslld	$12, %xmm5, %xmm15
	vpsrld	$20, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vpaddd	%xmm5, %xmm1, %xmm1
	vpxor	%xmm1, %xmm13, %xmm13
	vpshufb	32(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm9, %xmm9
	vpxor	%xmm9, %xmm5, %xmm5
	vpslld	$7, %xmm5, %xmm15
	vpsrld	$25, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vpaddd	%xmm6, %xmm2, %xmm2
	vpxor	%xmm2, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm6, %xmm6
	vpslld	$12, %xmm6, %xmm15
	vpsrld	$20, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vpaddd	%xmm6, %xmm2, %xmm2
	vpxor	%xmm2, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm6, %xmm6
	vpslld	$7, %xmm6, %xmm15
	vpsrld	$25, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vmovdqu	%xmm14, 64(%rsp)
	vmovdqu	48(%rsp), %xmm14
	vpaddd	%xmm7, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm11, %xmm11
	vpxor	%xmm11, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm15
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm11, %xmm11
	vpxor	%xmm11, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm15
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vmovdqu	%xmm14, 80(%rsp)
	vmovdqu	64(%rsp), %xmm14
	vmovdqu	%xmm14, 64(%rsp)
	vmovdqu	80(%rsp), %xmm14
	vpaddd	%xmm5, %xmm0, %xmm0
	vpxor	%xmm0, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm5, %xmm5
	vpslld	$12, %xmm5, %xmm15
	vpsrld	$20, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vpaddd	%xmm5, %xmm0, %xmm0
	vpxor	%xmm0, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm5, %xmm5
	vpslld	$7, %xmm5, %xmm15
	vpsrld	$25, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vmovdqu	%xmm14, 48(%rsp)
	vmovdqu	64(%rsp), %xmm14
	vpaddd	%xmm6, %xmm1, %xmm1
	vpxor	%xmm1, %xmm12, %xmm12
	vpshufb	16(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm11, %xmm11
	vpxor	%xmm11, %xmm6, %xmm6
	vpslld	$12, %xmm6, %xmm15
	vpsrld	$20, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vpaddd	%xmm6, %xmm1, %xmm1
	vpxor	%xmm1, %xmm12, %xmm12
	vpshufb	32(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm11, %xmm11
	vpxor	%xmm11, %xmm6, %xmm6
	vpslld	$7, %xmm6, %xmm15
	vpsrld	$25, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vpaddd	%xmm7, %xmm2, %xmm2
	vpxor	%xmm2, %xmm13, %xmm13
	vpshufb	16(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm15
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm2, %xmm2
	vpxor	%xmm2, %xmm13, %xmm13
	vpshufb	32(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm15
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vpaddd	%xmm4, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm9, %xmm9
	vpxor	%xmm9, %xmm4, %xmm4
	vpslld	$12, %xmm4, %xmm15
	vpsrld	$20, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	vpaddd	%xmm4, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm9, %xmm9
	vpxor	%xmm9, %xmm4, %xmm4
	vpslld	$7, %xmm4, %xmm15
	vpsrld	$25, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_v_avx_ic$13
	vmovdqu	48(%rsp), %xmm15
	vpaddd	352(%rsp), %xmm0, %xmm0
	vpaddd	368(%rsp), %xmm1, %xmm1
	vpaddd	384(%rsp), %xmm2, %xmm2
	vpaddd	400(%rsp), %xmm3, %xmm3
	vpaddd	416(%rsp), %xmm4, %xmm4
	vpaddd	432(%rsp), %xmm5, %xmm5
	vpaddd	448(%rsp), %xmm6, %xmm6
	vpaddd	464(%rsp), %xmm7, %xmm7
	vpaddd	480(%rsp), %xmm8, %xmm8
	vpaddd	496(%rsp), %xmm9, %xmm9
	vpaddd	512(%rsp), %xmm10, %xmm10
	vpaddd	528(%rsp), %xmm11, %xmm11
	vpaddd	544(%rsp), %xmm12, %xmm12
	vpaddd	560(%rsp), %xmm13, %xmm13
	vpaddd	576(%rsp), %xmm14, %xmm14
	vpaddd	592(%rsp), %xmm15, %xmm15
	vmovdqu	%xmm8, 96(%rsp)
	vmovdqu	%xmm9, 112(%rsp)
	vmovdqu	%xmm10, 128(%rsp)
	vmovdqu	%xmm11, 144(%rsp)
	vmovdqu	%xmm12, 160(%rsp)
	vmovdqu	%xmm13, 176(%rsp)
	vmovdqu	%xmm14, 192(%rsp)
	vmovdqu	%xmm15, 208(%rsp)
	vpunpckldq	%xmm1, %xmm0, %xmm8
	vpunpckhdq	%xmm1, %xmm0, %xmm0
	vpunpckldq	%xmm3, %xmm2, %xmm1
	vpunpckhdq	%xmm3, %xmm2, %xmm2
	vpunpckldq	%xmm5, %xmm4, %xmm3
	vpunpckhdq	%xmm5, %xmm4, %xmm4
	vpunpckldq	%xmm7, %xmm6, %xmm5
	vpunpckhdq	%xmm7, %xmm6, %xmm6
	vpunpcklqdq	%xmm1, %xmm8, %xmm7
	vpunpcklqdq	%xmm5, %xmm3, %xmm9
	vpunpckhqdq	%xmm1, %xmm8, %xmm1
	vpunpckhqdq	%xmm5, %xmm3, %xmm3
	vpunpcklqdq	%xmm2, %xmm0, %xmm5
	vpunpcklqdq	%xmm6, %xmm4, %xmm8
	vpunpckhqdq	%xmm2, %xmm0, %xmm0
	vpunpckhqdq	%xmm6, %xmm4, %xmm2
	vmovdqu	%xmm7, (%rdi)
	vmovdqu	%xmm9, 16(%rdi)
	vmovdqu	%xmm1, 64(%rdi)
	vmovdqu	%xmm3, 80(%rdi)
	vmovdqu	%xmm5, 128(%rdi)
	vmovdqu	%xmm8, 144(%rdi)
	vmovdqu	%xmm0, 192(%rdi)
	vmovdqu	%xmm2, 208(%rdi)
	vmovdqu	96(%rsp), %xmm0
	vmovdqu	128(%rsp), %xmm1
	vmovdqu	160(%rsp), %xmm2
	vmovdqu	192(%rsp), %xmm3
	vpunpckldq	112(%rsp), %xmm0, %xmm4
	vpunpckhdq	112(%rsp), %xmm0, %xmm0
	vpunpckldq	144(%rsp), %xmm1, %xmm5
	vpunpckhdq	144(%rsp), %xmm1, %xmm1
	vpunpckldq	176(%rsp), %xmm2, %xmm6
	vpunpckhdq	176(%rsp), %xmm2, %xmm2
	vpunpckldq	208(%rsp), %xmm3, %xmm7
	vpunpckhdq	208(%rsp), %xmm3, %xmm3
	vpunpcklqdq	%xmm5, %xmm4, %xmm8
	vpunpcklqdq	%xmm7, %xmm6, %xmm9
	vpunpckhqdq	%xmm5, %xmm4, %xmm4
	vpunpckhqdq	%xmm7, %xmm6, %xmm5
	vpunpcklqdq	%xmm1, %xmm0, %xmm6
	vpunpcklqdq	%xmm3, %xmm2, %xmm7
	vpunpckhqdq	%xmm1, %xmm0, %xmm0
	vpunpckhqdq	%xmm3, %xmm2, %xmm1
	vmovdqu	%xmm8, 32(%rdi)
	vmovdqu	%xmm9, 48(%rdi)
	vmovdqu	%xmm4, 96(%rdi)
	vmovdqu	%xmm5, 112(%rdi)
	vmovdqu	%xmm6, 160(%rdi)
	vmovdqu	%xmm7, 176(%rdi)
	vmovdqu	%xmm0, 224(%rdi)
	vmovdqu	%xmm1, 240(%rdi)
	addq	$256, %rdi
	addq	$-256, %rsi
	vmovdqu	glob_data + 0(%rip), %xmm0
	vpaddd	544(%rsp), %xmm0, %xmm0
	vmovdqu	%xmm0, 544(%rsp)
L_chacha_v_avx_ic$11:
	cmpq	$256, %rsi
	jnb 	L_chacha_v_avx_ic$12
	cmpq	$0, %rsi
	jbe 	L_chacha_v_avx_ic$2
	vmovdqu	352(%rsp), %xmm0
	vmovdqu	368(%rsp), %xmm1
	vmovdqu	384(%rsp), %xmm2
	vmovdqu	400(%rsp), %xmm3
	vmovdqu	416(%rsp), %xmm4
	vmovdqu	432(%rsp), %xmm5
	vmovdqu	448(%rsp), %xmm6
	vmovdqu	464(%rsp), %xmm7
	vmovdqu	480(%rsp), %xmm8
	vmovdqu	496(%rsp), %xmm9
	vmovdqu	512(%rsp), %xmm10
	vmovdqu	528(%rsp), %xmm11
	vmovdqu	544(%rsp), %xmm12
	vmovdqu	560(%rsp), %xmm13
	vmovdqu	576(%rsp), %xmm14
	vmovdqu	592(%rsp), %xmm15
	vmovdqu	%xmm15, 48(%rsp)
	movl	$10, %eax
L_chacha_v_avx_ic$10:
	vpaddd	%xmm4, %xmm0, %xmm0
	vpxor	%xmm0, %xmm12, %xmm12
	vpshufb	16(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm8, %xmm8
	vpxor	%xmm8, %xmm4, %xmm4
	vpslld	$12, %xmm4, %xmm15
	vpsrld	$20, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	vpaddd	%xmm4, %xmm0, %xmm0
	vpxor	%xmm0, %xmm12, %xmm12
	vpshufb	32(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm8, %xmm8
	vpxor	%xmm8, %xmm4, %xmm4
	vpslld	$7, %xmm4, %xmm15
	vpsrld	$25, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	vpaddd	%xmm5, %xmm1, %xmm1
	vpxor	%xmm1, %xmm13, %xmm13
	vpshufb	16(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm9, %xmm9
	vpxor	%xmm9, %xmm5, %xmm5
	vpslld	$12, %xmm5, %xmm15
	vpsrld	$20, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vpaddd	%xmm5, %xmm1, %xmm1
	vpxor	%xmm1, %xmm13, %xmm13
	vpshufb	32(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm9, %xmm9
	vpxor	%xmm9, %xmm5, %xmm5
	vpslld	$7, %xmm5, %xmm15
	vpsrld	$25, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vpaddd	%xmm6, %xmm2, %xmm2
	vpxor	%xmm2, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm6, %xmm6
	vpslld	$12, %xmm6, %xmm15
	vpsrld	$20, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vpaddd	%xmm6, %xmm2, %xmm2
	vpxor	%xmm2, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm6, %xmm6
	vpslld	$7, %xmm6, %xmm15
	vpsrld	$25, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vmovdqu	%xmm14, 64(%rsp)
	vmovdqu	48(%rsp), %xmm14
	vpaddd	%xmm7, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm11, %xmm11
	vpxor	%xmm11, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm15
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm11, %xmm11
	vpxor	%xmm11, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm15
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vmovdqu	%xmm14, 80(%rsp)
	vmovdqu	64(%rsp), %xmm14
	vmovdqu	%xmm14, 64(%rsp)
	vmovdqu	80(%rsp), %xmm14
	vpaddd	%xmm5, %xmm0, %xmm0
	vpxor	%xmm0, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm5, %xmm5
	vpslld	$12, %xmm5, %xmm15
	vpsrld	$20, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vpaddd	%xmm5, %xmm0, %xmm0
	vpxor	%xmm0, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm5, %xmm5
	vpslld	$7, %xmm5, %xmm15
	vpsrld	$25, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vmovdqu	%xmm14, 48(%rsp)
	vmovdqu	64(%rsp), %xmm14
	vpaddd	%xmm6, %xmm1, %xmm1
	vpxor	%xmm1, %xmm12, %xmm12
	vpshufb	16(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm11, %xmm11
	vpxor	%xmm11, %xmm6, %xmm6
	vpslld	$12, %xmm6, %xmm15
	vpsrld	$20, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vpaddd	%xmm6, %xmm1, %xmm1
	vpxor	%xmm1, %xmm12, %xmm12
	vpshufb	32(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm11, %xmm11
	vpxor	%xmm11, %xmm6, %xmm6
	vpslld	$7, %xmm6, %xmm15
	vpsrld	$25, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vpaddd	%xmm7, %xmm2, %xmm2
	vpxor	%xmm2, %xmm13, %xmm13
	vpshufb	16(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm15
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm2, %xmm2
	vpxor	%xmm2, %xmm13, %xmm13
	vpshufb	32(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm15
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vpaddd	%xmm4, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm9, %xmm9
	vpxor	%xmm9, %xmm4, %xmm4
	vpslld	$12, %xmm4, %xmm15
	vpsrld	$20, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	vpaddd	%xmm4, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm9, %xmm9
	vpxor	%xmm9, %xmm4, %xmm4
	vpslld	$7, %xmm4, %xmm15
	vpsrld	$25, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_v_avx_ic$10
	vmovdqu	48(%rsp), %xmm15
	vpaddd	352(%rsp), %xmm0, %xmm0
	vpaddd	368(%rsp), %xmm1, %xmm1
	vpaddd	384(%rsp), %xmm2, %xmm2
	vpaddd	400(%rsp), %xmm3, %xmm3
	vpaddd	416(%rsp), %xmm4, %xmm4
	vpaddd	432(%rsp), %xmm5, %xmm5
	vpaddd	448(%rsp), %xmm6, %xmm6
	vpaddd	464(%rsp), %xmm7, %xmm7
	vpaddd	480(%rsp), %xmm8, %xmm8
	vpaddd	496(%rsp), %xmm9, %xmm9
	vpaddd	512(%rsp), %xmm10, %xmm10
	vpaddd	528(%rsp), %xmm11, %xmm11
	vpaddd	544(%rsp), %xmm12, %xmm12
	vpaddd	560(%rsp), %xmm13, %xmm13
	vpaddd	576(%rsp), %xmm14, %xmm14
	vpaddd	592(%rsp), %xmm15, %xmm15
	vmovdqu	%xmm8, 96(%rsp)
	vmovdqu	%xmm9, 112(%rsp)
	vmovdqu	%xmm10, 128(%rsp)
	vmovdqu	%xmm11, 144(%rsp)
	vmovdqu	%xmm12, 160(%rsp)
	vmovdqu	%xmm13, 176(%rsp)
	vmovdqu	%xmm14, 192(%rsp)
	vmovdqu	%xmm15, 208(%rsp)
	vpunpckldq	%xmm1, %xmm0, %xmm8
	vpunpckhdq	%xmm1, %xmm0, %xmm0
	vpunpckldq	%xmm3, %xmm2, %xmm1
	vpunpckhdq	%xmm3, %xmm2, %xmm2
	vpunpckldq	%xmm5, %xmm4, %xmm3
	vpunpckhdq	%xmm5, %xmm4, %xmm4
	vpunpckldq	%xmm7, %xmm6, %xmm5
	vpunpckhdq	%xmm7, %xmm6, %xmm6
	vpunpcklqdq	%xmm1, %xmm8, %xmm7
	vpunpcklqdq	%xmm5, %xmm3, %xmm9
	vpunpckhqdq	%xmm1, %xmm8, %xmm1
	vpunpckhqdq	%xmm5, %xmm3, %xmm3
	vpunpcklqdq	%xmm2, %xmm0, %xmm5
	vpunpcklqdq	%xmm6, %xmm4, %xmm8
	vpunpckhqdq	%xmm2, %xmm0, %xmm0
	vpunpckhqdq	%xmm6, %xmm4, %xmm2
	vmovdqu	%xmm7, 224(%rsp)
	vmovdqu	%xmm9, 240(%rsp)
	vmovdqu	%xmm1, 256(%rsp)
	vmovdqu	%xmm3, 272(%rsp)
	vmovdqu	%xmm5, 288(%rsp)
	vmovdqu	%xmm8, 304(%rsp)
	vmovdqu	%xmm0, 320(%rsp)
	vmovdqu	%xmm2, 336(%rsp)
	vmovdqu	96(%rsp), %xmm0
	vmovdqu	128(%rsp), %xmm1
	vmovdqu	160(%rsp), %xmm2
	vmovdqu	192(%rsp), %xmm3
	vpunpckldq	112(%rsp), %xmm0, %xmm4
	vpunpckhdq	112(%rsp), %xmm0, %xmm0
	vpunpckldq	144(%rsp), %xmm1, %xmm5
	vpunpckhdq	144(%rsp), %xmm1, %xmm1
	vpunpckldq	176(%rsp), %xmm2, %xmm6
	vpunpckhdq	176(%rsp), %xmm2, %xmm2
	vpunpckldq	208(%rsp), %xmm3, %xmm7
	vpunpckhdq	208(%rsp), %xmm3, %xmm3
	vpunpcklqdq	%xmm5, %xmm4, %xmm8
	vpunpcklqdq	%xmm7, %xmm6, %xmm9
	vpunpckhqdq	%xmm5, %xmm4, %xmm4
	vpunpckhqdq	%xmm7, %xmm6, %xmm5
	vpunpcklqdq	%xmm1, %xmm0, %xmm6
	vpunpcklqdq	%xmm3, %xmm2, %xmm7
	vpunpckhqdq	%xmm1, %xmm0, %xmm0
	vpunpckhqdq	%xmm3, %xmm2, %xmm1
	vmovdqu	224(%rsp), %xmm10
	vmovdqu	240(%rsp), %xmm11
	vmovdqu	%xmm8, %xmm13
	vmovdqu	%xmm9, %xmm12
	vmovdqu	256(%rsp), %xmm9
	vmovdqu	272(%rsp), %xmm8
	vmovdqu	%xmm4, %xmm3
	vmovdqu	%xmm5, %xmm2
	cmpq	$128, %rsi
	jb  	L_chacha_v_avx_ic$9
	vmovdqu	%xmm10, (%rdi)
	vmovdqu	%xmm11, 16(%rdi)
	vmovdqu	%xmm13, 32(%rdi)
	vmovdqu	%xmm12, 48(%rdi)
	vmovdqu	%xmm9, 64(%rdi)
	vmovdqu	%xmm8, 80(%rdi)
	vmovdqu	%xmm3, 96(%rdi)
	vmovdqu	%xmm2, 112(%rdi)
	addq	$128, %rdi
	addq	$-128, %rsi
	vmovdqu	288(%rsp), %xmm10
	vmovdqu	304(%rsp), %xmm11
	vmovdqu	%xmm6, %xmm13
	vmovdqu	%xmm7, %xmm12
	vmovdqu	320(%rsp), %xmm9
	vmovdqu	336(%rsp), %xmm8
	vmovdqu	%xmm0, %xmm3
	vmovdqu	%xmm1, %xmm2
L_chacha_v_avx_ic$9:
	cmpq	$64, %rsi
	jb  	L_chacha_v_avx_ic$8
	vmovdqu	%xmm10, (%rdi)
	vmovdqu	%xmm11, 16(%rdi)
	vmovdqu	%xmm13, 32(%rdi)
	vmovdqu	%xmm12, 48(%rdi)
	addq	$64, %rdi
	addq	$-64, %rsi
	vmovdqu	%xmm9, %xmm10
	vmovdqu	%xmm8, %xmm11
	vmovdqu	%xmm3, %xmm13
	vmovdqu	%xmm2, %xmm12
L_chacha_v_avx_ic$8:
	cmpq	$32, %rsi
	jb  	L_chacha_v_avx_ic$7
	vmovdqu	%xmm10, (%rdi)
	vmovdqu	%xmm11, 16(%rdi)
	addq	$32, %rdi
	addq	$-32, %rsi
	vmovdqu	%xmm13, %xmm10
	vmovdqu	%xmm12, %xmm11
L_chacha_v_avx_ic$7:
	cmpq	$16, %rsi
	jb  	L_chacha_v_avx_ic$6
	vmovdqu	%xmm10, (%rdi)
	addq	$16, %rdi
	addq	$-16, %rsi
	vmovdqu	%xmm11, %xmm10
L_chacha_v_avx_ic$6:
	vpextrq	$0, %xmm10, %rax
	cmpq	$8, %rsi
	jb  	L_chacha_v_avx_ic$3
	movq	%rax, (%rdi)
	addq	$8, %rdi
	addq	$-8, %rsi
	vpextrq	$1, %xmm10, %rax
L_chacha_v_avx_ic$5:
	jmp 	L_chacha_v_avx_ic$3
L_chacha_v_avx_ic$4:
	movb	%al, %cl
	movb	%cl, (%rdi)
	shrq	$8, %rax
	incq	%rdi
	addq	$-1, %rsi
L_chacha_v_avx_ic$3:
	cmpq	$0, %rsi
	jnbe	L_chacha_v_avx_ic$4
L_chacha_v_avx_ic$2:
	ret 
L_chacha_xor_v_avx_ic$1:
	vmovdqu	glob_data + 64(%rip), %xmm0
	vmovdqu	glob_data + 48(%rip), %xmm1
	vmovdqu	%xmm0, 16(%rsp)
	vmovdqu	%xmm1, 32(%rsp)
	movl	%edx, 608(%rsp)
	vmovdqu	glob_data + 112(%rip), %xmm0
	vmovdqu	glob_data + 128(%rip), %xmm1
	vmovdqu	glob_data + 144(%rip), %xmm2
	vmovdqu	glob_data + 160(%rip), %xmm3
	vpbroadcastd	(%r9), %xmm4
	vpbroadcastd	4(%r9), %xmm5
	vpbroadcastd	8(%r9), %xmm6
	vpbroadcastd	12(%r9), %xmm7
	vpbroadcastd	16(%r9), %xmm8
	vpbroadcastd	20(%r9), %xmm9
	vpbroadcastd	24(%r9), %xmm10
	vpbroadcastd	28(%r9), %xmm11
	vpbroadcastd	608(%rsp), %xmm12
	vpaddd	glob_data + 96(%rip), %xmm12, %xmm12
	vpbroadcastd	(%rax), %xmm13
	vpbroadcastd	4(%rax), %xmm14
	vpbroadcastd	8(%rax), %xmm15
	vmovdqu	%xmm0, 352(%rsp)
	vmovdqu	%xmm1, 368(%rsp)
	vmovdqu	%xmm2, 384(%rsp)
	vmovdqu	%xmm3, 400(%rsp)
	vmovdqu	%xmm4, 416(%rsp)
	vmovdqu	%xmm5, 432(%rsp)
	vmovdqu	%xmm6, 448(%rsp)
	vmovdqu	%xmm7, 464(%rsp)
	vmovdqu	%xmm8, 480(%rsp)
	vmovdqu	%xmm9, 496(%rsp)
	vmovdqu	%xmm10, 512(%rsp)
	vmovdqu	%xmm11, 528(%rsp)
	vmovdqu	%xmm12, 544(%rsp)
	vmovdqu	%xmm13, 560(%rsp)
	vmovdqu	%xmm14, 576(%rsp)
	vmovdqu	%xmm15, 592(%rsp)
	jmp 	L_chacha_xor_v_avx_ic$11
L_chacha_xor_v_avx_ic$12:
	vmovdqu	352(%rsp), %xmm0
	vmovdqu	368(%rsp), %xmm1
	vmovdqu	384(%rsp), %xmm2
	vmovdqu	400(%rsp), %xmm3
	vmovdqu	416(%rsp), %xmm4
	vmovdqu	432(%rsp), %xmm5
	vmovdqu	448(%rsp), %xmm6
	vmovdqu	464(%rsp), %xmm7
	vmovdqu	480(%rsp), %xmm8
	vmovdqu	496(%rsp), %xmm9
	vmovdqu	512(%rsp), %xmm10
	vmovdqu	528(%rsp), %xmm11
	vmovdqu	544(%rsp), %xmm12
	vmovdqu	560(%rsp), %xmm13
	vmovdqu	576(%rsp), %xmm14
	vmovdqu	592(%rsp), %xmm15
	vmovdqu	%xmm15, 48(%rsp)
	movl	$10, %eax
L_chacha_xor_v_avx_ic$13:
	vpaddd	%xmm4, %xmm0, %xmm0
	vpxor	%xmm0, %xmm12, %xmm12
	vpshufb	16(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm8, %xmm8
	vpxor	%xmm8, %xmm4, %xmm4
	vpslld	$12, %xmm4, %xmm15
	vpsrld	$20, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	vpaddd	%xmm4, %xmm0, %xmm0
	vpxor	%xmm0, %xmm12, %xmm12
	vpshufb	32(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm8, %xmm8
	vpxor	%xmm8, %xmm4, %xmm4
	vpslld	$7, %xmm4, %xmm15
	vpsrld	$25, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	vpaddd	%xmm5, %xmm1, %xmm1
	vpxor	%xmm1, %xmm13, %xmm13
	vpshufb	16(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm9, %xmm9
	vpxor	%xmm9, %xmm5, %xmm5
	vpslld	$12, %xmm5, %xmm15
	vpsrld	$20, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vpaddd	%xmm5, %xmm1, %xmm1
	vpxor	%xmm1, %xmm13, %xmm13
	vpshufb	32(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm9, %xmm9
	vpxor	%xmm9, %xmm5, %xmm5
	vpslld	$7, %xmm5, %xmm15
	vpsrld	$25, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vpaddd	%xmm6, %xmm2, %xmm2
	vpxor	%xmm2, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm6, %xmm6
	vpslld	$12, %xmm6, %xmm15
	vpsrld	$20, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vpaddd	%xmm6, %xmm2, %xmm2
	vpxor	%xmm2, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm6, %xmm6
	vpslld	$7, %xmm6, %xmm15
	vpsrld	$25, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vmovdqu	%xmm14, 64(%rsp)
	vmovdqu	48(%rsp), %xmm14
	vpaddd	%xmm7, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm11, %xmm11
	vpxor	%xmm11, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm15
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm11, %xmm11
	vpxor	%xmm11, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm15
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vmovdqu	%xmm14, 80(%rsp)
	vmovdqu	64(%rsp), %xmm14
	vmovdqu	%xmm14, 64(%rsp)
	vmovdqu	80(%rsp), %xmm14
	vpaddd	%xmm5, %xmm0, %xmm0
	vpxor	%xmm0, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm5, %xmm5
	vpslld	$12, %xmm5, %xmm15
	vpsrld	$20, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vpaddd	%xmm5, %xmm0, %xmm0
	vpxor	%xmm0, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm5, %xmm5
	vpslld	$7, %xmm5, %xmm15
	vpsrld	$25, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vmovdqu	%xmm14, 48(%rsp)
	vmovdqu	64(%rsp), %xmm14
	vpaddd	%xmm6, %xmm1, %xmm1
	vpxor	%xmm1, %xmm12, %xmm12
	vpshufb	16(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm11, %xmm11
	vpxor	%xmm11, %xmm6, %xmm6
	vpslld	$12, %xmm6, %xmm15
	vpsrld	$20, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vpaddd	%xmm6, %xmm1, %xmm1
	vpxor	%xmm1, %xmm12, %xmm12
	vpshufb	32(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm11, %xmm11
	vpxor	%xmm11, %xmm6, %xmm6
	vpslld	$7, %xmm6, %xmm15
	vpsrld	$25, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vpaddd	%xmm7, %xmm2, %xmm2
	vpxor	%xmm2, %xmm13, %xmm13
	vpshufb	16(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm15
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm2, %xmm2
	vpxor	%xmm2, %xmm13, %xmm13
	vpshufb	32(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm15
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vpaddd	%xmm4, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm9, %xmm9
	vpxor	%xmm9, %xmm4, %xmm4
	vpslld	$12, %xmm4, %xmm15
	vpsrld	$20, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	vpaddd	%xmm4, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm9, %xmm9
	vpxor	%xmm9, %xmm4, %xmm4
	vpslld	$7, %xmm4, %xmm15
	vpsrld	$25, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_xor_v_avx_ic$13
	vmovdqu	48(%rsp), %xmm15
	vpaddd	352(%rsp), %xmm0, %xmm0
	vpaddd	368(%rsp), %xmm1, %xmm1
	vpaddd	384(%rsp), %xmm2, %xmm2
	vpaddd	400(%rsp), %xmm3, %xmm3
	vpaddd	416(%rsp), %xmm4, %xmm4
	vpaddd	432(%rsp), %xmm5, %xmm5
	vpaddd	448(%rsp), %xmm6, %xmm6
	vpaddd	464(%rsp), %xmm7, %xmm7
	vpaddd	480(%rsp), %xmm8, %xmm8
	vpaddd	496(%rsp), %xmm9, %xmm9
	vpaddd	512(%rsp), %xmm10, %xmm10
	vpaddd	528(%rsp), %xmm11, %xmm11
	vpaddd	544(%rsp), %xmm12, %xmm12
	vpaddd	560(%rsp), %xmm13, %xmm13
	vpaddd	576(%rsp), %xmm14, %xmm14
	vpaddd	592(%rsp), %xmm15, %xmm15
	vmovdqu	%xmm8, 96(%rsp)
	vmovdqu	%xmm9, 112(%rsp)
	vmovdqu	%xmm10, 128(%rsp)
	vmovdqu	%xmm11, 144(%rsp)
	vmovdqu	%xmm12, 160(%rsp)
	vmovdqu	%xmm13, 176(%rsp)
	vmovdqu	%xmm14, 192(%rsp)
	vmovdqu	%xmm15, 208(%rsp)
	vpunpckldq	%xmm1, %xmm0, %xmm8
	vpunpckhdq	%xmm1, %xmm0, %xmm0
	vpunpckldq	%xmm3, %xmm2, %xmm1
	vpunpckhdq	%xmm3, %xmm2, %xmm2
	vpunpckldq	%xmm5, %xmm4, %xmm3
	vpunpckhdq	%xmm5, %xmm4, %xmm4
	vpunpckldq	%xmm7, %xmm6, %xmm5
	vpunpckhdq	%xmm7, %xmm6, %xmm6
	vpunpcklqdq	%xmm1, %xmm8, %xmm7
	vpunpcklqdq	%xmm5, %xmm3, %xmm9
	vpunpckhqdq	%xmm1, %xmm8, %xmm1
	vpunpckhqdq	%xmm5, %xmm3, %xmm3
	vpunpcklqdq	%xmm2, %xmm0, %xmm5
	vpunpcklqdq	%xmm6, %xmm4, %xmm8
	vpunpckhqdq	%xmm2, %xmm0, %xmm0
	vpunpckhqdq	%xmm6, %xmm4, %xmm2
	vpxor	(%r10), %xmm7, %xmm4
	vpxor	16(%r10), %xmm9, %xmm6
	vpxor	64(%r10), %xmm1, %xmm1
	vpxor	80(%r10), %xmm3, %xmm3
	vpxor	128(%r10), %xmm5, %xmm5
	vpxor	144(%r10), %xmm8, %xmm7
	vpxor	192(%r10), %xmm0, %xmm0
	vpxor	208(%r10), %xmm2, %xmm2
	vmovdqu	%xmm4, (%r11)
	vmovdqu	%xmm6, 16(%r11)
	vmovdqu	%xmm1, 64(%r11)
	vmovdqu	%xmm3, 80(%r11)
	vmovdqu	%xmm5, 128(%r11)
	vmovdqu	%xmm7, 144(%r11)
	vmovdqu	%xmm0, 192(%r11)
	vmovdqu	%xmm2, 208(%r11)
	vmovdqu	96(%rsp), %xmm0
	vmovdqu	128(%rsp), %xmm1
	vmovdqu	160(%rsp), %xmm2
	vmovdqu	192(%rsp), %xmm3
	vpunpckldq	112(%rsp), %xmm0, %xmm4
	vpunpckhdq	112(%rsp), %xmm0, %xmm0
	vpunpckldq	144(%rsp), %xmm1, %xmm5
	vpunpckhdq	144(%rsp), %xmm1, %xmm1
	vpunpckldq	176(%rsp), %xmm2, %xmm6
	vpunpckhdq	176(%rsp), %xmm2, %xmm2
	vpunpckldq	208(%rsp), %xmm3, %xmm7
	vpunpckhdq	208(%rsp), %xmm3, %xmm3
	vpunpcklqdq	%xmm5, %xmm4, %xmm8
	vpunpcklqdq	%xmm7, %xmm6, %xmm9
	vpunpckhqdq	%xmm5, %xmm4, %xmm4
	vpunpckhqdq	%xmm7, %xmm6, %xmm5
	vpunpcklqdq	%xmm1, %xmm0, %xmm6
	vpunpcklqdq	%xmm3, %xmm2, %xmm7
	vpunpckhqdq	%xmm1, %xmm0, %xmm0
	vpunpckhqdq	%xmm3, %xmm2, %xmm1
	vpxor	32(%r10), %xmm8, %xmm2
	vpxor	48(%r10), %xmm9, %xmm3
	vpxor	96(%r10), %xmm4, %xmm4
	vpxor	112(%r10), %xmm5, %xmm5
	vpxor	160(%r10), %xmm6, %xmm6
	vpxor	176(%r10), %xmm7, %xmm7
	vpxor	224(%r10), %xmm0, %xmm0
	vpxor	240(%r10), %xmm1, %xmm1
	vmovdqu	%xmm2, 32(%r11)
	vmovdqu	%xmm3, 48(%r11)
	vmovdqu	%xmm4, 96(%r11)
	vmovdqu	%xmm5, 112(%r11)
	vmovdqu	%xmm6, 160(%r11)
	vmovdqu	%xmm7, 176(%r11)
	vmovdqu	%xmm0, 224(%r11)
	vmovdqu	%xmm1, 240(%r11)
	addq	$256, %r11
	addq	$256, %r10
	addq	$-256, %rcx
	vmovdqu	glob_data + 0(%rip), %xmm0
	vpaddd	544(%rsp), %xmm0, %xmm0
	vmovdqu	%xmm0, 544(%rsp)
L_chacha_xor_v_avx_ic$11:
	cmpq	$256, %rcx
	jnb 	L_chacha_xor_v_avx_ic$12
	cmpq	$0, %rcx
	jbe 	L_chacha_xor_v_avx_ic$2
	vmovdqu	352(%rsp), %xmm0
	vmovdqu	368(%rsp), %xmm1
	vmovdqu	384(%rsp), %xmm2
	vmovdqu	400(%rsp), %xmm3
	vmovdqu	416(%rsp), %xmm4
	vmovdqu	432(%rsp), %xmm5
	vmovdqu	448(%rsp), %xmm6
	vmovdqu	464(%rsp), %xmm7
	vmovdqu	480(%rsp), %xmm8
	vmovdqu	496(%rsp), %xmm9
	vmovdqu	512(%rsp), %xmm10
	vmovdqu	528(%rsp), %xmm11
	vmovdqu	544(%rsp), %xmm12
	vmovdqu	560(%rsp), %xmm13
	vmovdqu	576(%rsp), %xmm14
	vmovdqu	592(%rsp), %xmm15
	vmovdqu	%xmm15, 48(%rsp)
	movl	$10, %eax
L_chacha_xor_v_avx_ic$10:
	vpaddd	%xmm4, %xmm0, %xmm0
	vpxor	%xmm0, %xmm12, %xmm12
	vpshufb	16(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm8, %xmm8
	vpxor	%xmm8, %xmm4, %xmm4
	vpslld	$12, %xmm4, %xmm15
	vpsrld	$20, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	vpaddd	%xmm4, %xmm0, %xmm0
	vpxor	%xmm0, %xmm12, %xmm12
	vpshufb	32(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm8, %xmm8
	vpxor	%xmm8, %xmm4, %xmm4
	vpslld	$7, %xmm4, %xmm15
	vpsrld	$25, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	vpaddd	%xmm5, %xmm1, %xmm1
	vpxor	%xmm1, %xmm13, %xmm13
	vpshufb	16(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm9, %xmm9
	vpxor	%xmm9, %xmm5, %xmm5
	vpslld	$12, %xmm5, %xmm15
	vpsrld	$20, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vpaddd	%xmm5, %xmm1, %xmm1
	vpxor	%xmm1, %xmm13, %xmm13
	vpshufb	32(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm9, %xmm9
	vpxor	%xmm9, %xmm5, %xmm5
	vpslld	$7, %xmm5, %xmm15
	vpsrld	$25, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vpaddd	%xmm6, %xmm2, %xmm2
	vpxor	%xmm2, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm6, %xmm6
	vpslld	$12, %xmm6, %xmm15
	vpsrld	$20, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vpaddd	%xmm6, %xmm2, %xmm2
	vpxor	%xmm2, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm6, %xmm6
	vpslld	$7, %xmm6, %xmm15
	vpsrld	$25, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vmovdqu	%xmm14, 64(%rsp)
	vmovdqu	48(%rsp), %xmm14
	vpaddd	%xmm7, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm11, %xmm11
	vpxor	%xmm11, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm15
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm11, %xmm11
	vpxor	%xmm11, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm15
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vmovdqu	%xmm14, 80(%rsp)
	vmovdqu	64(%rsp), %xmm14
	vmovdqu	%xmm14, 64(%rsp)
	vmovdqu	80(%rsp), %xmm14
	vpaddd	%xmm5, %xmm0, %xmm0
	vpxor	%xmm0, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm5, %xmm5
	vpslld	$12, %xmm5, %xmm15
	vpsrld	$20, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vpaddd	%xmm5, %xmm0, %xmm0
	vpxor	%xmm0, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm10, %xmm10
	vpxor	%xmm10, %xmm5, %xmm5
	vpslld	$7, %xmm5, %xmm15
	vpsrld	$25, %xmm5, %xmm5
	vpxor	%xmm15, %xmm5, %xmm5
	vmovdqu	%xmm14, 48(%rsp)
	vmovdqu	64(%rsp), %xmm14
	vpaddd	%xmm6, %xmm1, %xmm1
	vpxor	%xmm1, %xmm12, %xmm12
	vpshufb	16(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm11, %xmm11
	vpxor	%xmm11, %xmm6, %xmm6
	vpslld	$12, %xmm6, %xmm15
	vpsrld	$20, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vpaddd	%xmm6, %xmm1, %xmm1
	vpxor	%xmm1, %xmm12, %xmm12
	vpshufb	32(%rsp), %xmm12, %xmm12
	vpaddd	%xmm12, %xmm11, %xmm11
	vpxor	%xmm11, %xmm6, %xmm6
	vpslld	$7, %xmm6, %xmm15
	vpsrld	$25, %xmm6, %xmm6
	vpxor	%xmm15, %xmm6, %xmm6
	vpaddd	%xmm7, %xmm2, %xmm2
	vpxor	%xmm2, %xmm13, %xmm13
	vpshufb	16(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm15
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm2, %xmm2
	vpxor	%xmm2, %xmm13, %xmm13
	vpshufb	32(%rsp), %xmm13, %xmm13
	vpaddd	%xmm13, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm15
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm15, %xmm7, %xmm7
	vpaddd	%xmm4, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	16(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm9, %xmm9
	vpxor	%xmm9, %xmm4, %xmm4
	vpslld	$12, %xmm4, %xmm15
	vpsrld	$20, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	vpaddd	%xmm4, %xmm3, %xmm3
	vpxor	%xmm3, %xmm14, %xmm14
	vpshufb	32(%rsp), %xmm14, %xmm14
	vpaddd	%xmm14, %xmm9, %xmm9
	vpxor	%xmm9, %xmm4, %xmm4
	vpslld	$7, %xmm4, %xmm15
	vpsrld	$25, %xmm4, %xmm4
	vpxor	%xmm15, %xmm4, %xmm4
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_xor_v_avx_ic$10
	vmovdqu	48(%rsp), %xmm15
	vpaddd	352(%rsp), %xmm0, %xmm0
	vpaddd	368(%rsp), %xmm1, %xmm1
	vpaddd	384(%rsp), %xmm2, %xmm2
	vpaddd	400(%rsp), %xmm3, %xmm3
	vpaddd	416(%rsp), %xmm4, %xmm4
	vpaddd	432(%rsp), %xmm5, %xmm5
	vpaddd	448(%rsp), %xmm6, %xmm6
	vpaddd	464(%rsp), %xmm7, %xmm7
	vpaddd	480(%rsp), %xmm8, %xmm8
	vpaddd	496(%rsp), %xmm9, %xmm9
	vpaddd	512(%rsp), %xmm10, %xmm10
	vpaddd	528(%rsp), %xmm11, %xmm11
	vpaddd	544(%rsp), %xmm12, %xmm12
	vpaddd	560(%rsp), %xmm13, %xmm13
	vpaddd	576(%rsp), %xmm14, %xmm14
	vpaddd	592(%rsp), %xmm15, %xmm15
	vmovdqu	%xmm8, 96(%rsp)
	vmovdqu	%xmm9, 112(%rsp)
	vmovdqu	%xmm10, 128(%rsp)
	vmovdqu	%xmm11, 144(%rsp)
	vmovdqu	%xmm12, 160(%rsp)
	vmovdqu	%xmm13, 176(%rsp)
	vmovdqu	%xmm14, 192(%rsp)
	vmovdqu	%xmm15, 208(%rsp)
	vpunpckldq	%xmm1, %xmm0, %xmm8
	vpunpckhdq	%xmm1, %xmm0, %xmm0
	vpunpckldq	%xmm3, %xmm2, %xmm1
	vpunpckhdq	%xmm3, %xmm2, %xmm2
	vpunpckldq	%xmm5, %xmm4, %xmm3
	vpunpckhdq	%xmm5, %xmm4, %xmm4
	vpunpckldq	%xmm7, %xmm6, %xmm5
	vpunpckhdq	%xmm7, %xmm6, %xmm6
	vpunpcklqdq	%xmm1, %xmm8, %xmm7
	vpunpcklqdq	%xmm5, %xmm3, %xmm9
	vpunpckhqdq	%xmm1, %xmm8, %xmm1
	vpunpckhqdq	%xmm5, %xmm3, %xmm3
	vpunpcklqdq	%xmm2, %xmm0, %xmm5
	vpunpcklqdq	%xmm6, %xmm4, %xmm8
	vpunpckhqdq	%xmm2, %xmm0, %xmm0
	vpunpckhqdq	%xmm6, %xmm4, %xmm2
	vmovdqu	%xmm7, 224(%rsp)
	vmovdqu	%xmm9, 240(%rsp)
	vmovdqu	%xmm1, 256(%rsp)
	vmovdqu	%xmm3, 272(%rsp)
	vmovdqu	%xmm5, 288(%rsp)
	vmovdqu	%xmm8, 304(%rsp)
	vmovdqu	%xmm0, 320(%rsp)
	vmovdqu	%xmm2, 336(%rsp)
	vmovdqu	96(%rsp), %xmm0
	vmovdqu	128(%rsp), %xmm1
	vmovdqu	160(%rsp), %xmm2
	vmovdqu	192(%rsp), %xmm3
	vpunpckldq	112(%rsp), %xmm0, %xmm4
	vpunpckhdq	112(%rsp), %xmm0, %xmm0
	vpunpckldq	144(%rsp), %xmm1, %xmm5
	vpunpckhdq	144(%rsp), %xmm1, %xmm1
	vpunpckldq	176(%rsp), %xmm2, %xmm6
	vpunpckhdq	176(%rsp), %xmm2, %xmm2
	vpunpckldq	208(%rsp), %xmm3, %xmm7
	vpunpckhdq	208(%rsp), %xmm3, %xmm3
	vpunpcklqdq	%xmm5, %xmm4, %xmm8
	vpunpcklqdq	%xmm7, %xmm6, %xmm9
	vpunpckhqdq	%xmm5, %xmm4, %xmm4
	vpunpckhqdq	%xmm7, %xmm6, %xmm5
	vpunpcklqdq	%xmm1, %xmm0, %xmm6
	vpunpcklqdq	%xmm3, %xmm2, %xmm7
	vpunpckhqdq	%xmm1, %xmm0, %xmm0
	vpunpckhqdq	%xmm3, %xmm2, %xmm1
	vmovdqu	224(%rsp), %xmm2
	vmovdqu	240(%rsp), %xmm10
	vmovdqu	%xmm8, %xmm12
	vmovdqu	%xmm9, %xmm11
	vmovdqu	256(%rsp), %xmm9
	vmovdqu	272(%rsp), %xmm8
	vmovdqu	%xmm5, %xmm3
	cmpq	$128, %rcx
	jb  	L_chacha_xor_v_avx_ic$9
	vpxor	(%r10), %xmm2, %xmm2
	vmovdqu	%xmm2, (%r11)
	vpxor	16(%r10), %xmm10, %xmm2
	vmovdqu	%xmm2, 16(%r11)
	vpxor	32(%r10), %xmm12, %xmm2
	vmovdqu	%xmm2, 32(%r11)
	vpxor	48(%r10), %xmm11, %xmm2
	vmovdqu	%xmm2, 48(%r11)
	vpxor	64(%r10), %xmm9, %xmm2
	vmovdqu	%xmm2, 64(%r11)
	vpxor	80(%r10), %xmm8, %xmm2
	vmovdqu	%xmm2, 80(%r11)
	vpxor	96(%r10), %xmm4, %xmm2
	vmovdqu	%xmm2, 96(%r11)
	vpxor	112(%r10), %xmm3, %xmm2
	vmovdqu	%xmm2, 112(%r11)
	addq	$128, %r11
	addq	$128, %r10
	addq	$-128, %rcx
	vmovdqu	288(%rsp), %xmm2
	vmovdqu	304(%rsp), %xmm10
	vmovdqu	%xmm6, %xmm12
	vmovdqu	%xmm7, %xmm11
	vmovdqu	320(%rsp), %xmm9
	vmovdqu	336(%rsp), %xmm8
	vmovdqu	%xmm0, %xmm4
	vmovdqu	%xmm1, %xmm3
L_chacha_xor_v_avx_ic$9:
	cmpq	$64, %rcx
	jb  	L_chacha_xor_v_avx_ic$8
	vpxor	(%r10), %xmm2, %xmm0
	vmovdqu	%xmm0, (%r11)
	vpxor	16(%r10), %xmm10, %xmm0
	vmovdqu	%xmm0, 16(%r11)
	vpxor	32(%r10), %xmm12, %xmm0
	vmovdqu	%xmm0, 32(%r11)
	vpxor	48(%r10), %xmm11, %xmm0
	vmovdqu	%xmm0, 48(%r11)
	addq	$64, %r11
	addq	$64, %r10
	addq	$-64, %rcx
	vmovdqu	%xmm9, %xmm2
	vmovdqu	%xmm8, %xmm10
	vmovdqu	%xmm4, %xmm12
	vmovdqu	%xmm3, %xmm11
L_chacha_xor_v_avx_ic$8:
	cmpq	$32, %rcx
	jb  	L_chacha_xor_v_avx_ic$7
	vpxor	(%r10), %xmm2, %xmm0
	vmovdqu	%xmm0, (%r11)
	vpxor	16(%r10), %xmm10, %xmm0
	vmovdqu	%xmm0, 16(%r11)
	addq	$32, %r11
	addq	$32, %r10
	addq	$-32, %rcx
	vmovdqu	%xmm12, %xmm2
	vmovdqu	%xmm11, %xmm10
L_chacha_xor_v_avx_ic$7:
	cmpq	$16, %rcx
	jb  	L_chacha_xor_v_avx_ic$6
	vpxor	(%r10), %xmm2, %xmm0
	vmovdqu	%xmm0, (%r11)
	addq	$16, %r11
	addq	$16, %r10
	addq	$-16, %rcx
	vmovdqu	%xmm10, %xmm2
L_chacha_xor_v_avx_ic$6:
	vpextrq	$0, %xmm2, %rax
	cmpq	$8, %rcx
	jb  	L_chacha_xor_v_avx_ic$3
	xorq	(%r10), %rax
	movq	%rax, (%r11)
	addq	$8, %r11
	addq	$8, %r10
	addq	$-8, %rcx
	vpextrq	$1, %xmm2, %rax
L_chacha_xor_v_avx_ic$5:
	jmp 	L_chacha_xor_v_avx_ic$3
L_chacha_xor_v_avx_ic$4:
	movb	%al, %dl
	xorb	(%r10), %dl
	movb	%dl, (%r11)
	shrq	$8, %rax
	incq	%r11
	incq	%r10
	addq	$-1, %rcx
L_chacha_xor_v_avx_ic$3:
	cmpq	$0, %rcx
	jnbe	L_chacha_xor_v_avx_ic$4
L_chacha_xor_v_avx_ic$2:
	ret 
L_chacha_h_x2_avx_ic$1:
	vmovdqu	glob_data + 64(%rip), %xmm0
	vmovdqu	glob_data + 48(%rip), %xmm1
	vmovdqu	glob_data + 208(%rip), %xmm2
	vmovdqu	(%rax), %xmm3
	vmovdqu	16(%rax), %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpinsrd	$0, %ecx, %xmm5, %xmm5
	vpinsrd	$1, (%rdx), %xmm5, %xmm5
	vpinsrq	$1, 4(%rdx), %xmm5, %xmm5
	jmp 	L_chacha_h_x2_avx_ic$16
L_chacha_h_x2_avx_ic$17:
	vmovdqu	%xmm2, %xmm6
	vmovdqu	%xmm3, %xmm7
	vmovdqu	%xmm4, %xmm8
	vmovdqu	%xmm5, %xmm9
	vmovdqu	%xmm2, %xmm10
	vmovdqu	%xmm3, %xmm11
	vmovdqu	%xmm4, %xmm12
	vmovdqu	%xmm5, %xmm13
	vpaddd	glob_data + 32(%rip), %xmm13, %xmm13
	movl	$10, %eax
L_chacha_h_x2_avx_ic$18:
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm0, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm14
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$12, %xmm11, %xmm14
	vpsrld	$20, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm1, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm14
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$7, %xmm11, %xmm14
	vpsrld	$25, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpshufd	$57, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$-109, %xmm9, %xmm9
	vpshufd	$57, %xmm11, %xmm11
	vpshufd	$78, %xmm12, %xmm12
	vpshufd	$-109, %xmm13, %xmm13
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm0, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm14
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$12, %xmm11, %xmm14
	vpsrld	$20, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm1, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm14
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$7, %xmm11, %xmm14
	vpsrld	$25, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpshufd	$-109, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$57, %xmm9, %xmm9
	vpshufd	$-109, %xmm11, %xmm11
	vpshufd	$78, %xmm12, %xmm12
	vpshufd	$57, %xmm13, %xmm13
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_h_x2_avx_ic$18
	vpaddd	%xmm2, %xmm6, %xmm6
	vpaddd	%xmm3, %xmm7, %xmm7
	vpaddd	%xmm4, %xmm8, %xmm8
	vpaddd	%xmm5, %xmm9, %xmm9
	vpaddd	%xmm2, %xmm10, %xmm10
	vpaddd	%xmm3, %xmm11, %xmm11
	vpaddd	%xmm4, %xmm12, %xmm12
	vpaddd	%xmm5, %xmm13, %xmm13
	vpaddd	glob_data + 32(%rip), %xmm13, %xmm13
	vmovdqu	%xmm6, (%rdi)
	vmovdqu	%xmm7, 16(%rdi)
	vmovdqu	%xmm8, 32(%rdi)
	vmovdqu	%xmm9, 48(%rdi)
	vmovdqu	%xmm10, 64(%rdi)
	vmovdqu	%xmm11, 80(%rdi)
	vmovdqu	%xmm12, 96(%rdi)
	vmovdqu	%xmm13, 112(%rdi)
	addq	$128, %rdi
	addq	$-128, %rsi
	vpaddd	glob_data + 16(%rip), %xmm5, %xmm5
L_chacha_h_x2_avx_ic$16:
	cmpq	$128, %rsi
	jnb 	L_chacha_h_x2_avx_ic$17
	cmpq	$64, %rsi
	jnbe	L_chacha_h_x2_avx_ic$2
	vmovdqu	%xmm2, %xmm6
	vmovdqu	%xmm3, %xmm7
	vmovdqu	%xmm4, %xmm8
	vmovdqu	%xmm5, %xmm9
	movl	$10, %eax
L_chacha_h_x2_avx_ic$15:
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm10
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm10
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpshufd	$57, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$-109, %xmm9, %xmm9
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm10
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm10
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpshufd	$-109, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$57, %xmm9, %xmm9
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_h_x2_avx_ic$15
	vpaddd	%xmm2, %xmm6, %xmm6
	vpaddd	%xmm3, %xmm7, %xmm2
	vpaddd	%xmm4, %xmm8, %xmm0
	vpaddd	%xmm5, %xmm9, %xmm1
	cmpq	$32, %rsi
	jb  	L_chacha_h_x2_avx_ic$14
	vmovdqu	%xmm6, (%rdi)
	vmovdqu	%xmm2, 16(%rdi)
	addq	$32, %rdi
	addq	$-32, %rsi
	vmovdqu	%xmm0, %xmm6
	vmovdqu	%xmm1, %xmm2
L_chacha_h_x2_avx_ic$14:
	cmpq	$16, %rsi
	jb  	L_chacha_h_x2_avx_ic$13
	vmovdqu	%xmm6, (%rdi)
	addq	$16, %rdi
	addq	$-16, %rsi
	vmovdqu	%xmm2, %xmm6
L_chacha_h_x2_avx_ic$13:
	vpextrq	$0, %xmm6, %rax
	cmpq	$8, %rsi
	jb  	L_chacha_h_x2_avx_ic$10
	movq	%rax, (%rdi)
	addq	$8, %rdi
	addq	$-8, %rsi
	vpextrq	$1, %xmm6, %rax
L_chacha_h_x2_avx_ic$12:
	jmp 	L_chacha_h_x2_avx_ic$10
L_chacha_h_x2_avx_ic$11:
	movb	%al, %cl
	movb	%cl, (%rdi)
	shrq	$8, %rax
	incq	%rdi
	addq	$-1, %rsi
L_chacha_h_x2_avx_ic$10:
	cmpq	$0, %rsi
	jnbe	L_chacha_h_x2_avx_ic$11
	jmp 	L_chacha_h_x2_avx_ic$3
L_chacha_h_x2_avx_ic$2:
	vmovdqu	%xmm2, %xmm6
	vmovdqu	%xmm3, %xmm7
	vmovdqu	%xmm4, %xmm8
	vmovdqu	%xmm5, %xmm9
	vmovdqu	%xmm2, %xmm10
	vmovdqu	%xmm3, %xmm11
	vmovdqu	%xmm4, %xmm12
	vmovdqu	%xmm5, %xmm13
	vpaddd	glob_data + 32(%rip), %xmm13, %xmm13
	movl	$10, %eax
L_chacha_h_x2_avx_ic$9:
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm0, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm14
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$12, %xmm11, %xmm14
	vpsrld	$20, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm1, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm14
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$7, %xmm11, %xmm14
	vpsrld	$25, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpshufd	$57, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$-109, %xmm9, %xmm9
	vpshufd	$57, %xmm11, %xmm11
	vpshufd	$78, %xmm12, %xmm12
	vpshufd	$-109, %xmm13, %xmm13
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm0, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm14
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$12, %xmm11, %xmm14
	vpsrld	$20, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm1, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm14
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$7, %xmm11, %xmm14
	vpsrld	$25, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpshufd	$-109, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$57, %xmm9, %xmm9
	vpshufd	$-109, %xmm11, %xmm11
	vpshufd	$78, %xmm12, %xmm12
	vpshufd	$57, %xmm13, %xmm13
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_h_x2_avx_ic$9
	vpaddd	%xmm2, %xmm6, %xmm0
	vpaddd	%xmm3, %xmm7, %xmm1
	vpaddd	%xmm4, %xmm8, %xmm6
	vpaddd	%xmm5, %xmm9, %xmm7
	vpaddd	%xmm2, %xmm10, %xmm9
	vpaddd	%xmm3, %xmm11, %xmm8
	vpaddd	%xmm4, %xmm12, %xmm2
	vpaddd	%xmm5, %xmm13, %xmm3
	vpaddd	glob_data + 32(%rip), %xmm3, %xmm3
	vmovdqu	%xmm0, (%rdi)
	vmovdqu	%xmm1, 16(%rdi)
	vmovdqu	%xmm6, 32(%rdi)
	vmovdqu	%xmm7, 48(%rdi)
	addq	$64, %rdi
	addq	$-64, %rsi
	cmpq	$32, %rsi
	jb  	L_chacha_h_x2_avx_ic$8
	vmovdqu	%xmm9, (%rdi)
	vmovdqu	%xmm8, 16(%rdi)
	addq	$32, %rdi
	addq	$-32, %rsi
	vmovdqu	%xmm2, %xmm9
	vmovdqu	%xmm3, %xmm8
L_chacha_h_x2_avx_ic$8:
	cmpq	$16, %rsi
	jb  	L_chacha_h_x2_avx_ic$7
	vmovdqu	%xmm9, (%rdi)
	addq	$16, %rdi
	addq	$-16, %rsi
	vmovdqu	%xmm8, %xmm9
L_chacha_h_x2_avx_ic$7:
	vpextrq	$0, %xmm9, %rax
	cmpq	$8, %rsi
	jb  	L_chacha_h_x2_avx_ic$4
	movq	%rax, (%rdi)
	addq	$8, %rdi
	addq	$-8, %rsi
	vpextrq	$1, %xmm9, %rax
L_chacha_h_x2_avx_ic$6:
	jmp 	L_chacha_h_x2_avx_ic$4
L_chacha_h_x2_avx_ic$5:
	movb	%al, %cl
	movb	%cl, (%rdi)
	shrq	$8, %rax
	incq	%rdi
	addq	$-1, %rsi
L_chacha_h_x2_avx_ic$4:
	cmpq	$0, %rsi
	jnbe	L_chacha_h_x2_avx_ic$5
L_chacha_h_x2_avx_ic$3:
	ret 
L_chacha_h_avx_ic$1:
	vmovdqu	glob_data + 64(%rip), %xmm0
	vmovdqu	glob_data + 48(%rip), %xmm1
	vmovdqu	glob_data + 208(%rip), %xmm2
	vmovdqu	(%rax), %xmm3
	vmovdqu	16(%rax), %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpinsrd	$0, %ecx, %xmm5, %xmm5
	vpinsrd	$1, (%rdx), %xmm5, %xmm5
	vpinsrq	$1, 4(%rdx), %xmm5, %xmm5
	jmp 	L_chacha_h_avx_ic$9
L_chacha_h_avx_ic$10:
	vmovdqu	%xmm2, %xmm6
	vmovdqu	%xmm3, %xmm7
	vmovdqu	%xmm4, %xmm8
	vmovdqu	%xmm5, %xmm9
	movl	$10, %eax
L_chacha_h_avx_ic$11:
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm10
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm10
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpshufd	$57, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$-109, %xmm9, %xmm9
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm10
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm10
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpshufd	$-109, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$57, %xmm9, %xmm9
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_h_avx_ic$11
	vpaddd	%xmm2, %xmm6, %xmm6
	vpaddd	%xmm3, %xmm7, %xmm7
	vpaddd	%xmm4, %xmm8, %xmm8
	vpaddd	%xmm5, %xmm9, %xmm9
	vmovdqu	%xmm6, (%rdi)
	vmovdqu	%xmm7, 16(%rdi)
	vmovdqu	%xmm8, 32(%rdi)
	vmovdqu	%xmm9, 48(%rdi)
	addq	$64, %rdi
	addq	$-64, %rsi
	vpaddd	glob_data + 32(%rip), %xmm5, %xmm5
L_chacha_h_avx_ic$9:
	cmpq	$64, %rsi
	jnb 	L_chacha_h_avx_ic$10
	cmpq	$0, %rsi
	jbe 	L_chacha_h_avx_ic$2
	vmovdqu	%xmm2, %xmm6
	vmovdqu	%xmm3, %xmm7
	vmovdqu	%xmm4, %xmm8
	vmovdqu	%xmm5, %xmm9
	movl	$10, %eax
L_chacha_h_avx_ic$8:
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm10
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm10
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpshufd	$57, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$-109, %xmm9, %xmm9
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm10
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm10
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpshufd	$-109, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$57, %xmm9, %xmm9
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_h_avx_ic$8
	vpaddd	%xmm2, %xmm6, %xmm6
	vpaddd	%xmm3, %xmm7, %xmm2
	vpaddd	%xmm4, %xmm8, %xmm0
	vpaddd	%xmm5, %xmm9, %xmm1
	cmpq	$32, %rsi
	jb  	L_chacha_h_avx_ic$7
	vmovdqu	%xmm6, (%rdi)
	vmovdqu	%xmm2, 16(%rdi)
	addq	$32, %rdi
	addq	$-32, %rsi
	vmovdqu	%xmm0, %xmm6
	vmovdqu	%xmm1, %xmm2
L_chacha_h_avx_ic$7:
	cmpq	$16, %rsi
	jb  	L_chacha_h_avx_ic$6
	vmovdqu	%xmm6, (%rdi)
	addq	$16, %rdi
	addq	$-16, %rsi
	vmovdqu	%xmm2, %xmm6
L_chacha_h_avx_ic$6:
	vpextrq	$0, %xmm6, %rax
	cmpq	$8, %rsi
	jb  	L_chacha_h_avx_ic$3
	movq	%rax, (%rdi)
	addq	$8, %rdi
	addq	$-8, %rsi
	vpextrq	$1, %xmm6, %rax
L_chacha_h_avx_ic$5:
	jmp 	L_chacha_h_avx_ic$3
L_chacha_h_avx_ic$4:
	movb	%al, %cl
	movb	%cl, (%rdi)
	shrq	$8, %rax
	incq	%rdi
	addq	$-1, %rsi
L_chacha_h_avx_ic$3:
	cmpq	$0, %rsi
	jnbe	L_chacha_h_avx_ic$4
L_chacha_h_avx_ic$2:
	ret 
L_chacha_xor_h_x2_avx_ic$1:
	vmovdqu	glob_data + 64(%rip), %xmm0
	vmovdqu	glob_data + 48(%rip), %xmm1
	vmovdqu	glob_data + 208(%rip), %xmm2
	vmovdqu	(%r9), %xmm3
	vmovdqu	16(%r9), %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpinsrd	$0, %edx, %xmm5, %xmm5
	vpinsrd	$1, (%rax), %xmm5, %xmm5
	vpinsrq	$1, 4(%rax), %xmm5, %xmm5
	jmp 	L_chacha_xor_h_x2_avx_ic$16
L_chacha_xor_h_x2_avx_ic$17:
	vmovdqu	%xmm2, %xmm6
	vmovdqu	%xmm3, %xmm7
	vmovdqu	%xmm4, %xmm8
	vmovdqu	%xmm5, %xmm9
	vmovdqu	%xmm2, %xmm10
	vmovdqu	%xmm3, %xmm11
	vmovdqu	%xmm4, %xmm12
	vmovdqu	%xmm5, %xmm13
	vpaddd	glob_data + 32(%rip), %xmm13, %xmm13
	movl	$10, %eax
L_chacha_xor_h_x2_avx_ic$18:
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm0, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm14
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$12, %xmm11, %xmm14
	vpsrld	$20, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm1, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm14
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$7, %xmm11, %xmm14
	vpsrld	$25, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpshufd	$57, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$-109, %xmm9, %xmm9
	vpshufd	$57, %xmm11, %xmm11
	vpshufd	$78, %xmm12, %xmm12
	vpshufd	$-109, %xmm13, %xmm13
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm0, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm14
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$12, %xmm11, %xmm14
	vpsrld	$20, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm1, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm14
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$7, %xmm11, %xmm14
	vpsrld	$25, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpshufd	$-109, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$57, %xmm9, %xmm9
	vpshufd	$-109, %xmm11, %xmm11
	vpshufd	$78, %xmm12, %xmm12
	vpshufd	$57, %xmm13, %xmm13
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_xor_h_x2_avx_ic$18
	vpaddd	%xmm2, %xmm6, %xmm6
	vpaddd	%xmm3, %xmm7, %xmm7
	vpaddd	%xmm4, %xmm8, %xmm8
	vpaddd	%xmm5, %xmm9, %xmm9
	vpaddd	%xmm2, %xmm10, %xmm10
	vpaddd	%xmm3, %xmm11, %xmm11
	vpaddd	%xmm4, %xmm12, %xmm12
	vpaddd	%xmm5, %xmm13, %xmm13
	vpaddd	glob_data + 32(%rip), %xmm13, %xmm13
	vpxor	(%r10), %xmm6, %xmm6
	vmovdqu	%xmm6, (%r11)
	vpxor	16(%r10), %xmm7, %xmm6
	vmovdqu	%xmm6, 16(%r11)
	vpxor	32(%r10), %xmm8, %xmm6
	vmovdqu	%xmm6, 32(%r11)
	vpxor	48(%r10), %xmm9, %xmm6
	vmovdqu	%xmm6, 48(%r11)
	vpxor	64(%r10), %xmm10, %xmm6
	vmovdqu	%xmm6, 64(%r11)
	vpxor	80(%r10), %xmm11, %xmm6
	vmovdqu	%xmm6, 80(%r11)
	vpxor	96(%r10), %xmm12, %xmm6
	vmovdqu	%xmm6, 96(%r11)
	vpxor	112(%r10), %xmm13, %xmm6
	vmovdqu	%xmm6, 112(%r11)
	addq	$128, %r11
	addq	$128, %r10
	addq	$-128, %rcx
	vpaddd	glob_data + 16(%rip), %xmm5, %xmm5
L_chacha_xor_h_x2_avx_ic$16:
	cmpq	$128, %rcx
	jnb 	L_chacha_xor_h_x2_avx_ic$17
	cmpq	$64, %rcx
	jnbe	L_chacha_xor_h_x2_avx_ic$2
	vmovdqu	%xmm2, %xmm6
	vmovdqu	%xmm3, %xmm7
	vmovdqu	%xmm4, %xmm8
	vmovdqu	%xmm5, %xmm9
	movl	$10, %eax
L_chacha_xor_h_x2_avx_ic$15:
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm10
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm10
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpshufd	$57, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$-109, %xmm9, %xmm9
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm10
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm10
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpshufd	$-109, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$57, %xmm9, %xmm9
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_xor_h_x2_avx_ic$15
	vpaddd	%xmm2, %xmm6, %xmm2
	vpaddd	%xmm3, %xmm7, %xmm3
	vpaddd	%xmm4, %xmm8, %xmm0
	vpaddd	%xmm5, %xmm9, %xmm1
	cmpq	$32, %rcx
	jb  	L_chacha_xor_h_x2_avx_ic$14
	vpxor	(%r10), %xmm2, %xmm2
	vmovdqu	%xmm2, (%r11)
	vpxor	16(%r10), %xmm3, %xmm2
	vmovdqu	%xmm2, 16(%r11)
	addq	$32, %r11
	addq	$32, %r10
	addq	$-32, %rcx
	vmovdqu	%xmm0, %xmm2
	vmovdqu	%xmm1, %xmm3
L_chacha_xor_h_x2_avx_ic$14:
	cmpq	$16, %rcx
	jb  	L_chacha_xor_h_x2_avx_ic$13
	vpxor	(%r10), %xmm2, %xmm0
	vmovdqu	%xmm0, (%r11)
	addq	$16, %r11
	addq	$16, %r10
	addq	$-16, %rcx
	vmovdqu	%xmm3, %xmm2
L_chacha_xor_h_x2_avx_ic$13:
	vpextrq	$0, %xmm2, %rax
	cmpq	$8, %rcx
	jb  	L_chacha_xor_h_x2_avx_ic$10
	xorq	(%r10), %rax
	movq	%rax, (%r11)
	addq	$8, %r11
	addq	$8, %r10
	addq	$-8, %rcx
	vpextrq	$1, %xmm2, %rax
L_chacha_xor_h_x2_avx_ic$12:
	jmp 	L_chacha_xor_h_x2_avx_ic$10
L_chacha_xor_h_x2_avx_ic$11:
	movb	%al, %dl
	xorb	(%r10), %dl
	movb	%dl, (%r11)
	shrq	$8, %rax
	incq	%r11
	incq	%r10
	addq	$-1, %rcx
L_chacha_xor_h_x2_avx_ic$10:
	cmpq	$0, %rcx
	jnbe	L_chacha_xor_h_x2_avx_ic$11
	jmp 	L_chacha_xor_h_x2_avx_ic$3
L_chacha_xor_h_x2_avx_ic$2:
	vmovdqu	%xmm2, %xmm6
	vmovdqu	%xmm3, %xmm7
	vmovdqu	%xmm4, %xmm8
	vmovdqu	%xmm5, %xmm9
	vmovdqu	%xmm2, %xmm10
	vmovdqu	%xmm3, %xmm11
	vmovdqu	%xmm4, %xmm12
	vmovdqu	%xmm5, %xmm13
	vpaddd	glob_data + 32(%rip), %xmm13, %xmm13
	movl	$10, %eax
L_chacha_xor_h_x2_avx_ic$9:
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm0, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm14
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$12, %xmm11, %xmm14
	vpsrld	$20, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm1, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm14
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$7, %xmm11, %xmm14
	vpsrld	$25, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpshufd	$57, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$-109, %xmm9, %xmm9
	vpshufd	$57, %xmm11, %xmm11
	vpshufd	$78, %xmm12, %xmm12
	vpshufd	$-109, %xmm13, %xmm13
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm0, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm14
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$12, %xmm11, %xmm14
	vpsrld	$20, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpaddd	%xmm7, %xmm6, %xmm6
	vpaddd	%xmm11, %xmm10, %xmm10
	vpxor	%xmm6, %xmm9, %xmm9
	vpxor	%xmm10, %xmm13, %xmm13
	vpshufb	%xmm1, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm13, %xmm13
	vpaddd	%xmm9, %xmm8, %xmm8
	vpaddd	%xmm13, %xmm12, %xmm12
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm14
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm12, %xmm11, %xmm11
	vpxor	%xmm14, %xmm7, %xmm7
	vpslld	$7, %xmm11, %xmm14
	vpsrld	$25, %xmm11, %xmm11
	vpxor	%xmm14, %xmm11, %xmm11
	vpshufd	$-109, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$57, %xmm9, %xmm9
	vpshufd	$-109, %xmm11, %xmm11
	vpshufd	$78, %xmm12, %xmm12
	vpshufd	$57, %xmm13, %xmm13
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_xor_h_x2_avx_ic$9
	vpaddd	%xmm2, %xmm6, %xmm0
	vpaddd	%xmm3, %xmm7, %xmm1
	vpaddd	%xmm4, %xmm8, %xmm6
	vpaddd	%xmm5, %xmm9, %xmm7
	vpaddd	%xmm2, %xmm10, %xmm9
	vpaddd	%xmm3, %xmm11, %xmm8
	vpaddd	%xmm4, %xmm12, %xmm2
	vpaddd	%xmm5, %xmm13, %xmm3
	vpaddd	glob_data + 32(%rip), %xmm3, %xmm3
	vpxor	(%r10), %xmm0, %xmm0
	vmovdqu	%xmm0, (%r11)
	vpxor	16(%r10), %xmm1, %xmm0
	vmovdqu	%xmm0, 16(%r11)
	vpxor	32(%r10), %xmm6, %xmm0
	vmovdqu	%xmm0, 32(%r11)
	vpxor	48(%r10), %xmm7, %xmm0
	vmovdqu	%xmm0, 48(%r11)
	addq	$64, %r11
	addq	$64, %r10
	addq	$-64, %rcx
	cmpq	$32, %rcx
	jb  	L_chacha_xor_h_x2_avx_ic$8
	vpxor	(%r10), %xmm9, %xmm0
	vmovdqu	%xmm0, (%r11)
	vpxor	16(%r10), %xmm8, %xmm0
	vmovdqu	%xmm0, 16(%r11)
	addq	$32, %r11
	addq	$32, %r10
	addq	$-32, %rcx
	vmovdqu	%xmm2, %xmm9
	vmovdqu	%xmm3, %xmm8
L_chacha_xor_h_x2_avx_ic$8:
	cmpq	$16, %rcx
	jb  	L_chacha_xor_h_x2_avx_ic$7
	vpxor	(%r10), %xmm9, %xmm0
	vmovdqu	%xmm0, (%r11)
	addq	$16, %r11
	addq	$16, %r10
	addq	$-16, %rcx
	vmovdqu	%xmm8, %xmm9
L_chacha_xor_h_x2_avx_ic$7:
	vpextrq	$0, %xmm9, %rax
	cmpq	$8, %rcx
	jb  	L_chacha_xor_h_x2_avx_ic$4
	xorq	(%r10), %rax
	movq	%rax, (%r11)
	addq	$8, %r11
	addq	$8, %r10
	addq	$-8, %rcx
	vpextrq	$1, %xmm9, %rax
L_chacha_xor_h_x2_avx_ic$6:
	jmp 	L_chacha_xor_h_x2_avx_ic$4
L_chacha_xor_h_x2_avx_ic$5:
	movb	%al, %dl
	xorb	(%r10), %dl
	movb	%dl, (%r11)
	shrq	$8, %rax
	incq	%r11
	incq	%r10
	addq	$-1, %rcx
L_chacha_xor_h_x2_avx_ic$4:
	cmpq	$0, %rcx
	jnbe	L_chacha_xor_h_x2_avx_ic$5
L_chacha_xor_h_x2_avx_ic$3:
	ret 
L_chacha_xor_h_avx_ic$1:
	vmovdqu	glob_data + 64(%rip), %xmm0
	vmovdqu	glob_data + 48(%rip), %xmm1
	vmovdqu	glob_data + 208(%rip), %xmm2
	vmovdqu	(%rax), %xmm3
	vmovdqu	16(%rax), %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpinsrd	$0, %ecx, %xmm5, %xmm5
	vpinsrd	$1, (%rdx), %xmm5, %xmm5
	vpinsrq	$1, 4(%rdx), %xmm5, %xmm5
	jmp 	L_chacha_xor_h_avx_ic$9
L_chacha_xor_h_avx_ic$10:
	vmovdqu	%xmm2, %xmm6
	vmovdqu	%xmm3, %xmm7
	vmovdqu	%xmm4, %xmm8
	vmovdqu	%xmm5, %xmm9
	movl	$10, %eax
L_chacha_xor_h_avx_ic$11:
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm10
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm10
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpshufd	$57, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$-109, %xmm9, %xmm9
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm10
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm10
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpshufd	$-109, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$57, %xmm9, %xmm9
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_xor_h_avx_ic$11
	vpaddd	%xmm2, %xmm6, %xmm6
	vpaddd	%xmm3, %xmm7, %xmm7
	vpaddd	%xmm4, %xmm8, %xmm8
	vpaddd	%xmm5, %xmm9, %xmm9
	vpxor	(%rdi), %xmm6, %xmm6
	vmovdqu	%xmm6, (%r8)
	vpxor	16(%rdi), %xmm7, %xmm6
	vmovdqu	%xmm6, 16(%r8)
	vpxor	32(%rdi), %xmm8, %xmm6
	vmovdqu	%xmm6, 32(%r8)
	vpxor	48(%rdi), %xmm9, %xmm6
	vmovdqu	%xmm6, 48(%r8)
	addq	$64, %r8
	addq	$64, %rdi
	addq	$-64, %rsi
	vpaddd	glob_data + 32(%rip), %xmm5, %xmm5
L_chacha_xor_h_avx_ic$9:
	cmpq	$64, %rsi
	jnb 	L_chacha_xor_h_avx_ic$10
	cmpq	$0, %rsi
	jbe 	L_chacha_xor_h_avx_ic$2
	vmovdqu	%xmm2, %xmm6
	vmovdqu	%xmm3, %xmm7
	vmovdqu	%xmm4, %xmm8
	vmovdqu	%xmm5, %xmm9
	movl	$10, %eax
L_chacha_xor_h_avx_ic$8:
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm10
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm10
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpshufd	$57, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$-109, %xmm9, %xmm9
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm0, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$12, %xmm7, %xmm10
	vpsrld	$20, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpaddd	%xmm7, %xmm6, %xmm6
	vpxor	%xmm6, %xmm9, %xmm9
	vpshufb	%xmm1, %xmm9, %xmm9
	vpaddd	%xmm9, %xmm8, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpslld	$7, %xmm7, %xmm10
	vpsrld	$25, %xmm7, %xmm7
	vpxor	%xmm10, %xmm7, %xmm7
	vpshufd	$-109, %xmm7, %xmm7
	vpshufd	$78, %xmm8, %xmm8
	vpshufd	$57, %xmm9, %xmm9
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_xor_h_avx_ic$8
	vpaddd	%xmm2, %xmm6, %xmm2
	vpaddd	%xmm3, %xmm7, %xmm3
	vpaddd	%xmm4, %xmm8, %xmm0
	vpaddd	%xmm5, %xmm9, %xmm1
	cmpq	$32, %rsi
	jb  	L_chacha_xor_h_avx_ic$7
	vpxor	(%rdi), %xmm2, %xmm2
	vmovdqu	%xmm2, (%r8)
	vpxor	16(%rdi), %xmm3, %xmm2
	vmovdqu	%xmm2, 16(%r8)
	addq	$32, %r8
	addq	$32, %rdi
	addq	$-32, %rsi
	vmovdqu	%xmm0, %xmm2
	vmovdqu	%xmm1, %xmm3
L_chacha_xor_h_avx_ic$7:
	cmpq	$16, %rsi
	jb  	L_chacha_xor_h_avx_ic$6
	vpxor	(%rdi), %xmm2, %xmm0
	vmovdqu	%xmm0, (%r8)
	addq	$16, %r8
	addq	$16, %rdi
	addq	$-16, %rsi
	vmovdqu	%xmm3, %xmm2
L_chacha_xor_h_avx_ic$6:
	vpextrq	$0, %xmm2, %rax
	cmpq	$8, %rsi
	jb  	L_chacha_xor_h_avx_ic$3
	xorq	(%rdi), %rax
	movq	%rax, (%r8)
	addq	$8, %r8
	addq	$8, %rdi
	addq	$-8, %rsi
	vpextrq	$1, %xmm2, %rax
L_chacha_xor_h_avx_ic$5:
	jmp 	L_chacha_xor_h_avx_ic$3
L_chacha_xor_h_avx_ic$4:
	movb	%al, %cl
	xorb	(%rdi), %cl
	movb	%cl, (%r8)
	shrq	$8, %rax
	incq	%r8
	incq	%rdi
	addq	$-1, %rsi
L_chacha_xor_h_avx_ic$3:
	cmpq	$0, %rsi
	jnbe	L_chacha_xor_h_avx_ic$4
L_chacha_xor_h_avx_ic$2:
	ret 
	.data
	.p2align	5
_glob_data:
glob_data:
      .byte 4
      .byte 0
      .byte 0
      .byte 0
      .byte 4
      .byte 0
      .byte 0
      .byte 0
      .byte 4
      .byte 0
      .byte 0
      .byte 0
      .byte 4
      .byte 0
      .byte 0
      .byte 0
      .byte 2
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 1
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 3
      .byte 0
      .byte 1
      .byte 2
      .byte 7
      .byte 4
      .byte 5
      .byte 6
      .byte 11
      .byte 8
      .byte 9
      .byte 10
      .byte 15
      .byte 12
      .byte 13
      .byte 14
      .byte 2
      .byte 3
      .byte 0
      .byte 1
      .byte 6
      .byte 7
      .byte 4
      .byte 5
      .byte 10
      .byte 11
      .byte 8
      .byte 9
      .byte 14
      .byte 15
      .byte 12
      .byte 13
      .byte 4
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 4
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 1
      .byte 0
      .byte 0
      .byte 0
      .byte 2
      .byte 0
      .byte 0
      .byte 0
      .byte 3
      .byte 0
      .byte 0
      .byte 0
      .byte 101
      .byte 120
      .byte 112
      .byte 97
      .byte 101
      .byte 120
      .byte 112
      .byte 97
      .byte 101
      .byte 120
      .byte 112
      .byte 97
      .byte 101
      .byte 120
      .byte 112
      .byte 97
      .byte 110
      .byte 100
      .byte 32
      .byte 51
      .byte 110
      .byte 100
      .byte 32
      .byte 51
      .byte 110
      .byte 100
      .byte 32
      .byte 51
      .byte 110
      .byte 100
      .byte 32
      .byte 51
      .byte 50
      .byte 45
      .byte 98
      .byte 121
      .byte 50
      .byte 45
      .byte 98
      .byte 121
      .byte 50
      .byte 45
      .byte 98
      .byte 121
      .byte 50
      .byte 45
      .byte 98
      .byte 121
      .byte 116
      .byte 101
      .byte 32
      .byte 107
      .byte 116
      .byte 101
      .byte 32
      .byte 107
      .byte 116
      .byte 101
      .byte 32
      .byte 107
      .byte 116
      .byte 101
      .byte 32
      .byte 107
      .byte 2
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 1
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 101
      .byte 120
      .byte 112
      .byte 97
      .byte 110
      .byte 100
      .byte 32
      .byte 51
      .byte 50
      .byte 45
      .byte 98
      .byte 121
      .byte 116
      .byte 101
      .byte 32
      .byte 107
      .byte 0
      .byte 0
      .byte 0
      .byte 1
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte -1
      .byte -1
      .byte -1
      .byte 3
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 5
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
