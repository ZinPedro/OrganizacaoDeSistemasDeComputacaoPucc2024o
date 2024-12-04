TITLE 2
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
.DATA
    VETORSTRING DB 'HELLO WORLD 2.0$'
.CODE
    MAIN PROC
        MOV AX,@DATA
        MOV DS,AX

        CALL PROCURA


        XOR AX,AX
        MOV AL,DL
        CALL IMPRIMEDECIMAL

        MOV AL,DH
        CALL IMPRIMEDECIMAL

        MOV AH,4Ch
        INT 21H
    MAIN ENDP

    PROCURA PROC
        PUSH AX
        CLD
        LEA SI,VETORSTRING
        XOR DX,DX

        PROCURA_LOOP:
            LODSB
            CMP AL,'$'
            JE EXIT_LOOP
            CMP AL,30H
            JB NNUMERO
            CMP AL,39H
            JA NNUMERO
            INC DL
            NNUMERO:
            CMP AL,41H
            JB NLETRA_MAIUSCULA
            CMP AL,5AH
            JA NLETRA_MAIUSCULA
            INC DH
            NLETRA_MAIUSCULA:
            CMP AL,61H
            JB NLETRA_MINUSCULA
            CMP AL,7AH
            JA NLETRA_MINUSCULA
            INC DH
            NLETRA_MINUSCULA:
            JMP PROCURA_LOOP

            EXIT_LOOP:
            POP AX
            RET
    PROCURA ENDP

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
