; novembro de 2021 - semestre 2021.1
; materia - infraestrutura de software  
;
; Aluno - gabriel ferreira da silva
; Login - gfs4
; Projeto - bootloader
;
;
; esse arquivo foi compilado com um arquivo 
; makefile, e o comando:
;	$ make 
;
;
; altamente recomendável ler o arquivo README.pdf
; para compreender as funções do bootloader
;
; esse bootloader chama as funções:
;      # asm1
;      # asm2
;      # asm3
;      # asm4
;      # asmx
;      # jogo


org 0x7e00
jmp 0x0000:_start

%include "callfunc.asm"    ; responsável por testar as entradas da linha
%include "keyboardf.asm"   ; funções de leitura e entrada do teclado e operar strings

%include "questao1.asm"    ; programas das questões da lista ASM 
%include "questao2.asm"
%include "questao3.asm"
%include "questao4.asm"
%include "questao_extra.asm"

%include "editor.asm"	   ; programa do editor de texto

%include "data.asm"         ; alguns dados necessariospara o jogo
%include "graphic.asm"     ; funcoes de grafico para o jogo
%include "son.asm"
%include "jogo.asm"        ; programa do jogos





data:
	line times 100 db 0   ; espaço da memoria que uso para ler os comandos 

	texto times 512 db 0
	texto2 times 512 db 0

	marreco times 11 db 0
	tigre times 11 db 0


_start:               ; limpa a tela e seta o video mode
	xor ax, ax	
	xor bx, bx
	xor cx, cx
	xor dx, dx	
	mov bx, 15
	mov ds, ax    
	mov es, ax

	call _clear

	mov ah, 00h
        mov al, 10h
        int 10h

	mov si, texto_inicial
	call _print_line

_set:
	xor ax, ax	
	xor bx, bx
	xor cx, cx
	xor dx, dx	
	mov bx, 15
	mov ds, ax    
	mov es, ax   

	mov al, '#'
	call _putchar
	mov al, ' '
	call _putchar
	
	mov di, line

_wait:                   ; esse loop lê teclado 
	call _getchar
	call _putchar
	cmp al, 13
	je _funcs       ; le o teclado ao ser pressionado o enter e pula para _funcs, onde a funçao  é checada
	stosb	
	jmp _wait

_funcs:                 ; aqui line é testada e comparada com o nome das funções
	mov al,0
	stosb

	call _cmp_asm1 	; essas cinco funçoes são os programas da primeira lista de assembly
	call _cmp_asm2
	call _cmp_asm3
	call _cmp_asm4
	call _cmp_asmx
	
	call _cmp_editor ; programa do editor
	
	call _cmp_jogo  ; programa do jogo

	call _quebralinha

	jmp  _set



jmp $
