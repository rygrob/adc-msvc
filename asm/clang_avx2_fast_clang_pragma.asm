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
	.globl	__real@2f1223cf                 # -- Begin function kernel_f32
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
	.globl	__real@3bd8f3f7
	.section	.rdata,"dr",discard,__real@3bd8f3f7
	.p2align	2, 0x0
__real@3bd8f3f7:
	.long	0x3bd8f3f7                      # float 0.00662087975
	.globl	__real@bdcf817b
	.section	.rdata,"dr",discard,__real@bdcf817b
	.p2align	2, 0x0
__real@bdcf817b:
	.long	0xbdcf817b                      # float -0.101321183
	.globl	__real@c0490fdb
	.section	.rdata,"dr",discard,__real@c0490fdb
	.p2align	2, 0x0
__real@c0490fdb:
	.long	0xc0490fdb                      # float -3.14159274
	.globl	__real@33bbbd2e
	.section	.rdata,"dr",discard,__real@33bbbd2e
	.p2align	2, 0x0
__real@33bbbd2e:
	.long	0x33bbbd2e                      # float 8.74227765E-8
	.globl	__real@40490fdb
	.section	.rdata,"dr",discard,__real@40490fdb
	.p2align	2, 0x0
__real@40490fdb:
	.long	0x40490fdb                      # float 3.14159274
	.globl	__real@b3bbbd2e
	.section	.rdata,"dr",discard,__real@b3bbbd2e
	.p2align	2, 0x0
__real@b3bbbd2e:
	.long	0xb3bbbd2e                      # float -8.74227765E-8
	.section	.text,"xr",one_only,kernel_f32
	.globl	kernel_f32
	.p2align	4, 0x90
kernel_f32:                             # @kernel_f32
.seh_proc kernel_f32
# %bb.0:
	sub	rsp, 136
	.seh_stackalloc 136
	vmovaps	xmmword ptr [rsp + 112], xmm13  # 16-byte Spill
	.seh_savexmm xmm13, 112
	vmovaps	xmmword ptr [rsp + 96], xmm12   # 16-byte Spill
	.seh_savexmm xmm12, 96
	vmovaps	xmmword ptr [rsp + 80], xmm11   # 16-byte Spill
	.seh_savexmm xmm11, 80
	vmovaps	xmmword ptr [rsp + 64], xmm10   # 16-byte Spill
	.seh_savexmm xmm10, 64
	vmovaps	xmmword ptr [rsp + 48], xmm9    # 16-byte Spill
	.seh_savexmm xmm9, 48
	vmovaps	xmmword ptr [rsp + 32], xmm8    # 16-byte Spill
	.seh_savexmm xmm8, 32
	vmovaps	xmmword ptr [rsp + 16], xmm7    # 16-byte Spill
	.seh_savexmm xmm7, 16
	vmovaps	xmmword ptr [rsp], xmm6         # 16-byte Spill
	.seh_savexmm xmm6, 0
	.seh_endprologue
	test	r8, r8
	je	.LBB0_8
# %bb.1:
	cmp	r8, 8
	setae	al
	mov	r9, rdx
	sub	r9, rcx
	cmp	r9, 32
	setae	r9b
	test	al, r9b
	jne	.LBB0_5
# %bb.2:
	xor	eax, eax
	jmp	.LBB0_3
