	section	.bss
strbuffer:	resb	0xFF

	section	.text


; atoi(char* str)
; str must be null terminated
atoi:	
	push	rcx
	push	rbx
	push	rdx
	
	xor	rax, rax
	xor	rdx, rdx
	xor	rcx, rcx
	
	mov	rbx, 10

atoiloop:	cmp	byte[rdi + rcx], 0
	je	atoiend
	
	mul	rbx

	mov	dl, byte[rdi + rcx]	; it would be better do just do inc rdi and not use rcx
	sub	rdx, '0'		; but that wouldnt preserve args
	add	rax, rdx

	inc	rcx
	jmp	atoiloop

atoiend:	pop	rdx
	pop	rbx
	pop	rcx
	ret


printNum:	
	mov	rax, rdi
	mov	rbx, 10
	xor	rcx, rcx

pnloop:	xor	rdx, rdx
	div	rbx
	
	add	dl, '0'
	mov	[rcx + strbuffer], dl
	inc	rcx

	cmp	rax, 0
	jg	pnloop

	xor	rdx, rdx
	mov	r8, rcx
	inc	r8
	mov	byte[rcx + strbuffer], 0xA

pnloop2:	dec	rcx
	
	mov	al, [rcx + strbuffer]
	mov	bl, [rdx + strbuffer]

	xor	al, bl
	xor	bl, al
	xor	al, bl

	mov	[rcx + strbuffer], al
	mov	[rdx + strbuffer], bl

	inc	rdx
	
	cmp	rcx, rdx
	jg	pnloop2

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, strbuffer
	mov	rdx, r8
	syscall

	ret
