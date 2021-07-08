; obj will be Java equivilant of the following:
;
; class Cube{
;     
;     public int width, length, height;
;     
;     public Rect(int width, int length, int height){
;         this.width = width;
;         this.length = length;
;         this.height = height;
;     }
;     
;     public long getVolume(){
;         return this.width * this.length * this.height;
;     }
;
; }
;
; plans:
;
; start address
; 3 doublewords = width, length, height
;
; thats it lol
; methods will be static and take in pointer to rect
;
	section	.data

PROT_READ:	equ	0x1
PROT_WRITE:	equ	0x2

MAP_PRIV:	equ	0x02
MAP_ANON:	equ	0x20

	section	.bss

rectArr:	resq	0xFF	; reserve 255 pointers (I could use linked lists or extend program break but im lazy)

	section	.text
	global	_start

; Rect(width, length, height)
; returns pointer to rect
constrctr:	
	; dont be an idiot and forget to save registers before you fuck them all up
	; and then spend 20 minutes wondering what you did wrong and why the wrong values
	; happen to look look like mmap flags
	push	r9
	push	r8
	push	r10
	push	rdx
	push	rsi
	push	rdi

	; allocate memory
	mov	rax, 0x9	; mmap syscall code
	mov	rdi, 0	; let mmap decide address
	mov	rsi, 12	; 3 x 4 bytes
	mov	rdx, 0x3	; read and write
	mov	r10, 0x22	; anon private
	mov	r8, -1	; ignore fd
	mov	r9, 0	; no offset
	syscall

	; also remember to pop the second time instead of pushing twice
	; thats another 30 minutes
	pop	rdi
	pop	rsi
	pop	rdx
	pop	r10
	pop	r8
	pop	r9

	mov	[rax], rdi
	mov	[rax+4], rsi
	mov	[rax+8], rdx

	ret

; getVolume(rect*)
; return value will just be 64 bit, allowing loss
; we could do a 128 bit one in xmm0, but that cant be
; done in java
getVolume:	
	push	rdx

	xor	rdx, rdx
	xor	rax, rax

	mov	eax, DWORD[rdi]
	mov	ebx, DWORD[rdi+4]

	mul	ebx

	; if result was 64 bit, left half will be in edx - moving this to rdx
	shl	rdx, 32
	add	rax, rdx

	mov	ebx, DWORD[rdi+8]

	mul	rbx
	pop	rbx

	ret

_start:	
	; create rect with lwh of 10, 12, 14
	mov	rdi, 10
	mov	rsi, 12
	mov	rdx, 14

	; fucking pray
	call	constrctr


	; try to make a bunch to confirm dynamic memory allocation
	xor	rbx, rbx

LOOP:	mov	rdi, rbx
	mov	rsi, rbx
	mov	rdx, rbx

	call	constrctr
	mov	[rbx+rectArr], rax

	mov	rdi, rax
	call	getVolume

	inc	rbx
	cmp	rbx, 69
	jl	LOOP

	; check values with gdb because I am much too lazy to make another atoi function

	; exit
EXIT:	mov	rax, 60
	mov	rdi, 0
	syscall