.LBB0_5:
	mov	rax, r8
	and	rax, -8
	xor	r9d, r9d
	vbroadcastss	ymm0, dword ptr [rip + __real@2f1223cf] # ymm0 = [1.32913444E-10,1.32913444E-10,1.32913444E-10,1.32913444E-10,1.32913444E-10,1.32913444E-10,1.32913444E-10,1.32913444E-10]
	vbroadcastss	ymm1, dword ptr [rip + __real@b2c84c5d] # ymm1 = [-2.33177904E-8,-2.33177904E-8,-2.33177904E-8,-2.33177904E-8,-2.33177904E-8,-2.33177904E-8,-2.33177904E-8,-2.33177904E-8]
	vbroadcastss	ymm2, dword ptr [rip + __real@362944a7] # ymm2 = [2.52229233E-6,2.52229233E-6,2.52229233E-6,2.52229233E-6,2.52229233E-6,2.52229233E-6,2.52229233E-6,2.52229233E-6]
	vbroadcastss	ymm3, dword ptr [rip + __real@b935eee9] # ymm3 = [-1.73505061E-4,-1.73505061E-4,-1.73505061E-4,-1.73505061E-4,-1.73505061E-4,-1.73505061E-4,-1.73505061E-4,-1.73505061E-4]
	vbroadcastss	ymm4, dword ptr [rip + __real@3bd8f3f7] # ymm4 = [6.62087975E-3,6.62087975E-3,6.62087975E-3,6.62087975E-3,6.62087975E-3,6.62087975E-3,6.62087975E-3,6.62087975E-3]
	vbroadcastss	ymm5, dword ptr [rip + __real@bdcf817b] # ymm5 = [-1.01321183E-1,-1.01321183E-1,-1.01321183E-1,-1.01321183E-1,-1.01321183E-1,-1.01321183E-1,-1.01321183E-1,-1.01321183E-1]
	vbroadcastss	ymm6, dword ptr [rip + __real@c0490fdb] # ymm6 = [-3.14159274E+0,-3.14159274E+0,-3.14159274E+0,-3.14159274E+0,-3.14159274E+0,-3.14159274E+0,-3.14159274E+0,-3.14159274E+0]
	vbroadcastss	ymm7, dword ptr [rip + __real@33bbbd2e] # ymm7 = [8.74227765E-8,8.74227765E-8,8.74227765E-8,8.74227765E-8,8.74227765E-8,8.74227765E-8,8.74227765E-8,8.74227765E-8]
	vbroadcastss	ymm8, dword ptr [rip + __real@40490fdb] # ymm8 = [3.14159274E+0,3.14159274E+0,3.14159274E+0,3.14159274E+0,3.14159274E+0,3.14159274E+0,3.14159274E+0,3.14159274E+0]
	vbroadcastss	ymm9, dword ptr [rip + __real@b3bbbd2e] # ymm9 = [-8.74227765E-8,-8.74227765E-8,-8.74227765E-8,-8.74227765E-8,-8.74227765E-8,-8.74227765E-8,-8.74227765E-8,-8.74227765E-8]
	.p2align	4, 0x90
.LBB0_6:                                # =>This Inner Loop Header: Depth=1
	vmovups	ymm10, ymmword ptr [rcx + 4*r9]
	vmulps	ymm11, ymm10, ymm10
	vmovaps	ymm12, ymm0
	vfmadd213ps	ymm12, ymm11, ymm1      # ymm12 = (ymm11 * ymm12) + ymm1
	vfmadd213ps	ymm12, ymm11, ymm2      # ymm12 = (ymm11 * ymm12) + ymm2
	vfmadd213ps	ymm12, ymm11, ymm3      # ymm12 = (ymm11 * ymm12) + ymm3
	vfmadd213ps	ymm12, ymm11, ymm4      # ymm12 = (ymm11 * ymm12) + ymm4
	vfmadd213ps	ymm12, ymm11, ymm5      # ymm12 = (ymm11 * ymm12) + ymm5
	vaddps	ymm11, ymm10, ymm6
	vaddps	ymm11, ymm11, ymm7
	vaddps	ymm13, ymm10, ymm8
	vaddps	ymm13, ymm13, ymm9
	vmulps	ymm11, ymm11, ymm13
	vmulps	ymm11, ymm11, ymm12
	vmulps	ymm10, ymm10, ymm11
	vmovups	ymmword ptr [rdx + 4*r9], ymm10
	add	r9, 8
	cmp	rax, r9
	jne	.LBB0_6
# %bb.7:
	cmp	rax, r8
	je	.LBB0_8
