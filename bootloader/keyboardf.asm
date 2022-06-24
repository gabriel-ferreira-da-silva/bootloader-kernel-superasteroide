_getchar:
 	mov ah, 00h
	int 16h
	ret


_check_char:
 	mov ah, 01h
	int 16h
	ret

_flush:                ; apaga o buffer do teclado
 	mov ah, 05h
	int 16h
	ret

_putchar:
	mov ah, 0x0e
	int 10h
	ret

_quebralinha:          ; pula pra a proxima linha
	mov al, 0x0a
	call _putchar
	mov al, 0x0d
	call _putchar
	ret	

_clear:
        mov ah, 0
        mov al, 10h
        int 10h
        ret

_strcmp:                             ; compara duas lihas armazanadas em si e di
	.loop1:
		lodsb
		cmp byte[di], 0
		jne .continue
		cmp al, 0
		jne .done
		stc
		jmp .done
		
		.continue:
			cmp al, byte[di]
    			jne .done
			clc
    			inc di
    			jmp .loop1

		.done:
			ret



_print_line:             ; printa a linha armazenada em si

	.loop1:
		lodsb	
		cmp al, 0
		je .fim
		call _putchar
		jmp .loop1
	
	.fim:
		ret



_fim:                          ; finaliza e retorna para o kernel
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
		;call _clear
		;ret

		pop ax
		jmp _start



