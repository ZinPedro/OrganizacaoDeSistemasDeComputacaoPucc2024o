TITLE Multiplicação
.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Digite o multiplicando: $'
    MSG2 DB 10,13,'Digite o multiplicador: $'
    MSG3 DB 10,13,'O produto eh: $'
    MSG4 DB 10,13, 'O caractere digitado nao eh um nuamero!$'
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX

        MULTIPLICANDO:
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
        MULTIPLICADOR:
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
        MOV AH,09
        LEA DX,MSG3
        INT 21H

        MOV AH,02H

        CMP CL,30H
        JE ZERO

        CMP CL,31H
        JE UM
        
        AND BL,0FH
        AND CL,0FH

        XOR DL,DL
        OR DL,30H

        MULTIPLICACAO:
            ADD DL,BL
            LOOP MULTIPLICACAO
            INT 21H

            JMP EXIT
        ;

        UM:
            MOV DL,BL
            INT 21H
            JMP EXIT
        ;

        ZERO:
            XOR BL,BL
            MOV DL,BL
            INT 21H
            JMP EXIT
        ;

        NNUMERO:
            MOV AH,09
            LEA DX,MSG4
            INT 21H
            CMP BH,01H
            JE MULTIPLICADOR

            MOV AH,02
            MOV DL,10
            INT 21H
            JMP MULTIPLICANDO

        EXIT:
            MOV AH,4Ch
            INT 21H
        ;
        MAIN ENDP
            END MAIN



        
            
