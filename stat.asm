;
; I was mostly lazy with this one, but I did some testing.
; In order, this is what I could quickly decipher from the stat struct for my machine.
;
; QWORD - st_dev
;
; DWORD - seems random?
; DWORD - st_ino
;
; QWORD - nlink
;
; DWORD - st_uid or st_gid
; DWORD - st_mode
;
; QWORD - st_uid or st_gid (?)
;
; QWORD - st_rdev (?)
;
; QWORD - st_size
; QWORD - st_blksize
; QWORD - st_blocks
; QWORD - st_atime (?)
; QWORD - ? (maybe st_mtime?)
; QWORD - st_ctime (?)

	section	.data
prompt:	db	"filename: "
promptlen:	equ	$ - prompt

sizestr:	db	"size: "
sizelen:	equ	$ - sizestr

	section	.bss
filename:	resb	0xFF

statstruct:	resb	92	; I used a C file and disassembled it to get offsets and size
strbuffer:	resb	0xFF

	section	.text
	global	_start

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

	; get rid of newline
	mov	byte[filename+rax-1], 0

	; also we have to null terminate the string, which combined with all
	; other things and the terrible struct, is enough evidence that this syscall
	; was never meant to be sued with assembly

	mov	rax, 4
	mov	rdi, filename
	mov	rsi, statstruct
	syscall

sysdone:	mov	rax, 1
	mov	rdi, 1
	mov	rsi, sizestr
	mov	rdx, sizelen
	syscall

	mov	rdi, [statstruct + 48]
	call	printNum

	; check if error or not using gdb
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
