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

; this fucks up a lot of registers
; printNum(int num)
printNum:	
	mov	rax, rdi		; we will need it in rAX for division
	mov	rbx, 10		; hardcoding base 10
	xor	rcx, rcx		

pnloop:	xor	rdx, rdx		; without this you get a bug which hurts
	div	rbx		; divide by ten
	
	add	dl, '0'		; convert to ascii char
	mov	[rcx + strbuffer], dl	; store and increment loop
	inc	rcx

	cmp	rax, 0		; if number is zero, we have hit the end
	jg	pnloop

	xor	rdx, rdx
	mov	r8, rcx		; store length of string as 1 + chars (for newline)
	inc	r8		
	mov	byte[rcx + strbuffer], 0xA ; assume mewline as end char

	; str is currently backwards, so we need to reverse it
pnloop2:	dec	rcx
	
	mov	al, [rcx + strbuffer]
	mov	bl, [rdx + strbuffer]

	; swap chars
	;mov	sil, al
	;mov	al, bl
	;mov	bl, sil
	; xor swaps used to be used, I believe they are slower on modern cpus
	; xor	al, bl
	; xor	bl, al
	; xor	al, bl

	mov	[rcx + strbuffer], bl
	mov	[rdx + strbuffer], al

	inc	rdx
	
	cmp	rcx, rdx
	jg	pnloop2

	mov	rax, 1
	mov	rdi, 1
	mov	rsi, strbuffer
	mov	rdx, r8
	syscall

	ret