.LBB0_3:
	vmovss	xmm0, dword ptr [rip + __real@2f1223cf] # xmm0 = [1.32913444E-10,0.0E+0,0.0E+0,0.0E+0]
	vmovss	xmm1, dword ptr [rip + __real@b2c84c5d] # xmm1 = [-2.33177904E-8,0.0E+0,0.0E+0,0.0E+0]
	vmovss	xmm2, dword ptr [rip + __real@362944a7] # xmm2 = [2.52229233E-6,0.0E+0,0.0E+0,0.0E+0]
	vmovss	xmm3, dword ptr [rip + __real@b935eee9] # xmm3 = [-1.73505061E-4,0.0E+0,0.0E+0,0.0E+0]
	vmovss	xmm4, dword ptr [rip + __real@3bd8f3f7] # xmm4 = [6.62087975E-3,0.0E+0,0.0E+0,0.0E+0]
	vmovss	xmm5, dword ptr [rip + __real@bdcf817b] # xmm5 = [-1.01321183E-1,0.0E+0,0.0E+0,0.0E+0]
	vmovss	xmm6, dword ptr [rip + __real@c0490fdb] # xmm6 = [-3.14159274E+0,0.0E+0,0.0E+0,0.0E+0]
	vmovss	xmm7, dword ptr [rip + __real@33bbbd2e] # xmm7 = [8.74227765E-8,0.0E+0,0.0E+0,0.0E+0]
	vmovss	xmm8, dword ptr [rip + __real@40490fdb] # xmm8 = [3.14159274E+0,0.0E+0,0.0E+0,0.0E+0]
	vmovss	xmm9, dword ptr [rip + __real@b3bbbd2e] # xmm9 = [-8.74227765E-8,0.0E+0,0.0E+0,0.0E+0]
	.p2align	4, 0x90
.LBB0_4:                                # =>This Inner Loop Header: Depth=1
	vmovss	xmm10, dword ptr [rcx + 4*rax]  # xmm10 = mem[0],zero,zero,zero
	vmulss	xmm11, xmm10, xmm10
	vmovaps	xmm12, xmm0
	vfmadd213ss	xmm12, xmm11, xmm1      # xmm12 = (xmm11 * xmm12) + xmm1
	vfmadd213ss	xmm12, xmm11, xmm2      # xmm12 = (xmm11 * xmm12) + xmm2
	vfmadd213ss	xmm12, xmm11, xmm3      # xmm12 = (xmm11 * xmm12) + xmm3
	vfmadd213ss	xmm12, xmm11, xmm4      # xmm12 = (xmm11 * xmm12) + xmm4
	vfmadd213ss	xmm12, xmm11, xmm5      # xmm12 = (xmm11 * xmm12) + xmm5
	vaddss	xmm11, xmm10, xmm6
	vaddss	xmm11, xmm11, xmm7
	vaddss	xmm13, xmm10, xmm8
	vaddss	xmm13, xmm13, xmm9
	vmulss	xmm11, xmm11, xmm13
	vmulss	xmm11, xmm11, xmm12
	vmulss	xmm10, xmm10, xmm11
	vmovss	dword ptr [rdx + 4*rax], xmm10
	inc	rax
	cmp	r8, rax
	jne	.LBB0_4
.LBB0_8:
	vmovaps	xmm6, xmmword ptr [rsp]         # 16-byte Reload
	vmovaps	xmm7, xmmword ptr [rsp + 16]    # 16-byte Reload
	vmovaps	xmm8, xmmword ptr [rsp + 32]    # 16-byte Reload
	vmovaps	xmm9, xmmword ptr [rsp + 48]    # 16-byte Reload
	vmovaps	xmm10, xmmword ptr [rsp + 64]   # 16-byte Reload
	vmovaps	xmm11, xmmword ptr [rsp + 80]   # 16-byte Reload
	vmovaps	xmm12, xmmword ptr [rsp + 96]   # 16-byte Reload
	vmovaps	xmm13, xmmword ptr [rsp + 112]  # 16-byte Reload
	add	rsp, 136
	vzeroupper
	ret
	.seh_endproc
                                        # -- End function
	.def	kernel_f64;
	.scl	2;
	.type	32;
	.endef
	.globl	__real@3de24479d9a2b3de         # -- Begin function kernel_f64
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
	.globl	__real@3f7b1e7ed045429c
	.section	.rdata,"dr",discard,__real@3f7b1e7ed045429c
	.p2align	3, 0x0
