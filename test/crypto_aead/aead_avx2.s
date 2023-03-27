	.att_syntax
	.text
	.p2align	5
	.globl	_jade_aead_chacha20poly1305_amd64_avx2_open
	.globl	jade_aead_chacha20poly1305_amd64_avx2_open
	.globl	_jade_aead_chacha20poly1305_amd64_avx2
	.globl	jade_aead_chacha20poly1305_amd64_avx2
_jade_aead_chacha20poly1305_amd64_avx2_open:
jade_aead_chacha20poly1305_amd64_avx2_open:
	movq	%rsp, %rax
	leaq	-888(%rsp), %rsp
	andq	$-32, %rsp
	movq	%rax, 880(%rsp)
	movq	%rbx, 832(%rsp)
	movq	%rbp, 840(%rsp)
	movq	%r12, 848(%rsp)
	movq	%r13, 856(%rsp)
	movq	%r14, 864(%rsp)
	movq	%r15, 872(%rsp)
	movq	%rsi, %r10
	addq	%rdx, %r10
	movq	$-1, %rax
	cmpq	$16, %rcx
	jb  	Ljade_aead_chacha20poly1305_amd64_avx2_open$1
	movq	%rdi, 640(%rsp)
	movq	%rsi, 648(%rsp)
	movq	%rdx, 656(%rsp)
	movq	%r10, 664(%rsp)
	leaq	16(%r10), %rax
	movq	%rax, 672(%rsp)
	leaq	-16(%rcx), %rax
	movq	%rax, 680(%rsp)
	movq	%r8, 688(%rsp)
	movq	%r9, 696(%rsp)
	xorl	%eax, %eax
	movl	$1634760805, 768(%rsp)
	movl	$857760878, 772(%rsp)
	movl	$2036477234, 776(%rsp)
	movl	$1797285236, 780(%rsp)
	movl	(%r9), %ecx
	movl	%ecx, 784(%rsp)
	movl	4(%r9), %ecx
	movl	%ecx, 788(%rsp)
	movl	8(%r9), %ecx
	movl	%ecx, 792(%rsp)
	movl	12(%r9), %ecx
	movl	%ecx, 796(%rsp)
	movl	16(%r9), %ecx
	movl	%ecx, 800(%rsp)
	movl	20(%r9), %ecx
	movl	%ecx, 804(%rsp)
	movl	24(%r9), %ecx
	movl	%ecx, 808(%rsp)
	movl	28(%r9), %ecx
	movl	%ecx, 812(%rsp)
	movl	%eax, 816(%rsp)
	movl	(%r8), %eax
	movl	%eax, 820(%rsp)
	movl	4(%r8), %eax
	movl	%eax, 824(%rsp)
	movl	8(%r8), %eax
	movl	%eax, 828(%rsp)
	movl	828(%rsp), %eax
	movl	%eax, 752(%rsp)
	movl	768(%rsp), %eax
	movl	772(%rsp), %ecx
	movl	776(%rsp), %edx
	movl	780(%rsp), %esi
	movl	784(%rsp), %edi
	movl	788(%rsp), %r8d
	movl	792(%rsp), %r9d
	movl	796(%rsp), %r10d
	movl	800(%rsp), %r11d
	movl	804(%rsp), %ebx
	movl	808(%rsp), %ebp
	movl	812(%rsp), %r12d
	movl	816(%rsp), %r13d
	movl	820(%rsp), %r14d
	movl	824(%rsp), %r15d
	movl	%r15d, 756(%rsp)
	movl	$10, %r15d
Ljade_aead_chacha20poly1305_amd64_avx2_open$20:
	movl	%r15d, 760(%rsp)
	movl	756(%rsp), %r15d
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
	movl	%r15d, 764(%rsp)
	movl	752(%rsp), %r15d
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
	movl	%r15d, 752(%rsp)
	movl	764(%rsp), %r15d
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
	movl	%r15d, 756(%rsp)
	movl	760(%rsp), %r15d
	decl	%r15d
	cmpl	$0, %r15d
	jnbe	Ljade_aead_chacha20poly1305_amd64_avx2_open$20
	addl	768(%rsp), %eax
	addl	772(%rsp), %ecx
	addl	776(%rsp), %edx
	addl	780(%rsp), %esi
	addl	784(%rsp), %edi
	addl	788(%rsp), %r8d
	addl	792(%rsp), %r9d
	addl	796(%rsp), %r10d
	movl	%eax, 720(%rsp)
	movl	%ecx, 724(%rsp)
	movl	%edx, 728(%rsp)
	movl	%esi, 732(%rsp)
	movl	%edi, 736(%rsp)
	movl	%r8d, 740(%rsp)
	movl	%r9d, 744(%rsp)
	movl	%r10d, 748(%rsp)
	movq	664(%rsp), %rax
	movq	648(%rsp), %rcx
	movq	656(%rsp), %rsi
	movq	672(%rsp), %rdi
	movq	680(%rsp), %r8
	movq	%rax, 656(%rsp)
	movq	$0, %r9
	movq	$0, %r10
	movq	$0, %r15
	movq	720(%rsp), %r11
	movq	728(%rsp), %rbx
	movq	$1152921487695413247, %rax
	andq	%rax, %r11
	movq	$1152921487695413244, %rax
	andq	%rax, %rbx
	movq	%rbx, %rbp
	shrq	$2, %rbp
	addq	%rbx, %rbp
	movq	%rsi, 648(%rsp)
	movq	%r8, 664(%rsp)
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx2_open$18
Ljade_aead_chacha20poly1305_amd64_avx2_open$19:
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
Ljade_aead_chacha20poly1305_amd64_avx2_open$18:
	cmpq	$16, %rsi
	jnb 	Ljade_aead_chacha20poly1305_amd64_avx2_open$19
	cmpq	$0, %rsi
	jbe 	Ljade_aead_chacha20poly1305_amd64_avx2_open$15
	movq	$0, 704(%rsp)
	movq	$0, 712(%rsp)
	movq	$0, %rax
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx2_open$16
Ljade_aead_chacha20poly1305_amd64_avx2_open$17:
	movb	(%rcx,%rax), %dl
	movb	%dl, 704(%rsp,%rax)
	incq	%rax
Ljade_aead_chacha20poly1305_amd64_avx2_open$16:
	cmpq	%rsi, %rax
	jb  	Ljade_aead_chacha20poly1305_amd64_avx2_open$17
	addq	704(%rsp), %r9
	adcq	712(%rsp), %r10
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
Ljade_aead_chacha20poly1305_amd64_avx2_open$15:
	cmpq	$256, %r8
	jb  	Ljade_aead_chacha20poly1305_amd64_avx2_open$12
	movq	%r11, %rcx
	movq	%rbx, %rsi
	movq	$0, %r9
	movq	%rcx, %rax
	andq	$67108863, %rax
	movq	%rax, 344(%rsp)
	movq	%rcx, %rax
	shrq	$26, %rax
	andq	$67108863, %rax
	movq	%rax, 376(%rsp)
	movq	%rcx, %rax
	shrdq	$52, %rsi, %rax
	movq	%rax, %rdx
	andq	$67108863, %rax
	movq	%rax, 408(%rsp)
	shrq	$26, %rdx
	andq	$67108863, %rdx
	movq	%rdx, 440(%rsp)
	movq	%rsi, %rax
	shrdq	$40, %r9, %rax
	movq	%rax, 472(%rsp)
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
	movq	%rax, 336(%rsp)
	movq	%rcx, %rax
	shrq	$26, %rax
	andq	$67108863, %rax
	movq	%rax, 368(%rsp)
	movq	%rcx, %rax
	shrdq	$52, %rsi, %rax
	movq	%rax, %rdx
	andq	$67108863, %rax
	movq	%rax, 400(%rsp)
	shrq	$26, %rdx
	andq	$67108863, %rdx
	movq	%rdx, 432(%rsp)
	movq	%rsi, %rax
	shrdq	$40, %r9, %rax
	movq	%rax, 464(%rsp)
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
	movq	%rax, 328(%rsp)
	movq	%rcx, %rax
	shrq	$26, %rax
	andq	$67108863, %rax
	movq	%rax, 360(%rsp)
	movq	%rcx, %rax
	shrdq	$52, %rsi, %rax
	movq	%rax, %rdx
	andq	$67108863, %rax
	movq	%rax, 392(%rsp)
	shrq	$26, %rdx
	andq	$67108863, %rdx
	movq	%rdx, 424(%rsp)
	movq	%rsi, %rax
	shrdq	$40, %r9, %rax
	movq	%rax, 456(%rsp)
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
	movq	%rcx, 320(%rsp)
	movq	%rax, %rcx
	shrq	$26, %rcx
	andq	$67108863, %rcx
	movq	%rcx, 352(%rsp)
	shrdq	$52, %rsi, %rax
	movq	%rax, %rcx
	andq	$67108863, %rax
	movq	%rax, 384(%rsp)
	shrq	$26, %rcx
	andq	$67108863, %rcx
	movq	%rcx, 416(%rsp)
	shrdq	$40, %r9, %rsi
	movq	%rsi, 448(%rsp)
	vpbroadcastq	glob_data + 528(%rip), %ymm0
	vpmuludq	352(%rsp), %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rsp)
	vpmuludq	384(%rsp), %ymm0, %ymm1
	vmovdqu	%ymm1, 96(%rsp)
	vpmuludq	416(%rsp), %ymm0, %ymm1
	vmovdqu	%ymm1, 128(%rsp)
	vpmuludq	448(%rsp), %ymm0, %ymm0
	vmovdqu	%ymm0, 160(%rsp)
	vpbroadcastq	320(%rsp), %ymm0
	vmovdqu	%ymm0, 480(%rsp)
	vpbroadcastq	352(%rsp), %ymm0
	vmovdqu	%ymm0, 512(%rsp)
	vpbroadcastq	384(%rsp), %ymm0
	vmovdqu	%ymm0, 544(%rsp)
	vpbroadcastq	416(%rsp), %ymm0
	vmovdqu	%ymm0, 576(%rsp)
	vpbroadcastq	448(%rsp), %ymm0
	vmovdqu	%ymm0, 608(%rsp)
	vpbroadcastq	64(%rsp), %ymm0
	vmovdqu	%ymm0, 192(%rsp)
	vpbroadcastq	96(%rsp), %ymm0
	vmovdqu	%ymm0, 224(%rsp)
	vpbroadcastq	128(%rsp), %ymm0
	vmovdqu	%ymm0, 256(%rsp)
	vpbroadcastq	160(%rsp), %ymm0
	vmovdqu	%ymm0, 288(%rsp)
	vpxor	%ymm0, %ymm0, %ymm0
	vpxor	%ymm1, %ymm1, %ymm1
	vpxor	%ymm2, %ymm2, %ymm2
	vpxor	%ymm3, %ymm3, %ymm3
	vpxor	%ymm4, %ymm4, %ymm4
	vpbroadcastq	glob_data + 520(%rip), %ymm5
	vmovdqu	%ymm5, (%rsp)
	vpbroadcastq	glob_data + 512(%rip), %ymm6
	vmovdqu	%ymm6, 32(%rsp)
	vmovdqu	(%rdi), %ymm6
	vmovdqu	32(%rdi), %ymm7
	addq	$64, %rdi
	vperm2i128	$32, %ymm7, %ymm6, %ymm8
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vpsrldq	$6, %ymm8, %ymm7
	vpsrldq	$6, %ymm6, %ymm9
	vpunpckhqdq	%ymm6, %ymm8, %ymm10
	vpunpcklqdq	%ymm6, %ymm8, %ymm6
	vpunpcklqdq	%ymm9, %ymm7, %ymm7
	vpsrlq	$4, %ymm7, %ymm8
	vpand	%ymm5, %ymm8, %ymm8
	vpsrlq	$26, %ymm6, %ymm9
	vpand	%ymm5, %ymm6, %ymm6
	vpsrlq	$30, %ymm7, %ymm7
	vpand	%ymm5, %ymm7, %ymm7
	vpsrlq	$40, %ymm10, %ymm10
	vpor	32(%rsp), %ymm10, %ymm10
	vpand	%ymm5, %ymm9, %ymm5
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx2_open$13
Ljade_aead_chacha20poly1305_amd64_avx2_open$14:
	vmovdqu	480(%rsp), %ymm9
	vmovdqu	512(%rsp), %ymm11
	vmovdqu	288(%rsp), %ymm12
	vpaddq	%ymm6, %ymm0, %ymm0
	vpaddq	%ymm5, %ymm1, %ymm1
	vpmuludq	%ymm9, %ymm0, %ymm5
	vpaddq	%ymm8, %ymm2, %ymm2
	vpmuludq	%ymm11, %ymm0, %ymm6
	vpaddq	%ymm7, %ymm3, %ymm3
	vpmuludq	%ymm9, %ymm1, %ymm7
	vpaddq	%ymm10, %ymm4, %ymm4
	vpmuludq	%ymm11, %ymm1, %ymm8
	vpmuludq	%ymm9, %ymm2, %ymm10
	vpmuludq	%ymm11, %ymm2, %ymm13
	vpmuludq	%ymm9, %ymm3, %ymm14
	vpaddq	%ymm6, %ymm7, %ymm6
	vpmuludq	%ymm11, %ymm3, %ymm7
	vpaddq	%ymm8, %ymm10, %ymm8
	vpmuludq	%ymm9, %ymm4, %ymm9
	vpaddq	%ymm13, %ymm14, %ymm10
	vpaddq	%ymm7, %ymm9, %ymm7
	vpmuludq	%ymm12, %ymm1, %ymm9
	vmovdqu	(%rdi), %ymm11
	vpmuludq	%ymm12, %ymm2, %ymm13
	vmovdqu	544(%rsp), %ymm14
	vpmuludq	%ymm12, %ymm3, %ymm15
	vpmuludq	%ymm12, %ymm4, %ymm12
	vpaddq	%ymm9, %ymm5, %ymm5
	vmovdqu	32(%rdi), %ymm9
	vpaddq	%ymm13, %ymm6, %ymm6
	vpaddq	%ymm15, %ymm8, %ymm8
	vpaddq	%ymm12, %ymm10, %ymm10
	vpmuludq	%ymm14, %ymm0, %ymm12
	vperm2i128	$32, %ymm9, %ymm11, %ymm13
	vpmuludq	%ymm14, %ymm1, %ymm15
	vperm2i128	$49, %ymm9, %ymm11, %ymm9
	vpmuludq	%ymm14, %ymm2, %ymm11
	vpaddq	%ymm12, %ymm8, %ymm8
	vmovdqu	256(%rsp), %ymm12
	vpaddq	%ymm15, %ymm10, %ymm10
	vpaddq	%ymm11, %ymm7, %ymm7
	vpmuludq	%ymm12, %ymm2, %ymm2
	vpmuludq	%ymm12, %ymm3, %ymm11
	vmovdqu	576(%rsp), %ymm14
	vpmuludq	%ymm12, %ymm4, %ymm12
	vpsrldq	$6, %ymm13, %ymm15
	vpaddq	%ymm2, %ymm5, %ymm2
	vpsrldq	$6, %ymm9, %ymm5
	vpaddq	%ymm11, %ymm6, %ymm6
	vpaddq	%ymm8, %ymm12, %ymm11
	vmovdqu	224(%rsp), %ymm8
	vpmuludq	%ymm14, %ymm0, %ymm12
	vpmuludq	%ymm14, %ymm1, %ymm1
	vpunpckhqdq	%ymm9, %ymm13, %ymm14
	vpunpcklqdq	%ymm9, %ymm13, %ymm9
	vpaddq	%ymm12, %ymm10, %ymm10
	vpaddq	%ymm1, %ymm7, %ymm1
	vpmuludq	%ymm8, %ymm3, %ymm3
	vpmuludq	%ymm8, %ymm4, %ymm7
	vpaddq	%ymm3, %ymm2, %ymm2
	vpaddq	%ymm6, %ymm7, %ymm3
	vmovdqu	(%rsp), %ymm12
	vpmuludq	192(%rsp), %ymm4, %ymm4
	vpmuludq	608(%rsp), %ymm0, %ymm0
	vpunpcklqdq	%ymm5, %ymm15, %ymm5
	vpsrlq	$4, %ymm5, %ymm6
	vpaddq	%ymm4, %ymm2, %ymm2
	vpsrlq	$26, %ymm2, %ymm4
	vpand	%ymm12, %ymm2, %ymm2
	vpand	%ymm12, %ymm10, %ymm7
	vpsrlq	$26, %ymm10, %ymm10
	vpaddq	%ymm0, %ymm1, %ymm0
	vpand	%ymm12, %ymm6, %ymm8
	vpsrlq	$26, %ymm9, %ymm13
	vpaddq	%ymm4, %ymm3, %ymm1
	vpaddq	%ymm10, %ymm0, %ymm0
	vpsrlq	$26, %ymm1, %ymm3
	vpsrlq	$26, %ymm0, %ymm4
	vpsllq	$2, %ymm4, %ymm6
	vpaddq	%ymm6, %ymm4, %ymm4
	vpand	%ymm12, %ymm1, %ymm1
	vpand	%ymm12, %ymm0, %ymm6
	vpaddq	%ymm3, %ymm11, %ymm0
	vpaddq	%ymm4, %ymm2, %ymm3
	vpsrlq	$26, %ymm0, %ymm4
	vpsrlq	$26, %ymm3, %ymm10
	vpand	%ymm12, %ymm0, %ymm2
	vpand	%ymm12, %ymm3, %ymm0
	vpaddq	%ymm4, %ymm7, %ymm3
	vpaddq	%ymm10, %ymm1, %ymm1
	vpsrlq	$26, %ymm3, %ymm4
	vpand	%ymm12, %ymm3, %ymm3
	vpaddq	%ymm4, %ymm6, %ymm4
	addq	$64, %rdi
	vpand	%ymm12, %ymm9, %ymm6
	vpsrlq	$30, %ymm5, %ymm5
	vpand	%ymm12, %ymm5, %ymm7
	vpsrlq	$40, %ymm14, %ymm5
	vpor	32(%rsp), %ymm5, %ymm10
	vpand	%ymm12, %ymm13, %ymm5
	addq	$-64, %r8
