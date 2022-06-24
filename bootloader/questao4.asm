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


_questao4:

	mov ah, 00h
        mov al, 10h
        int 10h
	mov dl, 0 

	
	mov ax, 0
	push ax


_set4:
	cmp al, 'x'
	je _gofim
	xor ax, ax	
	xor bx, bx
	xor cx, cx

	mov si, 0
	mov di, si
	mov bx, 15


_wait4:
	call _getchar4
	call _putchar4
	cmp al, 13
	je _printa4
	jmp _wait4


_printa4:
	call _quebralinha4
	call _stoi4         ; coloca numero digitado em ax
	jmp _atualiza4
	
	_continua4:
	
	
	jmp  _set4

_atualiza4:
	pop bx    ; pega contador
	inc bx	  ; incrementa o contador
	push ax   ; coloca novo elemento
	push bx   ; recoloca contador na pilha

	cmp bx, 4
	je _calcula4
	jmp _continua4


_calcula4:

	pop bx  		;  coloca contador em bx
	pop ax  		; coloca elemento4 em ax w
	pop bx 			; coloca elemento3 em bx z 
	pop cx 			; coloca elemento2 em cx y
	pop dx			; coloca elemento1 em dx x

	
	add dx, cx              ; soma x e x, stora em dx
	add dx, bx		; soma (x+y) e z  stora em dx
	sub dx, ax   		; subtrai (x+y+z) e w stora em dx

	push dx                 ; coloca numerador na pilha

	add dx, ax
	sub dx, bx              ; retorna a valores (x+y)
	
	add dx, ax              ; soma (x+y) e w em dx
	sub dx, bx	        ; subtrai (x+y+w) e z e stora em dx

	pop ax 		        ; coloca numerador em ax
			        ; dx é o denominador

	mov cx, dx
	mov dx, 0
	div cx

	mov bx, 0
	push bx 		; zera contador

	mov di, 0
	mov si, 0
	
	
	push ax			; coloca resultado no topo
	push dx                 ; coloca resto na pilha
	
	call _axtostring4        ; converte resto

	mov si, bx	
	pop ax			; tira resultado da pilha
	call _axtostring4	; converte resultado

	pop ax			; tira resultado da pilha
	call _axparity4		; coloca paridade de resultado na str

	call _printstring4
	call _quebralinha4
	mov al, 'x'
	jmp _set4

_axparity4:
	mov cx, 2
	mov dx, 0
	div cx

	cmp dx, 0
	je _ehpar
	jmp _ehimpar
	_continuap4:	
		ret

_ehimpar:
	mov al, 'i'
	stosb
	mov al, 'm'
	stosb
	mov al, 'p'
	stosb
	mov al, 'a'
	stosb
	mov al, 'r'
	stosb
	jmp _continuap4


_ehpar:
	mov al, 'p'
	stosb
	mov al, 'a'
	stosb
	mov al, 'r'
	stosb
	jmp _continuap4


_axtostring4:
	xor cx, cx
	_loops4:
		cmp al, 0
		je _endloops4
		xor dx, dx

		mov bx, 10
		div bx
		xchg ax, dx
		add ax, 48
		stosb
	
		xchg ax, dx
		jmp _loops4
	

	_endloops4:
		mov al, ' '
		stosb
		call _reverse4
		mov al, ' '
		stosb
		ret


_printstring4:
	mov al, 0
	stosb
	mov bl, 15
	_loop24:
		lodsb
		cmp al, 0
		je _endloop24
		call _putchar4
		jmp _loop24

	_endloop24:
		ret


_getchar4:
 	mov ah, 00h
	int 16h
	stosb
	ret

_putchar4:
	mov ah, 0x0e
	int 10h
	ret

_quebralinha4:
	mov al, 0x0a
	call _putchar4
	mov al, 0x0d
	call _putchar4
	ret


_stoi4:
	_setloop4:
		xor cx, cx
		xor ax, ax
		xor si, si
	
	_loop14:
		push ax
		lodsb
		mov cl, al
		pop ax
		
		dec di
		cmp di, 0
		je _endloop14

		sub cl, 48
		mov bx, 10
		mul bx
		add ax, cx	
		jmp _loop14
		
	_endloop14:
		ret


_reverse4:
	xor cx, cx
	_loopr4:
		lodsb
		cmp al, ' '
		je _endloopr4
		inc cl
		push ax
		jmp _loopr4
	_endloopr4:
		mov bx, cx
	_loopr24:
		cmp cl, 0
		je _endloopr24
		dec cl
		pop ax
		stosb
		jmp _loopr24
	_endloopr24:
		ret

_gofim:
	call _fim

	
	
