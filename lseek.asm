	global	_start
	section	.data
filename:	db	"lseek.asm", 0

	section	.bss
input:	resb	0x4FF	; 1kb

	section	.text

_start:	
	mov	rax, 2
	mov	rdi, filename
	mov	rsi, 0	; readonly
	syscall
	
	mov	rdi, rax	; fd
	mov	rax, 8	; lseek syscall
	mov	rsi, 250	; offset=250
	syscall

	; I haven't accounted for errors in a single program and the paranoia is
	; making me actually going to be a good programmer for once
	cmp	rax, -1
	je	error

	mov	rax, 0
	mov	rsi, input
	mov	rdx, 0x4FF
	syscall

	mov	rax, 1
	mov	rdi, 1
	syscall

done:	mov	rax, 60
	mov	rdi, 0
	syscall

error:	
	; ha jokes on you it just exits. Also no error checking for file open, which is
	; debatably more important
	mov	rax, 60
	mov	rdi, -1
	syscall
