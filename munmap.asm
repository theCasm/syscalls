	global	_start
	section	.data
errstr:	db	"failed to unallocate", 0xA
errlen:	equ	$ - errstr

	section	.text
; how tf do I make a program centered around unmapping something
_start:	
	; allocate memory
	mov	rax, 9	; mmap
	mov	rdi, 0	; let OS decide address
	mov	rsi, 69	; 69 bytes
	mov	rdx, 3	; read+write
	mov	r10, 0x22	; private and anonymous
	mov	r8, -1	; arent used with anonymous
	mov	r9, 0	; 
	syscall

	; unallocate memory
	mov	rdi, rax	; address
	mov	rax, 11	; munmap
	mov	rsi, 69	; 69 bytes
	syscall

	cmp	rax, 0
	jl	err

done:	mov	rax, 60
	xor	rdi, rdi
	syscall

err:	mov	rax, 1
	mov	rdi, 1
	mov	rsi, errstr
	mov	rdx, errlen
	syscall

	mov	rax, 60
	mov	rdi, -1
	syscall
