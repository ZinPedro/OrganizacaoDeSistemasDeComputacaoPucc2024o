TITLE ENTRADA DE_BINARIOS
.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Digite o numero hexadecimal (de 0 a F) : $'
    MSG2 DB 10,13,'O numero digitado foi: $'
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX

        MOV AH,9
        LEA DX,MSG1
        INT 21H

        MOV AH,01
        MOV CX,4


        WHILE_:
            INT 21H

            CMP AL,13
            JE EXIT_WHILE
            CMP AL,39H
            JG LETRA
            AND AL,0FH
            JMP SALTO1
            LETRA:
                XOR AL,0B7H
                INC AL
            SALTO1:
            OR BL,AL
            ROL BX,4
            LOOP WHILE_
        ;
        EXIT_WHILE:
            MOV AH,09
            LEA DX,MSG2
            INT 21H
            
            MOV AH,02
            MOV CX,4
        IMPRIME:
            TEST BX,0001H
            JZ ZERO
            MOV DL,31H
            JMP SALTO2
            ZERO:
            MOV DL,30H
            SALTO2:
            INT 21H
            ROL BX,1
            LOOP IMPRIME
        ;
        MOV AH,4Ch
        INT 21H
        MAIN ENDP
            END MAIN