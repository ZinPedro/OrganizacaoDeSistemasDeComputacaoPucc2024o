TITLE ex1
.MODEL SMALL
.STACK 100H

; MACROS para salvar e restaurar os registradores principais
PUSH_ALL MACRO
    PUSH AX             ; Salva o valor de AX na pilha
    PUSH BX             ; Salva o valor de BX na pilha
    PUSH CX             ; Salva o valor de CX na pilha
    PUSH DX             ; Salva o valor de DX na pilha
    PUSH SI             ; Salva o valor de SI na pilha
    PUSH DI             ; Salva o valor de DI na pilha
ENDM

POP_ALL MACRO
    POP DI              ; Restaura o valor de DI da pilha
    POP SI              ; Restaura o valor de SI da pilha
    POP DX              ; Restaura o valor de DX da pilha
    POP CX              ; Restaura o valor de CX da pilha
    POP BX              ; Restaura o valor de BX da pilha
    POP AX              ; Restaura o valor de AX da pilha
ENDM

; Macro para pular uma linha na tela
PulaLinha MACRO 
    PUSH_ALL            ; Salva todos os registradores antes de modificar
    MOV AH,02           ; Função de saída de caractere de `INT 21H`
    MOV DL,10           ; Código ASCII para salto de linha (newline)
    INT 21H             ; Interrupção para executar a função
    POP_ALL             ; Restaura os registradores para seu estado original
ENDM

; Macro para exibir uma mensagem
IMPRIMEMSG MACRO MSG
    PUSH_ALL            ; Salva todos os registradores
    MOV AH,09           ; Função de exibição de string de `INT 21H`
    LEA DX,MSG          ; Carrega o endereço da mensagem em DX
    INT 21H             ; Chama interrupção para exibir a string
    POP_ALL             ; Restaura os registradores
ENDM 

; Segmento de dados
.DATA
    VETOR DB 19,17,13,15,16,18,16,15

    MSG1 DB 'Existem $'   
    MSG2 DB ' numeros maiores que 15 no vetor!$' 
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX
        MOV ES,AX

        CLD 
        LEA DI,VETOR

        XOR DX,DX
        MOV CX,8

        COMPARA:
        LODSB 
        CMP AL,15
        JBE VOLTA
            INC DL
        VOLTA:
        LOOP COMPARA

        IMPRIMEMSG MSG1
        
        MOV AH,02
        OR DL,30H
        INT 21H 

        IMPRIMEMSG MSG2

        MOV AH,4Ch
        INT 21H

    MAIN ENDP

END MAIN    
