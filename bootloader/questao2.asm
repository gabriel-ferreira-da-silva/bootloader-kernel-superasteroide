; aluno - gabriel ferreira da silva
; login - gfs4
; lista ASM
;
;
; esse arquivo foi compilado com os comandos
;	nasm -f bin questao.asm -o questao.bin  
; 	qemu-system-i386 questao.bin
;
; inputs são lidos com o ENTER
; comentarios acompanham  algumas linhas


_questao2:
	mov ah, 00h
        mov al, 01h
        int 10h
_set2:
	xor cx, cx
	xor si, si
	mov di, si
	mov al, ''
	jmp _wait2

_wait2:
	call _getchar2
	call _putchar2
	cmp al, 13
	je _invert2
	cmp al, 0x08
	je _delchar2
	jmp _wait2

_getchar2:
 	mov ah, 00h
	int 16h
	stosb
	inc cx
	ret

_putchar2:
	mov ah, 0x0e
	int 10h
	ret

_delchar2:

	mov al,''
	call _putchar2
	mov al, 0x08
	call _putchar2
	inc di
	stosb
	dec cx
	jmp _wait2

_invert2:
	;xchg di, si
	mov si, cx
	call _quebralinha2
	.print:
		dec cx
		lodsb
		dec si
		dec si

		call _putchar2
		cmp si, -1
		jne .print
		call _quebralinha2
		call _fim

_quebralinha2:
	mov al, 0x0a
	call _putchar2
	mov al, 0x0d
	call _putchar2
	ret


