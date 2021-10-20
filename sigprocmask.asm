; Ima just make SIGINT (ctrl-c) not do anything.
; SIGINT = 2

; I've looked through more kernel source code than I ever have wanted to to make these signal ones work.
; linux/signal.h has defs for the lib functions like sigaddset, digdelset, etc.
; uapi/asm-generic/signal.h has the actual defs for the signals, or macros used in the kernel signal header.

	section	.data
set:	dq	0x0000000000000002	; SIGINT will be stored by default. Avoids library functions
	dq	0


	section	.text
	global	_start

_start:	
	mov	rax, 14	; rt_sigprocmask
	mov	rdi, 0	; SIG_BLOCK
	mov	rsi, set	; pray
	mov	rdx, 0	; don't save old sigset
	mov	r10, 8	; sigset_t is 64 bits
	syscall

loop:
	jmp	$	; I should probably just use a pause syscall here
			; oh well. Good code is for losers
