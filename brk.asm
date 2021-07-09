; brk either exits on success or "out", which is error.
; I have downloaded the linux kernel source to confirm that, on out,
; brk will return the original program break.

	section	.data
errmsg:	db	"Couldn't expand program break", 0xA
errlen:	equ	$ - errmsg

prompt:	db	"Array size: "
promptlen:	equ	$ - prompt

success:	db	"Success!", 0xA
succlen:	equ	$ - success

	section	.bss

arraylen:	resb	0xF	; not making an array larger than 10^15

	section	.text
	global	_start

%include	"tools.asm"

_start:	
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, prompt
	mov	rdx, promptlen
	syscall
	
	xor	rax, rax
	xor	rdi, rdi
	mov	rsi, arraylen
	mov	rdx, 0xF
	syscall

	; get rid of newline
	mov	byte[arraylen + rax-1], 0

	
	mov	rax, 12
	mov	rdi, -1	; unreasonable value, will trigger out on line 224 of mm/mmap.c
	syscall		; as it is less than the brk minimum value
	mov	r8, rax
	

	mov	rdi, arraylen
	call	atoi

	mov	rdi, r8
	add	rdi, rax	; reserve x bytes
	mov	rax, 12
	syscall

	cmp	rax, rdi
	jne	error

	; rax should have new program break, which is equal to rdi
	mov	byte[rax], 69

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, success
	mov	rdx, succlen
	syscall

done:	mov	rax, 60
	xor	rdi, rdi
	syscall

error:	mov	rax, 1
	mov	rdi, 1
	mov	rsi, errmsg
	mov	rdx, errlen
	syscall

	mov	rax, 60
	mov	rdi, -1
	syscall
