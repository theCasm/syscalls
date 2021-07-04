	section	.data
txt:	db	"so incredibly complicated", 0xA
txtLen:	equ	$ - txt

	section	.text
	global	_start

_start:	mov	rax, 1
	mov	rdi, 1
	mov	rsi, txt
	mov	rdx, txtLen
	syscall

	mov	rax, 60
	xor	rdi, rdi
	syscall