Ljade_aead_chacha20poly1305_amd64_avx2_open$13:
	cmpq	$128, %r8
	jnb 	Ljade_aead_chacha20poly1305_amd64_avx2_open$14
	vmovdqu	320(%rsp), %ymm9
	vmovdqu	352(%rsp), %ymm11
	vmovdqu	160(%rsp), %ymm12
	vpaddq	%ymm6, %ymm0, %ymm0
	vpaddq	%ymm5, %ymm1, %ymm1
	vpaddq	%ymm8, %ymm2, %ymm2
	vpaddq	%ymm7, %ymm3, %ymm3
	vpaddq	%ymm10, %ymm4, %ymm4
	vpmuludq	%ymm9, %ymm0, %ymm5
	vpmuludq	%ymm9, %ymm1, %ymm6
	vpmuludq	%ymm9, %ymm2, %ymm7
	vpmuludq	%ymm9, %ymm3, %ymm8
	vpmuludq	%ymm9, %ymm4, %ymm9
	vpmuludq	%ymm11, %ymm0, %ymm10
	vpmuludq	%ymm11, %ymm1, %ymm13
	vpmuludq	%ymm11, %ymm2, %ymm14
	vpmuludq	%ymm11, %ymm3, %ymm11
	vmovdqu	384(%rsp), %ymm15
	vpaddq	%ymm10, %ymm6, %ymm6
	vpaddq	%ymm13, %ymm7, %ymm7
	vpaddq	%ymm14, %ymm8, %ymm8
	vpaddq	%ymm11, %ymm9, %ymm9
	vpmuludq	%ymm12, %ymm1, %ymm10
	vpmuludq	%ymm12, %ymm2, %ymm11
	vpmuludq	%ymm12, %ymm3, %ymm13
	vpmuludq	%ymm12, %ymm4, %ymm12
	vmovdqu	128(%rsp), %ymm14
	vpaddq	%ymm10, %ymm5, %ymm5
	vpaddq	%ymm11, %ymm6, %ymm6
	vpaddq	%ymm13, %ymm7, %ymm7
	vpaddq	%ymm12, %ymm8, %ymm8
	vpmuludq	%ymm15, %ymm0, %ymm10
	vpmuludq	%ymm15, %ymm1, %ymm11
	vpmuludq	%ymm15, %ymm2, %ymm12
	vmovdqu	416(%rsp), %ymm13
	vpaddq	%ymm10, %ymm7, %ymm7
	vpaddq	%ymm11, %ymm8, %ymm8
	vpaddq	%ymm12, %ymm9, %ymm9
	vpmuludq	%ymm14, %ymm2, %ymm2
	vpmuludq	%ymm14, %ymm3, %ymm10
	vpmuludq	%ymm14, %ymm4, %ymm11
	vmovdqu	96(%rsp), %ymm12
	vpaddq	%ymm2, %ymm5, %ymm2
	vpaddq	%ymm10, %ymm6, %ymm5
	vpaddq	%ymm7, %ymm11, %ymm6
	vpmuludq	%ymm13, %ymm0, %ymm7
	vpmuludq	%ymm13, %ymm1, %ymm1
	vpaddq	%ymm7, %ymm8, %ymm7
	vpaddq	%ymm1, %ymm9, %ymm1
	vpmuludq	%ymm12, %ymm3, %ymm3
	vpmuludq	%ymm12, %ymm4, %ymm8
	vpaddq	%ymm3, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm8, %ymm3
	vpmuludq	64(%rsp), %ymm4, %ymm4
	vpmuludq	448(%rsp), %ymm0, %ymm0
	vpaddq	%ymm4, %ymm2, %ymm2
	vpaddq	%ymm0, %ymm1, %ymm0
	vmovdqu	(%rsp), %ymm1
	vpsrlq	$26, %ymm2, %ymm4
	vpsrlq	$26, %ymm7, %ymm5
	vpand	%ymm1, %ymm2, %ymm2
	vpand	%ymm1, %ymm7, %ymm7
	vpaddq	%ymm4, %ymm3, %ymm3
	vpaddq	%ymm5, %ymm0, %ymm0
	vpsrlq	$26, %ymm3, %ymm4
	vpsrlq	$26, %ymm0, %ymm5
	vpsllq	$2, %ymm5, %ymm8
	vpaddq	%ymm8, %ymm5, %ymm5
	vpand	%ymm1, %ymm3, %ymm3
	vpand	%ymm1, %ymm0, %ymm0
	vpaddq	%ymm4, %ymm6, %ymm4
	vpaddq	%ymm5, %ymm2, %ymm2
	vpsrlq	$26, %ymm4, %ymm5
	vpsrlq	$26, %ymm2, %ymm6
	vpand	%ymm1, %ymm4, %ymm4
	vpand	%ymm1, %ymm2, %ymm2
	vpaddq	%ymm5, %ymm7, %ymm5
	vpaddq	%ymm6, %ymm3, %ymm3
	vpsrlq	$26, %ymm5, %ymm6
	vpand	%ymm1, %ymm5, %ymm1
	vpaddq	%ymm6, %ymm0, %ymm0
	vpsllq	$26, %ymm3, %ymm3
	vpaddq	%ymm2, %ymm3, %ymm2
	vpsllq	$26, %ymm1, %ymm1
	vpaddq	%ymm4, %ymm1, %ymm1
	vpsrldq	$8, %ymm0, %ymm3
	vpaddq	%ymm0, %ymm3, %ymm0
	vpermq	$-128, %ymm0, %ymm0
	vperm2i128	$32, %ymm1, %ymm2, %ymm3
	vperm2i128	$49, %ymm1, %ymm2, %ymm1
	vpaddq	%ymm1, %ymm3, %ymm1
	vpunpcklqdq	%ymm0, %ymm1, %ymm2
	vpunpckhqdq	%ymm0, %ymm1, %ymm0
	vpaddq	%ymm0, %ymm2, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpextrq	$0, %xmm0, %rax
	vpextrq	$0, %xmm1, %r10
	vpextrq	$1, %xmm1, %rcx
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
Ljade_aead_chacha20poly1305_amd64_avx2_open$12:
	movq	664(%rsp), %rcx
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx2_open$10
Ljade_aead_chacha20poly1305_amd64_avx2_open$11:
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
Ljade_aead_chacha20poly1305_amd64_avx2_open$10:
	cmpq	$16, %rcx
	jnb 	Ljade_aead_chacha20poly1305_amd64_avx2_open$11
	cmpq	$0, %rcx
	jbe 	Ljade_aead_chacha20poly1305_amd64_avx2_open$7
	movq	$0, 704(%rsp)
	movq	$0, 712(%rsp)
	movq	$0, %rax
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx2_open$8
Ljade_aead_chacha20poly1305_amd64_avx2_open$9:
	movb	(%rdi,%rax), %dl
	movb	%dl, 704(%rsp,%rax)
	incq	%rax
Ljade_aead_chacha20poly1305_amd64_avx2_open$8:
	cmpq	%rcx, %rax
	jb  	Ljade_aead_chacha20poly1305_amd64_avx2_open$9
	addq	704(%rsp), %r9
	adcq	712(%rsp), %r10
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
Ljade_aead_chacha20poly1305_amd64_avx2_open$7:
	movq	648(%rsp), %rax
	movq	664(%rsp), %rcx
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
	movq	736(%rsp), %rax
	movq	744(%rsp), %rsi
	addq	%rax, %rcx
	adcq	%rsi, %rdx
	movq	656(%rsp), %rax
	xorq	(%rax), %rcx
	xorq	8(%rax), %rdx
	orq 	%rdx, %rcx
	xorq	%rax, %rax
	subq	$1, %rcx
	adcq	$0, %rax
	addq	$-1, %rax
	cmpq	$0, %rax
	jne 	Ljade_aead_chacha20poly1305_amd64_avx2_open$1
	movq	640(%rsp), %rax
	movq	672(%rsp), %rcx
	movq	680(%rsp), %rdx
	movq	688(%rsp), %rsi
	movq	696(%rsp), %rdi
	movl	$1, %r8d
	cmpq	$257, %rdx
	jb  	Ljade_aead_chacha20poly1305_amd64_avx2_open$3
	movq	%rax, %r11
	movq	%rcx, %r10
	movq	%rdx, %rcx
	movq	%rsi, %rax
	movl	%r8d, %edx
	movq	%rdi, %r9
	leaq	-1208(%rsp), %rsp
	call	L_chacha_xor_v_avx2_ic$1
Ljade_aead_chacha20poly1305_amd64_avx2_open$6:
	leaq	1208(%rsp), %rsp
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx2_open$4
Ljade_aead_chacha20poly1305_amd64_avx2_open$3:
	movq	%rax, %r11
	movq	%rcx, %r10
	movq	%rdx, %rcx
	movq	%rsi, %rax
	movl	%r8d, %edx
	movq	%rdi, %r9
	call	L_chacha_xor_h_x2_avx2_ic$1
Ljade_aead_chacha20poly1305_amd64_avx2_open$5:
Ljade_aead_chacha20poly1305_amd64_avx2_open$4:
	movq	$0, %rax
Ljade_aead_chacha20poly1305_amd64_avx2_open$2:
Ljade_aead_chacha20poly1305_amd64_avx2_open$1:
	movq	832(%rsp), %rbx
	movq	840(%rsp), %rbp
	movq	848(%rsp), %r12
	movq	856(%rsp), %r13
	movq	864(%rsp), %r14
	movq	872(%rsp), %r15
	movq	880(%rsp), %rsp
	ret 
_jade_aead_chacha20poly1305_amd64_avx2:
jade_aead_chacha20poly1305_amd64_avx2:
	movq	%rsp, %rax
	leaq	-240(%rsp), %rsp
	andq	$-32, %rsp
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
	cmpq	$257, %rcx
	jb  	Ljade_aead_chacha20poly1305_amd64_avx2$12
	movq	%rdi, %r11
	movq	%rax, %r10
	movq	%r8, %rax
	leaq	-1208(%rsp), %rsp
	call	L_chacha_xor_v_avx2_ic$1
Ljade_aead_chacha20poly1305_amd64_avx2$15:
	leaq	1208(%rsp), %rsp
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx2$13
Ljade_aead_chacha20poly1305_amd64_avx2$12:
	movq	%rdi, %r11
	movq	%rax, %r10
	movq	%r8, %rax
	call	L_chacha_xor_h_x2_avx2_ic$1
Ljade_aead_chacha20poly1305_amd64_avx2$14:
Ljade_aead_chacha20poly1305_amd64_avx2$13:
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
Ljade_aead_chacha20poly1305_amd64_avx2$11:
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
	jnbe	Ljade_aead_chacha20poly1305_amd64_avx2$11
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
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx2$9
Ljade_aead_chacha20poly1305_amd64_avx2$10:
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
Ljade_aead_chacha20poly1305_amd64_avx2$9:
	cmpq	$16, %rdi
	jnb 	Ljade_aead_chacha20poly1305_amd64_avx2$10
	cmpq	$0, %rdi
	jbe 	Ljade_aead_chacha20poly1305_amd64_avx2$6
	movq	$0, 56(%rsp)
	movq	$0, 64(%rsp)
	movq	$0, %rax
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx2$7
Ljade_aead_chacha20poly1305_amd64_avx2$8:
	movb	(%rsi,%rax), %dl
	movb	%dl, 56(%rsp,%rax)
	incq	%rax
Ljade_aead_chacha20poly1305_amd64_avx2$7:
	cmpq	%rdi, %rax
	jb  	Ljade_aead_chacha20poly1305_amd64_avx2$8
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
Ljade_aead_chacha20poly1305_amd64_avx2$6:
	movq	16(%rsp), %rsi
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx2$4
Ljade_aead_chacha20poly1305_amd64_avx2$5:
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
Ljade_aead_chacha20poly1305_amd64_avx2$4:
	cmpq	$16, %rsi
	jnb 	Ljade_aead_chacha20poly1305_amd64_avx2$5
	cmpq	$0, %rsi
	jbe 	Ljade_aead_chacha20poly1305_amd64_avx2$1
	movq	$0, 56(%rsp)
	movq	$0, 64(%rsp)
	movq	$0, %rax
	jmp 	Ljade_aead_chacha20poly1305_amd64_avx2$2
Ljade_aead_chacha20poly1305_amd64_avx2$3:
	movb	(%rcx,%rax), %dl
	movb	%dl, 56(%rsp,%rax)
	incq	%rax
Ljade_aead_chacha20poly1305_amd64_avx2$2:
	cmpq	%rsi, %rax
	jb  	Ljade_aead_chacha20poly1305_amd64_avx2$3
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
Ljade_aead_chacha20poly1305_amd64_avx2$1:
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
L_chacha_v_avx2_ic$1:
	vmovdqu	glob_data + 160(%rip), %ymm0
	vmovdqu	glob_data + 128(%rip), %ymm1
	vmovdqu	%ymm0, 32(%rsp)
	vmovdqu	%ymm1, 64(%rsp)
	movl	%eax, 1184(%rsp)
	vmovdqu	glob_data + 256(%rip), %ymm0
	vmovdqu	glob_data + 288(%rip), %ymm1
	vmovdqu	glob_data + 320(%rip), %ymm2
	vmovdqu	glob_data + 352(%rip), %ymm3
	vpbroadcastd	(%rcx), %ymm4
	vpbroadcastd	4(%rcx), %ymm5
	vpbroadcastd	8(%rcx), %ymm6
	vpbroadcastd	12(%rcx), %ymm7
	vpbroadcastd	16(%rcx), %ymm8
	vpbroadcastd	20(%rcx), %ymm9
	vpbroadcastd	24(%rcx), %ymm10
	vpbroadcastd	28(%rcx), %ymm11
	vpbroadcastd	1184(%rsp), %ymm12
	vpaddd	glob_data + 224(%rip), %ymm12, %ymm12
	vpbroadcastd	(%rdx), %ymm13
	vpbroadcastd	4(%rdx), %ymm14
	vpbroadcastd	8(%rdx), %ymm15
	vmovdqu	%ymm0, 672(%rsp)
	vmovdqu	%ymm1, 704(%rsp)
	vmovdqu	%ymm2, 736(%rsp)
	vmovdqu	%ymm3, 768(%rsp)
	vmovdqu	%ymm4, 800(%rsp)
	vmovdqu	%ymm5, 832(%rsp)
	vmovdqu	%ymm6, 864(%rsp)
	vmovdqu	%ymm7, 896(%rsp)
	vmovdqu	%ymm8, 928(%rsp)
	vmovdqu	%ymm9, 960(%rsp)
	vmovdqu	%ymm10, 992(%rsp)
	vmovdqu	%ymm11, 1024(%rsp)
	vmovdqu	%ymm12, 1056(%rsp)
	vmovdqu	%ymm13, 1088(%rsp)
	vmovdqu	%ymm14, 1120(%rsp)
	vmovdqu	%ymm15, 1152(%rsp)
	jmp 	L_chacha_v_avx2_ic$12
