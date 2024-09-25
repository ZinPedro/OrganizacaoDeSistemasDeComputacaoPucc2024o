TITLE PROG SUM10N
MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Digite um numero (numeros restantes: $'
    MSG2 DB  ')',10,13,'$'
    MSG3 DB 10,13,'O caractere digitado nao e um numero!',10,13,'$'
    LINHA DB 10,13,'$'
.CODE
    MAIN PROC
        MOV AX,@DATA
        MOV DS,AX

        MOV CX,9

        FOR:
            MOV AH,09H
            LEA DX,MSG1
            INT 21H

            MOV AH,02H
            MOV DL,CL
            ADD DL,30H
            INT 21H

            MOV AH,09H
            LEA DX,MSG2
            INT 21H

            MOV AH,01H
            INT 21H

            CMP AL,30H
            JL NAONUMERO

            CMP AL,39H
            JG NAONUMERO

            MOV AH,09H
            LEA DX,LINHA
            INT 21H

            ADD BL,AL

            LOOP FOR
            JMP EXIT
        ;
        NAONUMERO:
            MOV AH,09H
            LEA DX,MSG3
            INT 21H

            JMP FOR
        ;
        EXIT:
            MOV AH,02H
            MOV DL,BL
            INT 21H

            MOV AH,4Ch
            INT 21H
    MAIN ENDP
        END MAIN

        