__real@3f7b1e7ed045429c:
	.quad	0x3f7b1e7ed045429c              # double 0.0066208795218051474
	.globl	__real@bfb9f02f60ddbaea
	.section	.rdata,"dr",discard,__real@bfb9f02f60ddbaea
	.p2align	3, 0x0
__real@bfb9f02f60ddbaea:
	.quad	0xbfb9f02f60ddbaea              # double -0.10132118334670862
	.globl	__real@c00921fb54442d18
	.section	.rdata,"dr",discard,__real@c00921fb54442d18
	.p2align	3, 0x0
__real@c00921fb54442d18:
	.quad	0xc00921fb54442d18              # double -3.1415926535897931
	.globl	__real@bca1a62633145c07
	.section	.rdata,"dr",discard,__real@bca1a62633145c07
	.p2align	3, 0x0
__real@bca1a62633145c07:
	.quad	0xbca1a62633145c07              # double -1.2246467991473532E-16
	.globl	__real@400921fb54442d18
	.section	.rdata,"dr",discard,__real@400921fb54442d18
	.p2align	3, 0x0
__real@400921fb54442d18:
	.quad	0x400921fb54442d18              # double 3.1415926535897931
	.globl	__real@3ca1a62633145c07
	.section	.rdata,"dr",discard,__real@3ca1a62633145c07
	.p2align	3, 0x0
__real@3ca1a62633145c07:
	.quad	0x3ca1a62633145c07              # double 1.2246467991473532E-16
	.section	.text,"xr",one_only,kernel_f64
	.globl	kernel_f64
	.p2align	4, 0x90
kernel_f64:                             # @kernel_f64
.seh_proc kernel_f64
# %bb.0:
	sub	rsp, 136
	.seh_stackalloc 136
	vmovapd	xmmword ptr [rsp + 112], xmm13  # 16-byte Spill
	.seh_savexmm xmm13, 112
	vmovapd	xmmword ptr [rsp + 96], xmm12   # 16-byte Spill
	.seh_savexmm xmm12, 96
	vmovapd	xmmword ptr [rsp + 80], xmm11   # 16-byte Spill
	.seh_savexmm xmm11, 80
	vmovapd	xmmword ptr [rsp + 64], xmm10   # 16-byte Spill
	.seh_savexmm xmm10, 64
	vmovapd	xmmword ptr [rsp + 48], xmm9    # 16-byte Spill
	.seh_savexmm xmm9, 48
	vmovapd	xmmword ptr [rsp + 32], xmm8    # 16-byte Spill
	.seh_savexmm xmm8, 32
	vmovapd	xmmword ptr [rsp + 16], xmm7    # 16-byte Spill
	.seh_savexmm xmm7, 16
	vmovapd	xmmword ptr [rsp], xmm6         # 16-byte Spill
	.seh_savexmm xmm6, 0
	.seh_endprologue
	test	r8, r8
	je	.LBB1_8
# %bb.1:
	cmp	r8, 4
	setae	al
	mov	r9, rdx
	sub	r9, rcx
	cmp	r9, 32
	setae	r9b
	test	al, r9b
	jne	.LBB1_5
# %bb.2:
	xor	eax, eax
	jmp	.LBB1_3