L_chacha_v_avx2_ic$13:
	vmovdqu	672(%rsp), %ymm0
	vmovdqu	704(%rsp), %ymm1
	vmovdqu	736(%rsp), %ymm2
	vmovdqu	768(%rsp), %ymm3
	vmovdqu	800(%rsp), %ymm4
	vmovdqu	832(%rsp), %ymm5
	vmovdqu	864(%rsp), %ymm6
	vmovdqu	896(%rsp), %ymm7
	vmovdqu	928(%rsp), %ymm8
	vmovdqu	960(%rsp), %ymm9
	vmovdqu	992(%rsp), %ymm10
	vmovdqu	1024(%rsp), %ymm11
	vmovdqu	1056(%rsp), %ymm12
	vmovdqu	1088(%rsp), %ymm13
	vmovdqu	1120(%rsp), %ymm14
	vmovdqu	1152(%rsp), %ymm15
	vmovdqu	%ymm15, 96(%rsp)
	movl	$10, %eax
L_chacha_v_avx2_ic$14:
	vpaddd	%ymm4, %ymm0, %ymm0
	vpxor	%ymm0, %ymm12, %ymm12
	vpshufb	32(%rsp), %ymm12, %ymm12
	vpaddd	%ymm12, %ymm8, %ymm8
	vpaddd	%ymm6, %ymm2, %ymm2
	vpxor	%ymm8, %ymm4, %ymm4
	vpxor	%ymm2, %ymm14, %ymm14
	vpslld	$12, %ymm4, %ymm15
	vpsrld	$20, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm4, %ymm0, %ymm0
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm0, %ymm12, %ymm12
	vpxor	%ymm10, %ymm6, %ymm6
	vpshufb	64(%rsp), %ymm12, %ymm12
	vpslld	$12, %ymm6, %ymm15
	vpsrld	$20, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vpaddd	%ymm12, %ymm8, %ymm8
	vpaddd	%ymm6, %ymm2, %ymm2
	vpxor	%ymm8, %ymm4, %ymm4
	vpxor	%ymm2, %ymm14, %ymm14
	vpslld	$7, %ymm4, %ymm15
	vpsrld	$25, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm10, %ymm6, %ymm6
	vpslld	$7, %ymm6, %ymm15
	vpsrld	$25, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vmovdqu	96(%rsp), %ymm15
	vmovdqu	%ymm14, 128(%rsp)
	vpaddd	%ymm5, %ymm1, %ymm1
	vpxor	%ymm1, %ymm13, %ymm13
	vpshufb	32(%rsp), %ymm13, %ymm13
	vpaddd	%ymm13, %ymm9, %ymm9
	vpaddd	%ymm7, %ymm3, %ymm3
	vpxor	%ymm9, %ymm5, %ymm5
	vpxor	%ymm3, %ymm15, %ymm14
	vpslld	$12, %ymm5, %ymm15
	vpsrld	$20, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm5, %ymm1, %ymm1
	vpaddd	%ymm14, %ymm11, %ymm11
	vpxor	%ymm1, %ymm13, %ymm13
	vpxor	%ymm11, %ymm7, %ymm7
	vpshufb	64(%rsp), %ymm13, %ymm13
	vpslld	$12, %ymm7, %ymm15
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpaddd	%ymm13, %ymm9, %ymm9
	vpaddd	%ymm7, %ymm3, %ymm3
	vpxor	%ymm9, %ymm5, %ymm5
	vpxor	%ymm3, %ymm14, %ymm14
	vpslld	$7, %ymm5, %ymm15
	vpsrld	$25, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm11, %ymm11
	vpxor	%ymm11, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm15
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpaddd	%ymm6, %ymm1, %ymm1
	vpxor	%ymm1, %ymm12, %ymm12
	vpshufb	32(%rsp), %ymm12, %ymm12
	vpaddd	%ymm12, %ymm11, %ymm11
	vpaddd	%ymm5, %ymm0, %ymm0
	vpxor	%ymm11, %ymm6, %ymm6
	vpxor	%ymm0, %ymm14, %ymm14
	vpslld	$12, %ymm6, %ymm15
	vpsrld	$20, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm6, %ymm1, %ymm1
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm1, %ymm12, %ymm12
	vpxor	%ymm10, %ymm5, %ymm5
	vpshufb	64(%rsp), %ymm12, %ymm12
	vpslld	$12, %ymm5, %ymm15
	vpsrld	$20, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vpaddd	%ymm12, %ymm11, %ymm11
	vpaddd	%ymm5, %ymm0, %ymm0
	vpxor	%ymm11, %ymm6, %ymm6
	vpxor	%ymm0, %ymm14, %ymm14
	vpslld	$7, %ymm6, %ymm15
	vpsrld	$25, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpslld	$7, %ymm5, %ymm15
	vpsrld	$25, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vmovdqu	128(%rsp), %ymm15
	vmovdqu	%ymm14, 96(%rsp)
	vpaddd	%ymm7, %ymm2, %ymm2
	vpxor	%ymm2, %ymm13, %ymm13
	vpshufb	32(%rsp), %ymm13, %ymm13
	vpaddd	%ymm13, %ymm8, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm3
	vpxor	%ymm8, %ymm7, %ymm7
	vpxor	%ymm3, %ymm15, %ymm14
	vpslld	$12, %ymm7, %ymm15
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm7, %ymm2, %ymm2
	vpaddd	%ymm14, %ymm9, %ymm9
	vpxor	%ymm2, %ymm13, %ymm13
	vpxor	%ymm9, %ymm4, %ymm4
	vpshufb	64(%rsp), %ymm13, %ymm13
	vpslld	$12, %ymm4, %ymm15
	vpsrld	$20, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	vpaddd	%ymm13, %ymm8, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm3
	vpxor	%ymm8, %ymm7, %ymm7
	vpxor	%ymm3, %ymm14, %ymm14
	vpslld	$7, %ymm7, %ymm15
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm9, %ymm9
	vpxor	%ymm9, %ymm4, %ymm4
	vpslld	$7, %ymm4, %ymm15
	vpsrld	$25, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_v_avx2_ic$14
	vmovdqu	96(%rsp), %ymm15
	vpaddd	672(%rsp), %ymm0, %ymm0
	vpaddd	704(%rsp), %ymm1, %ymm1
	vpaddd	736(%rsp), %ymm2, %ymm2
	vpaddd	768(%rsp), %ymm3, %ymm3
	vpaddd	800(%rsp), %ymm4, %ymm4
	vpaddd	832(%rsp), %ymm5, %ymm5
	vpaddd	864(%rsp), %ymm6, %ymm6
	vpaddd	896(%rsp), %ymm7, %ymm7
	vpaddd	928(%rsp), %ymm8, %ymm8
	vpaddd	960(%rsp), %ymm9, %ymm9
	vpaddd	992(%rsp), %ymm10, %ymm10
	vpaddd	1024(%rsp), %ymm11, %ymm11
	vpaddd	1056(%rsp), %ymm12, %ymm12
	vpaddd	1088(%rsp), %ymm13, %ymm13
	vpaddd	1120(%rsp), %ymm14, %ymm14
	vpaddd	1152(%rsp), %ymm15, %ymm15
	vmovdqu	%ymm8, 160(%rsp)
	vmovdqu	%ymm9, 192(%rsp)
	vmovdqu	%ymm10, 224(%rsp)
	vmovdqu	%ymm11, 256(%rsp)
	vmovdqu	%ymm12, 288(%rsp)
	vmovdqu	%ymm13, 320(%rsp)
	vmovdqu	%ymm14, 352(%rsp)
	vmovdqu	%ymm15, 384(%rsp)
	vpunpckldq	%ymm1, %ymm0, %ymm8
	vpunpckhdq	%ymm1, %ymm0, %ymm0
	vpunpckldq	%ymm3, %ymm2, %ymm1
	vpunpckhdq	%ymm3, %ymm2, %ymm2
	vpunpckldq	%ymm5, %ymm4, %ymm3
	vpunpckhdq	%ymm5, %ymm4, %ymm4
	vpunpckldq	%ymm7, %ymm6, %ymm5
	vpunpckhdq	%ymm7, %ymm6, %ymm6
	vpunpcklqdq	%ymm1, %ymm8, %ymm7
	vpunpcklqdq	%ymm5, %ymm3, %ymm9
	vpunpckhqdq	%ymm1, %ymm8, %ymm1
	vpunpckhqdq	%ymm5, %ymm3, %ymm3
	vpunpcklqdq	%ymm2, %ymm0, %ymm5
	vpunpcklqdq	%ymm6, %ymm4, %ymm8
	vpunpckhqdq	%ymm2, %ymm0, %ymm0
	vpunpckhqdq	%ymm6, %ymm4, %ymm2
	vperm2i128	$32, %ymm9, %ymm7, %ymm4
	vperm2i128	$49, %ymm9, %ymm7, %ymm6
	vperm2i128	$32, %ymm3, %ymm1, %ymm7
	vperm2i128	$49, %ymm3, %ymm1, %ymm1
	vperm2i128	$32, %ymm8, %ymm5, %ymm3
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vperm2i128	$32, %ymm2, %ymm0, %ymm8
	vperm2i128	$49, %ymm2, %ymm0, %ymm0
	vmovdqu	%ymm4, (%rdi)
	vmovdqu	%ymm7, 64(%rdi)
	vmovdqu	%ymm3, 128(%rdi)
	vmovdqu	%ymm8, 192(%rdi)
	vmovdqu	%ymm6, 256(%rdi)
	vmovdqu	%ymm1, 320(%rdi)
	vmovdqu	%ymm5, 384(%rdi)
	vmovdqu	%ymm0, 448(%rdi)
	vmovdqu	160(%rsp), %ymm0
	vmovdqu	224(%rsp), %ymm1
	vmovdqu	288(%rsp), %ymm2
	vmovdqu	352(%rsp), %ymm3
	vpunpckldq	192(%rsp), %ymm0, %ymm4
	vpunpckhdq	192(%rsp), %ymm0, %ymm0
	vpunpckldq	256(%rsp), %ymm1, %ymm5
	vpunpckhdq	256(%rsp), %ymm1, %ymm1
	vpunpckldq	320(%rsp), %ymm2, %ymm6
	vpunpckhdq	320(%rsp), %ymm2, %ymm2
	vpunpckldq	384(%rsp), %ymm3, %ymm7
	vpunpckhdq	384(%rsp), %ymm3, %ymm3
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpunpckhqdq	%ymm7, %ymm6, %ymm5
	vpunpcklqdq	%ymm1, %ymm0, %ymm6
	vpunpcklqdq	%ymm3, %ymm2, %ymm7
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpunpckhqdq	%ymm3, %ymm2, %ymm1
	vperm2i128	$32, %ymm9, %ymm8, %ymm2
	vperm2i128	$49, %ymm9, %ymm8, %ymm3
	vperm2i128	$32, %ymm5, %ymm4, %ymm8
	vperm2i128	$49, %ymm5, %ymm4, %ymm4
	vperm2i128	$32, %ymm7, %ymm6, %ymm5
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vperm2i128	$32, %ymm1, %ymm0, %ymm7
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vmovdqu	%ymm2, 32(%rdi)
	vmovdqu	%ymm8, 96(%rdi)
	vmovdqu	%ymm5, 160(%rdi)
	vmovdqu	%ymm7, 224(%rdi)
	vmovdqu	%ymm3, 288(%rdi)
	vmovdqu	%ymm4, 352(%rdi)
	vmovdqu	%ymm6, 416(%rdi)
	vmovdqu	%ymm0, 480(%rdi)
	addq	$512, %rdi
	addq	$-512, %rsi
	vmovdqu	glob_data + 0(%rip), %ymm0
	vpaddd	1056(%rsp), %ymm0, %ymm0
	vmovdqu	%ymm0, 1056(%rsp)
L_chacha_v_avx2_ic$12:
	cmpq	$512, %rsi
	jnb 	L_chacha_v_avx2_ic$13
	cmpq	$0, %rsi
	jbe 	L_chacha_v_avx2_ic$2
	vmovdqu	672(%rsp), %ymm0
	vmovdqu	704(%rsp), %ymm1
	vmovdqu	736(%rsp), %ymm2
	vmovdqu	768(%rsp), %ymm3
	vmovdqu	800(%rsp), %ymm4
	vmovdqu	832(%rsp), %ymm5
	vmovdqu	864(%rsp), %ymm6
	vmovdqu	896(%rsp), %ymm7
	vmovdqu	928(%rsp), %ymm8
	vmovdqu	960(%rsp), %ymm9
	vmovdqu	992(%rsp), %ymm10
	vmovdqu	1024(%rsp), %ymm11
	vmovdqu	1056(%rsp), %ymm12
	vmovdqu	1088(%rsp), %ymm13
	vmovdqu	1120(%rsp), %ymm14
	vmovdqu	1152(%rsp), %ymm15
	vmovdqu	%ymm15, 96(%rsp)
	movl	$10, %eax
