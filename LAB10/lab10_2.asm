TITLE Iniciais Do Nome
.MODEL SMALL
.STACK 100H

ESPAÇO MACRO 
    PUSH AX
    MOV AH,02 
    MOV DL,32
    INT 21H 
    POP AX
ENDM   

PulaLinha MACRO 
    PUSH AX
    MOV AH,02 
    MOV DL,10
    INT 21H
    POP AX
ENDM

MENSAGEM MACRO
    PUSH AX
    PUSH DX
    PUSH BX

    MOV AH,09
    LEA DX,MSG1
    INT 21H

    MOV AX,BX
    MOV BL,4

    DIV BL

    MOV DL,AL
    MOV AH,02
    ADD DL,31H
    INT 21H

    MOV AH,09
    LEA DX,MSG2
    INT 21H

    MOV AH,02   
    MOV DX,SI
    ADD DL,31H
    INT 21H

    MOV AH,09
    LEA DX,MSG3
    INT 21H

    POP BX
    POP DX
    POP AX
ENDM

.DATA 
    MATRIZ DB 4 DUP(4 DUP(0)),'$'
    MSG1 DB 'Digite o numero da Matriz (linha: $'
    MSG2 DB ', coluna: $'
    MSG3 DB '):',10,13,'$'
    NPERM DB 'Este numero nao eh permitido!',10,13,'$'
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX

        CALL LER
        PulaLinha
        CALL IMPRIME
        CALL SOMA
        PulaLinha
        CALL IMPSOMA

        MOV AH,4Ch
        INT 21H
    MAIN ENDP

    LER PROC
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV CX,4
        MOV AH,01
        FORLER:
            XOR SI,SI
            PUSH CX
            MOV CX,4
            FORLER2:
                MENSAGEM
                INT 21H
                PulaLinha

                CMP AL,36H
                JA NPERMITIDO
                CMP AL,30H
                JB NPERMITIDO

                MOV MATRIZ[BX][SI],AL
                INC SI
                LOOP FORLER2
            ;
            POP CX
            ADD BX,4
            LOOP FORLER
            JMP LEREXIT
        ;
        NPERMITIDO:
            MOV AH,09
            LEA DX,NPERM
            INT 21H
            JMP FORLER2
        ;
        LEREXIT:
        POP DX
        POP CX
        POP BX
        POP AX
        RET
    LER ENDP

    IMPRIME PROC
        PUSH AX
        PUSH BX
        PUSH DX
        PUSH CX

        MOV AH,2
        MOV CX,4

        FORIMP:
            XOR SI,SI
            PUSH CX
            MOV CX,4
            FORIMP2:
                MOV DL,MATRIZ[BX][SI]
                OR DL,30H
                INT 21H 

                INC SI
                ESPAÇO
                LOOP FORIMP2
            ;
            PulaLinha
            POP CX
            ADD BX,4
            LOOP FORIMP

        POP CX
        POP DX
        POP BX
        POP AX
        RET

    IMPRIME ENDP

    SOMA PROC
        PUSH DX
        PUSH BX
        PUSH CX

        XOR AX,AX
        MOV CX,4
        FORSOMA:
            XOR SI,SI
            PUSH CX
            MOV CX,4
            FORSOMA2:
                XOR DX,DX
                MOV DL, MATRIZ[BX][SI]
                ADD AX,DX
                INC SI
                LOOP FORSOMA2
            ;
            POP CX
            ADD BX,4
            LOOP FORSOMA
    
        POP CX
        POP BX
        POP DX
        RET
    SOMA ENDP

    IMPSOMA PROC
        PUSH BX
        PUSH CX
        PUSH DX

        MOV BL,10
        PUSH AX;.
        SAIDADECIMAL:
            DIV BL
            AND AL,AL
            JZ EXIT

            MOV AL,AH
            XOR AH,AH
            INC CX
            JMP SAIDADECIMAL
        ;
        MOV CL,BH
        AND CX,CX
        JNZ SAIDADECIMAL2

        POP BX ;.
        MOV DL,BL
        OR DL,30H
        MOV AH,02
        INT 21H
        JMP PREEXIT

        SAIDADECIMAL2:
            DIV BL
            XOR DH,DH
            MOV DL,AL
            PUSH DX

            MOV AL,AH
            XOR AH,AH
        LOOP SAIDADECIMAL2
        MOV CL,BH

        SAIDADECIMAL3:
            MOV AH,02
            POP DX
            OR DL,30H
            INT 21H
        LOOP SAIDADECIMAL3

        POP AX;.
        JMP EXIT
        PREEXIT:
        MOV AX,BX

        EXIT:
        POP DX
        POP CX
        POP BX
        RET
    IMPSOMA ENDP
END MAIN