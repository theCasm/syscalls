	section	.data
prompt:	db	"filename: "
promptlen:	equ	$-prompt

fsize:	db	`\033[36mfile/link size\033[0m: `
flen:	equ	$ - fsize

	section	.bss
filename:	resb	0xFF
statstruct:	resb	92
strbuffer:	resb	0xFF

	section	.text
	global	_start

; simple program to get id of symlink owner (or file owner if not symlink)
_start:	
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, prompt
	mov	rdx, promptlen
	syscall

	xor	rax, rax
	xor	rdi, rdi
	mov	rsi, filename
	mov	rdx, 0xFF
	syscall

	mov	byte[filename + rax - 1], 0

	mov	rax, 6
	mov	rdi, filename
	mov	rsi, statstruct
	syscall

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, fsize
	mov	rdx, flen
	syscall

	mov	edi, [statstruct + 48]
	call	printNum

done:	mov	rax, 60
	xor	rdi, rdi
	syscall


printNum:	
	mov	rax, rdi
	mov	rbx, 10
	xor	rcx, rcx

loop:	xor	rdx, rdx
	div	rbx
	
	add	dl, '0'
	mov	[rcx + strbuffer], dl
	inc	rcx

	cmp	rax, 0
	jg	loop

	xor	rdx, rdx
	mov	r8, rcx
	inc	r8
	mov	byte[rcx + strbuffer], 0xA

loop2:	dec	rcx
	
	mov	al, [rcx + strbuffer]
	mov	bl, [rdx + strbuffer]

	xor	al, bl
	xor	bl, al
	xor	al, bl

	mov	[rcx + strbuffer], al
	mov	[rdx + strbuffer], bl

	inc	rdx
	
	cmp	rcx, rdx
	jg	loop2

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, strbuffer
	mov	rdx, r8
	syscall

	ret
