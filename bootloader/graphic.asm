%define VEL_SHOOT 8       ; algumas variaveis do jogo
%define VEL_NAVE 7


%define NOTA_DANO 0a0h
%define NOTA_SHOOT 0feh	
%define NOTA_COMETA 0ffh


_print_all:                             ; printa todos os objetos do jogo em suas posicoes
					; alem de gerenciar e atualizar os parametros

	mov si, nave_pos		; printa nave
	lodsw
	mov dx, ax
	lodsw
	mov cx, ax

	mov si, nave
	call _print_sprite


	.print_cometa:                    ; printa cometa

		mov si, cometa_pos
		lodsw
		mov dx, ax
		lodsw 
		mov cx, ax

		mov si, null
		call _print_sprite

		mov di, cometa_pos
		mov ax, dx
		stosw
		dec cx
		mov ax, cx
		stosw

		.cmp_shoot_cometa:                 ; checa se o tiro e o cometa colidiram
			
			mov si, shoot_pos
			lodsw
			
			sub ax, dx
			call _modulo_ax    ; modifica ax para obter seu modulo

			cmp ax, 10
			jg .continua_     ;-----------------------------------------------

			lodsw
			cmp ax, cx
			jg .reseta_cometa

			.continua_:


		cmp cx,10
		jg .continue

		.add_dano:                 ; se o meteoro bater na barra a vida e a barra de vida são diminuidas
		
			push ax                   ; som do cometa resetando
			mov di, nota              ; ponteiro com a nota ser tocada
			mov ax, NOTA_DANO              ; frequencia da nota
			stosw  
			mov di, son_time
			mov ax, 10                 ; tempo de duração da nota
			stosw
			pop ax

			mov si, life
			lodsw
			dec ax
			mov di, life
			stosw
			
			mov si, vida_dx      ; deleta parte da barra de vida
			lodsw
			push ax
			mov dx, ax
			mov cx, 4
			mov si,null
			call _print_sprite


			mov di, vida_dx     ; carrega nova posição da barra de volta em vida_dx
			pop ax			
			add ax, 16
			stosw			
			

	
		.reseta_cometa:                  ; reseta cometa para posicao inicial
						

			push ax                   ; som do cometa resetando
			mov si , nota
			lodsw
			cmp ax, NOTA_DANO
			je .ignore
			mov di, nota
			mov ax, NOTA_COMETA
			stosw
			mov di, son_time
			mov ax, 5
			stosw

			.ignore:
			pop ax


			mov si, shoot_pos      	;apaga tiro:	
			lodsw
			mov dx, ax
			lodsw
			mov cx, ax
			mov di, shoot_pos      	
			;mov ax, 0
			stosw
			stosw

			call _explode_cometa

			mov si, null		; apaga cometa
			call _print_sprite
			mov cx, 200            ; recoloca posicao incial em cx do cometa 
			mov di, cometa_pos
			
			push dx                ; da uma nova posição "aleatoria" para o cometa
			mov dx,0		; gerando um numero psudo-aleatorio com operações modulo
			pop ax
			add ax, 41
			push cx
			mov cx, 100
			div cx
			pop cx
			mov ax, dx
			stosw
			mov ax, cx
			stosw
			
			mov di, shoot_life     ; zera a vida do tiro pra que ele desaparecao
			mov ax, 0
			stosw
	
		.continue:

			mov si, cometa         ; printa varias vezes por motivos de: assembly
			call _print_sprite
			mov si, cometa
			call _print_sprite
			mov si, cometa
			call _print_sprite
	
			;call _print_cometa
		


	.print_shoot:    		; printa o tiro

		mov si, shoot_life
		lodsw
		cmp ax, 0         	; checa se há tiro para ser carregado	
		jng .apaga_tiro           ; se nao o tiro é apagado
					
		sub ax, VEL_SHOOT       ; decrementa a vida da bala e salva nova informacao
		mov di, shoot_life	
		stosw

		mov si, shoot_pos
		lodsw
		mov dx, ax
		lodsw
		mov cx, ax

		push cx
		push dx

		mov si, null		; limpa  a atual posicao do tiro
		call _print_sprite

		add cx, VEL_SHOOT	; faz o tiro andar uma posicao

		mov si, shoot           ; printa tiro atualizado
		call _print_sprite

		mov di, shoot_pos        ; guarda nova posicao em shoot_pos
		pop ax
		stosw
		pop ax
		add ax, VEL_SHOOT
		stosw


		push ax                   ; som do cometa resetando
		mov di, nota              ; ponteiro com a nota ser tocada
		mov ax, NOTA_SHOOT              ; frequencia da nota
		stosw  
		mov di, son_time
		mov ax, 5                 ; tempo de duração da nota
		stosw
		pop ax

		
		mov si, shoot_life
		lodsw
		cmp ax, 0		; ve se o tiro acabou e o limpa
		jg .fim

		.apaga_tiro:		
			mov si, shoot_pos      	
			lodsw
			mov dx, ax
			lodsw
			mov cx, ax

			mov si, shoot_num
			lodsw
			dec ax
			mov di, shoot_num
			stosw

			mov si, null
			call _print_sprite

	
	.fim:
		ret


