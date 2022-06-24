
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


_questao3:
	mov ah, 00h
        mov al, 01h
        int 10h
_set3:
	xor cx, cx
	xor dx, dx
	xor si, si
	mov di, si
	mov cx, 0
	mov ax, 0
	mov bx, 0
	mov al, ''
	jmp _wait3

_wait3:
	call _getchar3
	call _putchar3
	cmp al, 13
	je _check3
	_continue3:
	jmp _wait3

_getchar3:
 	mov ah, 00h
	int 16h
	stosb
	inc cx
	ret

_putchar3:
	mov ah, 0x0e
	int 10h
	ret

_quebralinha3:
	mov al, 0x0a
	call _putchar3
	mov al, 0x0d
	call _putchar3
	ret


_check3:	
	call _quebralinha3
	call _getchar3
	call _putchar3
	dec cx

	mov si, cx
	mov ax, 0	   
	lodsb		   ;carrega al com o caracter
	sub ax, 49	   ; converte caractere em inteiro
	
	mov bx, ax	   ; salva o inteiro que aponta o caractere desejado

	call _wait_return3

	call _quebralinha3
	mov si, bx
	lodsb
	call _putchar3
	call _quebralinha3
	call _fim

_wait_return3:
	mov ah, 00h
	int 16h
	ret
	cmp al, 13
	je .done
	jmp _wait_return3
	.done:
		ret

_fim3:
	.wait:
		call .getchar
		cmp al, 13
		je .fim
		jmp .wait

	.getchar:
	 	mov ah, 00h
		int 16h
		ret

	.fim:
		call _clear
		ret

