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

loop:	cmp	byte[rdi + rcx], 0
	je	end
	
	mul	rbx

	mov	dl, byte[rdi + rcx]	; it would be better do just do inc rdi and not use rcx
	sub	rdx, '0'		; but that wouldnt preserve args
	add	rax, rdx

	inc	rcx
	jmp	loop

end:	pop	rdx
	pop	rbx
	pop	rcx
	ret
