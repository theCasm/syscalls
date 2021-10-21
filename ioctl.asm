; literally the only ioctl type I know is FIONREAD/SIOCINQ, so I guess we're using that.

; I guess the program will prompt for input and then use brk to allocate just enough memory to hold the input

%define	FIONREAD	0x541B
%define	STDIN	0
%define	POLLIN	1

%define	SYS_READ	0x00
%define	SYS_WRITE	0x01
%define	SYS_POLL	0x07
%define	SYS_BRK	0x0C
%define	SYS_IOCTL	0x10
%define	SYS_EXIT	0x3C

	section	.data
prompt:	db	"enter as many chars as you can in under 60 seconds (must hit enter): "
promptlen:	equ	$ - prompt

size:	dd	0	; use as int for storing input size. I think it's reasonable to expect < 2^32
			; chars for only a minute of waiting. I would use 2^64, but that would
			; crash because I don't have that much ram. (also because x64 isn't yet
			; designed for that much, and can only handle 2^48 virtual and 2^52 physical
			; because of mapping and physical "cheap outs". They could do more, but
			; it really isn't worth it and won't be for a while)
			;
			; Please don't actually assume brk can reserve even close to 2^32
			; bytes, brk should be used with smaller values

; look at uapi/asm/poll.h include in linux src
; this code assumes int = 32 bits, short = 16, struct padding = 0.
; None of my code is meant to be portable - it's assembly. For portability use C.
pollstruct:	dd	STDIN
	dw	POLLIN 
	dw	0	; returned events - filled in by syscall

	section	.text
	global	_start

_start:	
	mov	rax, SYS_WRITE
	mov	rdi, STDIN
	mov	rsi, prompt
	mov	rdx, promptlen	; write prompt message to stdout
	syscall			

	mov	rax, SYS_POLL
	mov	rdi, pollstruct	
	mov	rsi, 1		; only 1 fd
	mov	rdx, 60000		; block for 60k milliseconds (1 minute)
	syscall

	mov	rax, SYS_IOCTL
	mov	rdi, STDIN
	mov	rsi, FIONREAD
	mov	rdx, size
	syscall

	; reserve space for (rAX) chars

	; get current program break
	mov	rax, SYS_BRK
	mov	rdi, -1		; unreasonable value, makes brk return current program break
	syscall

	mov	r8, rax		; save so we can use later

	add	rax, [size]		; calculate new break

	mov	rdi, rax
	mov	rax, SYS_BRK
	syscall			; reserve memory.

print:	mov	rax, SYS_READ
	mov	rdi, STDIN
	mov	rsi, r8		; I was about to do some really cool optimizaton here by using
	mov	rdx, [size]		; lea to set rdi to r8+1, but the program break is actually the
	syscall			; first value after your data so it's not necessary :(

	mov	rax, SYS_WRITE
	mov	rdi, STDIN
	mov	rsi, r8
	mov	rdx, [size]
	syscall

	mov	rax, SYS_EXIT
	xor	rdi, rdi
	syscall
