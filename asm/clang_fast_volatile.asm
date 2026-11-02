	.text
	.def	@feat.00;
	.scl	3;
	.type	0;
	.endef
	.globl	@feat.00
.set @feat.00, 0
	.intel_syntax noprefix
	.file	"kernel.cpp"
	.def	kernel_f32;
	.scl	2;
	.type	32;
	.endef
	.globl	__real@c0490fdb                 # -- Begin function kernel_f32
	.section	.rdata,"dr",discard,__real@c0490fdb
	.p2align	2, 0x0
__real@c0490fdb:
	.long	0xc0490fdb                      # float -3.14159274
	.globl	__real@40490fdb
	.section	.rdata,"dr",discard,__real@40490fdb
	.p2align	2, 0x0
__real@40490fdb:
	.long	0x40490fdb                      # float 3.14159274
	.globl	__real@33bbbd2e
	.section	.rdata,"dr",discard,__real@33bbbd2e
	.p2align	2, 0x0
__real@33bbbd2e:
	.long	0x33bbbd2e                      # float 8.74227765E-8
	.globl	__real@2f1223cf
	.section	.rdata,"dr",discard,__real@2f1223cf
	.p2align	2, 0x0
__real@2f1223cf:
	.long	0x2f1223cf                      # float 1.32913444E-10
	.globl	__real@b2c84c5d
	.section	.rdata,"dr",discard,__real@b2c84c5d
	.p2align	2, 0x0
__real@b2c84c5d:
	.long	0xb2c84c5d                      # float -2.33177904E-8
	.globl	__real@362944a7
	.section	.rdata,"dr",discard,__real@362944a7
	.p2align	2, 0x0
__real@362944a7:
	.long	0x362944a7                      # float 2.52229233E-6
	.globl	__real@b935eee9
	.section	.rdata,"dr",discard,__real@b935eee9
	.p2align	2, 0x0
__real@b935eee9:
	.long	0xb935eee9                      # float -1.73505061E-4
	.globl	__xmm@00000000000000003bd8f3f7b3bbbd2e
	.section	.rdata,"dr",discard,__xmm@00000000000000003bd8f3f7b3bbbd2e
	.p2align	4, 0x0
__xmm@00000000000000003bd8f3f7b3bbbd2e:
	.long	0xb3bbbd2e                      # float -8.74227765E-8
	.long	0x3bd8f3f7                      # float 0.00662087975
	.zero	4
	.zero	4
	.globl	__real@bdcf817b
	.section	.rdata,"dr",discard,__real@bdcf817b
	.p2align	2, 0x0
__real@bdcf817b:
	.long	0xbdcf817b                      # float -0.101321183
	.section	.text,"xr",one_only,kernel_f32
	.globl	kernel_f32
	.p2align	4, 0x90
kernel_f32:                             # @kernel_f32
.seh_proc kernel_f32
# %bb.0:
	sub	rsp, 136
	.seh_stackalloc 136
	movaps	xmmword ptr [rsp + 112], xmm12  # 16-byte Spill
	.seh_savexmm xmm12, 112
	movaps	xmmword ptr [rsp + 96], xmm11   # 16-byte Spill
	.seh_savexmm xmm11, 96
	movaps	xmmword ptr [rsp + 80], xmm10   # 16-byte Spill
	.seh_savexmm xmm10, 80
	movaps	xmmword ptr [rsp + 64], xmm9    # 16-byte Spill
	.seh_savexmm xmm9, 64
	movaps	xmmword ptr [rsp + 48], xmm8    # 16-byte Spill
	.seh_savexmm xmm8, 48
	movaps	xmmword ptr [rsp + 32], xmm7    # 16-byte Spill
	.seh_savexmm xmm7, 32
	movaps	xmmword ptr [rsp + 16], xmm6    # 16-byte Spill
	.seh_savexmm xmm6, 16
	.seh_endprologue
	test	r8, r8
	je	.LBB0_3
