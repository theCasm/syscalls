; If you don't know how this stuff works, this is compiled into
; binary format. In binary format, the code is turned into bytes,
; and thats it. Nothing fancy, just code that the processor can understand.
; In order for linux to run a file, it was ELF format, which has additional information
; for it. Because we are running this ourselves, we just use nasm -f bin -o file.bin file.asm
	[bits 64]
multby69:	; just for decoration, we are calling the address so this does nothing	
	mov	rax, rdi
	mov	rdi, 69
	mul	rdi
	ret