L_chacha_v_avx2_ic$11:
	vpaddd	%ymm4, %ymm0, %ymm0
	vpxor	%ymm0, %ymm12, %ymm12
	vpshufb	32(%rsp), %ymm12, %ymm12
	vpaddd	%ymm12, %ymm8, %ymm8
	vpaddd	%ymm6, %ymm2, %ymm2
	vpxor	%ymm8, %ymm4, %ymm4
	vpxor	%ymm2, %ymm14, %ymm14
	vpslld	$12, %ymm4, %ymm15
	vpsrld	$20, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm4, %ymm0, %ymm0
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm0, %ymm12, %ymm12
	vpxor	%ymm10, %ymm6, %ymm6
	vpshufb	64(%rsp), %ymm12, %ymm12
	vpslld	$12, %ymm6, %ymm15
	vpsrld	$20, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vpaddd	%ymm12, %ymm8, %ymm8
	vpaddd	%ymm6, %ymm2, %ymm2
	vpxor	%ymm8, %ymm4, %ymm4
	vpxor	%ymm2, %ymm14, %ymm14
	vpslld	$7, %ymm4, %ymm15
	vpsrld	$25, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm10, %ymm6, %ymm6
	vpslld	$7, %ymm6, %ymm15
	vpsrld	$25, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vmovdqu	96(%rsp), %ymm15
	vmovdqu	%ymm14, 128(%rsp)
	vpaddd	%ymm5, %ymm1, %ymm1
	vpxor	%ymm1, %ymm13, %ymm13
	vpshufb	32(%rsp), %ymm13, %ymm13
	vpaddd	%ymm13, %ymm9, %ymm9
	vpaddd	%ymm7, %ymm3, %ymm3
	vpxor	%ymm9, %ymm5, %ymm5
	vpxor	%ymm3, %ymm15, %ymm14
	vpslld	$12, %ymm5, %ymm15
	vpsrld	$20, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm5, %ymm1, %ymm1
	vpaddd	%ymm14, %ymm11, %ymm11
	vpxor	%ymm1, %ymm13, %ymm13
	vpxor	%ymm11, %ymm7, %ymm7
	vpshufb	64(%rsp), %ymm13, %ymm13
	vpslld	$12, %ymm7, %ymm15
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpaddd	%ymm13, %ymm9, %ymm9
	vpaddd	%ymm7, %ymm3, %ymm3
	vpxor	%ymm9, %ymm5, %ymm5
	vpxor	%ymm3, %ymm14, %ymm14
	vpslld	$7, %ymm5, %ymm15
	vpsrld	$25, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm11, %ymm11
	vpxor	%ymm11, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm15
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpaddd	%ymm6, %ymm1, %ymm1
	vpxor	%ymm1, %ymm12, %ymm12
	vpshufb	32(%rsp), %ymm12, %ymm12
	vpaddd	%ymm12, %ymm11, %ymm11
	vpaddd	%ymm5, %ymm0, %ymm0
	vpxor	%ymm11, %ymm6, %ymm6
	vpxor	%ymm0, %ymm14, %ymm14
	vpslld	$12, %ymm6, %ymm15
	vpsrld	$20, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm6, %ymm1, %ymm1
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm1, %ymm12, %ymm12
	vpxor	%ymm10, %ymm5, %ymm5
	vpshufb	64(%rsp), %ymm12, %ymm12
	vpslld	$12, %ymm5, %ymm15
	vpsrld	$20, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vpaddd	%ymm12, %ymm11, %ymm11
	vpaddd	%ymm5, %ymm0, %ymm0
	vpxor	%ymm11, %ymm6, %ymm6
	vpxor	%ymm0, %ymm14, %ymm14
	vpslld	$7, %ymm6, %ymm15
	vpsrld	$25, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpslld	$7, %ymm5, %ymm15
	vpsrld	$25, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vmovdqu	128(%rsp), %ymm15
	vmovdqu	%ymm14, 96(%rsp)
	vpaddd	%ymm7, %ymm2, %ymm2
	vpxor	%ymm2, %ymm13, %ymm13
	vpshufb	32(%rsp), %ymm13, %ymm13
	vpaddd	%ymm13, %ymm8, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm3
	vpxor	%ymm8, %ymm7, %ymm7
	vpxor	%ymm3, %ymm15, %ymm14
	vpslld	$12, %ymm7, %ymm15
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm7, %ymm2, %ymm2
	vpaddd	%ymm14, %ymm9, %ymm9
	vpxor	%ymm2, %ymm13, %ymm13
	vpxor	%ymm9, %ymm4, %ymm4
	vpshufb	64(%rsp), %ymm13, %ymm13
	vpslld	$12, %ymm4, %ymm15
	vpsrld	$20, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	vpaddd	%ymm13, %ymm8, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm3
	vpxor	%ymm8, %ymm7, %ymm7
	vpxor	%ymm3, %ymm14, %ymm14
	vpslld	$7, %ymm7, %ymm15
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm9, %ymm9
	vpxor	%ymm9, %ymm4, %ymm4
	vpslld	$7, %ymm4, %ymm15
	vpsrld	$25, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_v_avx2_ic$11
	vmovdqu	96(%rsp), %ymm15
	vpaddd	672(%rsp), %ymm0, %ymm0
	vpaddd	704(%rsp), %ymm1, %ymm1
	vpaddd	736(%rsp), %ymm2, %ymm2
	vpaddd	768(%rsp), %ymm3, %ymm3
	vpaddd	800(%rsp), %ymm4, %ymm4
	vpaddd	832(%rsp), %ymm5, %ymm5
	vpaddd	864(%rsp), %ymm6, %ymm6
	vpaddd	896(%rsp), %ymm7, %ymm7
	vpaddd	928(%rsp), %ymm8, %ymm8
	vpaddd	960(%rsp), %ymm9, %ymm9
	vpaddd	992(%rsp), %ymm10, %ymm10
	vpaddd	1024(%rsp), %ymm11, %ymm11
	vpaddd	1056(%rsp), %ymm12, %ymm12
	vpaddd	1088(%rsp), %ymm13, %ymm13
	vpaddd	1120(%rsp), %ymm14, %ymm14
	vpaddd	1152(%rsp), %ymm15, %ymm15
	vmovdqu	%ymm8, 160(%rsp)
	vmovdqu	%ymm9, 192(%rsp)
	vmovdqu	%ymm10, 224(%rsp)
	vmovdqu	%ymm11, 256(%rsp)
	vmovdqu	%ymm12, 288(%rsp)
	vmovdqu	%ymm13, 320(%rsp)
	vmovdqu	%ymm14, 352(%rsp)
	vmovdqu	%ymm15, 384(%rsp)
	vpunpckldq	%ymm1, %ymm0, %ymm8
	vpunpckhdq	%ymm1, %ymm0, %ymm0
	vpunpckldq	%ymm3, %ymm2, %ymm1
	vpunpckhdq	%ymm3, %ymm2, %ymm2
	vpunpckldq	%ymm5, %ymm4, %ymm3
	vpunpckhdq	%ymm5, %ymm4, %ymm4
	vpunpckldq	%ymm7, %ymm6, %ymm5
	vpunpckhdq	%ymm7, %ymm6, %ymm6
	vpunpcklqdq	%ymm1, %ymm8, %ymm7
	vpunpcklqdq	%ymm5, %ymm3, %ymm9
	vpunpckhqdq	%ymm1, %ymm8, %ymm1
	vpunpckhqdq	%ymm5, %ymm3, %ymm3
	vpunpcklqdq	%ymm2, %ymm0, %ymm5
	vpunpcklqdq	%ymm6, %ymm4, %ymm8
	vpunpckhqdq	%ymm2, %ymm0, %ymm0
	vpunpckhqdq	%ymm6, %ymm4, %ymm2
	vperm2i128	$32, %ymm9, %ymm7, %ymm4
	vperm2i128	$49, %ymm9, %ymm7, %ymm6
	vperm2i128	$32, %ymm3, %ymm1, %ymm7
	vperm2i128	$49, %ymm3, %ymm1, %ymm1
	vperm2i128	$32, %ymm8, %ymm5, %ymm3
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vperm2i128	$32, %ymm2, %ymm0, %ymm8
	vperm2i128	$49, %ymm2, %ymm0, %ymm0
	vmovdqu	%ymm4, 416(%rsp)
	vmovdqu	%ymm7, 448(%rsp)
	vmovdqu	%ymm3, 480(%rsp)
	vmovdqu	%ymm8, 512(%rsp)
	vmovdqu	%ymm6, 544(%rsp)
	vmovdqu	%ymm1, 576(%rsp)
	vmovdqu	%ymm5, 608(%rsp)
	vmovdqu	%ymm0, 640(%rsp)
	vmovdqu	160(%rsp), %ymm0
	vmovdqu	224(%rsp), %ymm1
	vmovdqu	288(%rsp), %ymm2
	vmovdqu	352(%rsp), %ymm3
	vpunpckldq	192(%rsp), %ymm0, %ymm4
	vpunpckhdq	192(%rsp), %ymm0, %ymm0
	vpunpckldq	256(%rsp), %ymm1, %ymm5
	vpunpckhdq	256(%rsp), %ymm1, %ymm1
	vpunpckldq	320(%rsp), %ymm2, %ymm6
	vpunpckhdq	320(%rsp), %ymm2, %ymm2
	vpunpckldq	384(%rsp), %ymm3, %ymm7
	vpunpckhdq	384(%rsp), %ymm3, %ymm3
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpunpckhqdq	%ymm7, %ymm6, %ymm5
	vpunpcklqdq	%ymm1, %ymm0, %ymm6
	vpunpcklqdq	%ymm3, %ymm2, %ymm7
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpunpckhqdq	%ymm3, %ymm2, %ymm1
	vperm2i128	$32, %ymm9, %ymm8, %ymm2
	vperm2i128	$49, %ymm9, %ymm8, %ymm3
	vperm2i128	$32, %ymm5, %ymm4, %ymm8
	vperm2i128	$49, %ymm5, %ymm4, %ymm4
	vperm2i128	$32, %ymm7, %ymm6, %ymm5
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vperm2i128	$32, %ymm1, %ymm0, %ymm7
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vmovdqu	416(%rsp), %ymm9
	vmovdqu	%ymm2, %ymm10
	vmovdqu	448(%rsp), %ymm12
	vmovdqu	%ymm8, %ymm11
	vmovdqu	480(%rsp), %ymm8
	vmovdqu	512(%rsp), %ymm2
	vmovdqu	%ymm7, %ymm1
	cmpq	$256, %rsi
	jb  	L_chacha_v_avx2_ic$10
	vmovdqu	%ymm9, (%rdi)
	vmovdqu	%ymm10, 32(%rdi)
	vmovdqu	%ymm12, 64(%rdi)
	vmovdqu	%ymm11, 96(%rdi)
	vmovdqu	%ymm8, 128(%rdi)
	vmovdqu	%ymm5, 160(%rdi)
	vmovdqu	%ymm2, 192(%rdi)
	vmovdqu	%ymm1, 224(%rdi)
	addq	$256, %rdi
	addq	$-256, %rsi
	vmovdqu	544(%rsp), %ymm9
	vmovdqu	%ymm3, %ymm10
	vmovdqu	576(%rsp), %ymm12
	vmovdqu	%ymm4, %ymm11
	vmovdqu	608(%rsp), %ymm8
	vmovdqu	%ymm6, %ymm5
	vmovdqu	640(%rsp), %ymm2
	vmovdqu	%ymm0, %ymm1
L_chacha_v_avx2_ic$10:
	cmpq	$128, %rsi
	jb  	L_chacha_v_avx2_ic$9
	vmovdqu	%ymm9, (%rdi)
	vmovdqu	%ymm10, 32(%rdi)
	vmovdqu	%ymm12, 64(%rdi)
	vmovdqu	%ymm11, 96(%rdi)
	addq	$128, %rdi
	addq	$-128, %rsi
	vmovdqu	%ymm8, %ymm9
	vmovdqu	%ymm5, %ymm10
	vmovdqu	%ymm2, %ymm12
	vmovdqu	%ymm1, %ymm11
L_chacha_v_avx2_ic$9:
	cmpq	$64, %rsi
	jb  	L_chacha_v_avx2_ic$8
	vmovdqu	%ymm9, (%rdi)
	vmovdqu	%ymm10, 32(%rdi)
	addq	$64, %rdi
	addq	$-64, %rsi
	vmovdqu	%ymm12, %ymm9
	vmovdqu	%ymm11, %ymm10
L_chacha_v_avx2_ic$8:
	cmpq	$32, %rsi
	jb  	L_chacha_v_avx2_ic$7
	vmovdqu	%ymm9, (%rdi)
	addq	$32, %rdi
	addq	$-32, %rsi
	vmovdqu	%ymm10, %ymm9
L_chacha_v_avx2_ic$7:
	vmovdqu	%xmm9, %xmm0
	cmpq	$16, %rsi
	jb  	L_chacha_v_avx2_ic$6
	vmovdqu	%xmm0, (%rdi)
	addq	$16, %rdi
	addq	$-16, %rsi
	vextracti128	$1, %ymm9, %xmm0
L_chacha_v_avx2_ic$6:
	vpextrq	$0, %xmm0, %rax
	cmpq	$8, %rsi
	jb  	L_chacha_v_avx2_ic$3
	movq	%rax, (%rdi)
	addq	$8, %rdi
	addq	$-8, %rsi
	vpextrq	$1, %xmm0, %rax
L_chacha_v_avx2_ic$5:
	jmp 	L_chacha_v_avx2_ic$3
L_chacha_v_avx2_ic$4:
	movb	%al, %cl
	movb	%cl, (%rdi)
	shrq	$8, %rax
	incq	%rdi
	addq	$-1, %rsi
L_chacha_v_avx2_ic$3:
	cmpq	$0, %rsi
	jnbe	L_chacha_v_avx2_ic$4
L_chacha_v_avx2_ic$2:
	ret 
L_chacha_xor_v_avx2_ic$1:
	vmovdqu	glob_data + 160(%rip), %ymm0
	vmovdqu	glob_data + 128(%rip), %ymm1
	vmovdqu	%ymm0, 32(%rsp)
	vmovdqu	%ymm1, 64(%rsp)
	movl	%edx, 1184(%rsp)
	vmovdqu	glob_data + 256(%rip), %ymm0
	vmovdqu	glob_data + 288(%rip), %ymm1
	vmovdqu	glob_data + 320(%rip), %ymm2
	vmovdqu	glob_data + 352(%rip), %ymm3
	vpbroadcastd	(%r9), %ymm4
	vpbroadcastd	4(%r9), %ymm5
	vpbroadcastd	8(%r9), %ymm6
	vpbroadcastd	12(%r9), %ymm7
	vpbroadcastd	16(%r9), %ymm8
	vpbroadcastd	20(%r9), %ymm9
	vpbroadcastd	24(%r9), %ymm10
	vpbroadcastd	28(%r9), %ymm11
	vpbroadcastd	1184(%rsp), %ymm12
	vpaddd	glob_data + 224(%rip), %ymm12, %ymm12
	vpbroadcastd	(%rax), %ymm13
	vpbroadcastd	4(%rax), %ymm14
	vpbroadcastd	8(%rax), %ymm15
	vmovdqu	%ymm0, 672(%rsp)
	vmovdqu	%ymm1, 704(%rsp)
	vmovdqu	%ymm2, 736(%rsp)
	vmovdqu	%ymm3, 768(%rsp)
	vmovdqu	%ymm4, 800(%rsp)
	vmovdqu	%ymm5, 832(%rsp)
	vmovdqu	%ymm6, 864(%rsp)
	vmovdqu	%ymm7, 896(%rsp)
	vmovdqu	%ymm8, 928(%rsp)
	vmovdqu	%ymm9, 960(%rsp)
	vmovdqu	%ymm10, 992(%rsp)
	vmovdqu	%ymm11, 1024(%rsp)
	vmovdqu	%ymm12, 1056(%rsp)
	vmovdqu	%ymm13, 1088(%rsp)
	vmovdqu	%ymm14, 1120(%rsp)
	vmovdqu	%ymm15, 1152(%rsp)
	jmp 	L_chacha_xor_v_avx2_ic$12
L_chacha_xor_v_avx2_ic$13:
	vmovdqu	672(%rsp), %ymm0
	vmovdqu	704(%rsp), %ymm1
	vmovdqu	736(%rsp), %ymm2
	vmovdqu	768(%rsp), %ymm3
	vmovdqu	800(%rsp), %ymm4
	vmovdqu	832(%rsp), %ymm5
	vmovdqu	864(%rsp), %ymm6
	vmovdqu	896(%rsp), %ymm7
	vmovdqu	928(%rsp), %ymm8
	vmovdqu	960(%rsp), %ymm9
	vmovdqu	992(%rsp), %ymm10
	vmovdqu	1024(%rsp), %ymm11
	vmovdqu	1056(%rsp), %ymm12
	vmovdqu	1088(%rsp), %ymm13
	vmovdqu	1120(%rsp), %ymm14
	vmovdqu	1152(%rsp), %ymm15
	vmovdqu	%ymm15, 96(%rsp)
	movl	$10, %eax
