TITLE PROGRAM MaiorIgualMenor
.MODEL SMALL
STACK 100H
.DATA
    MSG1 DB 10,13,'Digite o primeiro numero (digite um numero Natural)',10,13,'$'
    MSG2 DB 10,13,'Digite o segundo numero (digite um numero Natural)',10,13,'$'
    MSG3 DB 10,13,'O primeiro numero digitado foi maior que o segundo$'
    MSG4 DB 10,13,'O segundo numero digitado foi maior que o primeiro$'
    MSG5 DB 10,13,'Os dois numeros digitados sao iguais$'
    MSG6 DB 10,13,'O caractere digitado nao foi um numero!$'
.CODE
    MAIN PROC
        MOV AX,@DATA
        MOV DS,AX

        MOV AH,09H
        LEA DX,MSG1
        INT 21H

        MOV AH,01H
        INT 21H

        CMP AL,30H
        JL VERIFICADOR1

        CMP AL,39H
        JG VERIFICADOR1 

        MOV BL,AL
        JMP CORRETO1

        VERIFICADOR1:
            MOV AH,09H
            LEA DX,MSG6
            INT 21H

            MOV AH,09H
            LEA DX,MSG1
            INT 21H

            MOV AH,01H
            INT 21H

            CMP AL,30H
            JL VERIFICADOR1

            CMP AL,39H
            JG VERIFICADOR1

            MOV BL,AL
        ;

        CORRETO1:
            MOV AH,09H
            LEA DX,MSG2
            INT 21H

            MOV AH,01H
            INT 21H

            CMP AL,30H
            JL VERIFICADOR2

            CMP AL,39H
            JG VERIFICADOR2

            MOV CL,AL
            JMP CORRETO2
        ;

        VERIFICADOR2:
            MOV AH,09H
            LEA DX,MSG6
            INT 21H

            MOV AH,09H
            LEA DX,MSG2
            INT 21H

            MOV AH,01H
            INT 21H

            CMP AL,30H
            JL VERIFICADOR2

            CMP AL,39H
            JG VERIFICADOR2

            MOV CL,AL
        ;

        CORRETO2:
            CMP BL,CL
            JG MAIOR
            JL MENOR
        
            MOV AH,09H
            LEA DX,MSG5
            INT 21H

            JMP EXIT
        ;
        MAIOR:
            MOV AH,09H
            LEA DX,MSG3
            INT 21H

            JMP EXIT
        ;

        MENOR:
            MOV AH,09H
            LEA DX,MSG4
            INT 21H
        ;

        EXIT:
            MOV AH,4Ch
            INT 21H
        ;
        MAIN ENDP
            END MAIN







            
