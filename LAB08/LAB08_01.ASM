TITLE ENTRADA DE_BINARIOS
.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Digite o numero binario (apenas 0s e 1s) : $'
    MSG2 DB 'O numero digitado foi: $'
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX

        MOV AH,9
        LEA DX,MSG1
        INT 21H

        MOV AH,01
        OR CL,16


        WHILE_:
            INT 21H

            TEST AL,13
            JZ EXIT_WHILE
            AND AL,01H

            OR BL,AL
            ROL BX,1
            LOOP WHILE_
        ;
        EXIT_WHILE:
            MOV AH,09
            LEA DX,MSG2
            INT 21H
            
            MOV AH,02
            MOV CX,16
        IMPRIME:
            TEST BX,01
            JZ ZERO
            MOV DL,31H
            JMP SALTO
            ZERO:
            MOV DL,30H
            SALTO:
            INT 21H
            ROR BX,1
            LOOP IMPRIME
        ;
        MOV AH,4Ch
        INT 21H
        MAIN ENDP
            END MAIN