L_chacha_xor_v_avx2_ic$14:
	vpaddd	%ymm4, %ymm0, %ymm0
	vpxor	%ymm0, %ymm12, %ymm12
	vpshufb	32(%rsp), %ymm12, %ymm12
	vpaddd	%ymm12, %ymm8, %ymm8
	vpaddd	%ymm6, %ymm2, %ymm2
	vpxor	%ymm8, %ymm4, %ymm4
	vpxor	%ymm2, %ymm14, %ymm14
	vpslld	$12, %ymm4, %ymm15
	vpsrld	$20, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm4, %ymm0, %ymm0
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm0, %ymm12, %ymm12
	vpxor	%ymm10, %ymm6, %ymm6
	vpshufb	64(%rsp), %ymm12, %ymm12
	vpslld	$12, %ymm6, %ymm15
	vpsrld	$20, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vpaddd	%ymm12, %ymm8, %ymm8
	vpaddd	%ymm6, %ymm2, %ymm2
	vpxor	%ymm8, %ymm4, %ymm4
	vpxor	%ymm2, %ymm14, %ymm14
	vpslld	$7, %ymm4, %ymm15
	vpsrld	$25, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm10, %ymm6, %ymm6
	vpslld	$7, %ymm6, %ymm15
	vpsrld	$25, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vmovdqu	96(%rsp), %ymm15
	vmovdqu	%ymm14, 128(%rsp)
	vpaddd	%ymm5, %ymm1, %ymm1
	vpxor	%ymm1, %ymm13, %ymm13
	vpshufb	32(%rsp), %ymm13, %ymm13
	vpaddd	%ymm13, %ymm9, %ymm9
	vpaddd	%ymm7, %ymm3, %ymm3
	vpxor	%ymm9, %ymm5, %ymm5
	vpxor	%ymm3, %ymm15, %ymm14
	vpslld	$12, %ymm5, %ymm15
	vpsrld	$20, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm5, %ymm1, %ymm1
	vpaddd	%ymm14, %ymm11, %ymm11
	vpxor	%ymm1, %ymm13, %ymm13
	vpxor	%ymm11, %ymm7, %ymm7
	vpshufb	64(%rsp), %ymm13, %ymm13
	vpslld	$12, %ymm7, %ymm15
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpaddd	%ymm13, %ymm9, %ymm9
	vpaddd	%ymm7, %ymm3, %ymm3
	vpxor	%ymm9, %ymm5, %ymm5
	vpxor	%ymm3, %ymm14, %ymm14
	vpslld	$7, %ymm5, %ymm15
	vpsrld	$25, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm11, %ymm11
	vpxor	%ymm11, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm15
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpaddd	%ymm6, %ymm1, %ymm1
	vpxor	%ymm1, %ymm12, %ymm12
	vpshufb	32(%rsp), %ymm12, %ymm12
	vpaddd	%ymm12, %ymm11, %ymm11
	vpaddd	%ymm5, %ymm0, %ymm0
	vpxor	%ymm11, %ymm6, %ymm6
	vpxor	%ymm0, %ymm14, %ymm14
	vpslld	$12, %ymm6, %ymm15
	vpsrld	$20, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm6, %ymm1, %ymm1
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm1, %ymm12, %ymm12
	vpxor	%ymm10, %ymm5, %ymm5
	vpshufb	64(%rsp), %ymm12, %ymm12
	vpslld	$12, %ymm5, %ymm15
	vpsrld	$20, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vpaddd	%ymm12, %ymm11, %ymm11
	vpaddd	%ymm5, %ymm0, %ymm0
	vpxor	%ymm11, %ymm6, %ymm6
	vpxor	%ymm0, %ymm14, %ymm14
	vpslld	$7, %ymm6, %ymm15
	vpsrld	$25, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpslld	$7, %ymm5, %ymm15
	vpsrld	$25, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vmovdqu	128(%rsp), %ymm15
	vmovdqu	%ymm14, 96(%rsp)
	vpaddd	%ymm7, %ymm2, %ymm2
	vpxor	%ymm2, %ymm13, %ymm13
	vpshufb	32(%rsp), %ymm13, %ymm13
	vpaddd	%ymm13, %ymm8, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm3
	vpxor	%ymm8, %ymm7, %ymm7
	vpxor	%ymm3, %ymm15, %ymm14
	vpslld	$12, %ymm7, %ymm15
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm7, %ymm2, %ymm2
	vpaddd	%ymm14, %ymm9, %ymm9
	vpxor	%ymm2, %ymm13, %ymm13
	vpxor	%ymm9, %ymm4, %ymm4
	vpshufb	64(%rsp), %ymm13, %ymm13
	vpslld	$12, %ymm4, %ymm15
	vpsrld	$20, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	vpaddd	%ymm13, %ymm8, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm3
	vpxor	%ymm8, %ymm7, %ymm7
	vpxor	%ymm3, %ymm14, %ymm14
	vpslld	$7, %ymm7, %ymm15
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm9, %ymm9
	vpxor	%ymm9, %ymm4, %ymm4
	vpslld	$7, %ymm4, %ymm15
	vpsrld	$25, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_xor_v_avx2_ic$14
	vmovdqu	96(%rsp), %ymm15
	vpaddd	672(%rsp), %ymm0, %ymm0
	vpaddd	704(%rsp), %ymm1, %ymm1
	vpaddd	736(%rsp), %ymm2, %ymm2
	vpaddd	768(%rsp), %ymm3, %ymm3
	vpaddd	800(%rsp), %ymm4, %ymm4
	vpaddd	832(%rsp), %ymm5, %ymm5
	vpaddd	864(%rsp), %ymm6, %ymm6
	vpaddd	896(%rsp), %ymm7, %ymm7
	vpaddd	928(%rsp), %ymm8, %ymm8
	vpaddd	960(%rsp), %ymm9, %ymm9
	vpaddd	992(%rsp), %ymm10, %ymm10
	vpaddd	1024(%rsp), %ymm11, %ymm11
	vpaddd	1056(%rsp), %ymm12, %ymm12
	vpaddd	1088(%rsp), %ymm13, %ymm13
	vpaddd	1120(%rsp), %ymm14, %ymm14
	vpaddd	1152(%rsp), %ymm15, %ymm15
	vmovdqu	%ymm8, 160(%rsp)
	vmovdqu	%ymm9, 192(%rsp)
	vmovdqu	%ymm10, 224(%rsp)
	vmovdqu	%ymm11, 256(%rsp)
	vmovdqu	%ymm12, 288(%rsp)
	vmovdqu	%ymm13, 320(%rsp)
	vmovdqu	%ymm14, 352(%rsp)
	vmovdqu	%ymm15, 384(%rsp)
	vpunpckldq	%ymm1, %ymm0, %ymm8
	vpunpckhdq	%ymm1, %ymm0, %ymm0
	vpunpckldq	%ymm3, %ymm2, %ymm1
	vpunpckhdq	%ymm3, %ymm2, %ymm2
	vpunpckldq	%ymm5, %ymm4, %ymm3
	vpunpckhdq	%ymm5, %ymm4, %ymm4
	vpunpckldq	%ymm7, %ymm6, %ymm5
	vpunpckhdq	%ymm7, %ymm6, %ymm6
	vpunpcklqdq	%ymm1, %ymm8, %ymm7
	vpunpcklqdq	%ymm5, %ymm3, %ymm9
	vpunpckhqdq	%ymm1, %ymm8, %ymm1
	vpunpckhqdq	%ymm5, %ymm3, %ymm3
	vpunpcklqdq	%ymm2, %ymm0, %ymm5
	vpunpcklqdq	%ymm6, %ymm4, %ymm8
	vpunpckhqdq	%ymm2, %ymm0, %ymm0
	vpunpckhqdq	%ymm6, %ymm4, %ymm2
	vperm2i128	$32, %ymm9, %ymm7, %ymm4
	vperm2i128	$49, %ymm9, %ymm7, %ymm6
	vperm2i128	$32, %ymm3, %ymm1, %ymm7
	vperm2i128	$49, %ymm3, %ymm1, %ymm1
	vperm2i128	$32, %ymm8, %ymm5, %ymm3
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vperm2i128	$32, %ymm2, %ymm0, %ymm8
	vperm2i128	$49, %ymm2, %ymm0, %ymm0
	vpxor	(%r10), %ymm4, %ymm2
	vpxor	64(%r10), %ymm7, %ymm4
	vpxor	128(%r10), %ymm3, %ymm3
	vpxor	192(%r10), %ymm8, %ymm7
	vpxor	256(%r10), %ymm6, %ymm6
	vpxor	320(%r10), %ymm1, %ymm1
	vpxor	384(%r10), %ymm5, %ymm5
	vpxor	448(%r10), %ymm0, %ymm0
	vmovdqu	%ymm2, (%r11)
	vmovdqu	%ymm4, 64(%r11)
	vmovdqu	%ymm3, 128(%r11)
	vmovdqu	%ymm7, 192(%r11)
	vmovdqu	%ymm6, 256(%r11)
	vmovdqu	%ymm1, 320(%r11)
	vmovdqu	%ymm5, 384(%r11)
	vmovdqu	%ymm0, 448(%r11)
	vmovdqu	160(%rsp), %ymm0
	vmovdqu	224(%rsp), %ymm1
	vmovdqu	288(%rsp), %ymm2
	vmovdqu	352(%rsp), %ymm3
	vpunpckldq	192(%rsp), %ymm0, %ymm4
	vpunpckhdq	192(%rsp), %ymm0, %ymm0
	vpunpckldq	256(%rsp), %ymm1, %ymm5
	vpunpckhdq	256(%rsp), %ymm1, %ymm1
	vpunpckldq	320(%rsp), %ymm2, %ymm6
	vpunpckhdq	320(%rsp), %ymm2, %ymm2
	vpunpckldq	384(%rsp), %ymm3, %ymm7
	vpunpckhdq	384(%rsp), %ymm3, %ymm3
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpunpckhqdq	%ymm7, %ymm6, %ymm5
	vpunpcklqdq	%ymm1, %ymm0, %ymm6
	vpunpcklqdq	%ymm3, %ymm2, %ymm7
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpunpckhqdq	%ymm3, %ymm2, %ymm1
	vperm2i128	$32, %ymm9, %ymm8, %ymm2
	vperm2i128	$49, %ymm9, %ymm8, %ymm3
	vperm2i128	$32, %ymm5, %ymm4, %ymm8
	vperm2i128	$49, %ymm5, %ymm4, %ymm4
	vperm2i128	$32, %ymm7, %ymm6, %ymm5
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vperm2i128	$32, %ymm1, %ymm0, %ymm7
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vpxor	32(%r10), %ymm2, %ymm1
	vpxor	96(%r10), %ymm8, %ymm2
	vpxor	160(%r10), %ymm5, %ymm5
	vpxor	224(%r10), %ymm7, %ymm7
	vpxor	288(%r10), %ymm3, %ymm3
	vpxor	352(%r10), %ymm4, %ymm4
	vpxor	416(%r10), %ymm6, %ymm6
	vpxor	480(%r10), %ymm0, %ymm0
	vmovdqu	%ymm1, 32(%r11)
	vmovdqu	%ymm2, 96(%r11)
	vmovdqu	%ymm5, 160(%r11)
	vmovdqu	%ymm7, 224(%r11)
	vmovdqu	%ymm3, 288(%r11)
	vmovdqu	%ymm4, 352(%r11)
	vmovdqu	%ymm6, 416(%r11)
	vmovdqu	%ymm0, 480(%r11)
	addq	$512, %r11
	addq	$512, %r10
	addq	$-512, %rcx
	vmovdqu	glob_data + 0(%rip), %ymm0
	vpaddd	1056(%rsp), %ymm0, %ymm0
	vmovdqu	%ymm0, 1056(%rsp)
L_chacha_xor_v_avx2_ic$12:
	cmpq	$512, %rcx
	jnb 	L_chacha_xor_v_avx2_ic$13
	cmpq	$0, %rcx
	jbe 	L_chacha_xor_v_avx2_ic$2
	vmovdqu	672(%rsp), %ymm0
	vmovdqu	704(%rsp), %ymm1
	vmovdqu	736(%rsp), %ymm2
	vmovdqu	768(%rsp), %ymm3
	vmovdqu	800(%rsp), %ymm4
	vmovdqu	832(%rsp), %ymm5
	vmovdqu	864(%rsp), %ymm6
	vmovdqu	896(%rsp), %ymm7
	vmovdqu	928(%rsp), %ymm8
	vmovdqu	960(%rsp), %ymm9
	vmovdqu	992(%rsp), %ymm10
	vmovdqu	1024(%rsp), %ymm11
	vmovdqu	1056(%rsp), %ymm12
	vmovdqu	1088(%rsp), %ymm13
	vmovdqu	1120(%rsp), %ymm14
	vmovdqu	1152(%rsp), %ymm15
	vmovdqu	%ymm15, 96(%rsp)
	movl	$10, %eax
