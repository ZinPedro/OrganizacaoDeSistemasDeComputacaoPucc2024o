TITLE 3
.MODEL SMALL
.STACK 100H

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

PulaLinha MACRO 
    PUSH_ALL            ; Salva todos os registradores antes de modificar
    MOV AH,02           ; Função de saída de caractere de `INT 21H`
    MOV DL,10           ; Código ASCII para salto de linha (newline)
    INT 21H             ; Interrupção para executar a função
    POP_ALL             ; Restaura os registradores para seu estado original
ENDM
.DATA
    VETOR DB 1,3,6,7,9
.CODE
    MAIN PROC
        MOV AX,@DATA
        MOV DS,AX
        MOV ES,AX

        CALL IMPRIMEVETOR
        PulaLinha
        CALL INSERE
        CALL IMPRIMEVETOR

        MOV AH,4Ch
        INT 21H
    MAIN ENDP



    INSERE PROC
        MOV AL,2

        MOV DL,AL
        CLD
        LEA SI,VETOR

        MOV CX,5

        INSERE_LOOP:
            LODSB

            CMP DL,AL
            JB COLOCA
        LOOP INSERE_LOOP

        COLOCA:
            DEC SI
            PUSH SI
            MOV CX,5
            SUB CX,SI

            STD

            LEA SI,VETOR+4
            
            MOV DI,SI
            INC DI

            REP MOVSB

        POP SI
        MOV AL,DL

        STOSB

        RET
    INSERE ENDP

    IMPRIMEVETOR PROC
        PUSH_ALL
        MOV AH,02
        LEA SI,VETOR
        MOV CX,5
        IMPRIME_VETOR:
            LODSB

            OR AL,AL
            JZ EXIT_VETOR

            MOV DL,AL
            OR DL,30H
            INT 21H 
        LOOP IMPRIME_VETOR
        EXIT_VETOR:
        POP_ALL
        RET
    IMPRIMEVETOR ENDP


END MAIN
