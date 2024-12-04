TITLE ex5
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

ESPACO MACRO 
    PUSH_ALL            ; Salva todos os registradores antes de modificar
    MOV AH,02           ; Função de saída de caractere de `INT 21H`
    MOV DL,' '          ; Código ASCII para ESPAÇO
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
    MATRIZ DW 11,2,3,4
           DW 5,6,7,8
           DW 11,12,10,11
           DW 9,13,2,15

.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX

        CALL IMPRIMEMATRIZ

        MOV CX,4
        PulaLinha
        XOR SI,SI
        MOV BX,24

        TROCA_MATRIZ:
            MOV AX,MATRIZ[0][SI]
            XCHG MATRIZ[BX][6],AX
            MOV MATRIZ[0][SI],AX

            ADD SI,2
            SUB BX,8
        LOOP TROCA_MATRIZ

        CALL IMPRIMEMATRIZ

        MOV AH,4Ch
        INT 21H
    MAIN ENDP

    IMPRIMEMATRIZ PROC
        PUSH_ALL
        XOR BX,BX
        XOR SI,SI

        MOV CX,4

        IMPRIME_MATRIZ1:
            PUSH CX
            MOV CX,4
        
            IMPRIME_MATRIZ2:
                MOV AX,MATRIZ [BX][SI]
                CALL IMPRIMEDECIMAL
                ESPACO
                ADD SI,2
            LOOP IMPRIME_MATRIZ2

            PulaLinha
            POP CX
            XOR SI,SI
            ADD BX,8
            LOOP IMPRIME_MATRIZ1


        POP_ALL
        RET
    IMPRIMEMATRIZ ENDP

    IMPRIMEDECIMAL PROC
        PUSH_ALL
        MOV BL,10
        XOR CX,CX

        VERIFICA_DECIMAL:
            XOR DX,DX
            DIV BL

            MOV DL,AH
            PUSH DX
            XOR AH,AH

            INC CX

            OR AL,AL
            JZ EXIT_VERIFICA
        JMP VERIFICA_DECIMAL
        EXIT_VERIFICA:
        MOV AH,02
        IMPRIME_DECIMAL:
            POP DX 
            OR DL,30H
            INT 21H
        LOOP IMPRIME_DECIMAL

        POP_ALL
        RET
    IMPRIMEDECIMAL ENDP

END MAIN