L_chacha_xor_v_avx2_ic$11:
	vpaddd	%ymm4, %ymm0, %ymm0
	vpxor	%ymm0, %ymm12, %ymm12
	vpshufb	32(%rsp), %ymm12, %ymm12
	vpaddd	%ymm12, %ymm8, %ymm8
	vpaddd	%ymm6, %ymm2, %ymm2
	vpxor	%ymm8, %ymm4, %ymm4
	vpxor	%ymm2, %ymm14, %ymm14
	vpslld	$12, %ymm4, %ymm15
	vpsrld	$20, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm4, %ymm0, %ymm0
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm0, %ymm12, %ymm12
	vpxor	%ymm10, %ymm6, %ymm6
	vpshufb	64(%rsp), %ymm12, %ymm12
	vpslld	$12, %ymm6, %ymm15
	vpsrld	$20, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vpaddd	%ymm12, %ymm8, %ymm8
	vpaddd	%ymm6, %ymm2, %ymm2
	vpxor	%ymm8, %ymm4, %ymm4
	vpxor	%ymm2, %ymm14, %ymm14
	vpslld	$7, %ymm4, %ymm15
	vpsrld	$25, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm10, %ymm6, %ymm6
	vpslld	$7, %ymm6, %ymm15
	vpsrld	$25, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vmovdqu	96(%rsp), %ymm15
	vmovdqu	%ymm14, 128(%rsp)
	vpaddd	%ymm5, %ymm1, %ymm1
	vpxor	%ymm1, %ymm13, %ymm13
	vpshufb	32(%rsp), %ymm13, %ymm13
	vpaddd	%ymm13, %ymm9, %ymm9
	vpaddd	%ymm7, %ymm3, %ymm3
	vpxor	%ymm9, %ymm5, %ymm5
	vpxor	%ymm3, %ymm15, %ymm14
	vpslld	$12, %ymm5, %ymm15
	vpsrld	$20, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm5, %ymm1, %ymm1
	vpaddd	%ymm14, %ymm11, %ymm11
	vpxor	%ymm1, %ymm13, %ymm13
	vpxor	%ymm11, %ymm7, %ymm7
	vpshufb	64(%rsp), %ymm13, %ymm13
	vpslld	$12, %ymm7, %ymm15
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpaddd	%ymm13, %ymm9, %ymm9
	vpaddd	%ymm7, %ymm3, %ymm3
	vpxor	%ymm9, %ymm5, %ymm5
	vpxor	%ymm3, %ymm14, %ymm14
	vpslld	$7, %ymm5, %ymm15
	vpsrld	$25, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm11, %ymm11
	vpxor	%ymm11, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm15
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpaddd	%ymm6, %ymm1, %ymm1
	vpxor	%ymm1, %ymm12, %ymm12
	vpshufb	32(%rsp), %ymm12, %ymm12
	vpaddd	%ymm12, %ymm11, %ymm11
	vpaddd	%ymm5, %ymm0, %ymm0
	vpxor	%ymm11, %ymm6, %ymm6
	vpxor	%ymm0, %ymm14, %ymm14
	vpslld	$12, %ymm6, %ymm15
	vpsrld	$20, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm6, %ymm1, %ymm1
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm1, %ymm12, %ymm12
	vpxor	%ymm10, %ymm5, %ymm5
	vpshufb	64(%rsp), %ymm12, %ymm12
	vpslld	$12, %ymm5, %ymm15
	vpsrld	$20, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vpaddd	%ymm12, %ymm11, %ymm11
	vpaddd	%ymm5, %ymm0, %ymm0
	vpxor	%ymm11, %ymm6, %ymm6
	vpxor	%ymm0, %ymm14, %ymm14
	vpslld	$7, %ymm6, %ymm15
	vpsrld	$25, %ymm6, %ymm6
	vpxor	%ymm15, %ymm6, %ymm6
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm10, %ymm10
	vpxor	%ymm10, %ymm5, %ymm5
	vpslld	$7, %ymm5, %ymm15
	vpsrld	$25, %ymm5, %ymm5
	vpxor	%ymm15, %ymm5, %ymm5
	vmovdqu	128(%rsp), %ymm15
	vmovdqu	%ymm14, 96(%rsp)
	vpaddd	%ymm7, %ymm2, %ymm2
	vpxor	%ymm2, %ymm13, %ymm13
	vpshufb	32(%rsp), %ymm13, %ymm13
	vpaddd	%ymm13, %ymm8, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm3
	vpxor	%ymm8, %ymm7, %ymm7
	vpxor	%ymm3, %ymm15, %ymm14
	vpslld	$12, %ymm7, %ymm15
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpshufb	32(%rsp), %ymm14, %ymm14
	vpaddd	%ymm7, %ymm2, %ymm2
	vpaddd	%ymm14, %ymm9, %ymm9
	vpxor	%ymm2, %ymm13, %ymm13
	vpxor	%ymm9, %ymm4, %ymm4
	vpshufb	64(%rsp), %ymm13, %ymm13
	vpslld	$12, %ymm4, %ymm15
	vpsrld	$20, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	vpaddd	%ymm13, %ymm8, %ymm8
	vpaddd	%ymm4, %ymm3, %ymm3
	vpxor	%ymm8, %ymm7, %ymm7
	vpxor	%ymm3, %ymm14, %ymm14
	vpslld	$7, %ymm7, %ymm15
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm15, %ymm7, %ymm7
	vpshufb	64(%rsp), %ymm14, %ymm14
	vpaddd	%ymm14, %ymm9, %ymm9
	vpxor	%ymm9, %ymm4, %ymm4
	vpslld	$7, %ymm4, %ymm15
	vpsrld	$25, %ymm4, %ymm4
	vpxor	%ymm15, %ymm4, %ymm4
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_xor_v_avx2_ic$11
	vmovdqu	96(%rsp), %ymm15
	vpaddd	672(%rsp), %ymm0, %ymm0
	vpaddd	704(%rsp), %ymm1, %ymm1
	vpaddd	736(%rsp), %ymm2, %ymm2
	vpaddd	768(%rsp), %ymm3, %ymm3
	vpaddd	800(%rsp), %ymm4, %ymm4
	vpaddd	832(%rsp), %ymm5, %ymm5
	vpaddd	864(%rsp), %ymm6, %ymm6
	vpaddd	896(%rsp), %ymm7, %ymm7
	vpaddd	928(%rsp), %ymm8, %ymm8
	vpaddd	960(%rsp), %ymm9, %ymm9
	vpaddd	992(%rsp), %ymm10, %ymm10
	vpaddd	1024(%rsp), %ymm11, %ymm11
	vpaddd	1056(%rsp), %ymm12, %ymm12
	vpaddd	1088(%rsp), %ymm13, %ymm13
	vpaddd	1120(%rsp), %ymm14, %ymm14
	vpaddd	1152(%rsp), %ymm15, %ymm15
	vmovdqu	%ymm8, 160(%rsp)
	vmovdqu	%ymm9, 192(%rsp)
	vmovdqu	%ymm10, 224(%rsp)
	vmovdqu	%ymm11, 256(%rsp)
	vmovdqu	%ymm12, 288(%rsp)
	vmovdqu	%ymm13, 320(%rsp)
	vmovdqu	%ymm14, 352(%rsp)
	vmovdqu	%ymm15, 384(%rsp)
	vpunpckldq	%ymm1, %ymm0, %ymm8
	vpunpckhdq	%ymm1, %ymm0, %ymm0
	vpunpckldq	%ymm3, %ymm2, %ymm1
	vpunpckhdq	%ymm3, %ymm2, %ymm2
	vpunpckldq	%ymm5, %ymm4, %ymm3
	vpunpckhdq	%ymm5, %ymm4, %ymm4
	vpunpckldq	%ymm7, %ymm6, %ymm5
	vpunpckhdq	%ymm7, %ymm6, %ymm6
	vpunpcklqdq	%ymm1, %ymm8, %ymm7
	vpunpcklqdq	%ymm5, %ymm3, %ymm9
	vpunpckhqdq	%ymm1, %ymm8, %ymm1
	vpunpckhqdq	%ymm5, %ymm3, %ymm3
	vpunpcklqdq	%ymm2, %ymm0, %ymm5
	vpunpcklqdq	%ymm6, %ymm4, %ymm8
	vpunpckhqdq	%ymm2, %ymm0, %ymm0
	vpunpckhqdq	%ymm6, %ymm4, %ymm2
	vperm2i128	$32, %ymm9, %ymm7, %ymm4
	vperm2i128	$49, %ymm9, %ymm7, %ymm6
	vperm2i128	$32, %ymm3, %ymm1, %ymm7
	vperm2i128	$49, %ymm3, %ymm1, %ymm1
	vperm2i128	$32, %ymm8, %ymm5, %ymm3
	vperm2i128	$49, %ymm8, %ymm5, %ymm5
	vperm2i128	$32, %ymm2, %ymm0, %ymm8
	vperm2i128	$49, %ymm2, %ymm0, %ymm0
	vmovdqu	%ymm4, 416(%rsp)
	vmovdqu	%ymm7, 448(%rsp)
	vmovdqu	%ymm3, 480(%rsp)
	vmovdqu	%ymm8, 512(%rsp)
	vmovdqu	%ymm6, 544(%rsp)
	vmovdqu	%ymm1, 576(%rsp)
	vmovdqu	%ymm5, 608(%rsp)
	vmovdqu	%ymm0, 640(%rsp)
	vmovdqu	160(%rsp), %ymm0
	vmovdqu	224(%rsp), %ymm1
	vmovdqu	288(%rsp), %ymm2
	vmovdqu	352(%rsp), %ymm3
	vpunpckldq	192(%rsp), %ymm0, %ymm4
	vpunpckhdq	192(%rsp), %ymm0, %ymm0
	vpunpckldq	256(%rsp), %ymm1, %ymm5
	vpunpckhdq	256(%rsp), %ymm1, %ymm1
	vpunpckldq	320(%rsp), %ymm2, %ymm6
	vpunpckhdq	320(%rsp), %ymm2, %ymm2
	vpunpckldq	384(%rsp), %ymm3, %ymm7
	vpunpckhdq	384(%rsp), %ymm3, %ymm3
	vpunpcklqdq	%ymm5, %ymm4, %ymm8
	vpunpcklqdq	%ymm7, %ymm6, %ymm9
	vpunpckhqdq	%ymm5, %ymm4, %ymm4
	vpunpckhqdq	%ymm7, %ymm6, %ymm5
	vpunpcklqdq	%ymm1, %ymm0, %ymm6
	vpunpcklqdq	%ymm3, %ymm2, %ymm7
	vpunpckhqdq	%ymm1, %ymm0, %ymm0
	vpunpckhqdq	%ymm3, %ymm2, %ymm1
	vperm2i128	$32, %ymm9, %ymm8, %ymm2
	vperm2i128	$49, %ymm9, %ymm8, %ymm3
	vperm2i128	$32, %ymm5, %ymm4, %ymm8
	vperm2i128	$49, %ymm5, %ymm4, %ymm4
	vperm2i128	$32, %ymm7, %ymm6, %ymm5
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vperm2i128	$32, %ymm1, %ymm0, %ymm7
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vmovdqu	416(%rsp), %ymm1
	vmovdqu	%ymm2, %ymm10
	vmovdqu	448(%rsp), %ymm12
	vmovdqu	%ymm8, %ymm11
	vmovdqu	480(%rsp), %ymm9
	vmovdqu	%ymm5, %ymm8
	vmovdqu	512(%rsp), %ymm5
	vmovdqu	%ymm7, %ymm2
	cmpq	$256, %rcx
	jb  	L_chacha_xor_v_avx2_ic$10
	vpxor	(%r10), %ymm1, %ymm1
	vmovdqu	%ymm1, (%r11)
	vpxor	32(%r10), %ymm10, %ymm1
	vmovdqu	%ymm1, 32(%r11)
	vpxor	64(%r10), %ymm12, %ymm1
	vmovdqu	%ymm1, 64(%r11)
	vpxor	96(%r10), %ymm11, %ymm1
	vmovdqu	%ymm1, 96(%r11)
	vpxor	128(%r10), %ymm9, %ymm1
	vmovdqu	%ymm1, 128(%r11)
	vpxor	160(%r10), %ymm8, %ymm1
	vmovdqu	%ymm1, 160(%r11)
	vpxor	192(%r10), %ymm5, %ymm1
	vmovdqu	%ymm1, 192(%r11)
	vpxor	224(%r10), %ymm2, %ymm1
	vmovdqu	%ymm1, 224(%r11)
	addq	$256, %r11
	addq	$256, %r10
	addq	$-256, %rcx
	vmovdqu	544(%rsp), %ymm1
	vmovdqu	%ymm3, %ymm10
	vmovdqu	576(%rsp), %ymm12
	vmovdqu	%ymm4, %ymm11
	vmovdqu	608(%rsp), %ymm9
	vmovdqu	%ymm6, %ymm8
	vmovdqu	640(%rsp), %ymm5
	vmovdqu	%ymm0, %ymm2
L_chacha_xor_v_avx2_ic$10:
	cmpq	$128, %rcx
	jb  	L_chacha_xor_v_avx2_ic$9
	vpxor	(%r10), %ymm1, %ymm0
	vmovdqu	%ymm0, (%r11)
	vpxor	32(%r10), %ymm10, %ymm0
	vmovdqu	%ymm0, 32(%r11)
	vpxor	64(%r10), %ymm12, %ymm0
	vmovdqu	%ymm0, 64(%r11)
	vpxor	96(%r10), %ymm11, %ymm0
	vmovdqu	%ymm0, 96(%r11)
	addq	$128, %r11
	addq	$128, %r10
	addq	$-128, %rcx
	vmovdqu	%ymm9, %ymm1
	vmovdqu	%ymm8, %ymm10
	vmovdqu	%ymm5, %ymm12
	vmovdqu	%ymm2, %ymm11
L_chacha_xor_v_avx2_ic$9:
	cmpq	$64, %rcx
	jb  	L_chacha_xor_v_avx2_ic$8
	vpxor	(%r10), %ymm1, %ymm0
	vmovdqu	%ymm0, (%r11)
	vpxor	32(%r10), %ymm10, %ymm0
	vmovdqu	%ymm0, 32(%r11)
	addq	$64, %r11
	addq	$64, %r10
	addq	$-64, %rcx
	vmovdqu	%ymm12, %ymm1
	vmovdqu	%ymm11, %ymm10
L_chacha_xor_v_avx2_ic$8:
	cmpq	$32, %rcx
	jb  	L_chacha_xor_v_avx2_ic$7
	vpxor	(%r10), %ymm1, %ymm0
	vmovdqu	%ymm0, (%r11)
	addq	$32, %r11
	addq	$32, %r10
	addq	$-32, %rcx
	vmovdqu	%ymm10, %ymm1
L_chacha_xor_v_avx2_ic$7:
	vmovdqu	%xmm1, %xmm0
	cmpq	$16, %rcx
	jb  	L_chacha_xor_v_avx2_ic$6
	vpxor	(%r10), %xmm0, %xmm0
	vmovdqu	%xmm0, (%r11)
	addq	$16, %r11
	addq	$16, %r10
	addq	$-16, %rcx
	vextracti128	$1, %ymm1, %xmm0
L_chacha_xor_v_avx2_ic$6:
	vpextrq	$0, %xmm0, %rax
	cmpq	$8, %rcx
	jb  	L_chacha_xor_v_avx2_ic$3
	xorq	(%r10), %rax
	movq	%rax, (%r11)
	addq	$8, %r11
	addq	$8, %r10
	addq	$-8, %rcx
	vpextrq	$1, %xmm0, %rax
L_chacha_xor_v_avx2_ic$5:
	jmp 	L_chacha_xor_v_avx2_ic$3
L_chacha_xor_v_avx2_ic$4:
	movb	%al, %dl
	xorb	(%r10), %dl
	movb	%dl, (%r11)
	shrq	$8, %rax
	incq	%r11
	incq	%r10
	addq	$-1, %rcx
L_chacha_xor_v_avx2_ic$3:
	cmpq	$0, %rcx
	jnbe	L_chacha_xor_v_avx2_ic$4
L_chacha_xor_v_avx2_ic$2:
	ret 
L_chacha_h_x2_avx2_ic$1:
	vmovdqu	glob_data + 160(%rip), %ymm0
	vmovdqu	glob_data + 128(%rip), %ymm1
	vmovdqu	glob_data + 480(%rip), %ymm2
	vbroadcasti128	(%rax), %ymm3
	vbroadcasti128	16(%rax), %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpinsrd	$0, %ecx, %xmm5, %xmm5
	vpinsrd	$1, (%rdx), %xmm5, %xmm5
	vpinsrq	$1, 4(%rdx), %xmm5, %xmm5
	vpxor	%ymm6, %ymm6, %ymm6
	vinserti128	$0, %xmm5, %ymm6, %ymm6
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vpaddd	glob_data + 96(%rip), %ymm5, %ymm5
	jmp 	L_chacha_h_x2_avx2_ic$18
L_chacha_h_x2_avx2_ic$19:
	vmovdqu	%ymm2, %ymm6
	vmovdqu	%ymm3, %ymm7
	vmovdqu	%ymm4, %ymm8
	vmovdqu	%ymm5, %ymm9
	vmovdqu	%ymm2, %ymm10
	vmovdqu	%ymm3, %ymm11
	vmovdqu	%ymm4, %ymm12
	vmovdqu	%ymm5, %ymm13
	vpaddd	glob_data + 64(%rip), %ymm13, %ymm13
	movl	$10, %eax
L_chacha_h_x2_avx2_ic$20:
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm0, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm14
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$12, %ymm11, %ymm14
	vpsrld	$20, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm1, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm14
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$7, %ymm11, %ymm14
	vpsrld	$25, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpshufd	$57, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$-109, %ymm9, %ymm9
	vpshufd	$57, %ymm11, %ymm11
	vpshufd	$78, %ymm12, %ymm12
	vpshufd	$-109, %ymm13, %ymm13
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm0, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm14
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$12, %ymm11, %ymm14
	vpsrld	$20, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm1, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm14
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$7, %ymm11, %ymm14
	vpsrld	$25, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpshufd	$-109, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$57, %ymm9, %ymm9
	vpshufd	$-109, %ymm11, %ymm11
	vpshufd	$78, %ymm12, %ymm12
	vpshufd	$57, %ymm13, %ymm13
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_h_x2_avx2_ic$20
	vpaddd	%ymm2, %ymm6, %ymm6
	vpaddd	%ymm3, %ymm7, %ymm7
	vpaddd	%ymm4, %ymm8, %ymm8
	vpaddd	%ymm5, %ymm9, %ymm9
	vpaddd	%ymm2, %ymm10, %ymm10
	vpaddd	%ymm3, %ymm11, %ymm11
	vpaddd	%ymm4, %ymm12, %ymm12
	vpaddd	%ymm5, %ymm13, %ymm13
	vpaddd	glob_data + 64(%rip), %ymm13, %ymm13
	vperm2i128	$32, %ymm7, %ymm6, %ymm14
	vperm2i128	$32, %ymm9, %ymm8, %ymm15
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vperm2i128	$49, %ymm9, %ymm8, %ymm7
	vperm2i128	$32, %ymm11, %ymm10, %ymm8
	vperm2i128	$32, %ymm13, %ymm12, %ymm9
	vperm2i128	$49, %ymm11, %ymm10, %ymm10
	vperm2i128	$49, %ymm13, %ymm12, %ymm11
	vmovdqu	%ymm14, (%rdi)
	vmovdqu	%ymm15, 32(%rdi)
	vmovdqu	%ymm6, 64(%rdi)
	vmovdqu	%ymm7, 96(%rdi)
	vmovdqu	%ymm8, 128(%rdi)
	vmovdqu	%ymm9, 160(%rdi)
	vmovdqu	%ymm10, 192(%rdi)
	vmovdqu	%ymm11, 224(%rdi)
	addq	$256, %rdi
	addq	$-256, %rsi
	vpaddd	glob_data + 32(%rip), %ymm5, %ymm5
L_chacha_h_x2_avx2_ic$18:
	cmpq	$256, %rsi
	jnb 	L_chacha_h_x2_avx2_ic$19
	cmpq	$128, %rsi
	jnbe	L_chacha_h_x2_avx2_ic$2
	vmovdqu	%ymm2, %ymm6
	vmovdqu	%ymm3, %ymm7
	vmovdqu	%ymm4, %ymm8
	vmovdqu	%ymm5, %ymm9
	movl	$10, %eax
L_chacha_h_x2_avx2_ic$17:
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm10
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm10
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpshufd	$57, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$-109, %ymm9, %ymm9
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm10
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm10
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpshufd	$-109, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$57, %ymm9, %ymm9
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_h_x2_avx2_ic$17
	vpaddd	%ymm2, %ymm6, %ymm0
	vpaddd	%ymm3, %ymm7, %ymm1
	vpaddd	%ymm4, %ymm8, %ymm2
	vpaddd	%ymm5, %ymm9, %ymm3
	vperm2i128	$32, %ymm1, %ymm0, %ymm5
	vperm2i128	$32, %ymm3, %ymm2, %ymm4
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vperm2i128	$49, %ymm3, %ymm2, %ymm1
	cmpq	$64, %rsi
	jb  	L_chacha_h_x2_avx2_ic$16
	vmovdqu	%ymm5, (%rdi)
	vmovdqu	%ymm4, 32(%rdi)
	addq	$64, %rdi
	addq	$-64, %rsi
	vmovdqu	%ymm0, %ymm5
	vmovdqu	%ymm1, %ymm4
