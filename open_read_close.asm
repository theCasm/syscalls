; project to use open, read, and close syscalls
	section	.data
filename:	db	"open_read_close.asm"

	section	.bss
buf:	resb	0x400	; 1kb

	section	.text
	global	_start

_start:	
	mov	rax, 2
	mov	rdi, filename
	mov	rsi, 0	; I think this is O_RDONLY
	; Ive read both manual and source code and idk what I need for mode ._.
	; I think I only need it for different flags, with different values depending on the flag
	; from what I can tell, O_RDONLY doesnt require these, and this program works without them
	syscall

	push	rax

diditwork:	mov	rdi, rax
	xor	rax, rax
	mov	rsi, buf
	mov	rdx, 0x400
	syscall		; read 1kb from file

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, buf
	mov	rdx, 0x400
	syscall		; technically this is write syscall but I want to make the program
			; do something
	mov	rax, 3
	pop	rdi
	syscall		; close file, 

done:	mov	rax, 60
	xor	rdi, rdi
	syscall
