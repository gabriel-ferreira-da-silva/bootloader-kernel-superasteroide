questao1 db "asm1", 0
questao2 db "asm2", 0
questao3 db "asm3", 0
questao4 db "asm4", 0
questaox db "asmx", 0

editor db "editor", 0

jogo db "jogo", 0


_cmp_asm1:
	mov si, line
	mov di, questao1
	call _strcmp
	jne .fim
	call _questao1
	.fim
	ret

_cmp_asm2:
	mov si, line
	mov di, questao2
	call _strcmp
	jne .fim
	call _questao2
	.fim
	ret

_cmp_asm3:
	mov si, line
	mov di, questao3
	call _strcmp
	jne .fim
	call _questao3
	.fim
	ret

_cmp_asm4:
	mov si, line
	mov di, questao4
	call _strcmp
	jne .fim
	call _questao4
	mov si, questao4
	.fim
	ret
	ret

_cmp_asmx:
	mov si, line
	mov di, questaox
	call _strcmp
	jne .fim
	call _questaox
	.fim
	ret


_cmp_editor:
	mov si, line
	mov di, editor
	call _strcmp
	jne .fim
	call _editor
	.fim
	ret

_cmp_jogo:
	mov si, line
	mov di, jogo
	call _strcmp
	jne .fim
	call _jogo
	.fim
	ret