L_chacha_h_x2_avx2_ic$16:
	cmpq	$32, %rsi
	jb  	L_chacha_h_x2_avx2_ic$15
	vmovdqu	%ymm5, (%rdi)
	addq	$32, %rdi
	addq	$-32, %rsi
	vmovdqu	%ymm4, %ymm5
L_chacha_h_x2_avx2_ic$15:
	vmovdqu	%xmm5, %xmm0
	cmpq	$16, %rsi
	jb  	L_chacha_h_x2_avx2_ic$14
	vmovdqu	%xmm0, (%rdi)
	addq	$16, %rdi
	addq	$-16, %rsi
	vextracti128	$1, %ymm5, %xmm0
L_chacha_h_x2_avx2_ic$14:
	vpextrq	$0, %xmm0, %rax
	cmpq	$8, %rsi
	jb  	L_chacha_h_x2_avx2_ic$11
	movq	%rax, (%rdi)
	addq	$8, %rdi
	addq	$-8, %rsi
	vpextrq	$1, %xmm0, %rax
L_chacha_h_x2_avx2_ic$13:
	jmp 	L_chacha_h_x2_avx2_ic$11
L_chacha_h_x2_avx2_ic$12:
	movb	%al, %cl
	movb	%cl, (%rdi)
	shrq	$8, %rax
	incq	%rdi
	addq	$-1, %rsi
L_chacha_h_x2_avx2_ic$11:
	cmpq	$0, %rsi
	jnbe	L_chacha_h_x2_avx2_ic$12
	jmp 	L_chacha_h_x2_avx2_ic$3
L_chacha_h_x2_avx2_ic$2:
	vmovdqu	%ymm2, %ymm6
	vmovdqu	%ymm3, %ymm7
	vmovdqu	%ymm4, %ymm8
	vmovdqu	%ymm5, %ymm9
	vmovdqu	%ymm2, %ymm10
	vmovdqu	%ymm3, %ymm11
	vmovdqu	%ymm4, %ymm12
	vmovdqu	%ymm5, %ymm13
	vpaddd	glob_data + 64(%rip), %ymm13, %ymm13
	movl	$10, %eax
L_chacha_h_x2_avx2_ic$10:
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm0, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm14
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$12, %ymm11, %ymm14
	vpsrld	$20, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm1, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm14
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$7, %ymm11, %ymm14
	vpsrld	$25, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpshufd	$57, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$-109, %ymm9, %ymm9
	vpshufd	$57, %ymm11, %ymm11
	vpshufd	$78, %ymm12, %ymm12
	vpshufd	$-109, %ymm13, %ymm13
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm0, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm14
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$12, %ymm11, %ymm14
	vpsrld	$20, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm1, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm14
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$7, %ymm11, %ymm14
	vpsrld	$25, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpshufd	$-109, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$57, %ymm9, %ymm9
	vpshufd	$-109, %ymm11, %ymm11
	vpshufd	$78, %ymm12, %ymm12
	vpshufd	$57, %ymm13, %ymm13
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_h_x2_avx2_ic$10
	vpaddd	%ymm2, %ymm6, %ymm0
	vpaddd	%ymm3, %ymm7, %ymm1
	vpaddd	%ymm4, %ymm8, %ymm6
	vpaddd	%ymm5, %ymm9, %ymm7
	vpaddd	%ymm2, %ymm10, %ymm2
	vpaddd	%ymm3, %ymm11, %ymm3
	vpaddd	%ymm4, %ymm12, %ymm4
	vpaddd	%ymm5, %ymm13, %ymm5
	vpaddd	glob_data + 64(%rip), %ymm5, %ymm5
	vperm2i128	$32, %ymm1, %ymm0, %ymm8
	vperm2i128	$32, %ymm7, %ymm6, %ymm9
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vperm2i128	$49, %ymm7, %ymm6, %ymm1
	vperm2i128	$32, %ymm3, %ymm2, %ymm7
	vperm2i128	$32, %ymm5, %ymm4, %ymm6
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vperm2i128	$49, %ymm5, %ymm4, %ymm3
	vmovdqu	%ymm8, (%rdi)
	vmovdqu	%ymm9, 32(%rdi)
	vmovdqu	%ymm0, 64(%rdi)
	vmovdqu	%ymm1, 96(%rdi)
	addq	$128, %rdi
	addq	$-128, %rsi
	cmpq	$64, %rsi
	jb  	L_chacha_h_x2_avx2_ic$9
	vmovdqu	%ymm7, (%rdi)
	vmovdqu	%ymm6, 32(%rdi)
	addq	$64, %rdi
	addq	$-64, %rsi
	vmovdqu	%ymm2, %ymm7
	vmovdqu	%ymm3, %ymm6
L_chacha_h_x2_avx2_ic$9:
	cmpq	$32, %rsi
	jb  	L_chacha_h_x2_avx2_ic$8
	vmovdqu	%ymm7, (%rdi)
	addq	$32, %rdi
	addq	$-32, %rsi
	vmovdqu	%ymm6, %ymm7
L_chacha_h_x2_avx2_ic$8:
	vmovdqu	%xmm7, %xmm0
	cmpq	$16, %rsi
	jb  	L_chacha_h_x2_avx2_ic$7
	vmovdqu	%xmm0, (%rdi)
	addq	$16, %rdi
	addq	$-16, %rsi
	vextracti128	$1, %ymm7, %xmm0
L_chacha_h_x2_avx2_ic$7:
	vpextrq	$0, %xmm0, %rax
	cmpq	$8, %rsi
	jb  	L_chacha_h_x2_avx2_ic$4
	movq	%rax, (%rdi)
	addq	$8, %rdi
	addq	$-8, %rsi
	vpextrq	$1, %xmm0, %rax
L_chacha_h_x2_avx2_ic$6:
	jmp 	L_chacha_h_x2_avx2_ic$4
L_chacha_h_x2_avx2_ic$5:
	movb	%al, %cl
	movb	%cl, (%rdi)
	shrq	$8, %rax
	incq	%rdi
	addq	$-1, %rsi
L_chacha_h_x2_avx2_ic$4:
	cmpq	$0, %rsi
	jnbe	L_chacha_h_x2_avx2_ic$5
L_chacha_h_x2_avx2_ic$3:
	ret 
L_chacha_h_avx2_ic$1:
	vmovdqu	glob_data + 160(%rip), %ymm0
	vmovdqu	glob_data + 128(%rip), %ymm1
	vmovdqu	glob_data + 480(%rip), %ymm2
	vbroadcasti128	(%rax), %ymm3
	vbroadcasti128	16(%rax), %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpinsrd	$0, %ecx, %xmm5, %xmm5
	vpinsrd	$1, (%rdx), %xmm5, %xmm5
	vpinsrq	$1, 4(%rdx), %xmm5, %xmm5
	vpxor	%ymm6, %ymm6, %ymm6
	vinserti128	$0, %xmm5, %ymm6, %ymm6
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vpaddd	glob_data + 96(%rip), %ymm5, %ymm5
	jmp 	L_chacha_h_avx2_ic$10
L_chacha_h_avx2_ic$11:
	vmovdqu	%ymm2, %ymm6
	vmovdqu	%ymm3, %ymm7
	vmovdqu	%ymm4, %ymm8
	vmovdqu	%ymm5, %ymm9
	movl	$10, %eax
L_chacha_h_avx2_ic$12:
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm10
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm10
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpshufd	$57, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$-109, %ymm9, %ymm9
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm10
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm10
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpshufd	$-109, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$57, %ymm9, %ymm9
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_h_avx2_ic$12
	vpaddd	%ymm2, %ymm6, %ymm6
	vpaddd	%ymm3, %ymm7, %ymm7
	vpaddd	%ymm4, %ymm8, %ymm8
	vpaddd	%ymm5, %ymm9, %ymm9
	vperm2i128	$32, %ymm7, %ymm6, %ymm10
	vperm2i128	$32, %ymm9, %ymm8, %ymm11
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vperm2i128	$49, %ymm9, %ymm8, %ymm7
	vmovdqu	%ymm10, (%rdi)
	vmovdqu	%ymm11, 32(%rdi)
	vmovdqu	%ymm6, 64(%rdi)
	vmovdqu	%ymm7, 96(%rdi)
	addq	$128, %rdi
	addq	$-128, %rsi
	vpaddd	glob_data + 64(%rip), %ymm5, %ymm5
L_chacha_h_avx2_ic$10:
	cmpq	$128, %rsi
	jnb 	L_chacha_h_avx2_ic$11
	cmpq	$0, %rsi
	jbe 	L_chacha_h_avx2_ic$2
	vmovdqu	%ymm2, %ymm6
	vmovdqu	%ymm3, %ymm7
	vmovdqu	%ymm4, %ymm8
	vmovdqu	%ymm5, %ymm9
	movl	$10, %eax
L_chacha_h_avx2_ic$9:
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm10
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm10
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpshufd	$57, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$-109, %ymm9, %ymm9
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm10
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm10
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpshufd	$-109, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$57, %ymm9, %ymm9
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_h_avx2_ic$9
	vpaddd	%ymm2, %ymm6, %ymm0
	vpaddd	%ymm3, %ymm7, %ymm1
	vpaddd	%ymm4, %ymm8, %ymm2
	vpaddd	%ymm5, %ymm9, %ymm3
	vperm2i128	$32, %ymm1, %ymm0, %ymm5
	vperm2i128	$32, %ymm3, %ymm2, %ymm4
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vperm2i128	$49, %ymm3, %ymm2, %ymm1
	cmpq	$64, %rsi
	jb  	L_chacha_h_avx2_ic$8
	vmovdqu	%ymm5, (%rdi)
	vmovdqu	%ymm4, 32(%rdi)
	addq	$64, %rdi
	addq	$-64, %rsi
	vmovdqu	%ymm0, %ymm5
	vmovdqu	%ymm1, %ymm4
L_chacha_h_avx2_ic$8:
	cmpq	$32, %rsi
	jb  	L_chacha_h_avx2_ic$7
	vmovdqu	%ymm5, (%rdi)
	addq	$32, %rdi
	addq	$-32, %rsi
	vmovdqu	%ymm4, %ymm5
L_chacha_h_avx2_ic$7:
	vmovdqu	%xmm5, %xmm0
	cmpq	$16, %rsi
	jb  	L_chacha_h_avx2_ic$6
	vmovdqu	%xmm0, (%rdi)
	addq	$16, %rdi
	addq	$-16, %rsi
	vextracti128	$1, %ymm5, %xmm0
L_chacha_h_avx2_ic$6:
	vpextrq	$0, %xmm0, %rax
	cmpq	$8, %rsi
	jb  	L_chacha_h_avx2_ic$3
	movq	%rax, (%rdi)
	addq	$8, %rdi
	addq	$-8, %rsi
	vpextrq	$1, %xmm0, %rax
L_chacha_h_avx2_ic$5:
	jmp 	L_chacha_h_avx2_ic$3
L_chacha_h_avx2_ic$4:
	movb	%al, %cl
	movb	%cl, (%rdi)
	shrq	$8, %rax
	incq	%rdi
	addq	$-1, %rsi
L_chacha_h_avx2_ic$3:
	cmpq	$0, %rsi
	jnbe	L_chacha_h_avx2_ic$4
L_chacha_h_avx2_ic$2:
	ret 
L_chacha_xor_h_x2_avx2_ic$1:
	vmovdqu	glob_data + 160(%rip), %ymm0
	vmovdqu	glob_data + 128(%rip), %ymm1
	vmovdqu	glob_data + 480(%rip), %ymm2
	vbroadcasti128	(%r9), %ymm3
	vbroadcasti128	16(%r9), %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpinsrd	$0, %edx, %xmm5, %xmm5
	vpinsrd	$1, (%rax), %xmm5, %xmm5
	vpinsrq	$1, 4(%rax), %xmm5, %xmm5
	vpxor	%ymm6, %ymm6, %ymm6
	vinserti128	$0, %xmm5, %ymm6, %ymm6
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vpaddd	glob_data + 96(%rip), %ymm5, %ymm5
	jmp 	L_chacha_xor_h_x2_avx2_ic$18
L_chacha_xor_h_x2_avx2_ic$19:
	vmovdqu	%ymm2, %ymm6
	vmovdqu	%ymm3, %ymm7
	vmovdqu	%ymm4, %ymm8
	vmovdqu	%ymm5, %ymm9
	vmovdqu	%ymm2, %ymm10
	vmovdqu	%ymm3, %ymm11
	vmovdqu	%ymm4, %ymm12
	vmovdqu	%ymm5, %ymm13
	vpaddd	glob_data + 64(%rip), %ymm13, %ymm13
	movl	$10, %eax
L_chacha_xor_h_x2_avx2_ic$20:
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm0, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm14
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$12, %ymm11, %ymm14
	vpsrld	$20, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm1, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm14
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$7, %ymm11, %ymm14
	vpsrld	$25, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpshufd	$57, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$-109, %ymm9, %ymm9
	vpshufd	$57, %ymm11, %ymm11
	vpshufd	$78, %ymm12, %ymm12
	vpshufd	$-109, %ymm13, %ymm13
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm0, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm14
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$12, %ymm11, %ymm14
	vpsrld	$20, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm1, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm14
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$7, %ymm11, %ymm14
	vpsrld	$25, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpshufd	$-109, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$57, %ymm9, %ymm9
	vpshufd	$-109, %ymm11, %ymm11
	vpshufd	$78, %ymm12, %ymm12
	vpshufd	$57, %ymm13, %ymm13
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_xor_h_x2_avx2_ic$20
	vpaddd	%ymm2, %ymm6, %ymm6
	vpaddd	%ymm3, %ymm7, %ymm7
	vpaddd	%ymm4, %ymm8, %ymm8
	vpaddd	%ymm5, %ymm9, %ymm9
	vpaddd	%ymm2, %ymm10, %ymm10
	vpaddd	%ymm3, %ymm11, %ymm11
	vpaddd	%ymm4, %ymm12, %ymm12
	vpaddd	%ymm5, %ymm13, %ymm13
	vpaddd	glob_data + 64(%rip), %ymm13, %ymm13
	vperm2i128	$32, %ymm7, %ymm6, %ymm14
	vperm2i128	$32, %ymm9, %ymm8, %ymm15
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vperm2i128	$49, %ymm9, %ymm8, %ymm7
	vperm2i128	$32, %ymm11, %ymm10, %ymm8
	vperm2i128	$32, %ymm13, %ymm12, %ymm9
	vperm2i128	$49, %ymm11, %ymm10, %ymm10
	vperm2i128	$49, %ymm13, %ymm12, %ymm11
	vpxor	(%r10), %ymm14, %ymm12
	vmovdqu	%ymm12, (%r11)
	vpxor	32(%r10), %ymm15, %ymm12
	vmovdqu	%ymm12, 32(%r11)
	vpxor	64(%r10), %ymm6, %ymm6
	vmovdqu	%ymm6, 64(%r11)
	vpxor	96(%r10), %ymm7, %ymm6
	vmovdqu	%ymm6, 96(%r11)
	vpxor	128(%r10), %ymm8, %ymm6
	vmovdqu	%ymm6, 128(%r11)
	vpxor	160(%r10), %ymm9, %ymm6
	vmovdqu	%ymm6, 160(%r11)
	vpxor	192(%r10), %ymm10, %ymm6
	vmovdqu	%ymm6, 192(%r11)
	vpxor	224(%r10), %ymm11, %ymm6
	vmovdqu	%ymm6, 224(%r11)
	addq	$256, %r11
	addq	$256, %r10
	addq	$-256, %rcx
	vpaddd	glob_data + 32(%rip), %ymm5, %ymm5
L_chacha_xor_h_x2_avx2_ic$18:
	cmpq	$256, %rcx
	jnb 	L_chacha_xor_h_x2_avx2_ic$19
	cmpq	$128, %rcx
	jnbe	L_chacha_xor_h_x2_avx2_ic$2
	vmovdqu	%ymm2, %ymm6
	vmovdqu	%ymm3, %ymm7
	vmovdqu	%ymm4, %ymm8
	vmovdqu	%ymm5, %ymm9
	movl	$10, %eax