# %bb.1:
	xor	eax, eax
	movss	xmm0, dword ptr [rip + __real@c0490fdb] # xmm0 = [-3.14159274E+0,0.0E+0,0.0E+0,0.0E+0]
	movss	xmm1, dword ptr [rip + __real@40490fdb] # xmm1 = [3.14159274E+0,0.0E+0,0.0E+0,0.0E+0]
	movss	xmm2, dword ptr [rip + __real@33bbbd2e] # xmm2 = [8.74227765E-8,0.0E+0,0.0E+0,0.0E+0]
	movss	xmm3, dword ptr [rip + __real@2f1223cf] # xmm3 = [1.32913444E-10,0.0E+0,0.0E+0,0.0E+0]
	movss	xmm4, dword ptr [rip + __real@b2c84c5d] # xmm4 = [-2.33177904E-8,0.0E+0,0.0E+0,0.0E+0]
	movss	xmm5, dword ptr [rip + __real@362944a7] # xmm5 = [2.52229233E-6,0.0E+0,0.0E+0,0.0E+0]
	movss	xmm6, dword ptr [rip + __real@b935eee9] # xmm6 = [-1.73505061E-4,0.0E+0,0.0E+0,0.0E+0]
	movsd	xmm7, qword ptr [rip + __xmm@00000000000000003bd8f3f7b3bbbd2e] # xmm7 = [-8.74227765E-8,6.62087975E-3,0.0E+0,0.0E+0]
	movss	xmm8, dword ptr [rip + __real@bdcf817b] # xmm8 = [-1.01321183E-1,0.0E+0,0.0E+0,0.0E+0]
	.p2align	4, 0x90
.LBB0_2:                                # =>This Inner Loop Header: Depth=1
	movss	xmm9, dword ptr [rcx + 4*rax]   # xmm9 = mem[0],zero,zero,zero
	movaps	xmm10, xmm9
	addss	xmm10, xmm0
	movss	dword ptr [rsp + 12], xmm10
	movaps	xmm10, xmm9
	addss	xmm10, xmm1
	movss	dword ptr [rsp + 8], xmm10
	movss	xmm11, dword ptr [rsp + 12]     # xmm11 = mem[0],zero,zero,zero
	addss	xmm11, xmm2
	movss	xmm10, dword ptr [rsp + 8]      # xmm10 = mem[0],zero,zero,zero
	unpcklps	xmm11, xmm9                     # xmm11 = xmm11[0],xmm9[0],xmm11[1],xmm9[1]
	shufps	xmm9, xmm9, 0                   # xmm9 = xmm9[0,0,0,0]
	mulps	xmm9, xmm11
	movaps	xmm11, xmm9
	shufps	xmm11, xmm9, 85                 # xmm11 = xmm11[1,1],xmm9[1,1]
	movaps	xmm12, xmm11
	mulss	xmm12, xmm3
	addss	xmm12, xmm4
	mulss	xmm12, xmm11
	addss	xmm12, xmm5
	mulss	xmm12, xmm11
	addss	xmm12, xmm6
	mulss	xmm12, xmm11
	unpcklps	xmm10, xmm12                    # xmm10 = xmm10[0],xmm12[0],xmm10[1],xmm12[1]
	addps	xmm10, xmm7
	mulps	xmm10, xmm9
	movaps	xmm9, xmm10
	shufps	xmm9, xmm10, 85                 # xmm9 = xmm9[1,1],xmm10[1,1]
	addss	xmm9, xmm8
	mulss	xmm9, xmm10
	movss	dword ptr [rdx + 4*rax], xmm9
	inc	rax
	cmp	r8, rax
	jne	.LBB0_2
.LBB0_3:
	movaps	xmm6, xmmword ptr [rsp + 16]    # 16-byte Reload
	movaps	xmm7, xmmword ptr [rsp + 32]    # 16-byte Reload
	movaps	xmm8, xmmword ptr [rsp + 48]    # 16-byte Reload
	movaps	xmm9, xmmword ptr [rsp + 64]    # 16-byte Reload
	movaps	xmm10, xmmword ptr [rsp + 80]   # 16-byte Reload
	movaps	xmm11, xmmword ptr [rsp + 96]   # 16-byte Reload
	movaps	xmm12, xmmword ptr [rsp + 112]  # 16-byte Reload
	add	rsp, 136
	ret
	.seh_endproc
                                        # -- End function
	.def	kernel_f64;
	.scl	2;
	.type	32;
	.endef
	.globl	__real@c00921fb54442d18         # -- Begin function kernel_f64
	.section	.rdata,"dr",discard,__real@c00921fb54442d18
	.p2align	3, 0x0