.LBB1_5:
	mov	rax, r8
	and	rax, -4
	xor	r9d, r9d
	vbroadcastsd	ymm0, qword ptr [rip + __real@3de24479d9a2b3de] # ymm0 = [1.3291344137954461E-10,1.3291344137954461E-10,1.3291344137954461E-10,1.3291344137954461E-10]
	vbroadcastsd	ymm1, qword ptr [rip + __real@be59098b925e463c] # ymm1 = [-2.3317789608526773E-8,-2.3317789608526773E-8,-2.3317789608526773E-8,-2.3317789608526773E-8]
	vbroadcastsd	ymm2, qword ptr [rip + __real@3ec52894e32bff46] # ymm2 = [2.5222923566436173E-6,2.5222923566436173E-6,2.5222923566436173E-6,2.5222923566436173E-6]
	vbroadcastsd	ymm3, qword ptr [rip + __real@bf26bddd194cb763] # ymm3 = [-1.7350505790985756E-4,-1.7350505790985756E-4,-1.7350505790985756E-4,-1.7350505790985756E-4]
	vbroadcastsd	ymm4, qword ptr [rip + __real@3f7b1e7ed045429c] # ymm4 = [6.6208795218051474E-3,6.6208795218051474E-3,6.6208795218051474E-3,6.6208795218051474E-3]
	vbroadcastsd	ymm5, qword ptr [rip + __real@bfb9f02f60ddbaea] # ymm5 = [-1.0132118334670862E-1,-1.0132118334670862E-1,-1.0132118334670862E-1,-1.0132118334670862E-1]
	vbroadcastsd	ymm6, qword ptr [rip + __real@c00921fb54442d18] # ymm6 = [-3.1415926535897931E+0,-3.1415926535897931E+0,-3.1415926535897931E+0,-3.1415926535897931E+0]
	vbroadcastsd	ymm7, qword ptr [rip + __real@bca1a62633145c07] # ymm7 = [-1.2246467991473532E-16,-1.2246467991473532E-16,-1.2246467991473532E-16,-1.2246467991473532E-16]
	vbroadcastsd	ymm8, qword ptr [rip + __real@400921fb54442d18] # ymm8 = [3.1415926535897931E+0,3.1415926535897931E+0,3.1415926535897931E+0,3.1415926535897931E+0]
	vbroadcastsd	ymm9, qword ptr [rip + __real@3ca1a62633145c07] # ymm9 = [1.2246467991473532E-16,1.2246467991473532E-16,1.2246467991473532E-16,1.2246467991473532E-16]
	.p2align	4, 0x90
.LBB1_6:                                # =>This Inner Loop Header: Depth=1
	vmovupd	ymm10, ymmword ptr [rcx + 8*r9]
	vmulpd	ymm11, ymm10, ymm10
	vmovapd	ymm12, ymm0
	vfmadd213pd	ymm12, ymm11, ymm1      # ymm12 = (ymm11 * ymm12) + ymm1
	vfmadd213pd	ymm12, ymm11, ymm2      # ymm12 = (ymm11 * ymm12) + ymm2
	vfmadd213pd	ymm12, ymm11, ymm3      # ymm12 = (ymm11 * ymm12) + ymm3
	vfmadd213pd	ymm12, ymm11, ymm4      # ymm12 = (ymm11 * ymm12) + ymm4
	vfmadd213pd	ymm12, ymm11, ymm5      # ymm12 = (ymm11 * ymm12) + ymm5
	vaddpd	ymm11, ymm10, ymm6
	vaddpd	ymm11, ymm11, ymm7
	vaddpd	ymm13, ymm10, ymm8
	vaddpd	ymm13, ymm13, ymm9
	vmulpd	ymm11, ymm11, ymm13
	vmulpd	ymm11, ymm11, ymm12
	vmulpd	ymm10, ymm10, ymm11
	vmovupd	ymmword ptr [rdx + 8*r9], ymm10
	add	r9, 4
	cmp	rax, r9
	jne	.LBB1_6
# %bb.7:
	cmp	rax, r8
	je	.LBB1_8
