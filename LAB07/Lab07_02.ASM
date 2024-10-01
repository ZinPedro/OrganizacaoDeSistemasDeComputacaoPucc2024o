TITLE Multiplicação
.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Digite o dividendo: $'
    MSG2 DB 10,13,'Digite o divisor: $'
    MSG3 DB 10,13,'O quociente eh: $'
    MSG4 DB 10,13,'O resto eh: $'
    MSG5 DB 10,13, 'O caractere digitado nao eh um numero!$'
    MSG6 DB 10,13, 'Esta divisao eh indefinida!$'
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX

        DIVIDENDO:
            MOV AH,09
            LEA DX,MSG1
            INT 21H

            MOV AH,01
            INT 21H
            CMP AL,39H
            JA NNUMERO
            CMP AL,30H
            JB NNUMERO
            MOV BL,AL
            OR BH,01H
        ;
        DIVISOR:
            MOV AH,09
            LEA DX,MSG2
            INT 21H

            MOV AH,01
            INT 21H
            CMP AL,39H
            JA NNUMERO
            CMP AL,30H
            JB NNUMERO
            MOV CL,AL
        ;

        CMP CL,30H
        JE ZERO

        MOV AH,09
        LEA DX,MSG3
        INT 21H

        MOV AH,02H
        
        AND BL,0FH
        AND CL,0FH
        XOR DL,DL

        DIVISAO:
            CMP BL,CL
            JB CONTINUA

            SUB BL,CL
            INC DL
            JMP DIVISAO
        ;
        CONTINUA:
            OR BL,30H
            OR DL,30H

            INT 21H

            MOV AH,09
            LEA DX,MSG4
            INT 21H

            MOV AH,02
            MOV DL,BL
            INT 21H
           
            JMP EXIT
        ;

        ZERO:
            MOV AH,09
            LEA DX, MSG6
            INT 21H
            JMP EXIT
        ;

        NNUMERO:
            MOV AH,09
            LEA DX,MSG5
            INT 21H
            CMP BH,01H
            JE DIVISOR

            MOV AH,02
            MOV DL,10
            INT 21H
            JMP DIVIDENDO

        EXIT:
            MOV AH,4Ch
            INT 21H
        ;
        MAIN ENDP
            END MAIN