; this will also count for sigreturn, because how else can I make a program dedicated to it?
; I actually have an idea for something at least mildly cool
; make ctr+c not quit, but send a message

	global	_start
	section	.data

sigact:	dq	onsig	; handler
	dq	0x04000000	; SA_RESTORER
	dq	sigrest	; restore
times 16	dq	0	; sa_mask; dont block anything

msgstr:	db	"You sent SIGINT", 0xA
msglen:	equ	$ - msgstr

	section	.bss
end:	resb	1

	section	.text

onsig:	
	pop	r8

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, msgstr
	mov	rdx, msglen
	syscall

	push	r8

	ret

sigrest:	
	mov	rax, 15	; rt_sigreturn
	syscall	

_start:	
	mov	rax, 13	; I'm not superstitious but there are so many things that can fail here (rt_sigaction)
	mov	edi, 2	; SIGINT
	mov	rsi, sigact	; fucking pray its layed out properly
	mov	rdx, 0	; dont save old
	mov	r10, 8	; size of sigset_t
	syscall		; so many things can fail... pray a second time

loop:	
	jmp	loop

done:	mov	rax, 60
	xor	rdi, rdi
	syscall
