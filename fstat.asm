	section	.data
wmsg:	db	"Welcome to shitty(tm) text editor!", 0xA
wlen:	equ	$ - wmsg

prompt:	db	"Enter filename or q to quit: "
promptlen:	equ	$ - prompt

	section	.bss
filename:	resb	0xFF

	section	.text
	global	_start

_start:	
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, wmsg
	mov	rdx, wlen
	syscall

getfile:	mov	rax, 1
	mov	rdi, 1
	mov	rsi, prompt
	mov	rdx, promptlen
	syscall


	xor	rax, rax
	xor	rdi, rdi
	mov	rsi, filename
	mov	rdx, 0xFF
	syscall

	; get rid of newline
	mov	byte[filename+rax-1], 0

	mov	rax, 2
	mov	rdi, filename
	mov	rsi, 2		; read and write flag
	syscall

done:	mov	rax, 60
	xor	rdi, rdi
	syscall
