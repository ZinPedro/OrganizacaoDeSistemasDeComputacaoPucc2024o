TITLE Entrada de Numeros 
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
    VETOR1 DB 1,2,9,4,5,6,7
    VETOR2 DB 1,2,9,4,9,6,7

    MSG1 DB 'Os vetores tem $'
    MSG2 DB ' elementos iguais, sao eles: $'
.CODE
    MAIN PROC
        MOV AX,@DATA
        MOV DS,AX
        MOV ES,AX

        STD
        LEA SI,VETOR1+6
        LEA DI,VETOR2+6

        MOV CX,7    
        XOR AX,AX
        XOR DX,DX

        COMPARA:
            CMPSB 
            JNZ NIGUAL
                INC SI
                LODSB
                PUSH AX
                INC DX
            NIGUAL:
        LOOP COMPARA

        MOV AH,02
        MOV CX,DX
        IMPRIMEMSG MSG1
        OR DL,30H
        INT 21H
        IMPRIMEMSG MSG2

        IMPRIME_IGUAIS:
            POP DX
            OR DL,30H
            INT 21H

            MOV DL,','
            INT 21H 

            MOV DL,''
            INT 21H
        LOOP IMPRIME_IGUAIS

        MOV AH,4Ch
        INT 21H

    MAIN ENDP 
END MAIN