_print_sprite:                   ; imprime um sprite (guardado em SI) na posição coluna=cx, linha= dx

	push dx
	push cx
	

	.loop:
		lodsb   
		cmp al,'0'
		je .fim

		cmp al,'.'	
		je .next_line

		.next_pixel:
			call _print_pixel
			inc cx
			jmp .loop	
		
		.next_line:	
			
			pop cx      		 ;reseta cx para o valor inicial, o começo de uma nova linha
			push cx

			inc dx
			lodsb
			jmp .next_pixel
		
		.fim:
			pop cx
			pop dx
			;call _sleep
			;popa			
			ret 


_print_pixel:      	  			; printa um pixel na posição coluna = dx , linha = dx
        mov ah, 0ch
        mov bh, 0
        int 10h
        ret


_ajustar_tela: 			           ; ajusta a posição dos objetos guardada nos registradores (cx, dx) para
				           ; resolução da tela

	.ajusta_cx:
		cmp cx, 100
		jb .ajusta_dx
	
	.set_cx_600:
		mov cx, 100


	.ajusta_dx:
		cmp dx, 100
		jb .fim 
	
	.set_dx_300:
		mov dx, 100


	.fim:
		ret

_modulo_ax:                        ; retorna o valor absoluto de ax  , (  |ax|   )
		
	cmp ax, 0
	jge .fim

	push bx
	push dx
	mov bx,-1
	imul bx
	pop dx
	pop bx

	.fim:
		ret



 _print_barra_vida:             ; imprime a barra de vida

	mov dx, 150
	mov cx, 2

	.loop:
		mov si, barra_vida
		call _print_sprite
		inc dx
		cmp dx, 170
		jge  .fim
		jmp .loop
	.fim:
		ret 



_sleep:                                         ; dorme por alguns nanosegundos
	push cx
	push dx

	mov dx, 0
	.loop:
		inc dx
		mov cx, 0
			.time:
				inc cx
				cmp cx, 100
				jne .time
	
		cmp dx, 100
		jne .loop
	pop dx
	pop cx
	ret

_explode_cometa:
	push ax
	mov ax, 20

	.loop:
		dec ax
		push ax
			mov si, cometa_ex          ; ess é o sprite explodindo
			call _print_sprite	   ; ele é printado varias vezes
		pop ax		
		cmp ax, 0
		jne .loop

	.fim
		pop ax
		ret


_print_cometa:
	push ax
	mov ax, 10

	.loop:
		dec ax
		push ax
			mov si, cometa          ; ess é o sprite explodindo
			call _print_sprite	   ; ele é printado varias vezes
		pop ax		
		cmp ax, 0
		jne .loop

	.fim
		pop ax
		ret


_explode_nave:
	push ax
	mov ax, 500

	.loop:
		dec ax
		push ax
			mov si, cometa_ex          ; ess é o sprite explodindo
			call _print_sprite	   ; ele é printado varias vezes
		pop ax		
		cmp ax, 0
		jne .loop

	.fim
		pop ax
		ret










push ax            ; adicino som ao dano
			push cx
			push dx

			mov di, son_time
			mov ax, 100	
			stosw
			mov ax, 700	
			stosw

			mov di, nota
			mov ax, 0f1h
			stosw	

			pop dx
			pop cx
			pop ax







;****************************************************************
; funções que eu queria mas não consigue implementar


os_play_sound:

    mov     al, 182
    out     0x43, al
    mov     ax, cx

    out     0x42, al
    mov     al, ah
    out     0x42, al
    in      al, 0x61

    or      al, 00000011b
    out     0x61, al

    .pause1:
        mov cx, 65535

    .pause2:
        dec cx
        jne .pause2
        dec bx
        jne .pause1

        in  al, 0x61
        and al, 11111100b
        out 0x61, al

        ret

_tone:
    PUSHA               ; Prolog: Preserve all registers
    MOV BX, AX          ; 1) Preserve the note value by storing it in BX.
    MOV AL, 182         ; 2) Set up the write to the control word register.
    OUT 43h, AL         ; 2) Perform the write.
    MOV AX, BX          ; 2) Pull back the frequency from BX.
    OUT 42h, AL         ; 2) Send lower byte of the frequency.
    MOV AL, AH          ; 2) Load higher byte of the frequency.
    OUT 42h, AL         ; 2) Send the higher byte.
    IN AL, 61h          ; 3) Read the current keyboard controller status.
    OR AL, 03h          ; 3) Turn on 0 and 1 bit, enabling the PC speaker gate and the data transfer.
    OUT 61h, AL         ; 3) Save the new keyboard controller status.
    MOV AH, 86h         ; 4) Load the BIOS WAIT, int15h function AH=86h.
    INT 15h             ; 4) Immidiately interrupt. The delay is already in CX:DX.
    IN AL, 61h          ; 5) Read the current keyboard controller status.
    AND AL, 0FCh        ; 5) Zero 0 and 1 bit, simply disabling the gate.
    OUT 61h, AL         ; 5) Write the new keyboard controller status.
    POPA                ; Epilog: Pop off all the registers pushed
    RET                 ; Epilog: Return.







