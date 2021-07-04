; brk either exits on success or "out", which is error.
; I have downloaded the linux kernel source to confirm that, on out,
; brk will return the original program break.

	section	.bss

; this will be expanded
myArray:	resb	10

	section	.text
	global	_start

_start:	
	mov	rax, 12
	mov	rdi, -1	; unreasonable value, will trigger out on line 224 of mm/mmap.c
	syscall		; as it is less than the brk minimum value

	mov	rdi, rax
	mov	rax, 12
	add	rdi, 10	; reserve 10 bytes
	syscall

	; rax should have new program break, which should be equal to rdi
	; write to new data
	mov	byte[rax-9], 0x1
	mov	byte[rax-8], 0x2

done:	mov	rax, 60
	xor	rdi, rdi
	syscall
