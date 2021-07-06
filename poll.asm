	global	_start

	section	.data
pollstruct:	dd	0	; stdin
	dw	1	; pollin
	dw	0	; filled in by syscall

savecur:	db	`\033[s`
restcur:	db	`\033[u`
cursize:	equ	$ - restcur

	section	.bss
input:	resb	0xFF

	section	.text

_start:	
	
loop:	
	mov	rax, 7
	mov	rdi, pollstruct
	mov	rsi, 1
	mov	rdx, 0
	syscall

	cmp	rax, 1
	jl	noimp

	xor	rax, rax
	xor	rdi, rdi
	mov	rsi, input
	mov	rdx, 0xFF
	syscall

noimp:	jmp	loop

done:	mov	rax, 60
	xor	rdi, rdi
	syscall
