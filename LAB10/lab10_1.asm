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

.DATA 
MATRIZ  DB 1,2,3,4
        DB 4,3,2,1
        DB 5,6,7,8
        DB 8,7,6,5
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX


        CALL IMPRIME

        MOV AH,4Ch
        INT 21H
    MAIN ENDP

    IMPRIME PROC
        PUSH AX
        PUSH BX
        PUSH DX
        PUSH CX

        MOV AH,2
        MOV CX,4

        FOR:
            XOR SI,SI
            PUSH CX
            MOV CX,4
            FOR2:
                MOV DL,MATRIZ[BX][SI]
                OR DL,30H
                INT 21H 

                INC SI
                ESPAÇO
                LOOP FOR2
            ;
            PulaLinha
            ADD BX,4
            CMP BX,16
            JL  FOR

        POP CX
        POP DX
        POP BX
        POP AX
        RET

    IMPRIME ENDP
END MAIN