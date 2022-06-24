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


frase db 'malu e uma otima monitora', 0

_questaox:


	mov ah, 00h
        mov al, 10h
        int 10h

_set5:
	xor ax, ax	
	xor bx, bx
	xor cx, cx
	xor dx, dx
	mov dl, 0
	mov si, 0
	mov di, si
		
	mov bx, 15

_wait5:
	call _getchar5
	call _putchar5
	cmp al, 13
	je _printa5
	jmp _wait5

_printa5:
	call _quebralinha5
	call _stoi5
	mov bl, al
	call _printa_frase5
	call _quebralinha5

	jmp  _fim


_getchar5:
 	mov ah, 00h
	int 16h
	stosb
	ret

_putchar5:
	mov ah, 0x0e
	int 10h
	ret

_quebralinha5:
	mov al, 0x0a
	call _putchar5
	mov al, 0x0d
	call _putchar5
	ret


_stoi5:
	_setloop5:
		xor cx, cx
		xor ax, ax
		xor si, si
	
	_loop15:
		push ax
		lodsb
		mov cl, al
		pop ax
		
		dec di
		cmp di, 0
		je _endloop5

		sub cl, 48
		mov bx, 10
		mul bx
		add ax, cx		
		jmp _loop15
		

	_endloop5:
		ret



_printa_frase5:
	mov si, frase
	_repete5:
		lodsb
		cmp al, 0
		je _done
		call _putchar5
		jmp _repete5
		_done:
			ret





