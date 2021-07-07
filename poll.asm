	global	_start

	section	.data
pollstruct:	dd	0	; stdin
	dw	1	; pollin
	dw	0	; filled in by syscall

savecur:	db	`\033[s`
restcur:	db	`\033[u`
cursize:	equ	$ - restcur

wheel:	db	"|/-\\"

output:	db	`\033[s  \r\033[u`

finstr:	db	"You said: "
finlen:	equ	$-finstr

	section	.bss
input:	resb	0xFF

	section	.text

_start:	
	mov	r15, output
	xor	r14, r14
	xor	r13, r13
loop:
	inc	r13
	cmp	r13, 20000
	jl	print
	xor	r13, r13

	inc	r14
	cmp	r14, 4
	jl	print
	xor	r14, r14
print:
	mov	r15b, byte[r14+wheel]
	mov	byte[output+4], r15b

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, output
	mov	rdx, 9
	syscall

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

	jmp	finish

noimp:	jmp	loop
finish:

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, finstr
	mov	rdx, finlen
	syscall

	mov	rax, 1
	mov	rsi, input
	mov	rdx, 0xFF
	syscall

done:	mov	rax, 60
	xor	rdi, rdi
	syscall


