; I actually have an idea for something at least mildly cool
; make ctr+c not quit, but send a message

	global	_start
	section	.data

sigact:	dq	onsig	; handler
	dq	0	; no flags
	dq	0	; restore
times 16	dq	0	; sa_mask; dont block anything

oldact:	dq	0	; empty struct
	dq	0
	dq	0
times 16	dq	0

msgstr:	db	"You sent SIGINT", 0xA
msglen:	equ	$ - msgstr

	section	.text

onsig:	
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, msgstr
	mov	rdx, msglen
	;mov	r10, 8
	syscall

	ret

sigrest:	
	mov	rax, 15	; rt_sigreturn
	syscall	

_start:	
	mov	rax, 13	; I'm not superstitious but there are so many things that can fail here (rt_sigaction)
	mov	edi, 2	; SIGINT
	mov	rsi, sigact	; fucking pray its layed out properly
	mov	rdx, 0	; no save
	mov	r10d, 8	; size of sigset_t
	syscall		; so many things can fail... pray a second time

loop:	
	jmp	loop
done:	mov	rax, 60
	xor	rdi, rdi
	syscall
