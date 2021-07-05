	section	.data
wmsg:	db	"Welcome to shitty(tm) text editor!", 0xA
wlen:	equ	$ - wmsg

prompt:	db	"Enter filename or q to quit: "
promptlen:	equ	$ - prompt

writemsg:	db	"What would you like to write into the file: "
writelen:	equ	$ - writemsg

fsize:	db	"new file size: "
flen:	equ	$ - fsize

fd:	db	0

	section	.bss
filename:	resb	0xFF
writedata:	resb	0xFFF	; technically I should use a buffer that can expand, but idk how to do that
statstruct:	resb	92	; with only 1 syscall, or if its even possible short of creating my
strbuffer:	resb	0xFF	; own OS

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
	mov	byte[filename + rax - 1], 0

	mov	rax, 2
	mov	rdi, filename
	mov	rsi, 1026		; read and write flag, append flag
	syscall

	mov	[fd], rax

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, writemsg
	mov	rdx, writelen
	syscall

	xor	rax, rax
	xor	rdi, rdi
	mov	rsi, writedata
	mov	rdx, 0xFFF
	syscall

	mov	rdx, rax
	mov	rax, 1
	mov	rdi, [fd]
	mov	rsi, writedata
	syscall

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, fsize
	mov	rdx, flen
	syscall

	mov	rax, 5
	mov	rdi, [fd]
	mov	rsi, statstruct
	syscall

	mov	rdi, [statstruct + 48]
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