L_chacha_xor_h_x2_avx2_ic$17:
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm10
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm10
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpshufd	$57, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$-109, %ymm9, %ymm9
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm10
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm10
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpshufd	$-109, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$57, %ymm9, %ymm9
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_xor_h_x2_avx2_ic$17
	vpaddd	%ymm2, %ymm6, %ymm0
	vpaddd	%ymm3, %ymm7, %ymm1
	vpaddd	%ymm4, %ymm8, %ymm2
	vpaddd	%ymm5, %ymm9, %ymm3
	vperm2i128	$32, %ymm1, %ymm0, %ymm5
	vperm2i128	$32, %ymm3, %ymm2, %ymm4
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vperm2i128	$49, %ymm3, %ymm2, %ymm1
	cmpq	$64, %rcx
	jb  	L_chacha_xor_h_x2_avx2_ic$16
	vpxor	(%r10), %ymm5, %ymm2
	vmovdqu	%ymm2, (%r11)
	vpxor	32(%r10), %ymm4, %ymm2
	vmovdqu	%ymm2, 32(%r11)
	addq	$64, %r11
	addq	$64, %r10
	addq	$-64, %rcx
	vmovdqu	%ymm0, %ymm5
	vmovdqu	%ymm1, %ymm4
L_chacha_xor_h_x2_avx2_ic$16:
	cmpq	$32, %rcx
	jb  	L_chacha_xor_h_x2_avx2_ic$15
	vpxor	(%r10), %ymm5, %ymm0
	vmovdqu	%ymm0, (%r11)
	addq	$32, %r11
	addq	$32, %r10
	addq	$-32, %rcx
	vmovdqu	%ymm4, %ymm5
L_chacha_xor_h_x2_avx2_ic$15:
	vmovdqu	%xmm5, %xmm0
	cmpq	$16, %rcx
	jb  	L_chacha_xor_h_x2_avx2_ic$14
	vpxor	(%r10), %xmm0, %xmm0
	vmovdqu	%xmm0, (%r11)
	addq	$16, %r11
	addq	$16, %r10
	addq	$-16, %rcx
	vextracti128	$1, %ymm5, %xmm0
L_chacha_xor_h_x2_avx2_ic$14:
	vpextrq	$0, %xmm0, %rax
	cmpq	$8, %rcx
	jb  	L_chacha_xor_h_x2_avx2_ic$11
	xorq	(%r10), %rax
	movq	%rax, (%r11)
	addq	$8, %r11
	addq	$8, %r10
	addq	$-8, %rcx
	vpextrq	$1, %xmm0, %rax
L_chacha_xor_h_x2_avx2_ic$13:
	jmp 	L_chacha_xor_h_x2_avx2_ic$11
L_chacha_xor_h_x2_avx2_ic$12:
	movb	%al, %dl
	xorb	(%r10), %dl
	movb	%dl, (%r11)
	shrq	$8, %rax
	incq	%r11
	incq	%r10
	addq	$-1, %rcx
L_chacha_xor_h_x2_avx2_ic$11:
	cmpq	$0, %rcx
	jnbe	L_chacha_xor_h_x2_avx2_ic$12
	jmp 	L_chacha_xor_h_x2_avx2_ic$3
L_chacha_xor_h_x2_avx2_ic$2:
	vmovdqu	%ymm2, %ymm6
	vmovdqu	%ymm3, %ymm7
	vmovdqu	%ymm4, %ymm8
	vmovdqu	%ymm5, %ymm9
	vmovdqu	%ymm2, %ymm10
	vmovdqu	%ymm3, %ymm11
	vmovdqu	%ymm4, %ymm12
	vmovdqu	%ymm5, %ymm13
	vpaddd	glob_data + 64(%rip), %ymm13, %ymm13
	movl	$10, %eax
L_chacha_xor_h_x2_avx2_ic$10:
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm0, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm14
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$12, %ymm11, %ymm14
	vpsrld	$20, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm1, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm14
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$7, %ymm11, %ymm14
	vpsrld	$25, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpshufd	$57, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$-109, %ymm9, %ymm9
	vpshufd	$57, %ymm11, %ymm11
	vpshufd	$78, %ymm12, %ymm12
	vpshufd	$-109, %ymm13, %ymm13
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm0, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm14
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$12, %ymm11, %ymm14
	vpsrld	$20, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm11, %ymm10, %ymm10
	vpxor	%ymm6, %ymm9, %ymm9
	vpxor	%ymm10, %ymm13, %ymm13
	vpshufb	%ymm1, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm13, %ymm12, %ymm12
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm14
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm12, %ymm11, %ymm11
	vpxor	%ymm14, %ymm7, %ymm7
	vpslld	$7, %ymm11, %ymm14
	vpsrld	$25, %ymm11, %ymm11
	vpxor	%ymm14, %ymm11, %ymm11
	vpshufd	$-109, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$57, %ymm9, %ymm9
	vpshufd	$-109, %ymm11, %ymm11
	vpshufd	$78, %ymm12, %ymm12
	vpshufd	$57, %ymm13, %ymm13
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_xor_h_x2_avx2_ic$10
	vpaddd	%ymm2, %ymm6, %ymm0
	vpaddd	%ymm3, %ymm7, %ymm1
	vpaddd	%ymm4, %ymm8, %ymm6
	vpaddd	%ymm5, %ymm9, %ymm7
	vpaddd	%ymm2, %ymm10, %ymm2
	vpaddd	%ymm3, %ymm11, %ymm3
	vpaddd	%ymm4, %ymm12, %ymm4
	vpaddd	%ymm5, %ymm13, %ymm5
	vpaddd	glob_data + 64(%rip), %ymm5, %ymm5
	vperm2i128	$32, %ymm1, %ymm0, %ymm8
	vperm2i128	$32, %ymm7, %ymm6, %ymm9
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vperm2i128	$49, %ymm7, %ymm6, %ymm1
	vperm2i128	$32, %ymm3, %ymm2, %ymm7
	vperm2i128	$32, %ymm5, %ymm4, %ymm6
	vperm2i128	$49, %ymm3, %ymm2, %ymm2
	vperm2i128	$49, %ymm5, %ymm4, %ymm3
	vpxor	(%r10), %ymm8, %ymm4
	vmovdqu	%ymm4, (%r11)
	vpxor	32(%r10), %ymm9, %ymm4
	vmovdqu	%ymm4, 32(%r11)
	vpxor	64(%r10), %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%r11)
	vpxor	96(%r10), %ymm1, %ymm0
	vmovdqu	%ymm0, 96(%r11)
	addq	$128, %r11
	addq	$128, %r10
	addq	$-128, %rcx
	cmpq	$64, %rcx
	jb  	L_chacha_xor_h_x2_avx2_ic$9
	vpxor	(%r10), %ymm7, %ymm0
	vmovdqu	%ymm0, (%r11)
	vpxor	32(%r10), %ymm6, %ymm0
	vmovdqu	%ymm0, 32(%r11)
	addq	$64, %r11
	addq	$64, %r10
	addq	$-64, %rcx
	vmovdqu	%ymm2, %ymm7
	vmovdqu	%ymm3, %ymm6
L_chacha_xor_h_x2_avx2_ic$9:
	cmpq	$32, %rcx
	jb  	L_chacha_xor_h_x2_avx2_ic$8
	vpxor	(%r10), %ymm7, %ymm0
	vmovdqu	%ymm0, (%r11)
	addq	$32, %r11
	addq	$32, %r10
	addq	$-32, %rcx
	vmovdqu	%ymm6, %ymm7
L_chacha_xor_h_x2_avx2_ic$8:
	vmovdqu	%xmm7, %xmm0
	cmpq	$16, %rcx
	jb  	L_chacha_xor_h_x2_avx2_ic$7
	vpxor	(%r10), %xmm0, %xmm0
	vmovdqu	%xmm0, (%r11)
	addq	$16, %r11
	addq	$16, %r10
	addq	$-16, %rcx
	vextracti128	$1, %ymm7, %xmm0
L_chacha_xor_h_x2_avx2_ic$7:
	vpextrq	$0, %xmm0, %rax
	cmpq	$8, %rcx
	jb  	L_chacha_xor_h_x2_avx2_ic$4
	xorq	(%r10), %rax
	movq	%rax, (%r11)
	addq	$8, %r11
	addq	$8, %r10
	addq	$-8, %rcx
	vpextrq	$1, %xmm0, %rax
L_chacha_xor_h_x2_avx2_ic$6:
	jmp 	L_chacha_xor_h_x2_avx2_ic$4
L_chacha_xor_h_x2_avx2_ic$5:
	movb	%al, %dl
	xorb	(%r10), %dl
	movb	%dl, (%r11)
	shrq	$8, %rax
	incq	%r11
	incq	%r10
	addq	$-1, %rcx
L_chacha_xor_h_x2_avx2_ic$4:
	cmpq	$0, %rcx
	jnbe	L_chacha_xor_h_x2_avx2_ic$5
L_chacha_xor_h_x2_avx2_ic$3:
	ret 
L_chacha_xor_h_avx2_ic$1:
	vmovdqu	glob_data + 160(%rip), %ymm0
	vmovdqu	glob_data + 128(%rip), %ymm1
	vmovdqu	glob_data + 480(%rip), %ymm2
	vbroadcasti128	(%rax), %ymm3
	vbroadcasti128	16(%rax), %ymm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpinsrd	$0, %ecx, %xmm5, %xmm5
	vpinsrd	$1, (%rdx), %xmm5, %xmm5
	vpinsrq	$1, 4(%rdx), %xmm5, %xmm5
	vpxor	%ymm6, %ymm6, %ymm6
	vinserti128	$0, %xmm5, %ymm6, %ymm6
	vinserti128	$1, %xmm5, %ymm6, %ymm5
	vpaddd	glob_data + 96(%rip), %ymm5, %ymm5
	jmp 	L_chacha_xor_h_avx2_ic$10
L_chacha_xor_h_avx2_ic$11:
	vmovdqu	%ymm2, %ymm6
	vmovdqu	%ymm3, %ymm7
	vmovdqu	%ymm4, %ymm8
	vmovdqu	%ymm5, %ymm9
	movl	$10, %eax
L_chacha_xor_h_avx2_ic$12:
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm10
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm10
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpshufd	$57, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$-109, %ymm9, %ymm9
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm10
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm10
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpshufd	$-109, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$57, %ymm9, %ymm9
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_xor_h_avx2_ic$12
	vpaddd	%ymm2, %ymm6, %ymm6
	vpaddd	%ymm3, %ymm7, %ymm7
	vpaddd	%ymm4, %ymm8, %ymm8
	vpaddd	%ymm5, %ymm9, %ymm9
	vperm2i128	$32, %ymm7, %ymm6, %ymm10
	vperm2i128	$32, %ymm9, %ymm8, %ymm11
	vperm2i128	$49, %ymm7, %ymm6, %ymm6
	vperm2i128	$49, %ymm9, %ymm8, %ymm7
	vpxor	(%rdi), %ymm10, %ymm8
	vmovdqu	%ymm8, (%r8)
	vpxor	32(%rdi), %ymm11, %ymm8
	vmovdqu	%ymm8, 32(%r8)
	vpxor	64(%rdi), %ymm6, %ymm6
	vmovdqu	%ymm6, 64(%r8)
	vpxor	96(%rdi), %ymm7, %ymm6
	vmovdqu	%ymm6, 96(%r8)
	addq	$128, %r8
	addq	$128, %rdi
	addq	$-128, %rsi
	vpaddd	glob_data + 64(%rip), %ymm5, %ymm5
L_chacha_xor_h_avx2_ic$10:
	cmpq	$128, %rsi
	jnb 	L_chacha_xor_h_avx2_ic$11
	cmpq	$0, %rsi
	jbe 	L_chacha_xor_h_avx2_ic$2
	vmovdqu	%ymm2, %ymm6
	vmovdqu	%ymm3, %ymm7
	vmovdqu	%ymm4, %ymm8
	vmovdqu	%ymm5, %ymm9
	movl	$10, %eax
L_chacha_xor_h_avx2_ic$9:
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm10
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm10
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpshufd	$57, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$-109, %ymm9, %ymm9
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$12, %ymm7, %ymm10
	vpsrld	$20, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpxor	%ymm6, %ymm9, %ymm9
	vpshufb	%ymm1, %ymm9, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpslld	$7, %ymm7, %ymm10
	vpsrld	$25, %ymm7, %ymm7
	vpxor	%ymm10, %ymm7, %ymm7
	vpshufd	$-109, %ymm7, %ymm7
	vpshufd	$78, %ymm8, %ymm8
	vpshufd	$57, %ymm9, %ymm9
	decl	%eax
	cmpl	$0, %eax
	jnbe	L_chacha_xor_h_avx2_ic$9
	vpaddd	%ymm2, %ymm6, %ymm0
	vpaddd	%ymm3, %ymm7, %ymm1
	vpaddd	%ymm4, %ymm8, %ymm2
	vpaddd	%ymm5, %ymm9, %ymm3
	vperm2i128	$32, %ymm1, %ymm0, %ymm5
	vperm2i128	$32, %ymm3, %ymm2, %ymm4
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vperm2i128	$49, %ymm3, %ymm2, %ymm1
	cmpq	$64, %rsi
	jb  	L_chacha_xor_h_avx2_ic$8
	vpxor	(%rdi), %ymm5, %ymm2
	vmovdqu	%ymm2, (%r8)
	vpxor	32(%rdi), %ymm4, %ymm2
	vmovdqu	%ymm2, 32(%r8)
	addq	$64, %r8
	addq	$64, %rdi
	addq	$-64, %rsi
	vmovdqu	%ymm0, %ymm5
	vmovdqu	%ymm1, %ymm4
L_chacha_xor_h_avx2_ic$8:
	cmpq	$32, %rsi
	jb  	L_chacha_xor_h_avx2_ic$7
	vpxor	(%rdi), %ymm5, %ymm0
	vmovdqu	%ymm0, (%r8)
	addq	$32, %r8
	addq	$32, %rdi
	addq	$-32, %rsi
	vmovdqu	%ymm4, %ymm5
L_chacha_xor_h_avx2_ic$7:
	vmovdqu	%xmm5, %xmm0
	cmpq	$16, %rsi
	jb  	L_chacha_xor_h_avx2_ic$6
	vpxor	(%rdi), %xmm0, %xmm0
	vmovdqu	%xmm0, (%r8)
	addq	$16, %r8
	addq	$16, %rdi
	addq	$-16, %rsi
	vextracti128	$1, %ymm5, %xmm0
L_chacha_xor_h_avx2_ic$6:
	vpextrq	$0, %xmm0, %rax
	cmpq	$8, %rsi
	jb  	L_chacha_xor_h_avx2_ic$3
	xorq	(%rdi), %rax
	movq	%rax, (%r8)
	addq	$8, %r8
	addq	$8, %rdi
	addq	$-8, %rsi
	vpextrq	$1, %xmm0, %rax
L_chacha_xor_h_avx2_ic$5:
	jmp 	L_chacha_xor_h_avx2_ic$3
L_chacha_xor_h_avx2_ic$4:
	movb	%al, %cl
	xorb	(%rdi), %cl
	movb	%cl, (%r8)
	shrq	$8, %rax
	incq	%r8
	incq	%rdi
	addq	$-1, %rsi
L_chacha_xor_h_avx2_ic$3:
	cmpq	$0, %rsi
	jnbe	L_chacha_xor_h_avx2_ic$4
L_chacha_xor_h_avx2_ic$2:
	ret 
	.data
	.p2align	5
_glob_data:
glob_data:
      .byte 8
      .byte 0
      .byte 0
      .byte 0
      .byte 8
      .byte 0
      .byte 0
      .byte 0
      .byte 8
      .byte 0
      .byte 0
      .byte 0
      .byte 8
      .byte 0
      .byte 0
      .byte 0
      .byte 8
      .byte 0
      .byte 0
      .byte 0
      .byte 8
      .byte 0
      .byte 0
      .byte 0
      .byte 8
      .byte 0
      .byte 0
      .byte 0
      .byte 8
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
      .byte 0
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
      .byte 8
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 8
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 8
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 0
      .byte 8
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
      .byte 4
      .byte 0
      .byte 0
      .byte 0
      .byte 5
      .byte 0
      .byte 0
      .byte 0
      .byte 6
      .byte 0
      .byte 0
      .byte 0
      .byte 7
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
      .byte 0
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
