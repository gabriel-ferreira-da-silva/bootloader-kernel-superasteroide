
%define VEL_SHOOT 8       ; algumas variaveis do jogo
%define VEL_NAVE 7


%define DOWN_KEY  's'
%define UP_KEY    'w'
%define RIGHT_KEY 'd'
%define LEFT_KEY  'a'

%define CX_INICIAL 20
%define DX_INICIAL 50

%define SHOOT_KEY 'k'

; tamanho da tela 100 x 100


_jogo:       ; posições, vida e textos iniciais são colocados aqui
	
	call _clear
	
	mov si, vida
	call _print_line		

	mov si, texto_apoio
	call _print_line

	mov ah, 00h
	mov al, 08h
	int 10h

	call _print_barra_vida

	mov di, vida_dx
	mov ax, 150
	stosw
	

	mov di, son_time     ; carrega os vbalores do tempo do son
	mov ax, 0
	stosw
	stosw

	xor ax, ax
        mov ds, ax
        mov es, ax
        mov dx, DX_INICIAL            ;linha
        mov cx, CX_INICIAL	      ;coluna
	mov si, 0
	mov di, 0

	mov di, life            		; coloca a vida inicial
	mov ax, 3
	stosw

	xor ax,ax
	mov di, ax

	mov di, shoot_life
	stosw
	mov di, nave_pos
	mov ax, dx
	stosw
	mov ax, cx
	stosw
	mov di, shoot_pos
	mov ax, dx
	stosw
	mov ax, cx
	stosw

	mov dx, 80
	mov cx, 200	

	mov di, cometa_pos
	mov ax, dx
	stosw
	mov ax, cx
	stosw
	
	mov si, cometa
	call _print_sprite
	
	mov ax, 0h

	mov dx, DX_INICIAL
	mov cx, CX_INICIAL	

	mov si, nave
	call _print_sprite

	mov si, base
	mov dx, 0
	mov cx, 0
	call _print_sprite



_wait_key:                   ; nesse loop o teclado lê


	call _atualiza_son

	mov si, life         ; vê se a vida da nave acabou	
	lodsw
	cmp ax, 0
	je _pula_fim

	call _flush
	call _getchar

	cmp al, DOWN_KEY  ;  as funçoes leem o teclado atualizam a posicao da nave e do tiro
	je _move_down

	cmp al, UP_KEY
	je _move_up

	cmp al, LEFT_KEY
	je _move_left

	cmp al, RIGHT_KEY
	je _move_right

	cmp al, SHOOT_KEY
	je _shoot

	cmp al, 13
	je _pula_fim

	_next:
		call _print_all
		call _sleep
			
	mov si, life
	lodsw
	cmp ax, 0
	je _pula_fim

	jmp _wait_key


_move_down:

	mov si, nave_pos          ; carrefa posicoes da nave em dx, cx 
	lodsw
	mov dx, ax
	lodsw
	mov cx, ax

	mov si, null            ; apaga a posicao atual
	call _print_sprite

	mov ax, VEL_NAVE         ; move a nave para uma nova posicao
	add dx, ax	

	call _ajustar_tela       ; checa se a posicao da nave esta dentro da resolução

	mov di, nave_pos          ; coloca nova posicao em nave_pos
	mov ax, dx
	stosw

	mov ax, cx
	stosw
	
	jmp _next

_move_up:

	mov si, nave_pos
	lodsw
	mov dx, ax
	lodsw
	mov cx, ax

	mov si, null
	call _print_sprite

	mov ax, VEL_NAVE
	sub dx, ax

	call _ajustar_tela

	mov di, nave_pos
	mov ax, dx
	stosw

	mov ax, cx
	stosw
	
	jmp _next

_move_right:
	
	mov si, nave_pos
	lodsw
	mov dx, ax
	lodsw
	mov cx, ax

	mov si, null
	call _print_sprite

	mov ax, 5h
	add cx, ax	

	call _ajustar_tela

	mov di, nave_pos
	mov ax, dx
	stosw

	mov ax, cx
	stosw

	jmp _next
	
_move_left:

	mov si, nave_pos
	lodsw
	mov dx, ax
	lodsw
	mov cx, ax

	mov si, null
	call _print_sprite

	mov ax, 5h
	sub cx, ax

	call _ajustar_tela

	cmp cx, 16
	jge .continua

	mov cx, 16

	.continua:

	mov di, nave_pos
	mov ax, dx
	stosw

	mov ax, cx
	stosw

	jmp _next


_shoot:
	;call _tone
	mov bx, 0
	mov si, shoot_life       ; carrega o tiro
	lodsw
	cmp ax, 0 		; tiro existe ? se sim saia dessa funcao, se nao crie o tiro
	jg .fim

	mov di, shoot_life       ; carrega "vida" do tiro
	mov ax, 100
	stosw

	mov si, nave_pos         ; posicao atual da nave
	lodsw
	mov dx, ax
	
	lodsw
	mov cx, ax	
	add cx, 16               ; carrega o tiro na frente da nave

	call _ajustar_tela

	mov di, shoot_pos    	; carrega tiro com as posicoes atuais da nave  em shoot_pos 
	mov ax, dx
	stosw
	mov ax, cx
	stosw	

	.fim:
		jmp _next

_pula_fim:                     ; tela  de game over e volta para o kernel
	

	call _stop_note

	mov si, nave_pos
	lodsw
	mov dx, ax
	lodsw
	mov cx, ax

	call _explode_nave


	xor ax, ax
        mov ds, ax
        mov es, ax
	mov bx, ax	
	mov cx, ax
	mov dx, ax
	mov si, ax
	mov di, ax        

	call _flush
	
	jmp _fim                          ; finaliza e retorna para o kernel

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

		;pop ax
		jmp _start