__real@c00921fb54442d18:
	.quad	0xc00921fb54442d18              # double -3.1415926535897931
	.globl	__real@400921fb54442d18
	.section	.rdata,"dr",discard,__real@400921fb54442d18
	.p2align	3, 0x0
__real@400921fb54442d18:
	.quad	0x400921fb54442d18              # double 3.1415926535897931
	.globl	__real@bca1a62633145c07
	.section	.rdata,"dr",discard,__real@bca1a62633145c07
	.p2align	3, 0x0
__real@bca1a62633145c07:
	.quad	0xbca1a62633145c07              # double -1.2246467991473532E-16
	.globl	__real@3de24479d9a2b3de
	.section	.rdata,"dr",discard,__real@3de24479d9a2b3de
	.p2align	3, 0x0
__real@3de24479d9a2b3de:
	.quad	0x3de24479d9a2b3de              # double 1.3291344137954461E-10
	.globl	__real@be59098b925e463c
	.section	.rdata,"dr",discard,__real@be59098b925e463c
	.p2align	3, 0x0
__real@be59098b925e463c:
	.quad	0xbe59098b925e463c              # double -2.3317789608526773E-8
	.globl	__real@3ec52894e32bff46
	.section	.rdata,"dr",discard,__real@3ec52894e32bff46
	.p2align	3, 0x0
__real@3ec52894e32bff46:
	.quad	0x3ec52894e32bff46              # double 2.5222923566436173E-6
	.globl	__real@bf26bddd194cb763
	.section	.rdata,"dr",discard,__real@bf26bddd194cb763
	.p2align	3, 0x0
__real@bf26bddd194cb763:
	.quad	0xbf26bddd194cb763              # double -1.7350505790985756E-4
	.globl	__xmm@3f7b1e7ed045429c3ca1a62633145c07
	.section	.rdata,"dr",discard,__xmm@3f7b1e7ed045429c3ca1a62633145c07
	.p2align	4, 0x0
__xmm@3f7b1e7ed045429c3ca1a62633145c07:
	.quad	0x3ca1a62633145c07              # double 1.2246467991473532E-16
	.quad	0x3f7b1e7ed045429c              # double 0.0066208795218051474
	.globl	__real@bfb9f02f60ddbaea
	.section	.rdata,"dr",discard,__real@bfb9f02f60ddbaea
	.p2align	3, 0x0
__real@bfb9f02f60ddbaea:
	.quad	0xbfb9f02f60ddbaea              # double -0.10132118334670862
	.section	.text,"xr",one_only,kernel_f64
	.globl	kernel_f64
	.p2align	4, 0x90
kernel_f64:                             # @kernel_f64
.seh_proc kernel_f64
# %bb.0:
	sub	rsp, 136
	.seh_stackalloc 136
	movapd	xmmword ptr [rsp + 112], xmm12  # 16-byte Spill
	.seh_savexmm xmm12, 112
	movapd	xmmword ptr [rsp + 96], xmm11   # 16-byte Spill
	.seh_savexmm xmm11, 96
	movapd	xmmword ptr [rsp + 80], xmm10   # 16-byte Spill
	.seh_savexmm xmm10, 80
	movapd	xmmword ptr [rsp + 64], xmm9    # 16-byte Spill
	.seh_savexmm xmm9, 64
	movapd	xmmword ptr [rsp + 48], xmm8    # 16-byte Spill
	.seh_savexmm xmm8, 48
	movapd	xmmword ptr [rsp + 32], xmm7    # 16-byte Spill
	.seh_savexmm xmm7, 32
	movapd	xmmword ptr [rsp + 16], xmm6    # 16-byte Spill
	.seh_savexmm xmm6, 16
	.seh_endprologue
	test	r8, r8
	je	.LBB1_3
