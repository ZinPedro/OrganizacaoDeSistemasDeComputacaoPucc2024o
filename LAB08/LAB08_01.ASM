TITLE ENTRADA DE_BINARIOS
.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Digite o numero binario (apenas 0s e 1s) : $'
    MSG2 DB 10,13,'O numero digitado foi: $'
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX

        MOV AH,9
        LEA DX,MSG1
        INT 21H

        MOV AH,01
        MOV CX,16


        WHILE_:
            INT 21H

            CMP AL,13
            JE EXIT_WHILE

            ROL BX,1
            AND AL,01H

            OR BL,AL
 
            LOOP WHILE_
        ;
        EXIT_WHILE:
            MOV AH,09
            LEA DX,MSG2
            INT 21H

            ROL BX,1
            
            MOV AH,02
            MOV CX,16
        IMPRIME:
            TEST BX,0001H
            JZ ZERO
            MOV DL,31H
            JMP SALTO
            ZERO:
            MOV DL,30H
            SALTO:
            INT 21H
            ROL BX,1
            LOOP IMPRIME
        ;
        MOV AH,4Ch
        INT 21H
        MAIN ENDP
            END MAIN