.LBB1_3:
	vmovsd	xmm0, qword ptr [rip + __real@3de24479d9a2b3de] # xmm0 = [1.3291344137954461E-10,0.0E+0]
	vmovsd	xmm1, qword ptr [rip + __real@be59098b925e463c] # xmm1 = [-2.3317789608526773E-8,0.0E+0]
	vmovsd	xmm2, qword ptr [rip + __real@3ec52894e32bff46] # xmm2 = [2.5222923566436173E-6,0.0E+0]
	vmovsd	xmm3, qword ptr [rip + __real@bf26bddd194cb763] # xmm3 = [-1.7350505790985756E-4,0.0E+0]
	vmovsd	xmm4, qword ptr [rip + __real@3f7b1e7ed045429c] # xmm4 = [6.6208795218051474E-3,0.0E+0]
	vmovsd	xmm5, qword ptr [rip + __real@bfb9f02f60ddbaea] # xmm5 = [-1.0132118334670862E-1,0.0E+0]
	vmovsd	xmm6, qword ptr [rip + __real@c00921fb54442d18] # xmm6 = [-3.1415926535897931E+0,0.0E+0]
	vmovsd	xmm7, qword ptr [rip + __real@bca1a62633145c07] # xmm7 = [-1.2246467991473532E-16,0.0E+0]
	vmovsd	xmm8, qword ptr [rip + __real@400921fb54442d18] # xmm8 = [3.1415926535897931E+0,0.0E+0]
	vmovsd	xmm9, qword ptr [rip + __real@3ca1a62633145c07] # xmm9 = [1.2246467991473532E-16,0.0E+0]
	.p2align	4, 0x90
.LBB1_4:                                # =>This Inner Loop Header: Depth=1
	vmovsd	xmm10, qword ptr [rcx + 8*rax]  # xmm10 = mem[0],zero
	vmulsd	xmm11, xmm10, xmm10
	vmovapd	xmm12, xmm0
	vfmadd213sd	xmm12, xmm11, xmm1      # xmm12 = (xmm11 * xmm12) + xmm1
	vfmadd213sd	xmm12, xmm11, xmm2      # xmm12 = (xmm11 * xmm12) + xmm2
	vfmadd213sd	xmm12, xmm11, xmm3      # xmm12 = (xmm11 * xmm12) + xmm3
	vfmadd213sd	xmm12, xmm11, xmm4      # xmm12 = (xmm11 * xmm12) + xmm4
	vfmadd213sd	xmm12, xmm11, xmm5      # xmm12 = (xmm11 * xmm12) + xmm5
	vaddsd	xmm11, xmm10, xmm6
	vaddsd	xmm11, xmm11, xmm7
	vaddsd	xmm13, xmm10, xmm8
	vaddsd	xmm13, xmm13, xmm9
	vmulsd	xmm11, xmm11, xmm13
	vmulsd	xmm11, xmm11, xmm12
	vmulsd	xmm10, xmm10, xmm11
	vmovsd	qword ptr [rdx + 8*rax], xmm10
	inc	rax
	cmp	r8, rax
	jne	.LBB1_4
.LBB1_8:
	vmovaps	xmm6, xmmword ptr [rsp]         # 16-byte Reload
	vmovaps	xmm7, xmmword ptr [rsp + 16]    # 16-byte Reload
	vmovaps	xmm8, xmmword ptr [rsp + 32]    # 16-byte Reload
	vmovaps	xmm9, xmmword ptr [rsp + 48]    # 16-byte Reload
	vmovaps	xmm10, xmmword ptr [rsp + 64]   # 16-byte Reload
	vmovaps	xmm11, xmmword ptr [rsp + 80]   # 16-byte Reload
	vmovaps	xmm12, xmmword ptr [rsp + 96]   # 16-byte Reload
	vmovaps	xmm13, xmmword ptr [rsp + 112]  # 16-byte Reload
	add	rsp, 136
	vzeroupper
	ret
	.seh_endproc
                                        # -- End function
	.section	.drectve,"yni"
	.ascii	" /DEFAULTLIB:libcmt.lib"
	.ascii	" /DEFAULTLIB:oldnames.lib"
	.addrsig
	.globl	_fltused
