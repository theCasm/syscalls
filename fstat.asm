	global	_start
%include	"tools.asm"

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
			; own OS

	section	.text

_start:	
	mov	rax, 1		; write syscall
	mov	rdi, 1		; stdout
	mov	rsi, wmsg		; welcome message
	mov	rdx, wlen		; length of welcome message
	syscall

getfile:	mov	rax, 1		; write syscall
	mov	rdi, 1		; stdout
	mov	rsi, prompt		; prompt for filename
	mov	rdx, promptlen
	syscall

	xor	rax, rax		; read syscall
	xor	rdi, rdi		; stdout
	mov	rsi, filename	; read into filename
	mov	rdx, 0xFF		; read up to 255 chars (max filename size in linux)
	syscall

	cmp	byte[filename], 'q'	;
	jne	cont		; if input is q:
	cmp	byte[filename+1], `\n`	; jmp to done
	je	done		;

	; get rid of newline
cont:	mov	byte[filename + rax - 1], 0

	mov	rax, 2		; open syscall
	mov	rdi, filename	;
	mov	rsi, 1026		; read and write flag, append flag
	syscall

	mov	[fd], rax		; save file descriptor

	mov	rax, 1		; write syscall
	mov	rdi, 1		; stdout
	mov	rsi, writemsg	; prompt for input
	mov	rdx, writelen	
	syscall

	xor	rax, rax		; read syscall
	xor	rdi, rdi		; stdin
	mov	rsi, writedata	; read into writedata
	mov	rdx, 0xFFF		; read up to 4kb
	syscall

	mov	rdx, rax		; write number of bytes read
	mov	rax, 1		; write syscall
	mov	rdi, [fd]		; fd of open file
	mov	rsi, writedata	; write data that was read
	syscall

	mov	rax, 1		; write syscall
	mov	rdi, 1		; stdout
	mov	rsi, fsize		; beginning of size notice
	mov	rdx, flen		; len of size notice
	syscall

	mov	rax, 5		; fstat syscall
	mov	rdi, [fd]		; fd of open file
	mov	rsi, statstruct	; stat struct
	syscall

	mov	rdi, [statstruct + 48]	; get length from struct
	call	printNum		; print length

	jmp	getfile

done:	mov	rax, 60
	xor	rdi, rdi
	syscall