# %bb.1:
	xor	eax, eax
	movsd	xmm0, qword ptr [rip + __real@c00921fb54442d18] # xmm0 = [-3.1415926535897931E+0,0.0E+0]
	movsd	xmm1, qword ptr [rip + __real@400921fb54442d18] # xmm1 = [3.1415926535897931E+0,0.0E+0]
	movsd	xmm2, qword ptr [rip + __real@bca1a62633145c07] # xmm2 = [-1.2246467991473532E-16,0.0E+0]
	movsd	xmm3, qword ptr [rip + __real@3de24479d9a2b3de] # xmm3 = [1.3291344137954461E-10,0.0E+0]
	movsd	xmm4, qword ptr [rip + __real@be59098b925e463c] # xmm4 = [-2.3317789608526773E-8,0.0E+0]
	movsd	xmm5, qword ptr [rip + __real@3ec52894e32bff46] # xmm5 = [2.5222923566436173E-6,0.0E+0]
	movsd	xmm6, qword ptr [rip + __real@bf26bddd194cb763] # xmm6 = [-1.7350505790985756E-4,0.0E+0]
	movapd	xmm7, xmmword ptr [rip + __xmm@3f7b1e7ed045429c3ca1a62633145c07] # xmm7 = [1.2246467991473532E-16,6.6208795218051474E-3]
	movsd	xmm8, qword ptr [rip + __real@bfb9f02f60ddbaea] # xmm8 = [-1.0132118334670862E-1,0.0E+0]
	.p2align	4, 0x90
.LBB1_2:                                # =>This Inner Loop Header: Depth=1
	movsd	xmm9, qword ptr [rcx + 8*rax]   # xmm9 = mem[0],zero
	movapd	xmm10, xmm9
	addsd	xmm10, xmm0
	movsd	qword ptr [rsp + 8], xmm10
	movapd	xmm10, xmm9
	addsd	xmm10, xmm1
	movsd	qword ptr [rsp], xmm10
	movsd	xmm11, qword ptr [rsp + 8]      # xmm11 = mem[0],zero
	addsd	xmm11, xmm2
	movsd	xmm10, qword ptr [rsp]          # xmm10 = mem[0],zero
	unpcklpd	xmm11, xmm9                     # xmm11 = xmm11[0],xmm9[0]
	unpcklpd	xmm9, xmm9                      # xmm9 = xmm9[0,0]
	mulpd	xmm9, xmm11
	movapd	xmm11, xmm9
	unpckhpd	xmm11, xmm9                     # xmm11 = xmm11[1],xmm9[1]
	movapd	xmm12, xmm11
	mulsd	xmm12, xmm3
	addsd	xmm12, xmm4
	mulsd	xmm12, xmm11
	addsd	xmm12, xmm5
	mulsd	xmm12, xmm11
	addsd	xmm12, xmm6
	mulsd	xmm12, xmm11
	unpcklpd	xmm10, xmm12                    # xmm10 = xmm10[0],xmm12[0]
	addpd	xmm10, xmm7
	mulpd	xmm10, xmm9
	movapd	xmm9, xmm10
	unpckhpd	xmm9, xmm10                     # xmm9 = xmm9[1],xmm10[1]
	addsd	xmm9, xmm8
	mulsd	xmm9, xmm10
	movsd	qword ptr [rdx + 8*rax], xmm9
	inc	rax
	cmp	r8, rax
	jne	.LBB1_2
.LBB1_3:
	movaps	xmm6, xmmword ptr [rsp + 16]    # 16-byte Reload
	movaps	xmm7, xmmword ptr [rsp + 32]    # 16-byte Reload
	movaps	xmm8, xmmword ptr [rsp + 48]    # 16-byte Reload
	movaps	xmm9, xmmword ptr [rsp + 64]    # 16-byte Reload
	movaps	xmm10, xmmword ptr [rsp + 80]   # 16-byte Reload
	movaps	xmm11, xmmword ptr [rsp + 96]   # 16-byte Reload
	movaps	xmm12, xmmword ptr [rsp + 112]  # 16-byte Reload
	add	rsp, 136
	ret
	.seh_endproc
                                        # -- End function
	.section	.drectve,"yni"
	.ascii	" /DEFAULTLIB:libcmt.lib"
	.ascii	" /DEFAULTLIB:oldnames.lib"
	.addrsig
	.globl	_fltused
