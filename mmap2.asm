; using mmap for files

	global	_start
	section	.data
filename:	db	"multby69.bin", 0

	section	.bss
file:	resb	0xF

	section	.text

_start:	
	mov	rax, 2
	mov	rdi, filename
	mov	rsi, 2	; read and write
	syscall
	
	mov	r8, rax	; fd
	mov	rax, 9	; mmap
	mov	rdi, 0	; OS chooses location
	mov	rsi, 0xFF	; length of 255 bytes
	mov	rdx, 0b111	; read, write, execute
	mov	r10, 1	; shared map
	mov	r9, 0	; no offset
	syscall

	; don't try this at home, kids
	mov	rdi, 10
	call	rax	; call loaded file

done:	mov	rax, 60
	xor	rdi, rdi
	syscall
