

_editor:
	cli
	xor ax, ax 
	xor bx, bx
	xor cx, cx
	xor dx, dx
	mov es, ax
	mov dx, ax

	call _mudatexto1
	call _read_log
	call _print_texto
	
	call _mudatexto1
	call _write_log
	call _print_texto
	
	call _fim


_read_log:

	mov ah, 24h
	mov al, 2h
	mov dl, 80h
	;int 13h

	mov ax,texto	;0x7E0<<1 + 0 = 0x7E00
        mov es,ax
        xor bx,bx		;Zerando o offset

	mov ah, 21h
	mov al, 1h  ;porção de setores ocupados pelo kernel.asm
        mov ch, 0h   ;track 0
        mov cl, 3h   ;setor 3
        mov dh, 1h   ;head 0
        mov dl, 0h   ;drive 0
        int 13h

	mov si, marreco
	cmp ah, 0
	je .fim
		mov si,tigre
	.fim
	ret

_write_log:

	mov ah, 24h
	mov al, 1h
	mov dl, 80h
	int 13h

	mov ax,texto	;0x7E0<<1 + 0 = 0x7E00
        mov es,ax
        xor bx,bx		;Zerando o offset

	mov ah, 22H
	mov al, 1h  ;porção de setores ocupados pelo kernel.asm
        mov ch, 0   ;track 0
        mov cl, 3   ;setor 3
        mov dh, 1   ;head 0
        mov dl, 0H   ;drive 0
        int 13h

	mov si, marreco
	cmp ah, 0
	je .fim
		mov si, tigre
	.fim
	ret
	
_mudatexto1:
	mov di,texto
	mov al, 'a'
	stosb
	mov al, 'a'
	stosb
	mov al, 'a'
	stosb
	mov al, 0
	stosb
	ret

_mudatexto2:
	mov di,texto
	mov al, 'z'
	stosb
	mov al, 'z'
	stosb
	mov al, 'z'
	stosb
	mov al, 0
	stosb
	ret


_write_texto:            ; escreve buffer do texto

	xor ax, ax
	mov es, ax       ; ES <- 0

	mov cx, 1h       ; cylinder 0, sector 1
	mov dx, 0180h    ; DH = 0 (head), drive = 80h (0th hard disk)	
	mov bx, 0x8000    ; segment offset of the buffer
	mov ax, 0301h 	 ; AH = 03 (disk write), AL = 01 (number of sectors to write)
	int 13h
	jc _write_texto
	ret

_read_texto:         

	xor ax, ax	
	mov es, ax    ; ES <- 0

	mov cx, 1     ; cylinder 0, sector 1
	mov dx, 0180h ; DH = 0 (head), drive = 80h (0th hard disk)
	mov bx, 0x8000 ; segment offset of the buffer
	mov ax, 0201h ; AH = 02 (disk read), AL = 01 (number of sectors to read)
	int 13h
	ret


_readpar:
	mov ah, 08h
	mov DL, 40h
	int 13h
	
	jc .fim	
	
	mov si, tigre
	
	.fim:

	mov al, ch
	add al, 48
	call _putchar
	call _quebralinha

	mov al, cl
	add ax, 48
	call _putchar
	call _quebralinha

	mov al, dl
	add ax, 48
	call _putchar
	call _quebralinha
		ret

_print_texto:
	call _quebralinha
	mov bl, 0fh
	.loop:
		lodsb
		cmp al, 0
		jne .inner
		ret
		.inner:
			call _putchar
			jmp .loop

